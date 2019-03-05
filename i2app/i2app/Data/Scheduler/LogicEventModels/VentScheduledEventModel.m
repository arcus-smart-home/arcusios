//
//  VentScheduledEventModel.m
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
#import "VentScheduledEventModel.h"
#import "SchedulerSettingViewController.h"
#import "PopupSelectionNumberView.h"
#import "VentCapability.h"
#import "DeviceController.h"

@implementation VentScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        // Set the default attributes
        [self setVentLevel:100];
    }
    return self;
}

- (int)getVentLevel {
    NSNumber *level = [self.attributes objectForKey:kAttrVentLevel];
    if (level) {
        return [level intValue];
    }
    return 0;
}

- (void)setVentLevel:(NSInteger)level {
    [self.attributes setObject:@(level) forKey:kAttrVentLevel];
}

#pragma mark - override
- (NSString *)getSideValue {
    return [NSString stringWithFormat:@"%d%% Open", [self getVentLevel]];
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    [items addObject:[[SchedulerSettingOption createSideValue:@"OPEN"
                                                    sideValue:[NSString stringWithFormat:@"Open %d%%", [self getVentLevel]]
                                                   eventOwner:self
                                                      onClick:@selector(chooseVentLevel)] setTag:1]];
    return items;
}

#pragma mark - on click actions
- (void)chooseVentLevel {
    PopupSelectionNumberView *numberPicker = [PopupSelectionNumberView create:@"VENT OPEN" withMinNumber:0 maxNumber:100 stepNumber:1 withSign:@"%"];
    
    [numberPicker setCurrentKey:@([self getVentLevel])];
    [self.delegate popup:numberPicker complete:@selector(ventLevelUpdate:) withOwner:self];
}

- (void)ventLevelUpdate:(NSNumber *)value {
    if (value.integerValue != [self getVentLevel]) {
        [self setVentLevel:value.integerValue];
        [self.delegate reloadData];
    }
}

@end
