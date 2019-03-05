//
//  DevicePairingManager.m
//  i2app
//
//  Created by Arcus Team on 7/10/15.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

#import <i2app-Swift.h>
#import "DevicePairingManager.h"
#import "DeviceController.h"
#import "DevicePairingController.h"
#import "HubCapability.h"


#import "DeviceCapability.h"

#import "BasePairingViewController.h"
#import "DevicePairingWizard.h"
#import "FoundDevicesViewController.h"
#import "DeviceManager.h"
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionWindow.h"
#import "ContactCapability.h"
#import "PairingStep.h"
#import <i2app-Swift.h>

NSString *const kUpdateUINotification = @"UpdateUI";
NSString *const kUpdateUIDeviceAddedNotification = @"UpdateUIDeviceAdded";

@interface DevicePairingManager ()

- (void)stateChanged:(NSNotification *)sender;
- (void)stateChangedWithHubModel:(HubModel *)hubModel;
- (void)hubStateChangedWithError:(NSError *)error;

- (void)deviceUpdated:(NSNotification *)note;
- (void)deviceAdded:(NSNotification *)note;
- (void)hubPairingModeTimedOut;

- (void)createPairingPopupWithMainText:(NSString *)maintext Subtext:(NSString *)subtext andButtonText:(NSString *)btnText;

@end


@implementation DevicePairingManager {
    BOOL _inPairingMode;
    BOOL _stopPairingModeActionSent;

    PopupSelectionWindow *_popupWindow;
}

static UIView       *_popupView;

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(socketClosed:)
                                                     name:Constants.kNetworkConnectionNotAvailableNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userIsLoggedIn:)
                                                     name:kDeviceListRefreshedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(socketClosed:)
                                                     name:Constants.kSocketClosedNotification
                                                   object:nil];
    }
    return self;
}

+ (DevicePairingManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static DevicePairingManager *_manager = nil;
    dispatch_once(&pred, ^{
        _manager = [[DevicePairingManager alloc] init];
    });

    return _manager;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)subscribeToNotifications {
    DDLogWarn(@"subscribeToNotifications");

    if (!self.ignoreDeviceAdded) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAdded:) name:Constants.kModelAddedNotification object:nil];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRemoved:) name:Constants.kModelRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceUpdated:) name:kDeviceBackgroupUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged:) name:Constants.kModelErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged:) name:[Model attributeChangedNotification:kAttrHubState] object:nil];
}

- (void)stopSubscribingToNofitications {
    DDLogWarn(@"stopSubscribingToNofitications");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Constants.kModelAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Constants.kModelRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeviceBackgroupUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[Model attributeChangedNotification:kAttrHubState]  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Constants.kModelErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeviceListRefreshedNotification object:nil];
}

- (void)subscribeToDeviceAddedNotification {
    DDLogWarn(@"subscribeToDeviceAddedNotification");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAdded:) name:Constants.kModelAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIsLoggedIn:) name:kDeviceListRefreshedNotification object:nil];
}

- (void)stopSubscribingToDeviceAddedNotification {
    DDLogWarn(@"stopSubscribingToDeviceAddedNotification");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Constants.kModelAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeviceListRefreshedNotification object:nil];
}

- (void)socketClosed:(NSNotification *)note {
    [self stopSubscribingToNofitications];

    _inPairingMode = NO;
}

- (void)clearUpdatedPairedDevices {
  _updatedPairedDevices = [NSMutableArray new];
}

- (void)resetAllPairingStates {
    _inPairingMode = NO;
    _stopPairingModeActionSent = YES;
    _currentDevice = nil;

    // Use _updatedPairedDevices to add the device id of the devices that have been renamed
    _updatedPairedDevices = [NSMutableArray new];
    _justPairedDevices = [NSMutableArray new];

    _pairingWizard = nil;
    _currentDevice = nil;
    _pairingFlowType = PairingFlowTypeAddHub;
    _isPostPostPairing = NO;
    _ignoreDeviceAdded = NO;
    _prePairingActiveAlerts = [NSMutableArray new];

    [self stopSubscribingToNofitications];
}

- (void)initializePairingProcess {
    [self resetAllPairingStates];
    [self subscribeToNotifications];

    // Capture the activation state of each pro-mon alert before we start pairing
    _prePairingActiveAlerts = [[[AlarmSubsystemControllerObjcAdapter alloc] init] activeMonitoredAlerts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceUpdated:) name:[Model attributeChangedNotification:kAttrDeviceName] object:nil];
}

- (BOOL)isInPairingMode {
    return _inPairingMode;
}

#pragma mark - Start/Stop Pairing
- (PMKPromise *)startHubPairing:(BOOL)restarted {
    if ([[CorneaHolder shared] settings].currentHub) {
        self.pairingFlowType = PairingFlowTypeAddMultipleFoundDevices;
        _stopPairingModeActionSent = NO;
        if (_inPairingMode) {
            return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {}];
        }
        // If hub pairing mode is going to be restarted, don't add observers: they have already been added
        if (!restarted) {
            [self subscribeToNotifications];
        }
        // We are waiting for the "base:ValueChange" to process the hub state
        return [DevicePairingController startHubPairingMode:[[CorneaHolder shared] settings].currentPlace].then(^ {
            return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
                _inPairingMode = YES;
            }];
        }).catch(^(NSError *error) {
            _inPairingMode = NO;
            [self hubStateChangedWithError:error];
        });
    }
    else {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {}];
    }
}

- (void)stopHubPairing {
    // Stop the hub pairing mode only if the hub is in pairing mode
    if (!_inPairingMode) {
        return;
    }
    _stopPairingModeActionSent = YES;

    // We are waiting for the "base:ValueChange" to process the hub state
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController stopHubPairingMode:[[CorneaHolder shared] settings].currentPlace].then(^(HubPairingRequestResponse *response) {
            _inPairingMode = NO;
            [self stopSubscribingToNofitications];
        }).catch(^(NSError *error) {
            DDLogWarn(@"ERROR:%@",error.localizedDescription);
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUINotification object:error];
        });
    });
}

- (void)pairingProcessDone {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[Model attributeChangedNotification:kAttrDeviceName] object:nil];
}

- (void)stopPairingProcessAndNotifications {
  [self pairingProcessDone];
  [self stopSubscribingToNofitications];
}

#pragma mark - Notification Observers
- (void)stateChanged:(NSNotification *)note {
    if ([note.object isKindOfClass:[NSError class]]) {
        [self hubStateChangedWithError:note.object];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stateChangedWithHubModel:[[CorneaHolder shared] settings].currentHub];
        });
    }
}

- (void)userIsLoggedIn:(NSNotification *)note {
    [self subscribeToNotifications];

    [self updateDeviceList:note];
}

- (void)updateDeviceList:(NSNotification *)note {
    [self stateChangedWithHubModel:[[CorneaHolder shared] settings].currentHub];

    [self subscribeToNotifications];

    // Compare current and old device lists and see if any devices have been added
    NSArray *oldDeviceKeys = [[[[CorneaHolder shared] modelCache] oldModelsDictionary] allKeys];
    for (Model *model in [[[CorneaHolder shared] modelCache] fetchModels:[DeviceCapability namespace]]) {
        DeviceModel *device = (DeviceModel *)model;

        if (![oldDeviceKeys containsObject:device.modelId]) {
            [self deviceAdded:[NSNotification notificationWithName:Constants.kModelAddedNotification
                                                            object:device]];
        }
    }
}


- (void)stateChangedWithHubModel:(HubModel *)hubModel {
    NSString *state = [hubModel getAttribute:kAttrHubState];
    DDLogWarn(@"stateChanged: %@", state);

    if ([state isEqualToString:kEnumHubStateNORMAL]) {
        if (!_inPairingMode) {
            return;
        }

        // Check if the valueChanged event is sent as a response to stopPairing
        // command or just the hub pairing mode has timed out
        if (!_stopPairingModeActionSent) {
            [self hubPairingModeTimedOut];
        }
    }
    else if ([state isEqualToString:kEnumHubStatePAIRING]) {
        _inPairingMode = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUINotification object:hubModel];
    }
}

- (void)hubStateChangedWithError:(NSError *)error {
    NSString *errorMessage = ((NSDictionary *)error.userInfo)[@"message"];
    if ([errorMessage isEqualToString:@"hub cannot enter pairing mode as it is already in pairing or unpairing mode"]) {
        // Hub is already in pairing mode - just show the current hub mode
        _inPairingMode = YES;
    }
    else {
        _inPairingMode = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUINotification object:[[CorneaHolder shared] settings].currentHub];
}

- (void)deviceAdded:(NSNotification *)note {

    if ([note.name isEqualToString:Constants.kModelAddedNotification]) {
        if ([note.object isKindOfClass:[DeviceModel class]] && ![_justPairedDevices containsObject:note.object]) {
            [ArcusAnalytics tag:AnalyticsTags.AddDeviceClick attributes:@{ AnalyticsTags.TargetAddressKey : [DeviceCapability getModelFromModel:(DeviceModel *)note.object]}];

            [_justPairedDevices addObject:(DeviceModel *)note.object];

            // If this is the first device, lets make it the currentDevice
            // so that it can be renamed first.
            if (!_currentDevice) {
                _currentDevice = note.object;
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUIDeviceAddedNotification object:note.object];
        }

        if (self.justPairedDevices.count == 0) {
            return;
        }

        if (self.pairingFlowType == PairingFlowTypeAddOneDevice) {
            if (!self.ignoreDeviceAdded) {
                if (self.justPairedDevices.count >= 2) {
                    DeviceModel *model = self.justPairedDevices[0];

                    // Special case: Pairing garage door controller; assume secondary device is a door sensor and skip ahead to "devices found" screen
                    if (model.deviceType == DeviceTypeGarageDoorController) {
                        [self customizeDevice:note];
                    }

                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self createPairingPopupWithMainText:@"devices paired" Subtext:@"The Hub just saved you some time\nand paired multiple devices!" andButtonText:@"Show devices"];
                        });
                    }
                }
                else {
                    DeviceModel *deviceModel = [DevicePairingManager sharedInstance].currentDevice;
                    PairingStep *step = [self.pairingWizard currentStep];
                    if ((step.stepType != PairingStepSearch) ||
                        (step.stepType == PairingStepSearch && deviceModel.deviceType != self.pairingWizard.deviceType)) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            DeviceModel *model = self.justPairedDevices[0];

                            if (model.deviceType != DeviceTypeGarageDoorController) {
                                [self createPairingPopupWithMainText:[NSString stringWithFormat:@"%@ paired", model.name] Subtext:@"The Hub just saved you some time!" andButtonText:@"customize"];
                            }
                        });
                    }
                }
            }
        }
    }
}

- (void)deviceRemoved:(NSNotification *)note {

    if ([note.name isEqualToString:Constants.kModelRemovedNotification]) {
        if ([note.object isKindOfClass:[DeviceModel class]]) {
            if ([self.justPairedDevices containsObject:note.object]) {
                [self.justPairedDevices removeObject:note.object];

                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUIDeviceAddedNotification object:note.object];
            }
            if ([self.updatedPairedDevices containsObject:note.object]) {
                [self.updatedPairedDevices removeObject:note.object];
            }
        }
    }
}

- (void)deviceUpdated:(NSNotification *)note {
    if ([note.object isKindOfClass:[DeviceModel class]]) {
        if (![_updatedPairedDevices containsObject:((DeviceModel *)note.object).modelId]) {
            if ([self shouldMarkDeviceAsUpdated:note.object]) {
                [_updatedPairedDevices addObject:((DeviceModel *)note.object).modelId];
            }
        }
    }
    else if ([note.object isKindOfClass:[HubModel class]]) {
        DDLogWarn(@"What do we do about Hub Renaming changes");
    }
    else if ([note.object isKindOfClass:[NSDictionary class]] &&
             [((NSDictionary *)note.object) objectForKey:kAttrDeviceName] &&
             [[((NSDictionary *)note.object) objectForKey:kAttrDeviceName] isKindOfClass:[NSString class]] &&
             ((NSString *)[((NSDictionary *)note.object) objectForKey:kAttrDeviceName]).length > 0 &&
             [note.userInfo.allValues[0] isKindOfClass:[Model class]] ) {

        NSString *modelId = ((DeviceModel *)((NSDictionary *)note.userInfo).allValues[0]).modelId;
        if (![_updatedPairedDevices containsObject:modelId]) {
            NSString *address = [DeviceModel addressForId:modelId];
            if ([self shouldMarkDeviceAsUpdated:(DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address]]) {
                [_updatedPairedDevices addObject:modelId];
            }
        }
    }
}

- (void)markAsUpdated:(DeviceModel *)device {
    if (![_updatedPairedDevices containsObject:device.modelId]) {
        if ([self shouldMarkDeviceAsUpdated:device]) {
            [_updatedPairedDevices addObject:device.modelId];
        }
    }
}

// For C2C devices, as soon as the app receives a "base:added" event, it will receive a
// device Updated (name changed) event and that will put the device into
// the _updatedPairedDevices array. For C2C devices we need to check if the
// PairingStepNameAndPhoto step has been completed and only then add the device
// to the _updatedPairedDevices array
- (BOOL)shouldMarkDeviceAsUpdated:(DeviceModel *)deviceModel {
    if (![deviceModel isC2CDevice]) {
        return YES;
    }

    // Sometimes, more than one notifications are received for the update of the same device
    if ([_updatedPairedDevices containsObject:deviceModel.modelId]) {
        return NO;
    }
    if (!self.currentDevice ||
        ([self.currentDevice.modelId isEqualToString:deviceModel.modelId] &&
         [self.pairingWizard isStepOfTypeExecuted:PairingStepNameAndPhoto])) {
            return NO;
        }
    return YES;
}

#pragma mark - Update UI Label
- (void)changeLabels:(UILabel *)lookingLabel deviceCountLabel:(UILabel *)deviceCountLabel inView:(UIView *)view {

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *deviceLabel = (int)_justPairedDevices.count == 1 ? [NSLocalizedString(@"Device", nil) lowercaseString] : [NSLocalizedString(@"Devices", nil) lowercaseString];
        if ([[CorneaHolder shared] settings].currentHub) {
            if (_inPairingMode) {
                deviceCountLabel.text = @"In Pairing Mode";
                if (_justPairedDevices.count == 0) {
                    lookingLabel.text = NSLocalizedString(@"Looking...", nil);
                }
                else {
                    lookingLabel.text = [NSString stringWithFormat:@"%d %@ found", (int)_justPairedDevices.count, deviceLabel];
                }
            }
            else {
                deviceCountLabel.text = @"Not in Pairing Mode";
                lookingLabel.text = [NSString stringWithFormat:@"%d %@ found", (int)_justPairedDevices.count, deviceLabel];
            }
        }
        else {
            deviceCountLabel.text = @"No Hub";
            if (_justPairedDevices.count == 0) {
                lookingLabel.text = @"";
            }
            else {
                lookingLabel.text = [NSString stringWithFormat:@"%d %@ found", (int)_justPairedDevices.count, deviceLabel];
            }
        }
    });

    lookingLabel.textAlignment = NSTextAlignmentLeft;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(lookingLabel.frame.origin.x + lookingLabel.frame.size.width + 6, lookingLabel.frame.origin.y + 2, 10, 15)];
    image.image = [UIImage imageNamed:@"Chevron"];
    [view setNeedsLayout];
}

#pragma mark - Hub Pairing Mode timed out
- (void)hubPairingModeTimedOut {
    if (_inPairingMode) {
        _inPairingMode = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:@"Hub Time out" subtitle:@"Keep Looking?" button:[PopupSelectionButtonModel create:@"YES" event:@selector(yesTapped)], [PopupSelectionButtonModel create:@"NO" event:@selector(noTapped)], nil];
            [buttonView setOwner:self];

            [self popupWithoutClose:buttonView];

        });
    }
}

- (void)popupWithoutClose:(PopupSelectionBaseContainer *)container {
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    _popupWindow = [PopupSelectionWindow popup:rootViewController.view
                                       subview:container
                                         owner:self displyCloseButton:NO];
}
- (void)yesTapped {
    UINavigationController *navController = (UINavigationController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    navController.view.userInteractionEnabled = YES;
    DDLogWarn(@"yes tapped");
    [navController slideOutTwoButtonAlert];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[DevicePairingManager sharedInstance] startHubPairing:YES];
    });
}

- (void)noTapped {
    UINavigationController *navController = (UINavigationController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    navController.navigationController.view.userInteractionEnabled = YES;
    [navController slideOutTwoButtonAlert];

    // Go to Dashboard if all devices have been renamed
    if (_justPairedDevices.count == _updatedPairedDevices.count) {
        [self resetAllPairingStates];
        [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
    }
}

#pragma mark -
- (void)createPairingPopupWithMainText:(NSString *)maintext
                               Subtext:(NSString *)subtext
                         andButtonText:(NSString *)btnText {
  // Do not show pop up for nest
  if ([self hasC2CPairingFlow]) {
    return;
  }

  UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
  if (![rootViewController isKindOfClass:[SWRevealViewController class]]) {
    return;
  }

  SWRevealViewController *root = (SWRevealViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
  UINavigationController *navController = (UINavigationController *)root.frontViewController;

  PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:maintext subtitle:subtext button:[PopupSelectionButtonModel create:btnText event:@selector(customizeDevice:)], nil];
  [buttonView setOwner:self];

  if (_popupWindow.view.superview) {
    [_popupWindow close];
  }
  _popupWindow = [PopupSelectionWindow popup:navController.view subview:buttonView];
}

- (void)customizeDevice:(id)sender {
  SWRevealViewController *root = (SWRevealViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
  UINavigationController *navController = (UINavigationController *)root.frontViewController;
  
  if ([DevicePairingManager sharedInstance].justPairedDevices.count == 0) {
    return;
  }

  if ([DevicePairingManager sharedInstance].justPairedDevices.count >= 2) {
    if ([self hasC2CPairingFlow]) {
      self.pairingFlowType = PairingFlowTypeAddMultipleFoundDevices;
    }
    [navController pushViewController:[FoundDevicesViewController create] animated:YES];
  }
  else {
    DeviceModel *model = [DevicePairingManager sharedInstance].justPairedDevices[0];
    [DevicePairingManager sharedInstance].currentDevice = model;
    [DevicePairingWizard runMultiplePairingFlowWithDeviceModel:model andDeviceType:[model deviceType]];
  }
  navController.view.userInteractionEnabled = YES;
}

- (void)slideOut {
    [UIView beginAnimations:@"removeFromSuperviewWithAnimation" context:nil];

    // Set delegate and selector to remove from superview when animation completes
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    _popupView.alpha = 0.0f;

    // Move this view to bottom of superview
    CGRect frame = _popupView.frame;
    frame.origin = CGPointMake(0.0, ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.bounds.size.height);
    _popupView.frame = frame;
    [UIView commitAnimations];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.view.userInteractionEnabled = YES;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [_popupView removeFromSuperview];
    }
}

#pragma mark - update devices
- (BOOL)isDeviceUpdated:(DeviceModel *)deviceModel {
    return [_updatedPairedDevices containsObject:deviceModel.modelId];
}

- (void)renameDevice:(NSString *)deviceName forDeviceModel:(DeviceModel *)deviceModel completeBlock:(void (^)(void))compleBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        if (deviceModel && deviceName.length > 0) {
            [DeviceCapability setName:deviceName onModel:deviceModel];

            [deviceModel commit].then(^ {
            }).catch(^(NSError *error) {
                [self hubStateChangedWithError:error];
                DDLogWarn(@"renameDevice error: %@", error.localizedDescription);
            }).finally(^(void){
                if (compleBlock) {
                    compleBlock();
                }
            });
        }
    });
}
- (void)renameDevice:(NSString *)deviceName forDeviceModel:(DeviceModel *)deviceModel {
    [self renameDevice:deviceName forDeviceModel:deviceModel completeBlock:^{
      SWRevealViewController *root = (SWRevealViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
      UINavigationController *navController = (UINavigationController *)root.frontViewController;
      
        UIViewController *vc = navController.viewControllers[navController.viewControllers.count - 1];
        [vc hideGif];
    }];
}

- (BOOL)areAllDevicesUpdated {
    return (_justPairedDevices.count ==_updatedPairedDevices.count);
}

- (void)markAllDevicesUpdated {
    _updatedPairedDevices = _justPairedDevices;
}

- (BOOL)wasZWaveDevicePaired {

    for (DeviceModel *device in _justPairedDevices) {
        if ([DeviceController getDeviceConnectivityType:device] == DeviceConnectivityTypeZwave) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *) alertsActivatedDuringPairing {
    NSArray* postPairingActiveAlerts = [[[AlarmSubsystemControllerObjcAdapter alloc] init] activeMonitoredAlerts];
    NSMutableArray* newlyActivated = [[NSMutableArray alloc] init];
    
    for (NSString* thisAlert in postPairingActiveAlerts) {
        if (![_prePairingActiveAlerts containsObject:thisAlert]) {
            [newlyActivated addObject:thisAlert];
        }
    }
    
    return newlyActivated;
}

- (BOOL)hasHoneywellThermostatsPaired {
    for (DeviceModel *device in _justPairedDevices) {
        if (device.deviceType == DeviceTypeThermostatHoneywellC2C) {
            return YES;
        }
    }
    return NO;
}

// change to C2C pairing flow
- (BOOL)hasC2CPairingFlow {
  for (DeviceModel *device in _justPairedDevices) {
    if (device.deviceType == DeviceTypeThermostatNest) {
      return YES;
    }
  }
  NSArray *deviceIDs = @[@"f9a5b0", //Nest
                         //@"973d58", @"1dbb3f", @"d9685c", //Honeywell (kept for future context)
                       @"d8ceb2", @"7b2892", @"3420b0", @"0f1b61", @"e44e37"]; //Lutron
  for (DeviceModel *device in _justPairedDevices) {
    if ([deviceIDs containsObject:device.productId]) {
      return YES;
    }
  }
  return NO;
}

- (void)setIgnoreDeviceAdded:(BOOL)ignoreDeviceAdded {
    _ignoreDeviceAdded = ignoreDeviceAdded;
    if (_ignoreDeviceAdded) {
        [self stopSubscribingToDeviceAddedNotification];
    } else {
        [self subscribeToDeviceAddedNotification];
    }
}

@end
