//
//  AlarmMorePackage.m
//  i2app
//
//  Created by Arcus Team on 8/24/15.
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
#import "AlarmMorePackage.h"
#import "AlarmMoreViewControllerOld.h"
#import "AlarmDeviceListViewController.h"
#import "NSDate+Convert.h"
#import "UIViewController+AlertBar.h"

#import "SecuritySubsystemAlertController.h"
#import "SafetySubsystemAlertController.h"
#import "SubsystemsController.h"
#import "SafetySubsystemCapability.h"

#import "NSDate+Convert.h"
#import "PopupSelectionMinsTimerView.h"
#import "PopupSelectionNumberView.h"
#import "PopupSelectionButtonsView.h"
#import <i2app-Swift.h>

@interface AlarmBaseMorePackage()

@property (weak, nonatomic) AlarmMoreViewControllerOld *owner;

@end

@implementation AlarmBaseMorePackage

- (NSString *)getTitle {
    return nil;
}

- (NSArray *)getUnits {
    return @[];
}

- (void)updateList {
    if (_owner) {
        
    }
}

@end


@implementation AlarmSafetyMorePackage {
    PopupSelectionWindow    *_popupWindow;
}

- (NSString *)getTitle {
    return NSLocalizedString(@"More", nil);
}

- (NSArray *)getUnits {
    NSMutableArray *units = [[NSMutableArray alloc] init];
    
    BOOL waterShutOffValve = [[SubsystemsController sharedInstance].safetyController getWaterShutOff];
    
    AlarmMoreUnitModel *model = [AlarmMoreUnitModel createSwitchModel:NSLocalizedString(@"Water Shut Off Valve", nil) subtitle:NSLocalizedString(@"Turn water off when a leak is detected.", nil) selected:waterShutOffValve switchEvent:^(AlarmMoreUnitModel *model) {
        if (![[SubsystemsController sharedInstance].safetyController hasWaterShutOffVales]) {
            PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Forget something?", nil) subtitle:NSLocalizedString(@"You don't have a Water Shut-Off Valve\nconnected to Arcus.", nil) button:[PopupSelectionButtonModel create:NSLocalizedString(@"CANCEL", nil) event:nil], [PopupSelectionButtonModel create:NSLocalizedString(@"BUY WATER SHUT-OFF VALVE", nil) event:@selector(buyWaterValve)], nil];
            buttonView.owner = self;
            _popupWindow = [PopupSelectionWindow popup:[ApplicationRoutingService.defaultService displayingViewControllerInViewController:nil].view
                                               subview:buttonView
                                                 owner:self
                                         closeSelector:nil
                                                 style:PopupWindowStyleCautionWindow];
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [[SubsystemsController sharedInstance].safetyController setWaterShutOff:model.enable];
            });
            
        }
    }];
    
    if (![[SubsystemsController sharedInstance].safetyController hasWaterShutOffVales]) {
        model.disabled = YES;
    }
    
    [units addObject:model];
    
    BOOL silent = [[SubsystemsController sharedInstance].safetyController getSilent];
    [units addObject:[AlarmMoreUnitModel createSwitchModel:NSLocalizedString(@"Silent alarm", nil) subtitle:NSLocalizedString(@"No sound will be made when alarm is triggered, but Arcus will send push notifications and phone calls based on the Alarm Notification List", nil) selected:silent switchEvent:^(AlarmMoreUnitModel *model) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            [[SubsystemsController sharedInstance].safetyController setSilent:model.enable];
        });
    }]];
    
    return units;
}

- (void)buyWaterValve {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @""] options:@{} completionHandler:nil];
}

@end


@implementation AlarmSecurityMorePackage

- (NSString *)getTitle {
    return NSLocalizedString(@"More", nil);
}

- (NSArray *)getUnits {
    NSMutableArray *units = [[NSMutableArray alloc] init];
    NSString *storyboard = @"AlarmStoryboard";
    
    [units addObject:[AlarmMoreUnitModel createLabelModel:NSLocalizedString(@"Alarm Devices", nil) subtitle:NSLocalizedString(@"Assign Devices for On & Partial Alarms", nil) pressedEvent:^(AlarmMoreUnitModel *model) {
        NSArray *allSecurityDeviceIds = [[SubsystemsController sharedInstance].securityController allDeviceIds];
        AlarmDeviceListViewController *vc =  [AlarmDeviceListViewController createWithDevices:allSecurityDeviceIds withStoryboard:storyboard];
        [model.owner.navigationController pushViewController:vc animated:YES];
        
    }]];
    
    [units addObject:[AlarmMoreUnitModel createLabelModel:NSLocalizedString(@"Grace Periods", nil) subtitle:NSLocalizedString(@"Time Needed to Enter & Exit Home", nil) pressedEvent:^(AlarmMoreUnitModel *model) {
        AlarmMoreViewControllerOld *vc = [AlarmMoreViewControllerOld createWithPackage:[[AlarmSecurityGracePeriodMorePackge alloc] init] withStoryboard:storyboard];
        [model.owner.navigationController pushViewController:vc animated:YES];
        
        
    }]];
    
    int alarmSensitivityDeviceCount = [[SubsystemsController sharedInstance].securityController alarmSensitivityDeviceCount];
    NSString *numberOfRequirementDevices = [NSString stringWithFormat:@"%d", alarmSensitivityDeviceCount];
    
    [units addObject:[AlarmMoreUnitModel createLabelModel:NSLocalizedString(@"Alarm Requirement", nil) subtitle:NSLocalizedString(@"Number of Devices That Need to be Triggered Before the Alarm Goes Off", nil) sideValue:numberOfRequirementDevices pressedEvent:^(AlarmMoreUnitModel *model) {
        
        int numberOfDevices = [[SubsystemsController sharedInstance].securityController numberOfDevices];
        PopupSelectionNumberView *popupNumber = [PopupSelectionNumberView create:NSLocalizedString(@"Choose number of devices", nil) withMaxNumber:numberOfDevices];
        
        NSNumber *currentValue = @([[SubsystemsController sharedInstance].securityController alarmSensitivityDeviceCount]);
        
        [model.owner popupWithBlockSetCurrentValue:popupNumber currentValue:currentValue completeBlock:^(id selectedValue) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                
                [[SubsystemsController sharedInstance].securityController setAlarmSensitivityDeviceCount:((NSNumber *)selectedValue).intValue];
            });
        }];
        
    }]];
    
    [units addObject:[AlarmMoreUnitModel createLabelModel:NSLocalizedString(@"Sounds", nil) subtitle:NSLocalizedString(@"Configure Alarm Sounds", nil) pressedEvent:^(AlarmMoreUnitModel *model) {
        AlarmMoreViewControllerOld *vc = [AlarmMoreViewControllerOld createWithPackage:[[AlarmSecuritySoundMorePackage alloc] init] withStoryboard:storyboard];
        [model.owner.navigationController pushViewController:vc animated:YES];
    }]];
    
    return units;
}

@end

@implementation AlarmSecurityGracePeriodMorePackge

- (NSString *)getTitle {
    return NSLocalizedString(@"Grace Period", nil);
}

- (NSArray *)getUnits {
    
    NSMutableArray *units = [[NSMutableArray alloc] init];
    
    [units addObject: [self exitDelayModeOnUnit]];
    [units addObject: [self entranceDelayModeOnUnit]];
    [units addObject: [self exitDelayModePartialUnit]];
    [units addObject: [self entranceDelayModePartialUnit]];
    
    return units;
}

- (AlarmMoreUnitModel *)exitDelayModeOnUnit {
    SecuritySubsystemAlertController *securitySubsystemController = [SubsystemsController sharedInstance].securityController;
    int exitDelaySecModeOn = [securitySubsystemController getExitDelaySecForModeOn];
    NSString *exitDelaySecModeOnString = [NSString stringWithFormat:@"%ds",exitDelaySecModeOn];
    
    return [AlarmMoreUnitModel createLabelModel:NSLocalizedString(@"ON - EXIT DELAY", nil) subtitle:NSLocalizedString(@"Time Needed to Exit Before the Alarm Arms", nil) sideValue:exitDelaySecModeOnString  pressedEvent:^(AlarmMoreUnitModel *model) {
        
        int exitDelay= [[SubsystemsController sharedInstance].securityController getExitDelaySecForModeOn];
        NSDate *selectedDate = [NSDate dateForTotalDelaySeconds:exitDelay];
        
        PopupSelectionMinsTimerView *popupTimer = [PopupSelectionMinsTimerView create:NSLocalizedString(@"Delay", nil) withDate:selectedDate];
        
        
        [model.owner popupWithBlockSetCurrentValue:popupTimer  currentValue:selectedDate completeBlock:^(id selectedValue) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                
                [[SubsystemsController sharedInstance].securityController setExitDelaySecForModeOn:[(NSDate *)selectedValue getSeconds]];
            });
        }];
    }];
}

- (AlarmMoreUnitModel *)entranceDelayModeOnUnit {
    SecuritySubsystemAlertController *securitySubsystemController = [SubsystemsController sharedInstance].securityController;
    
    int entranceDelaySecModeOn = [securitySubsystemController getEntranceDelaySecForModeOn];
    NSString *entranceDelaySecModeOnString = [NSString stringWithFormat:@"%ds",entranceDelaySecModeOn];
    
    return [AlarmMoreUnitModel createLabelModel:NSLocalizedString(@"ON - ENTRANCE DELAY", nil) subtitle:NSLocalizedString(@"Time Needed to Disarm After Entering Home", nil)  sideValue:entranceDelaySecModeOnString pressedEvent:^(AlarmMoreUnitModel *model) {
        
        int entranceDelay= [[SubsystemsController sharedInstance].securityController getEntranceDelaySecForModeOn];
        NSDate *selectedDate = [NSDate dateForTotalDelaySeconds:entranceDelay];
        
        PopupSelectionMinsTimerView *popupTimer = [PopupSelectionMinsTimerView create:NSLocalizedString(@"Delay", nil) withDate:selectedDate];
        
        [model.owner popupWithBlockSetCurrentValue:popupTimer currentValue:selectedDate completeBlock:^(id selectedValue) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [[SubsystemsController sharedInstance].securityController setEntranceDelaySecForModeOn:[(NSDate *)selectedValue getSeconds]];
            });
        }];
    }];
}

- (AlarmMoreUnitModel *)exitDelayModePartialUnit {
    SecuritySubsystemAlertController *securitySubsystemController = [SubsystemsController sharedInstance].securityController;
    
    int exitDelaySecModePartial = [securitySubsystemController getExitDelaySecForModePartial];
    NSString *exitDelaySecModePartialString = [NSString stringWithFormat:@"%ds",exitDelaySecModePartial];
    
    return [AlarmMoreUnitModel createLabelModel:NSLocalizedString(@"PARTIAL - EXIT DELAY", nil) subtitle:NSLocalizedString(@"Time Needed to Exit Before the Alarm Arms", nil) sideValue:exitDelaySecModePartialString pressedEvent:^(AlarmMoreUnitModel *model) {
        
        int exitDelay= [[SubsystemsController sharedInstance].securityController getExitDelaySecForModePartial];
        NSDate *selectedDate = [NSDate dateForTotalDelaySeconds:exitDelay];
        
        PopupSelectionMinsTimerView *popupTimer = [PopupSelectionMinsTimerView create:NSLocalizedString(@"Delay", nil) withDate:selectedDate];
        
        [model.owner popupWithBlockSetCurrentValue:popupTimer currentValue:selectedDate completeBlock:^(id selectedValue) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                
                [[SubsystemsController sharedInstance].securityController setExitDelaySecForModePartial:[(NSDate *)selectedValue getSeconds]];
            });
        }];
    }];
}

- (AlarmMoreUnitModel *)entranceDelayModePartialUnit {
    SecuritySubsystemAlertController *securitySubsystemController = [SubsystemsController sharedInstance].securityController;
    
    int entranceDelaySecModePartial = [securitySubsystemController getEntranceDelaySecForModePartial];
    NSString *entranceDelaySecModePartialString = [NSString stringWithFormat:@"%ds",entranceDelaySecModePartial];
    
    return [AlarmMoreUnitModel createLabelModel:NSLocalizedString(@"PARTIAL - ENTRANCE DELAY", nil) subtitle:NSLocalizedString(@"Time Needed to Disarm After Entering Home", nil)  sideValue:entranceDelaySecModePartialString pressedEvent:^(AlarmMoreUnitModel *model) {
        
        int entranceDelay= [[SubsystemsController sharedInstance].securityController getEntranceDelaySecForModePartial];
        NSDate *selectedDate = [NSDate dateForTotalDelaySeconds:entranceDelay];
        
        PopupSelectionMinsTimerView *popupTimer = [PopupSelectionMinsTimerView create:NSLocalizedString(@"Delay", nil) withDate:selectedDate];
        [model.owner popupWithBlockSetCurrentValue:popupTimer  currentValue:selectedDate completeBlock:^(id selectedValue) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [[SubsystemsController sharedInstance].securityController setEntranceDelaySecForModePartial:[(NSDate *)selectedValue getSeconds]];});
        }];
    }];
}


@end

@implementation AlarmSecuritySoundMorePackage

- (NSString *)getTitle {
    return NSLocalizedString(@"Sounds", nil);
}

- (NSArray *)getUnits {
    NSMutableArray *units = [[NSMutableArray alloc] init];
    
    BOOL soundEnabled = [[SubsystemsController sharedInstance].securityController getSoundsEnabled];
    [units addObject:[AlarmMoreUnitModel createSwitchModel:NSLocalizedString(@"ALARM SOUNDS", nil) subtitle:NSLocalizedString(@"Hub and keypad make sounds while arming?", nil) selected:soundEnabled switchEvent:^(AlarmMoreUnitModel *model) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [[SubsystemsController sharedInstance].securityController setSoundsEnabled:model.enable];
        });
    }]];
    
    BOOL silent = [[SubsystemsController sharedInstance].securityController getSilent];
    [units addObject:[AlarmMoreUnitModel createSwitchModel:NSLocalizedString(@"SILENT ALARM", nil) subtitle:NSLocalizedString(@"When the Security Alarm is triggered, A Silent Alarm will occur.(No sound will be made, but Arcus will send push notification and phone calls based on the Alarm Notification List)", nil) selected:silent switchEvent:^(AlarmMoreUnitModel *model) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            [[SubsystemsController sharedInstance].securityController setSilent:model.enable];
        });
        
    }]];
    
    return units;
}
@end
