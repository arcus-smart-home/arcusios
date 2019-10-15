//
//  DeviceUnpairingManager.m
//  i2app
//
//  Created by Arcus Team on 9/30/15.
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
#import "DeviceUnpairingManager.h"
#import "MessageWithButtonsViewController.h"
#import "DeviceListViewController.h"
#import "DeviceDetailsTabBarController.h"

#import "DeviceController.h"
#import "DevicePairingController.h"
#import "ProductCatalogController.h"
#import "ProductCapability.h"
#import "DeviceCapability.h"




typedef enum {
    UnpairingFlowTypeAddHub,
    UnpairingFlowTypeAddOneDevice,
    UnpairingFlowTypeAddMultipleFoundDevices
} UnpairingFlowType;

@interface DeviceUnpairingManager ()

@property (nonatomic, strong, readonly) DeviceModel *deviceModel;

@end


MessageWithButtonsControllerModel   *_currentStep;

#pragma mark - MessageWithButtonsControllerModel Overridden classed interfaces
@interface BaseRemoveDeviceControlModel: MessageWithButtonsControllerModel

@end

@implementation BaseRemoveDeviceControlModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.controllerTitle = NSLocalizedString(@"REMOVE DEVICE", nil);
    }
    return self;
}

@end

#pragma mark - Zigbee or IPCD Online
@interface ZigbeeOrIpcdOnlineRemoveDeviceModel : BaseRemoveDeviceControlModel
@end

@interface ForcedRemovalSuccessDeviceModel : BaseRemoveDeviceControlModel
@end


#pragma mark - Zigbee Offline
@interface OffLineRemoveDeviceModel : BaseRemoveDeviceControlModel
@end


#pragma mark - Zwave Online
@interface ZwaveOnlineRemoveDeviceModel : BaseRemoveDeviceControlModel
@end

#pragma mark - Zigbee and Zwave Online
@interface OnlineRemovalSuccessDeviceModel : BaseRemoveDeviceControlModel
@end

@interface OnlineRemovalFailureDeviceModel : BaseRemoveDeviceControlModel
@end

@interface OnlineRemovalFailureWithCancelDeviceModel : BaseRemoveDeviceControlModel
@end

@interface OffLineRemovalFailureDeviceModel : BaseRemoveDeviceControlModel
@end

#pragma mark - Unpairing Text Only
@interface TitleSubtitleDeviceRemovalModel : BaseRemoveDeviceControlModel
- (instancetype)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle;
@end

#pragma mark - Unpairing Text Only From Product Catalog
@interface TitleSubtitleProductRemovalModel : BaseRemoveDeviceControlModel
@end

#pragma mark - DeviceUnpairingManager implementation
@implementation DeviceUnpairingManager {
    DeviceConnectivityType        _deviceType;
    BOOL        _isOffline;
}

+ (DeviceUnpairingManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static DeviceUnpairingManager *_manager = nil;
    dispatch_once(&pred, ^{
        _manager = [[DeviceUnpairingManager alloc] init];
    });
    
    return _manager;
}

- (MessageWithButtonsViewController *)startRemovingDevice:(DeviceModel *)device {
    _deviceModel = device;
    
    _deviceType = [DeviceController getDeviceConnectivityType:_deviceModel];
    _isOffline = [_deviceModel isDeviceOffline];
    if (_deviceType == DeviceConnectivityTypeZwave) {
        if (!_isOffline) {
            // Is Zwave and Online
            _currentStep = [[ZwaveOnlineRemoveDeviceModel alloc] init];
            return _currentStep.viewController;
        }
        else {
            // Is Zwave and Offline
            _currentStep = [[OffLineRemoveDeviceModel alloc] init];
            return _currentStep.viewController;
        }
    }
    else if (_deviceType == DeviceConnectivityTypeOther) {
        // Unknown device
        _currentStep = [[OnlineRemovalFailureDeviceModel alloc] init];
        return _currentStep.viewController;
    }
    else {
        // Zigbee, Honeywell or IPCD Devices
        if (!_isOffline) {
            // Zigbee or IPCD and Online
            _currentStep = [[ZigbeeOrIpcdOnlineRemoveDeviceModel alloc] init];
            return _currentStep.viewController;
        }
        else {
            // Zigbee or IPCD and Offline
            _currentStep = [[OffLineRemoveDeviceModel alloc] init];
            return _currentStep.viewController;
        }
    }
    return nil;
}

- (MessageWithButtonsViewController *)productInfoRemovalWithDevice:(DeviceModel *)device {
    _isOffline = NO;
    _deviceModel = device;

    _currentStep = [[TitleSubtitleProductRemovalModel alloc] init];

    return _currentStep.viewController;
}

- (MessageWithButtonsViewController *)disabledRemovalWithTitle:(NSString*)title subtitle:(NSString*)subtitle {
    _isOffline = NO;
    _currentStep = [[TitleSubtitleDeviceRemovalModel alloc] initWithTitle:title subtitle:subtitle];

    return _currentStep.viewController;
}

@end


#pragma mark - Zigbee Online
@implementation ZigbeeOrIpcdOnlineRemoveDeviceModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Unpairing Your Device", nil);
        self.subtitle = NSLocalizedString(@"The hub will beep when the device is\n successfully removed.", nil);
        self.iconImage = [UIImage imageNamed:@"processing"];
        self.secondButtonName = NSLocalizedString(@"Cancel", nil);
        self.secondButtonSelector = @selector(cancelDeviceRemoval);
    }
    return self;
}

- (void)beginRuning {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController startRemovingDevice:[DeviceUnpairingManager sharedInstance].deviceModel withSuccessBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController.navigationController pushViewController:[[OnlineRemovalSuccessDeviceModel alloc] init].viewController animated:YES];
            });
        } withFailureBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController.navigationController pushViewController:[[OnlineRemovalFailureDeviceModel alloc] init].viewController animated:YES];
            });
        }];
    });
}

- (void)cancelDeviceRemoval {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:[[OnlineRemovalFailureDeviceModel alloc] init].viewController animated:YES];
    });
}

@end

@implementation ForcedRemovalSuccessDeviceModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Force Remove was Successful", nil);
        self.subtitle = NSLocalizedString(@"Your device has been successfully removed\n from the hub. To re-pair, reset the device\n itself and then tap + on the dashboard", nil);
        self.iconImage = [UIImage imageNamed:@"checkedMark"];
        self.hasCloseButton = YES;
        self.goToDeviceList = YES;
    }
    return self;
}

@end

#pragma mark - Zigbee and Zwave Online
@implementation OnlineRemovalSuccessDeviceModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Unpairing was Successful", nil);
        self.subtitle = NSLocalizedString(@"Your device has been successfully unpaired.\n To re-pair, tap + on the dashboard.", nil);
        self.iconImage = [UIImage imageNamed:@"checkedMark"];
        self.hasCloseButton = YES;
        self.goToDeviceList = YES;
    }
    return self;
}

@end

@implementation OnlineRemovalFailureDeviceModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Unpairing was Unsuccessful", nil);
        self.subtitle = NSLocalizedString(@"Force Remove will delete the device from the\n hub. However, in order to re-connect this\n device, you will need to do a manual reset\n of the device itself before re-pairing.", nil);
        self.iconImage = [UIImage imageNamed:@"icon_alert_black"];
        self.hasCloseButton = YES;
        self.topButtonName = NSLocalizedString(@"Retry Unpairing", nil);
        self.topButtonSelector = @selector(retryUnpairingDevice);
        self.secondButtonName = NSLocalizedString(@"Force Remove", nil);
        self.secondButtonSelector = @selector(forceRemoveDevice);
    }
    return self;
}

- (void)retryUnpairingDevice {
    DeviceConnectivityType deviceType = [DeviceController getDeviceConnectivityType:[DeviceUnpairingManager sharedInstance].deviceModel];
    if (deviceType == DeviceConnectivityTypeZigbee) {
        [self.viewController.navigationController pushViewController:[[ZigbeeOrIpcdOnlineRemoveDeviceModel alloc] init].viewController animated:YES];
    }
    else if (deviceType == DeviceConnectivityTypeZwave) {
        [self.viewController.navigationController pushViewController:[[ZwaveOnlineRemoveDeviceModel alloc] init].viewController animated:YES];
    }
}

- (void)forceRemoveDevice {
    [ArcusAnalytics tagWithNamed: AnalyticsTags.DevicesMoreForceRemove];
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController forceRemoveDevice:[DeviceUnpairingManager sharedInstance].deviceModel].then(^ {
            [self.viewController.navigationController pushViewController:[[ForcedRemovalSuccessDeviceModel alloc] init].viewController animated:YES];
        });
    });
}

@end

@implementation OnlineRemovalFailureWithCancelDeviceModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Unpairing was Unsuccessful", nil);
        self.subtitle = NSLocalizedString(@"Force Remove will delete the device from the\n hub. However, in order to re-connect this\n device, you will need to do a manual reset\n of the device itself before re-pairing.", nil);
        self.iconImage = [UIImage imageNamed:@"icon_alert_black"];
        self.hasCloseButton = YES;
        self.topButtonName = NSLocalizedString(@"Force Remove", nil);
        self.topButtonSelector = @selector(forceRemoveDevice);
        self.secondButtonName = NSLocalizedString(@"Cancel", nil);
        self.secondButtonSelector = @selector(cancelDeviceRemoval);
    }
    return self;
}

- (void)forceRemoveDevice {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController forceRemoveDevice:[DeviceUnpairingManager sharedInstance].deviceModel].then(^ {
            [self.viewController.navigationController pushViewController:[[ForcedRemovalSuccessDeviceModel alloc] init].viewController animated:YES];
        });
    });
}

- (void)cancelDeviceRemoval {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController stopHubUnpairingMode:[[CorneaHolder shared] settings].currentHub].then(^ {
            UIViewController *vc = [self.viewController findLastViewController:[DeviceDetailsTabBarController class]];
            if (vc) {
                [self.viewController.navigationController popToViewController:vc animated:YES];
            }
        });
    });
}

@end


#pragma mark - Zigbee Offline
@implementation OffLineRemoveDeviceModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"The Device is Offline", nil);
        self.subtitle = NSLocalizedString(@"The device is offline and cannot communicate\n with the hub. Force Remove will delete the\n device from the hub. However, in order to re-connect this device, you will need to do\n a manual reset of the device itself before\n re-pairing.", nil);
        self.iconImage = [UIImage imageNamed:@"icon_alert_black"];
        self.hasCloseButton = YES;
        self.topButtonName = NSLocalizedString(@"Force Remove", nil);
        self.topButtonSelector = @selector(forceRemoveDevice);
        self.secondButtonName = NSLocalizedString(@"Cancel", nil);
        self.secondButtonSelector = @selector(cancelDeviceRemoval);
    }
    return self;
}

- (void)forceRemoveDevice {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController forceRemoveDevice:[DeviceUnpairingManager sharedInstance].deviceModel].then(^ {
            
            [self.viewController.navigationController pushViewController:[[ForcedRemovalSuccessDeviceModel alloc] init].viewController animated:YES];
            
        })
        .catch(^(NSError *error) {
            
            if (![[DeviceUnpairingManager sharedInstance].deviceModel isDeviceOffline]) {
                [self.viewController.navigationController pushViewController:[[OnlineRemovalFailureDeviceModel alloc] init].viewController animated:YES];
            }
            else {
                [self.viewController.navigationController pushViewController:[[OffLineRemovalFailureDeviceModel alloc] init].viewController animated:YES];
            }
        });
    });
}

- (void)cancelDeviceRemoval {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController stopHubUnpairingMode:[[CorneaHolder shared] settings].currentHub].then(^ {
            [self.viewController.navigationController popViewControllerAnimated:YES];
        });
    });
}

@end


@implementation OffLineRemovalFailureDeviceModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Unpairing was Unsuccessful", nil);
        self.subtitle = NSLocalizedString(@"Generic errors", nil);
        self.iconImage = [UIImage imageNamed:@"icon_alert_black-ios"];
        self.hasCloseButton = YES;
        
        self.clickableButtonName = NSLocalizedString(@"1-0", nil);
        self.clickableButtonSelector = @selector(call);
        
        self.topButtonName = NSLocalizedString(@"Retry Force Removal", nil);
        self.topButtonSelector = @selector(forceRemoveDevice);
        self.secondButtonName = NSLocalizedString(@"Cancel", nil);
        self.secondButtonSelector = @selector(cancelDeviceRemoval);
    }
    return self;
}

- (void)forceRemoveDevice {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController forceRemoveDevice:[DeviceUnpairingManager sharedInstance].deviceModel].then(^ {
            
            [self.viewController.navigationController pushViewController:[[ForcedRemovalSuccessDeviceModel alloc] init].viewController animated:YES];
            
        })
        .catch(^(NSError *error) {
            
            [self.viewController.navigationController pushViewController:[[OnlineRemovalFailureDeviceModel alloc] init].viewController animated:YES];
            
        });
    });
}

- (void)cancelDeviceRemoval {
    [self.viewController.navigationController popToViewController:[self.viewController findLastViewController:[DeviceDetailsTabBarController class]] animated:YES];
}

- (void)call {
    // This will need to be addressed if support is added.
//
//    NSString *phNo = @"+18554694747";
//    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//        [[UIApplication sharedApplication] openURL:phoneUrl];
//    }
//    else {
//        // Call facility is not available
//    }
}

@end


#pragma mark - Zwave Online
@interface ZwaveOnlineRemoveDeviceModel ()

@property (atomic, assign) BOOL appIdleTimerDisabled;
@property (nonatomic, strong) NSTimer *searchTimer;

@end

@implementation ZwaveOnlineRemoveDeviceModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Searching", nil);
        self.iconImage = [UIImage imageNamed:@"other"];
        self.secondButtonName = NSLocalizedString(@"Cancel", nil);
        self.secondButtonSelector = @selector(cancelDeviceRemoval);
        self.openSelector = @selector(viewWillAppear);
        self.closeSelector = @selector(viewWillDisappear);

        NSString *productId = [DeviceCapability getProductIdFromModel:[DeviceUnpairingManager sharedInstance].deviceModel];
        // Setting productId to empty string to prevent Cornea from crashing.
        // By sending the empty string, we can let the platform report the error back to use instead handling it in UI.
        if (!productId) {
            DDLogError(@"Error: nil productId for DeviceID: %@", [(DeviceModel *)[[DeviceUnpairingManager sharedInstance] deviceModel] address]);
            productId = @"";
        }

        if (productId.length > 0) {
            __block dispatch_semaphore_t getProductDataSemaphore = dispatch_semaphore_create(0);

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [ProductCatalogController getProductWithId:productId].then(^(ProductModel *productModel) {
                    NSArray *removalArr = [ProductCapability getRemovalFromModel:productModel];
                    if (removalArr.count > 0) {
                        NSDictionary *removalDict = removalArr[0];
                        if (removalDict && removalDict.count > 0) {
                            NSString *text = removalDict[@"text"];
                            text = [text stringByReplacingOccurrencesOfString:@"           " withString:@"\n"];
                            if (text.length > 0) {
                                self.subtitle = text;
                            }
                        }
                    }
                    if (getProductDataSemaphore) {
                        dispatch_semaphore_signal(getProductDataSemaphore);
                    }
                });
                __block NSString *blockSubtitle = self.subtitle;
                __block MessageWithButtonsViewController *blockViewController = self.viewController;
                dispatch_semaphore_wait(getProductDataSemaphore, dispatch_time(DISPATCH_TIME_NOW, (30 * NSEC_PER_SEC)));
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (blockSubtitle.length == 0) {
                        blockSubtitle = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"Remove Zwave device message1", nil), NSLocalizedString(@"Remove Zwave device message2", nil)];
                    }
                    if (blockViewController && [blockViewController conformsToProtocol:@protocol(MessageWithButtonsControllerCallback)]) {
                        [blockViewController refresh];
                    }
                });
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.subtitle.length == 0) {
                    self.subtitle = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"Remove Zwave device message1", nil), NSLocalizedString(@"Remove Zwave device message2", nil)];
                }
                if (self.viewController && [self.viewController conformsToProtocol:@protocol(MessageWithButtonsControllerCallback)]) {
                    [self.viewController refresh];
                }
            });
        }
    }
    return self;
}

- (void)beginRuning {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController startRemovingDevice:[DeviceUnpairingManager sharedInstance].deviceModel withSuccessBlock:^{
            // Device removal succedded
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController.navigationController pushViewController:[[OnlineRemovalSuccessDeviceModel alloc] init].viewController animated:YES];
            });
        } withFailureBlock:^{
            [self handleDeviceRemovalFailure];
         }];
    });
}

- (void)handleDeviceRemovalFailure {
    // Device removal Failed
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:[[OnlineRemovalFailureDeviceModel alloc] init].viewController animated:YES];
    });
}

#pragma mark - Selectors
- (void)viewWillAppear {
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(handleDeviceRemovalFailure) userInfo:nil repeats:NO];

    // Disable app sleep mode
    self.appIdleTimerDisabled = [UIApplication sharedApplication].idleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear {
    [UIApplication sharedApplication].idleTimerDisabled = self.appIdleTimerDisabled;

    [self.searchTimer invalidate];
    self.searchTimer = nil;
}

- (void)cancelDeviceRemoval {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:[[OnlineRemovalFailureWithCancelDeviceModel alloc] init].viewController animated:YES];
    });
}

@end

#pragma mark - Unpairing Text Only
@implementation TitleSubtitleDeviceRemovalModel

- (instancetype)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle {
    if (self = [super init]) {
        self.title = NSLocalizedString(title, nil);
        self.subtitle = NSLocalizedString(subtitle, nil);
        self.iconImage = nil;
        self.hasCloseButton = YES;
//        self.goToDeviceList = YES;
    }
    return self;
}

@end

#pragma mark - Unpairing Piairing Step
@implementation TitleSubtitleProductRemovalModel {
    BOOL _unpairing;
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"";
        self.subtitle = @"";
        self.iconImage = nil;
        self.hasCloseButton = YES;
        self.closeSelector = @selector(cancelDeviceRemoval);

        _unpairing = true;

        NSString *productId = [DeviceCapability getProductIdFromModel:[DeviceUnpairingManager sharedInstance].deviceModel];
        // Setting productId to empty string to prevent Cornea from crashing.
        // By sending the empty string, we can let the platform report the error back to use instead handling it in UI.
        if (productId.length == 0) {
            DDLogError(@"Error: nil productId for DeviceID: %@", [(DeviceModel *)[[DeviceUnpairingManager sharedInstance] deviceModel] address]);
            productId = @"";
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [ProductCatalogController getProductWithId:productId].then (^(ProductModel *productModel) {
                NSArray *removalArr = [ProductCapability getRemovalFromModel:productModel];
                if (removalArr.count > 0) {
                    NSDictionary *removalDict = removalArr[0];
                    if (removalDict && removalDict.count > 0) {

                        NSString *title = removalDict[@"text"];
                        NSString *subtitle = removalDict[@"subText"];

                        if (!title || [title isKindOfClass:[NSNull class]]) {
                            title = @"";
                        }

                        if (!subtitle || [subtitle isKindOfClass:[NSNull class]]) {
                            subtitle = @"";
                        }

                        // TODO: This is janky for Somfy Blinds because Unpairing Steps don't work on the platform properly
                        if ([[[DeviceUnpairingManager sharedInstance] deviceModel] deviceType] == DeviceTypeSomfyBlinds) {
                            self.title = @"Remove Somfy Blinds";
                            self.subtitle = title;
                        } else if ([[[DeviceUnpairingManager sharedInstance] deviceModel] deviceType] == DeviceTypeSomfyBlindsController) {
                            self.title = @"Remove Somfy Controller";
                            self.subtitle = title;
                        } else {
                            self.title = title;
                            self.subtitle = subtitle;
                        }

                        if (self.viewController && [self.viewController conformsToProtocol:@protocol(MessageWithButtonsControllerCallback)]) {
                            [self.viewController refresh];
                        }
                    }
                }
            });
        });
    }
    return self;
}

- (void)beginRuning {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [DevicePairingController startRemovingDevice:[DeviceUnpairingManager sharedInstance].deviceModel withSuccessBlock:^{
                // Device removal succedded
                dispatch_async(dispatch_get_main_queue(), ^{
                    _unpairing = false;
                    [self.viewController.navigationController pushViewController:[[OnlineRemovalSuccessDeviceModel alloc] init].viewController animated:YES];
                });
            } withFailureBlock:^{
                // Device removal Failed
                dispatch_async(dispatch_get_main_queue(), ^{
                    _unpairing = false;
                    [self.viewController.navigationController pushViewController:[[OnlineRemovalFailureDeviceModel alloc] init].viewController animated:YES];
                });
            }];
        });
//    }
}

- (void)cancelDeviceRemoval {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DevicePairingController stopHubUnpairingMode:[[CorneaHolder shared] settings].currentHub].then(^ {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_unpairing) {
                    [self.viewController.navigationController popViewControllerAnimated:YES];
                    _unpairing = false;
                }
            });
        });
    });
}


@end


