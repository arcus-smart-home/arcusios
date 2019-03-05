//
//  FanScheduledEventModel.m
//  i2app
//
//  Created by Arcus Team on 2/23/16.
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
#import "FanScheduledEventModel.h"
#import "ScheduleController.h"
#import "SchedulerSettingViewController.h"
#import "PopupSelectionNumberView.h"
#import "PopupSelectionTextPickerView.h"
#import "PopupSelectionButtonsView.h"
#import "SwitchCapability.h"
#import "DeviceController.h"
#import "ThermostatCapability.h"
#import "FanCapability.h"


@implementation FanScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        [self setSwitchState:YES];
        [self setFanSpeed:[self getMaxFanSpeed]];
    }
    return self;
}

- (BOOL)getSwitchState {
    if (![self.attributes objectForKey:kAttrSwitchState] || ![self.attributes[kAttrSwitchState] isKindOfClass:[NSString class]] ) {
        return NO;
    }
    
    return [self.attributes[kAttrSwitchState] isEqualToString:kEnumSwitchStateON];
}

- (void)setSwitchState:(BOOL)switchOn {
    [self.attributes setObject:switchOn ? kEnumSwitchStateON : kEnumSwitchStateOFF forKey:kAttrSwitchState];
}

- (NSInteger)getMaxFanSpeed {
    return (NSInteger)[FanCapability getMaxSpeedFromModel:(DeviceModel *)[ScheduleController scheduleController].schedulingModel];
}

- (NSInteger)getFanSpeed {
    NSNumber *level = [self.attributes objectForKey:kAttrFanSpeed];
    if (level) {
        return [level integerValue];
    }
    return 0;
}

- (void)setFanSpeed:(NSInteger)speed {
    if ([self getSwitchState]) {
        [self.attributes setObject:@(speed) forKey:kAttrFanSpeed];
    } else {
        [self.attributes setObject:@(0) forKey:kAttrFanSpeed];
    }
}

- (NSString *)getFanSpeedState {
    NSInteger currentSpeed = [self getFanSpeed];
    NSInteger maxSpeed = [self getMaxFanSpeed];
    
    NSString *speedState = nil;
    
    if ([self getSwitchState]) {
        if (maxSpeed == currentSpeed) {
            speedState = @"High";
        } else if (currentSpeed == 1) {
            speedState = @"Low";
        } else {
            speedState = @"Medium";
        }
    } else {
        speedState = @"Off";
    }
    
    return speedState;
}

#pragma mark - override
- (NSString *)getSideValue {
    NSString *sideValue = @"";
    
    if ([self.attributes[@"swit:state"] isEqualToString:@"OFF"]) {
        sideValue = @"OFF";
    } else if([self.attributes[@"swit:state"] isEqualToString:@"ON"]) {
        NSNumber *fanspeed = self.attributes[@"fan:speed"];
        if (fanspeed.intValue == 1) {
            sideValue = @"LOW";
        } else if (fanspeed.intValue == 2) {
            sideValue = @"MEDIUM";
        } else if (fanspeed.intValue == 3) {
            sideValue = @"HIGH";
        }
    }
    
    return sideValue;
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    [items addObject:[SchedulerSettingOption createSwitch:@"STATE" isChecked:[self getSwitchState] eventOwner:self onClick:@selector(fanSwitchStateClick)]];
    
    [items addObject:[[SchedulerSettingOption createSideValue:@"SPEED"
                                                    sideValue:[self getFanSpeedState]
                                                   eventOwner:self
                                                      onClick:@selector(chooseFanSpeed)] setTag:2]];
    return items;
}

#pragma mark - on click actions
- (void)chooseFanSwitchState {
    OrderedDictionary *dic = [[OrderedDictionary alloc] init];
    [dic setObject:@(true) forKey:@"On"];
    [dic setObject:@(false) forKey:@"Off"];
    
    PopupSelectionTextPickerView *textPicker = [PopupSelectionTextPickerView create:@"STATE" list:dic];
    [textPicker setCurrentKey:([self getSwitchState] ? @"On" : @"Off")];
    
    [self.delegate popup:textPicker complete:@selector(fanSwitchStateUpdate:) withOwner:self];
}

- (void)fanSwitchStateUpdate:(id)value {
    if (value && [value boolValue] != [self getSwitchState]) {
        [self setSwitchState:[value boolValue]];
        if (![value boolValue]) {
            [self setFanSpeed:0];
        }
        [self.delegate reloadData];
    }
}

- (void)fanSwitchStateClick {
    [self setSwitchState:![self getSwitchState]];
    if (![self getSwitchState]) {
        [self setFanSpeed:0];
    }
    
    [self.delegate reloadData];
}

- (void)chooseFanSpeed {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"FAN SPEED", nil) button:
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"HIGH", nil) event:@selector(setFanToHigh)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"MEDIUM", nil) event:@selector(setFanToMedium)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"LOW", nil) event:@selector(setFanToLow)], nil];
    buttonView.owner = self;
    [self.delegate popup:buttonView complete:nil withOwner:self];
}

- (void)setFanToHigh {
    if (![self getSwitchState]) {
        [self fanSwitchStateClick];
    }
    
    [self setFanSpeed:[self getMaxFanSpeed]];
    [self.delegate reloadData];
}

- (void)setFanToMedium {
    if (![self getSwitchState]) {
        [self fanSwitchStateClick];
    }

    [self setFanSpeed: (NSInteger)(([self getMaxFanSpeed]+1)/2) ];
    [self.delegate reloadData];
}

- (void)setFanToLow {
    if (![self getSwitchState]) {
        [self fanSwitchStateClick];
    }

    [self setFanSpeed:1];
    [self.delegate reloadData];
}



@end
