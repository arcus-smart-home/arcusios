//
//  SafetyAlarmViewController.m
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
#import "SafetyAlarmViewController.h"
#import "SegmentModelsBuilder.h"
#import "DeviceTextAttributeControl.h"
#import "AlarmConfiguration.h"
#import "AlarmDeviceListViewController.h"
#import "AlarmNotificationViewController.h"


#import "SubsystemsController.h"
#import "SafetySubsystemCapability.h"
#import "SafetySubsystemAlertController.h"


#import "AlarmPartialSettingViewController.h"
#import "AlarmHistoryViewController.h"

#import "PopupSelectionWindow.h"
#import <i2app-Swift.h>

@interface SafetyAlarmViewController ()

@property (nonatomic, weak) IBOutlet UIView *alertView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *alertViewBottomConstraint;
@property (nonatomic, weak) IBOutlet UILabel *alertTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *alertTextLabel;
@property (nonatomic, assign) BOOL isClearingWarningVisible;

@end

@implementation SafetyAlarmViewController {
    DeviceTextAttributeControl *_smokeStateControl;
    DeviceTextAttributeControl *_waterStateControl;
    DeviceTextAttributeControl *_coStateControl;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitle:@"Status"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isClearingWarningVisible = NO;
    
    //Tag Service - Safety:
    [ArcusAnalytics tag:AnalyticsTags.SafetyAlarm attributes:@{}];
    
    _smokeStateControl = [DeviceTextAttributeControl create:@"SMOKE" withValue:@""];
    _coStateControl = [DeviceTextAttributeControl create:@"CO" withValue:@""];
    _waterStateControl = [DeviceTextAttributeControl create:@"WATER LEAK" withValue:@""];
    [self safetyStateChanged:nil];
    
    [self.attributesView loadControl:_smokeStateControl control2:_coStateControl control3:_waterStateControl];
    [self removeButtons];
    
    [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegMentsSafetyDevices]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(safetyStateChanged:)
                                                 name:[Model attributeChangedNotification:kAttrSafetySubsystemAlarm]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(numberOfDevicesChanged:)
                                                 name:[Model attributeChangedNotification:kAttrSafetySubsystemTotalDevices]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(numberOfDevicesChanged:)
                                                 name:[Model attributeChangedNotification:kAttrSafetySubsystemActiveDevices]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationListChanged:)
                                                 name:[Model attributeChangedNotification:kAttrSafetySubsystemCallTreeEnabled]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationListChanged:)
                                                 name:[Model attributeChangedNotification:kAttrSafetySubsystemCallTreeEnabled]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeAlert:)
                                                 name:@"ClearingSafetyAlarmAlertClosed"
                                               object:nil];

}

- (NSString *)convertStateToUIState:(NSString *)state {
    if ([state isEqualToString:@"NONE"]) {
        return NSLocalizedString(@"NONE", nil);
    }
    else if ([state isEqualToString:@"DETECTED"]) {
        if ([[[SubsystemsController sharedInstance].safetyController alarmState] isEqualToString:@"CLEARING"]) {
            return NSLocalizedString(@"CLEARING", nil);
        }
        return NSLocalizedString(@"DETECTED", nil);
    }
    else if ([state isEqualToString:@"SAFE"]) {
        return NSLocalizedString(@"NO", nil);
    }
    
    return state;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmBaseViewControllerCell *cell = (AlarmBaseViewControllerCell *)[tableView dequeueReusableCellWithIdentifier:@"logoTextCell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    SafetySubsystemAlertController *safetyController = [SubsystemsController sharedInstance].safetyController;
    NSString *subtitle;

    switch ([indexPath row]) {
        case 0:
            if (safetyController.numberOfOfflineDevices > 0 && safetyController.numberOfOnlineDevices > 0) {
                subtitle = [NSString stringWithFormat:@"%d %@, %d %@", [SubsystemsController sharedInstance].safetyController.numberOfOfflineDevices, NSLocalizedString(@"Offline", nil), [SubsystemsController sharedInstance].safetyController.numberOfOnlineDevices, NSLocalizedString(@"Online", nil)];
            }
            else if (safetyController.numberOfOfflineDevices > 0) {
                subtitle = [NSString stringWithFormat:@"%d %@", [SubsystemsController sharedInstance].safetyController.numberOfOfflineDevices, NSLocalizedString(@"Offline", nil)];
            }
            else if (safetyController.numberOfOnlineDevices > 0) {
                subtitle = [NSString stringWithFormat:@"%d %@", [SubsystemsController sharedInstance].safetyController.numberOfOnlineDevices, NSLocalizedString(@"Devices", nil)];
            }
            [cell setTitle:[NSLocalizedString(@"SAFETY ALARM DEVICES", nil) capitalizedString] subtitle:subtitle];
            
            [cell setLogo:[UIImage imageNamed:@"icon_unfilled_safetyAndPanicAlarm"]];
            break;
            
        case 1:
            [cell setTitle:[NSLocalizedString(@"ALARM HISTORY", nil) capitalizedString] subtitle:[self detailTextForCell:(int)indexPath.row]];
            [cell setLogo:[UIImage imageNamed:@"icon_alert"]];
            break;
            
        case 2:
            [cell setTitle:[NSLocalizedString(@"ALARM NOTIFICATION LIST", nil) capitalizedString] subtitle:[self detailTextForCell:(int)indexPath.row]];
            
            [cell setLogo:[UIImage imageNamed:@"CareNotificationIcon"]];

            break;
            
        default:
            break;
    }

    return cell;
}

- (NSString *)detailTextForCell:(int)index {
    NSString *returnString;
    
    switch (index) {
        case 0:
            break;
        case 1:
            returnString = [[SubsystemsController sharedInstance].safetyController lastTriggeredString];
            break;
        case 2:
            returnString = [self subTextStringForNotificationList];
            break;
    }
    
    return returnString;
}

- (NSString *)subTextStringForNotificationList {
    NSString *subtext = nil;
    
    NSArray *callTree = [[SubsystemsController sharedInstance].safetyController callTree];
    
    if (callTree.count == 0) {
        subtext = NSLocalizedString(@"Learn How To Alert Others", @"");
    } else {
        subtext = [self subTextForCallTree];
    }
    
    return subtext;
}

- (NSString *)subTextForCallTree {
    NSString *callTreeSubText = nil;
    
    NSArray *callTree = [[SubsystemsController sharedInstance].safetyController callTree];
    
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
    BOOL isCallTreeEnabled = [[SubsystemsController sharedInstance].safetyController isCallTreeEnabled];
    NSMutableArray *personImages = [NSMutableArray array];
    
    if (isCallTreeEnabled &&
        [SubsystemsController sharedInstance].safetyController.callTree.count > 0) {
       
        for (NSDictionary *personDict in [SubsystemsController sharedInstance].safetyController.callTree) {
            if (((NSNumber *)[personDict objectForKey:@"enabled"]).boolValue == NO ) {
                continue;
            }
            
            NSString *personAdress = [personDict objectForKey:@"person" ];
            UIImage *image = [(PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:personAdress] image];
           
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

        [*cell setTitle:[NSLocalizedString(@"ALARM NOTIFICATION LIST", nil) capitalizedString] subtitle:NSLocalizedString(@"Learn How to Alert Others", nil)];
        [*cell setLogo:image];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *storyboard = @"AlarmStoryboard";
    
    switch ([indexPath row]) {
        case 0:
            [self.navigationController pushViewController:[AlarmDeviceListViewController create:AlarmDeviceTypeSafety withStoryboard:storyboard] animated:YES];
            break;
            
        case 1:
            [self.navigationController pushViewController:[AlarmHistoryViewController create:AlarmTypeSafety withStoryboard:storyboard] animated:YES];
            break;
            
        case 2:
            [self.navigationController pushViewController:[AlarmNotificationViewController create:AlarmTypeSafety withStoryboard:storyboard] animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - Notifications
- (void)safetyStateChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        SafetySubsystemAlertController *safetyController = [SubsystemsController sharedInstance].safetyController;
        
        [self.attributesView loadControl:_smokeStateControl control2:_coStateControl control3:_waterStateControl];
        
        [_smokeStateControl setValueText:[self smokeSateStringWithState:[safetyController smokeState]]];
        [_coStateControl  setValueText:[self coSateStringWithState:[safetyController coState]]];
        [_waterStateControl  setValueText:[self waterLeakSateStringWithState:[safetyController waterState]]];
        
        [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegMentsSafetyDevices]];
        
        [self checkAlarmStateForEvent:@"ALARM" withImage:@"icon_unfilled_safetyAndPanicAlarm"];
    } );
}

- (NSString *)coSateStringWithState:(NSString *)state {
    int numberOfOfflineCoSensor = [[SubsystemsController sharedInstance].safetyController numberOfOfflineCOSensors];
    if (numberOfOfflineCoSensor > 0) {
        return [NSString stringWithFormat:@"%d OFFLINE", numberOfOfflineCoSensor];
    }
    return [self convertStateToUIState:state];
}

- (NSString *)smokeSateStringWithState:(NSString *)state {
    int numberOfOfflineSmokeSensor = [[SubsystemsController sharedInstance].safetyController numberOfOfflineSmokeSensors];
    if (numberOfOfflineSmokeSensor > 0) {
        return [NSString stringWithFormat:@"%d OFFLINE", numberOfOfflineSmokeSensor];
    }
    return [self convertStateToUIState:state];
}

- (NSString *)waterLeakSateStringWithState:(NSString *)state {
    int numberOfOfflineWaterLeakSensor = [[SubsystemsController sharedInstance].safetyController numberOfOfflineWaterLeakSensor];
    if (numberOfOfflineWaterLeakSensor > 0) {
        return [NSString stringWithFormat:@"%d OFFLINE", numberOfOfflineWaterLeakSensor];
    }
    
    return [self convertStateToUIState:state];
}

- (void)checkAlarmStateForEvent:(NSString *)event withImage:(NSString *)imageName {
    NSString *alarmState = [[SubsystemsController sharedInstance].safetyController alarmState];
    
//    if ([alarmState isEqualToString:kEnumSafetySubsystemAlarmALERT]) {
//        DeviceModel *device = [[SubsystemsController sharedInstance].safetyController getFirstTriggeredDevice];
//
//        //TODO last Alert Cause is nil for some reason
//        // NSString *reason = [[SubsystemsController sharedInstance].safetyController lastAlertCause];
//        
//        NSString *reason = [self reasonForTriggeredDeviceWithId:device.modelId];
//        NSDate *date = [[SubsystemsController sharedInstance].safetyController lastAlertTime];
//        DeviceTimeAttributeControl *timeControl = [DeviceTimeAttributeControl createWithDate:date withState: reason];
//        
//        [self.attributesView loadControl:timeControl];
//        [self activeAlarmWithName:[device name] event:event icon:nil borderColor:pinkAlertColor];
//        [self setIconByDevice:device withImage:imageName];
//    } else if (![alarmState isEqualToString:kEnumSafetySubsystemAlarmCLEARING]) {
//        [super deactivateAlarm];
//    }
}

- (void)deactivateAlarm {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        DeviceModel *device = [[SubsystemsController sharedInstance].safetyController getFirstTriggeredDevice];
        __block NSString *alarmType = [self reasonForTriggeredDeviceWithId:device.modelId];
        if ([SubsystemsController sharedInstance].safetyController != nil) {
            [[SubsystemsController sharedInstance].safetyController clear].then(^{
                NSString *alarmState = [[SubsystemsController sharedInstance].safetyController currentAlarmState];
                [super deactivateAlarm];
                
//                if ([alarmState isEqualToString:kEnumSafetySubsystemAlarmCLEARING] ||
//                    [alarmState isEqualToString:kEnumSafetySubsystemAlarmALERT]) {
//                    [self showClearingWarning:alarmType];
//                }
            });
        }
    });
}

- (void)closeAlert:(NSNotification *)notification {
    [super deactivateAlarm];
}

- (NSString *)reasonForTriggeredDeviceWithId:(NSString *)deviceId {
    NSString *reason = [[SubsystemsController sharedInstance].safetyController reasonForTriggeredDeviceWithId:deviceId];
    
    if (reason.length > 0) {
        return  [NSString stringWithFormat:@"%@ DETECTED", reason];
    }
    
    return @"";
}

- (void)numberOfDevicesChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [super setRingTextWithTitle:@"Devices"];
        [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegMentsSafetyDevices]];
    } );
}

- (void)notificationListChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    });
}

- (void)showClearingWarning:(NSString *)alarmType {
    if (!self.isClearingWarningVisible) {
        NSString *localizedString = nil;
        
        if ([alarmType isEqualToString:@"CO DETECTED"]) {
            localizedString = NSLocalizedString(@"Cleared CO Safety Alarm String", nil);
        } else if ([alarmType isEqualToString:@"SMOKE DETECTED"]) {
            localizedString = NSLocalizedString(@"Cleared Smoke Safety Alarm String", nil);
        }
        
        if (localizedString) {
            self.alertTitleLabel.text = NSLocalizedString(@"Alarm May Still Be Sounding", nil);
            self.alertTextLabel.text = localizedString;
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ (void) {
                                 self.alertViewBottomConstraint.constant = 15.0f;
                                 [self.alertView setNeedsDisplay];
                             }
                             completion:^ (BOOL finished) {
                                 self.isClearingWarningVisible = YES;
                             }];
        }
    }
}

- (IBAction)closeAlertPressed:(id)sender {
    if (self.isClearingWarningVisible) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ (void) {
                             self.alertViewBottomConstraint.constant = -self.alertView.frame.size.height;
                             [self.alertView setNeedsDisplay];
                         }
                         completion:^ (BOOL finished) {
                             self.isClearingWarningVisible = NO;
                         }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearingSafetyAlarmAlertClosed"
                                                            object:nil];
    }
}

@end
