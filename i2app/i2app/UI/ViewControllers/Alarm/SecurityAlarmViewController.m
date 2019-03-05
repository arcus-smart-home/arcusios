//
//  SecurityAlarmViewController.m
//  i2app
//
//  Created by Arcus Team on 8/17/15.
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
#import "SecurityAlarmViewController.h"

#import "AlarmDeviceListViewController.h"
#import "PopupSelectionButtonsView.h"
#import "SegmentModelsBuilder.h"
#import "AlarmNotificationViewController.h"
#import "AlarmHistoryViewController.h"


#import "SubsystemsController.h"
#import "SecuritySubsystemAlertController.h"
#import "SubsystemsController.h"
#import "SecuritySubsystemCapability.h"
#import "SecurityAlarmModeCapability.h"
#import "PersonCapability.h"
#import "RuleCapability.h"

#import <i2app-Swift.h>

@interface SecurityAlarmViewController ()

@property (nonatomic, strong) NSString *lastTriggered;

@end

@implementation SecurityAlarmViewController {
    NSTimer     *_countDownTimer;
    int         _countTime;

    // Used to make sure that the Security subsystem is disarmed only once after it has been armed
    BOOL        _needToDisarmAlarm;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setTitle:@"Status"];
}

- (void)viewDidLoad {
    //Tag Service - Security:
    [ArcusAnalytics tag:AnalyticsTags.SecurityAlarm attributes:@{}];
    
    [self loadTimer];

    [super viewDidLoad];
    
    [self setRingText];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(securityStateChanged:) name: [Model attributeChangedNotification:kAttrSecuritySubsystemAlarmState] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(securityModeChanged:) name: [Model attributeChangedNotification:kAttrSecuritySubsystemAlarmMode] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subsystemInitialized:) name:kSubsystemInitializedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemTriggeredDevices] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemOfflineDevices] object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemSecurityDevices] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:[NSString stringWithFormat:@"%@:%@", kAttrSecurityAlarmModeDevices,kEnumSecuritySubsystemAlarmModeON]] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:[NSString stringWithFormat:@"%@:%@", kAttrSecurityAlarmModeDevices,kEnumSecuritySubsystemAlarmModePARTIAL]] object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemCallTreeEnabled] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemCallTree] object:nil];
    
    if ([SubsystemsController sharedInstance].securityController && [SubsystemsController sharedInstance].securityController.subsystemModel) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [[SubsystemsController sharedInstance].securityController.subsystemModel refresh].then(^ {
                [self securityStateChanged:[NSNotification notificationWithName:[Model attributeChangedNotification:kAttrSecuritySubsystemAlarmState] object:nil]];
            });
        });
    }

    self.lastTriggered = @"";

    [[SubsystemsController sharedInstance].securityController lastTriggeredString:^(NSString *lastTriggered) {
        dispatch_async(dispatch_get_main_queue(),^{
            self.lastTriggered = lastTriggered;
            [self.tableView reloadData];
        });
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self saveTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _needToDisarmAlarm = YES;

    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmBaseViewControllerCell *cell = (AlarmBaseViewControllerCell *)[tableView dequeueReusableCellWithIdentifier:@"logoTextCell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    SecuritySubsystemAlertController *controller = [SubsystemsController sharedInstance].securityController;
    [cell setLogo:[UIImage imageNamed:@"userIcon"]];
    
    switch (indexPath.row) {
        case 0:
            [cell setTitle:[NSLocalizedString(@"On Devices", nil) capitalizedString] subtitle:controller.securityAlarmDevicesStatus];
            [cell setLogo:[UIImage imageNamed:@"security_icon"]];
            break;
            
        case 1:
            [cell setTitle:[NSLocalizedString(@"Partial Only Devices", nil) capitalizedString] subtitle:controller.partialSecurityAlarmDevicesStatus];
            [cell setLogo:[UIImage imageNamed:@"security_icon"]];
            break;
            
        case 2: {
            [cell setTitle:[NSLocalizedString(@"ALARM HISTORY", nil) capitalizedString] subtitle:self.lastTriggered];
            [cell setLogo:[UIImage imageNamed:@"alartHisotry"]];
        }
            break;
            
        case 3:
            [cell setTitle:[NSLocalizedString(@"ALARM NOTIFICATION LIST", nil) capitalizedString] subtitle:[self subTextStringForNotificationList]];
            
            [cell setLogo:[UIImage imageNamed:@"CareNotificationIcon"]];
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)subTextStringForNotificationList {
    NSString *subtext = nil;
    
    NSArray *callTree = [[SubsystemsController sharedInstance].securityController callTree];
    
    if (callTree.count == 0) {
        subtext = NSLocalizedString(@"Learn How To Alert Others", @"");
    } else {
        subtext = [self subTextForCallTree];
    }
    
    return subtext;
}

- (NSString *)subTextForCallTree {
    NSString *callTreeSubText = nil;
    
    NSArray *callTree = [[SubsystemsController sharedInstance].securityController callTree];
    
    BOOL firstEnabledFound = NO;
    
    NSInteger enabledCount = 0;
    
    for (NSDictionary *callTreeInfo in callTree) {
        if (callTreeInfo[@"person"] && [callTreeInfo[@"enabled"] boolValue]) {
            if (!firstEnabledFound) {
                callTreeSubText = [(PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:callTreeInfo[@"person"]] firstName];
                
                firstEnabledFound = YES;
            }
        }
        
        if ([callTreeInfo[@"enabled"] boolValue]) {
            enabledCount++;
        }
    }
    
    
    if (enabledCount >= 2) {
        callTreeSubText = [NSString stringWithFormat:@"%@ & %i More", callTreeSubText, (int)(enabledCount - 1)];
    } else if (enabledCount == 1){
        callTreeSubText = [NSString stringWithFormat:@"%@", callTreeSubText];
    }else {
        callTreeSubText = NSLocalizedString(@"Learn How To Alert Others", @"");
    }
    
    return callTreeSubText;
}

- (void)setupCellForNotificationList:(AlarmBaseViewControllerCell **)cell {
    BOOL isCallTreeEnabled = [[SubsystemsController sharedInstance].securityController isCallTreeEnabled];
    NSMutableArray *personImages = [NSMutableArray array];
    
    if (isCallTreeEnabled &&
        [SubsystemsController sharedInstance].securityController.callTree.count > 0) {
        
        for (NSDictionary *personDict in [SubsystemsController sharedInstance].securityController.callTree) {
            if (((NSNumber *)[personDict objectForKey:@"enabled"]).boolValue == NO ) {
                continue;
            }
            NSString *personAddress = [personDict objectForKey:@"person" ];
            UIImage *image = [(PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:personAddress] image];

            if (image == nil) {
                image = [UIImage imageNamed:@"userIcon"];
            }
            [personImages addObject:image];
        }
    }
    if (personImages.count > 0) {
        
        [*cell setLogos:personImages];
    }
    else {
        PersonModel *person = [[[CorneaHolder shared] settings] currentPerson];
        UIImage *image = [person image];
        if (image == nil) {
            image = [UIImage imageNamed:@"userIcon"];
        }
        [*cell setTitle: [NSLocalizedString(@"ALARM NOTIFICATION LIST", nil) capitalizedString] subtitle:NSLocalizedString(@"Learn How to Alert Others",nil)];
        [*cell setLogo:image];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *storyboard = @"AlarmStoryboard";

    switch ([indexPath row]) {
        case 0:
            [self.navigationController pushViewController:[AlarmDeviceListViewController create:AlarmDeviceTypeSecurityOnMode withStoryboard:storyboard] animated:YES];
            break;
            
        case 1:
            [self.navigationController pushViewController:[AlarmDeviceListViewController create:AlarmDeviceTypeSecurityPartialMode withStoryboard:storyboard] animated:YES];
            break;
            
        case 2:
            [self.navigationController pushViewController:[AlarmHistoryViewController create:AlarmTypeSecurity withStoryboard:storyboard] animated:YES];
            break;
            
        case 3:
            [self.navigationController pushViewController:[AlarmNotificationViewController create:AlarmTypeSecurity withStoryboard:storyboard] animated:YES];
            break;
            
        default:
            break;
    }
}


#pragma buttons action
- (void)popupUnreadyModeOn {
    NSString *noticeMessage = NSLocalizedString(@"Unsecure devices message", nil);
    
    PopupSelectionButtonsView *buttonView =
    [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"A Door Or Window Is Open", nil)
                                  subtitle:noticeMessage
                                    button:[PopupSelectionButtonModel create:@"Continue to arm" event:@selector(onContinueClicked:)], [PopupSelectionButtonModel create:@"Cancel" event:@selector(onCancelClicked:)], nil];
    buttonView.owner = self;
    [self popupWarning:buttonView complete:nil];
}

- (void)popupUnreadyModePartial {
    NSString *noticeMessage = NSLocalizedString(@"Unsecure devices message", nil);
    
    PopupSelectionButtonsView *buttonView =
    [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"A Door Or Window Is Open", nil)
                                      subtitle:noticeMessage
                                        button:[PopupSelectionButtonModel create:@"Continue to arm" event:@selector(partialContinueClicked:)], [PopupSelectionButtonModel create:@"Cancel" event:@selector(onCancelClicked:)], nil];
    buttonView.owner = self;
    [self popupWarning:buttonView complete:nil];
}



- (void)onContinueClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (![SubsystemsController sharedInstance] || ![SubsystemsController sharedInstance].securityController) {
            return;
        }
        [[SubsystemsController sharedInstance].securityController armByPassedModeOn].then(^{
            
        }).catch(^{
            DDLogWarn(@"onContinueClicked error encountered");
        });
    });
}

- (void)partialContinueClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([SubsystemsController sharedInstance].securityController == nil) {
            return;
        }
        [[SubsystemsController sharedInstance].securityController armByPassedModePartial].then(^{
            
        }).catch(^{
            DDLogWarn(@"partialContinueClicked error encountered");
        });
    });
}

- (void)onClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([SubsystemsController sharedInstance].securityController == nil) {
            return;
        }

        [[SubsystemsController sharedInstance].securityController armModeOn].then(^{
            
        }).catch(^(NSError *error){
            if (error) {
                NSString *errorCode = error.userInfo[@"code"];
                if ([errorCode isEqualToString:kErrorSecurityTriggeredDevicesBlockingArming]) {
                    [self popupUnreadyModeOn];
                }
            } else {
                DDLogWarn(@"Unknown error when arming security alarm");
            }
        });
    });
    
    //Tag that the security system is fully armed
    [ArcusAnalytics tag:AnalyticsTags.SecurityAlarm attributes:@{ AnalyticsTags.SelectedState : AnalyticsTags.SecurityAlarmFullyArmed }];
}

- (void)onCancelClicked:(id)sender {
}

- (void)partialClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([SubsystemsController sharedInstance].securityController == nil) {
            return;
        }

        [[SubsystemsController sharedInstance].securityController armPartial].then(^{
            
        }).catch(^(NSError *error){
            if (error) {
                NSString *errorCode = error.userInfo[@"code"];
                if ([errorCode isEqualToString:kErrorSecurityTriggeredDevicesBlockingArming]) {
                    [self popupUnreadyModePartial];
                }
            } else {
                DDLogWarn(@"Unknown error when partial arming security alarm");
            }
        });
    });
    
    //Tag that the security system is fully armed
    [ArcusAnalytics tag:AnalyticsTags.SecurityAlarm attributes:@{ AnalyticsTags.SelectedState : AnalyticsTags.SecurityAlarmPartiallyArmed }];
}

- (void)offClicked:(id)sender {
    [self stopTimer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (![SubsystemsController sharedInstance] || ![SubsystemsController sharedInstance].securityController) {
            return;
        }
        
        [[SubsystemsController sharedInstance].securityController disArm].then(^{
            
            //Tag that the security system is disarmed
            [ArcusAnalytics tag:AnalyticsTags.SecurityAlarm attributes:@{ AnalyticsTags.SelectedState : AnalyticsTags.SecurityAlarmDisarmed }];
            
        }).catch(^{
            DDLogWarn(@"offClicked error encountered");
        });
    });
}

- (void)deactivateAlarm {
    if (!_needToDisarmAlarm) {
        // Timer has already been stopped: DISARM has been called.
        // No need to DISARM again
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (![SubsystemsController sharedInstance] || ![SubsystemsController sharedInstance].securityController) {
            return;
        }
        
        [[SubsystemsController sharedInstance].securityController disArm].then(^{
            _needToDisarmAlarm = NO;
            [super deactivateAlarm];
            
            //Tag that the security system is disarmed
            [ArcusAnalytics tag:AnalyticsTags.SecurityAlarm attributes:@{ AnalyticsTags.SelectedState : AnalyticsTags.SecurityAlarmDisarmed }];
        }).catch(^{
            DDLogWarn(@"Get error");
        });
    });
}

- (void)cancelClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([SubsystemsController sharedInstance].securityController == nil) {
            return;
        }

        [[SubsystemsController sharedInstance].securityController disArm].then(^{
            
        }).catch(^{
            DDLogWarn(@"cancelClicked error encountered");
        });
    });
}

#pragma mark Notifications
- (void)securityStateChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        NSString *securityState = [[SubsystemsController sharedInstance].securityController stateString];
        if ([securityState isEqualToString: kEnumSecuritySubsystemAlarmStateARMING]) {
            _countTime = [self delayTime];
        }
        [self setRingText];
    } );
}

- (void)subsystemInitialized:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self setRingText];
    } );
}

- (void)securityModeChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView reloadData];
    });
}

- (void)devicesChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self setRingText];
        [self.tableView reloadData];
    });
}

- (void)notificationListChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    });
}

#pragma mark - setup Ring Text

- (void)setRingText {
    NSString *securityState = [[SubsystemsController sharedInstance].securityController stateString];
    NSString *securityMode = [[SubsystemsController sharedInstance].securityController mode];
    
    if ([SubsystemsController sharedInstance].securityController.isAlarmTriggered) {
        if (!self.isAlarming) {
            [self setUpViewsAlertMode];
        }
        return;
    } else if (self.isAlarming) {
        // This is here to not disable the alarm itself but to hide the active alarm if necessary
        // TODO: Remove this from setRingText. Unrelated consequences.
        [super deactivateAlarm];
    }
    
    if ([securityState isEqualToString: kEnumSecuritySubsystemAlarmStateDISARMED] || [securityMode isEqualToString:kEnumSecuritySubsystemAlarmModeOFF]) {
        [self setupViewsWithDisArmMode];
    }
    else if ([securityState isEqualToString: kEnumSecuritySubsystemAlarmStateARMING]) {
        [self setupViewsWithArmingMode];
    }
    else if ([securityState isEqualToString: kEnumSecuritySubsystemAlarmStateARMED] && ([securityMode isEqualToString:kEnumSecuritySubsystemAlarmModeON])) {
        [self setupViewsWithArmedMode];
    }
    else if ([securityState isEqualToString: kEnumSecuritySubsystemAlarmModePARTIAL] || [securityMode isEqualToString:kEnumSecuritySubsystemAlarmModePARTIAL] ) {
        [self setupViewsWithPartialMode];
    }
}

#pragma setup views with Mode

- (void)setupViewsWithArmedMode {
    [self stopTimer];
    [self setupRingTextFullArmedModeWithTitle:@"Devices"];
    [self setupButtonsArmMode];
    [self setupStateLabelArmMode];
    [self setupRingSegmentsArmedMode];
}

- (void)setupViewsWithArmingMode {
    [self startTimer];
    [self setupRingTextArmingModeIn:_countTime withTitle:@"Arming"];
    [self setupButtonsForArmingMode];
    [self setupStateLabelForArmingMode];
    [self setupRingSegmentsArmingMode];
}

- (void)setupViewsWithPartialMode {
    [self stopTimer];
    [self setupRingTextPartialModeWithTitle:@"Devices"];
    [self setupButtonsPartialMode];
    [self setupStateLabelPartialMode];
    [self setupRingSegmentsPartialMode];
}

- (void)setupViewsWithDisArmMode {
    [self stopTimer];
    [self setupRingtextDisarmedModeWithTitle:@"Security Alarm" text:@"Off"];
    [self setupButtonsForDisarmMode];
    [self setupStateLabelForDisarmMode];
    [self setupRingSegmentsDisArmMode];
}

- (int)delayTime {
    if ( [[[SubsystemsController sharedInstance].securityController mode] isEqualToString:kEnumSecuritySubsystemAlarmModeON] ) {
        return [[SubsystemsController sharedInstance].securityController getExitDelaySecForModeOn];
    }
    
    return [[SubsystemsController sharedInstance].securityController getExitDelaySecForModePartial];
}

- (void)setUpViewsAlertMode {
    [self setupRingAlertModeWithDefaultReason:@"ALARM" image:@"icon_unfilled_safetyAndPanicAlarm"];
    [self setupButtonsAlertMode];
    [self setupStateLabelForAlertMode];
}

#pragma setup Ring Text

- (void)setupRingAlertModeWithDefaultReason:(NSString *)defaultReason image:(NSString *)imageName {
    Model *model = [[SubsystemsController sharedInstance].securityController getFirstTriggerDevice];
    NSString *reason = [[SubsystemsController sharedInstance].securityController lastAlertCause];
    NSString *iconImageName = @"icon_unfilled_safetyAndPanicAlarm";
    
    if ([reason isKindOfClass:[NSNull class]] || reason.length == 0) {
        reason = NSLocalizedString(defaultReason, nil);
    }
    
    if ([model isKindOfClass:[DeviceModel class]]) {
        [self activeAlarmWithName:[model name] event:reason icon:nil borderColor:pinkAlertColor];
        [self setIconByDevice:(DeviceModel *)model withImage:iconImageName];
    }
    else if ([model isKindOfClass:[PersonModel class]]) {
        [self activeAlarmWithName:[NSString stringWithFormat:@"%@ %@", [PersonCapability getFirstNameFromModel:(PersonModel *)model], [PersonCapability getLastNameFromModel:(PersonModel *)model]] event:reason icon:nil borderColor:pinkAlertColor];
        [self setIconByDevice:nil withImage:iconImageName];
    }
    else if ([model isKindOfClass:[RuleModel class]]) {
        [self activeAlarmWithName:[RuleCapability getNameFromModel:(RuleModel *)model] event:reason icon:nil borderColor:pinkAlertColor];
        [self setIconByDevice:nil withImage:iconImageName];
    }
    else {
        [self activeAlarmWithName:nil event:reason icon:nil borderColor:pinkAlertColor];
        [self setIconByDevice:nil withImage:iconImageName];
    }
}

- (void)setupRingtextDisarmedModeWithTitle:(NSString *)title text:(NSString *)text {
    [self setRingTitle:NSLocalizedString(title, nil)];
    [self setRingText:NSLocalizedString(text, nil)];
}

- (void)setupRingTextArmingModeIn:(int)seconds withTitle:(NSString *)title{
    [self setRingTitle:NSLocalizedString(title, nil)];
    [self setRingText:[NSString stringWithFormat:@"%d",seconds] withSuperscript:@" s"];
}

- (void)setupRingTextFullArmedModeWithTitle:(NSString *)title {
    [self setRingTitle:NSLocalizedString(title, nil)];
    
    int numberOfOfflineDevices = [[SubsystemsController sharedInstance].securityController numberOfRedSegments];
    int numberOfSecurityDevices = [[SubsystemsController sharedInstance].securityController totalNumberOfSegments];
    int numberOfOpenDevices = [[SubsystemsController sharedInstance].securityController numberOfGreySegments];
    
    if ((numberOfOfflineDevices == 0) && (numberOfOpenDevices == 0)) {
        [self setRingText:[NSString stringWithFormat:@"%d", numberOfSecurityDevices]];
    } else {
        int numberOfArmedDevices = [[SubsystemsController sharedInstance].securityController numberOfWhiteSegments];
        [self setRingText:[NSString stringWithFormat:@"%d", numberOfArmedDevices] withSuperscript:[NSString stringWithFormat:@"/ %d", numberOfSecurityDevices]];
    }
}

- (void)setupRingTextPartialModeWithTitle:(NSString *)title {
    [self setRingTitle:NSLocalizedString(title, nil)];
    
    int numberOfOfflineDevices = [[SubsystemsController sharedInstance].securityController numberOfRedSegments];
    int numberOfSecurityDevices = [[SubsystemsController sharedInstance].securityController totalNumberOfSegments];
    int numberOfOpenDevices = [[SubsystemsController sharedInstance].securityController numberOfGreySegments];
    
    if ((numberOfOfflineDevices == 0) && (numberOfOpenDevices == 0)) {
        [self setRingText:[NSString stringWithFormat:@"%d", numberOfSecurityDevices]];
    } else {
        int numberOfArmedDevices = [[SubsystemsController sharedInstance].securityController numberOfWhiteSegments];
        [self setRingText:[NSString stringWithFormat:@"%d", numberOfArmedDevices] withSuperscript:[NSString stringWithFormat:@"/ %d", numberOfSecurityDevices]];
    }
}

#pragma mark - state buttons

- (void)setupButtonsForDisarmMode {
    
    DeviceButtonBaseControl *onButton = [DeviceButtonBaseControl createDefaultButton:@"ON" withSelector:@selector(onClicked:) owner:self];
    DeviceButtonBaseControl *PartialButton = [DeviceButtonBaseControl createDefaultButton:@"Partial" withSelector:@selector(partialClicked:) owner:self];
    
    [self loadButton:onButton button2:PartialButton];
}

- (void)setupButtonsForArmingMode {
    DeviceButtonBaseControl *offButton = [DeviceButtonBaseControl createDefaultButton:@"OFF" withSelector:@selector(offClicked:) owner:self];
    [self loadButton:offButton];
}

- (void)setupButtonsArmMode {
    DeviceButtonBaseControl *offButton = [DeviceButtonBaseControl createDefaultButton:@"OFF" withSelector:@selector(offClicked:) owner:self];

    [self loadButton:offButton];
}

- (void)setupButtonsPartialMode {
    DeviceButtonBaseControl *offButton = [DeviceButtonBaseControl createDefaultButton:@"OFF" withSelector:@selector(offClicked:) owner:self];
    [self loadButton:offButton];
    
}

- (void)setupButtonsAlertMode {
    DeviceButtonBaseControl *cancelButton = [DeviceButtonBaseControl createDefaultButton:@"OFF" withSelector:@selector(cancelClicked:) owner:self];
    [self loadButton:cancelButton];
}

#pragma mark - State Label
- (void)setupStateLabelForAlertMode {
    NSDate *lastAlertTime = [[SubsystemsController sharedInstance].securityController lastAlertTime];
    [self setupStateLabelWithDate:lastAlertTime];
}

- (void)setupStateLabelForDisarmMode {
    NSDate *lastDisarmedTime = [[SubsystemsController sharedInstance].securityController lastDisarmedTime];
    [self setupStateLabelWithDate:lastDisarmedTime withTitle:@"Off Since"];
}

- (void)setupStateLabelForArmingMode {
    [self setupStateLabelWithTitle:@"Arming" subtitle:@"..."];
}

- (void)setupStateLabelArmMode {
    NSDate *lastArmedTime = [[SubsystemsController sharedInstance].securityController lastArmedTime];
    [self setupStateLabelWithDate:lastArmedTime withTitle:@"On Since"];
}

- (void)setupStateLabelPartialMode {
    NSDate *lastArmedTime = [[SubsystemsController sharedInstance].securityController lastArmedTime];
    [self setupStateLabelWithDate:lastArmedTime withTitle:@"Partial Since"];
}

- (void)setupStateLabelWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    DeviceTextAttributeControl *textControl = [DeviceTextAttributeControl create:title withValue:subtitle];
    [self.attributesView loadControl:textControl];
}

- (void)setupStateLabelWithDate:(NSDate *)date withTitle:(NSString *)title {
    DeviceTimeAttributeControl *timeControl = [DeviceTimeAttributeControl createWithDate:date withState:NSLocalizedString(title, nil)];
    
    [self.attributesView loadControl:timeControl];
}
- (void)setupStateLabelWithDate:(NSDate *)date {
    [self setupStateLabelWithDate:date withTitle:@"Set at"];
}

#pragma mark - Ring segments

- (void)setupRingSegmentsDisArmMode {
    NSArray *segmentModels = [SegmentModelsBuilder ringSegmentsDisArmMode];
    [self loadRingSigmentsWithModel:segmentModels];
}

- (void)setupRingSegmentsArmingMode {
    [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegmentsArmingMode]];
}

- (void)setupRingSegmentsPartialMode {
    [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegMentsArmedMode]];
}

- (void)setupRingSegmentsArmedMode {
    [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegMentsArmedMode]];
}

#pragma mark - Timer

- (void)countDown {
    if (_countTime < 0) {
        [self stopTimer];
        return;
    }
    
    [self setRingText:[NSString stringWithFormat:@"%d",_countTime] withSuperscript:@" s"];
    _countTime -= 1;
}

- (BOOL)stopTimer {
    if (!_countDownTimer) {
        return NO;
    }
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    return YES;
}

- (void)startTimer {
    [self stopTimer];
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(countDown)
                                                     userInfo:nil
                                                      repeats:YES];
    [_countDownTimer fire];
}

- (void)loadTimer {
    NSDictionary *timerDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"ArmingTimer"];
    
    if (timerDict != nil) {
        int remainingTime = ((NSNumber *)[timerDict objectForKey:@"TimerCounter"]).intValue;
        NSDate *timeStamp = [timerDict objectForKey:@"TimeStamp"];
        NSTimeInterval interValInSecond = - [timeStamp timeIntervalSinceNow];
        if ((int)interValInSecond < remainingTime) {
            _countTime = (int)(remainingTime - interValInSecond);
            return;
        }
    }
    
    _countTime = 0;
}

- (void)saveTimer {
    NSString *securityState = [[SubsystemsController sharedInstance].securityController stateString];
    
    if (_countTime != 0 && ([securityState isEqualToString: kEnumSecuritySubsystemAlarmStateARMING]) ) {
        NSMutableDictionary *timerDict = [[NSMutableDictionary  alloc] init];
        [timerDict setObject:[NSNumber numberWithInt:_countTime] forKey:@"TimerCounter"];
        [timerDict setObject:[NSDate date] forKey:@"TimeStamp"];
        [[NSUserDefaults standardUserDefaults] setObject:timerDict forKey:@"ArmingTimer"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        return;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ArmingTimer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

