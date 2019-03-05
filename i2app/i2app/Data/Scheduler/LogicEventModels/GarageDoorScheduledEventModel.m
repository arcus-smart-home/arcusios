//
//  GarageDoorScheduledEventModel.m
//  i2app
//
//  Created by Arcus Team on 1/4/16.
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
#import "GarageDoorScheduledEventModel.h"
#import "SchedulerSettingViewController.h"
#import "PopupSelectionNumberView.h"
#import "PopupSelectionTextPickerView.h"
#import "MotorizedDoorCapability.h"

@implementation GarageDoorScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        // Set the default attributes
        [self setLockState:YES];
    }
    return self;
}

- (BOOL)getLockState {
    if ([self.attributes[kAttrMotorizedDoorDoorstate] length] > 0) {
        return [self.attributes[kAttrMotorizedDoorDoorstate] isEqualToString:kEnumMotorizedDoorDoorstateCLOSED];
    }
    return [self.attributes[kAttrMotorizedDoorDoorstate] isEqualToString:kEnumMotorizedDoorDoorstateCLOSED];
}

- (void)setLockState:(BOOL)lock {
    [self.attributes setObject:lock ? kEnumMotorizedDoorDoorstateCLOSED : kEnumMotorizedDoorDoorstateOPEN forKey:kAttrMotorizedDoorDoorstate];
}

#pragma mark - override
- (NSString *)getSideValue {
    return [self getLockState] ? @"Close": @"Open";
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    [items addObject:[[SchedulerSettingOption createSideValue:@"STATE"
                                                    sideValue:[self getLockState] ? @"Close" : @"Open"
                                                   eventOwner:self
                                                      onClick:@selector(chooseLockState)] setTag:1]];
    return items;
}
#pragma mark - on click actions
- (void)chooseLockState {
    OrderedDictionary *dic = [[OrderedDictionary alloc] init];
    [dic setObject:@(true) forKey:@"Close"];
    [dic setObject:@(false) forKey:@"Open"];
    
    PopupSelectionTextPickerView *textPicker = [PopupSelectionTextPickerView create:@"LOCK" list:dic];
    [textPicker setCurrentKey:([self getLockState] ? @"Close" : @"Open")];
    
    [self.delegate popup:textPicker complete:@selector(lockStateUpdate:) withOwner:self];
}
- (void)lockStateUpdate:(id)value {
    if (value && [value boolValue] != [self getLockState]) {
        [self setLockState:[value boolValue]];
        [self.delegate reloadData];
    }
}

@end
