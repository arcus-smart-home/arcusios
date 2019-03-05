//
//  LightSwitchScheduledEventModel.m
//  i2app
//
//  Created by Arcus Team on 12/8/15.
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
#import "LightSwitchScheduledEventModel.h"
#import "ScheduleController.h"
#import "SchedulerSettingViewController.h"
#import "PopupSelectionNumberView.h"
#import "PopupSelectionTextPickerView.h"
#import "SwitchCapability.h"

#import "DimmerCapability.h"

#define DEFAULT_DIMMER_BRIGHTNESS 100

@implementation LightSwitchScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        // Set the default attributes
        [self setSwitchState:YES];
        if ([((DeviceModel *)ScheduleController.scheduleController.schedulingModel) isDimmer]) {
            [self.attributes setObject:@(100) forKey:kAttrDimmerBrightness];
        }
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
    if (switchOn) {
        [self.attributes setObject:kEnumSwitchStateON forKey:kAttrSwitchState];
        if ([self isDimmable]) {
            [self.attributes setObject:@(DEFAULT_DIMMER_BRIGHTNESS) forKey:kAttrDimmerBrightness];
        }
    } else {
        [self.attributes setObject:kEnumSwitchStateOFF forKey:kAttrSwitchState];
        if ([self isDimmable]) {
            [self.attributes removeObjectForKey:kAttrDimmerBrightness];
        }
    }
    
}

- (int)getDimmerBrightness {
    NSNumber *dimmerBrightness = [self.attributes objectForKey:kAttrDimmerBrightness];
    if (dimmerBrightness && dimmerBrightness != [NSNull null]) {
        return [dimmerBrightness intValue];
    }
    return 0;
}

#pragma mark - override
- (NSString *)getSideValue {
    NSString *sideValue;
    BOOL scheduledToTurnOn = [self getSwitchState];
    
    if (scheduledToTurnOn) {
        NSInteger brightness = [self getDimmerBrightness];
        sideValue = brightness > 0 ? [NSString stringWithFormat:@"%ld%%", (long) brightness] : NSLocalizedString(@"On", nil);
    } else {
        sideValue = NSLocalizedString(@"Off", nil);
    }
    
    return sideValue;
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    
    [items addObject:[[SchedulerSettingOption createSideValue:@"STATE"
                                                    sideValue:[self getSwitchState] ? @"On" : @"Off"
                                                   eventOwner:self
                                                      onClick:@selector(chooseSwitchState)] setTag:1]];
    BOOL scheduledToTurnOn = [self getSwitchState];
    if (self.attributes.count == 2 && scheduledToTurnOn) {
        [items addObject:[[SchedulerSettingOption createSideValue:@"BRIGHTNESS"
                                                        sideValue:[NSString stringWithFormat:@"%d%%",[self getDimmerBrightness]]
                                                       eventOwner:self
                                                          onClick:@selector(chooseBrightness)] setTag:2]];
    }
    return items;
}

//- (BOOL)updateEventTime:(NSObject *)eventTime {
//    if ([eventTime isKindOfClass:[NSDate class]]) {
//        [super updateEventTime:eventTime];
//    }
//    return NO;
//}

- (void)chooseSwitchState {
    OrderedDictionary *dic = [[OrderedDictionary alloc] init];
    [dic setObject:@(true) forKey:@"On"];
    [dic setObject:@(false) forKey:@"Off"];
    
    PopupSelectionTextPickerView *textPicker = [PopupSelectionTextPickerView create:@"STATE" list:dic];
    [textPicker setCurrentKey:([self getSwitchState] ? @"On" : @"Off")];
    
    [self.delegate popup:textPicker complete:@selector(switchStateUpdate:) withOwner:self];
}

- (void)switchStateUpdate:(id)value {
    if (value && [value boolValue] != [self getSwitchState]) {
        [self setSwitchState:[value boolValue]];
        [self.delegate reloadData];
    }
}

- (void)chooseBrightness {
    PopupSelectionNumberView *numberPicker = [PopupSelectionNumberView create:@"BRIGHTNESS" withMinNumber:10 maxNumber:100 stepNumber:10 withSign:@"%"];
    
    [numberPicker setCurrentKey:self.attributes[kAttrDimmerBrightness]];
    [self.delegate popup:numberPicker complete:@selector(brightnessUpdate:) withOwner:self];
}

- (void)brightnessUpdate:(NSNumber *)value {
    if (value.intValue != [self.attributes[kAttrDimmerBrightness] intValue]) {
        [self.attributes setObject:value forKey:kAttrDimmerBrightness];
        
        [self.delegate reloadData];
    }
}

- (BOOL)isDimmable {
    return [((DeviceModel *)ScheduleController.scheduleController.schedulingModel) isDimmer];
}

@end
