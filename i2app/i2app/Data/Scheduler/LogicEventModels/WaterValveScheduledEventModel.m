//
//  WaterValveScheduledEventModel.m
//  i2app
//
//  Created by Arcus Team on 1/21/16.
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
#import "WaterValveScheduledEventModel.h"
#import "ValveCapability.h"
#import "DeviceConnectionCapability.h"
#import "DevicePowerCapability.h"
#import "SchedulerSettingViewController.h"
#import "PopupSelectionTextPickerView.h"

@implementation WaterValveScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        [self setStatus:YES];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    WaterValveScheduledEventModel *another = [[WaterValveScheduledEventModel alloc] init];
    
    another.eventDay = self.eventDay;
    another.eventTime = self.eventTime.copy;
    another.eventId = self.eventId.copy;
    another.attributes = [[NSMutableDictionary alloc] initWithDictionary:self.attributes copyItems:YES];
    another.messageType = self.messageType.copy;
    another.delegate = self.delegate;
    
    return another;
}

- (BOOL) getStatus {
    NSString *valueState = self.attributes[kAttrValveValvestate];
    
    if ([valueState isEqualToString:kEnumValveValvestateCLOSING]) {
        return NO;
    }
    else if ([valueState isEqualToString:kEnumValveValvestateOPENING]) {
        return YES;
    }
    else if ([valueState isEqualToString:kEnumValveValvestateCLOSED]) {
        return NO;
    }
    else if ([valueState isEqualToString:kEnumValveValvestateOPEN]) {
        return YES;
    }
    
    return NO;
}
- (void) setStatus: (BOOL)status {
    if (status) {
        [self.attributes setObject:kEnumValveValvestateOPEN forKey:kAttrValveValvestate];
    } else {
        [self.attributes setObject:kEnumValveValvestateCLOSED forKey:kAttrValveValvestate];
    }
}

#pragma mark - override
- (NSString *)getSideValue {
    return [self getStatus] ? @"Open" : @"Closed";
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    [items addObject:[[SchedulerSettingOption createSideValue:@"STATUS"
                                                    sideValue:[self getSideValue]
                                                   eventOwner:self
                                                      onClick:@selector(chooseSwitchState)] setTag:1]];
    
    return items;
}

- (void)chooseSwitchState {
    OrderedDictionary *dic = [[OrderedDictionary alloc] init];
    [dic setObject:@(true) forKey:@"Open"];
    [dic setObject:@(false) forKey:@"Close"];
    
    PopupSelectionTextPickerView *textPicker = [PopupSelectionTextPickerView create:@"STATE" list:dic];
    [textPicker setCurrentKey:([self getStatus] ? @"On" : @"Off")];
    
    [self.delegate popup:textPicker complete:@selector(switchStateUpdate:) withOwner:self];
}

- (void)switchStateUpdate:(id)value {
    if (value && [value boolValue] != [self getStatus]) {
        [self setStatus:[value boolValue]];
        [self.delegate reloadData];
    }
}


@end
