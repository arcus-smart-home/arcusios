//
//  WaterScheduledEventModel.m
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
#import "WaterHeaterScheduledEventModel.h"
#import "DeviceController.h"
#import "WaterHeaterCapability.h"
#import "ScheduleController.h"
#import "SchedulerSettingViewController.h"
#import "PopupSelectionTextPickerView.h"
#import "PopupSelectionNumberView.h"

const int kInitialHeatingPoint = 120;
const int kHeatingSetPoint = 60;

@implementation WaterHeaterScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        [self setHeatSettingPoint:kInitialHeatingPoint];
    }
    return self;
}

- (NSInteger)getHeatSettingPoint {
    NSInteger heatSettingPoint = [DeviceController celsiusToFahrenheit:[self.attributes[kAttrWaterHeaterSetpoint] doubleValue]];
    if (heatSettingPoint < kHeatingSetPoint) {
        return kHeatingSetPoint;
    }
    return heatSettingPoint;
}

- (void)setHeatSettingPoint:(NSInteger)point {
    [self.attributes setObject:@([DeviceController fahrenheitToCelsius:(double)point]) forKey:kAttrWaterHeaterSetpoint];
}

#pragma mark - override
- (NSString *)getSideValue {
    return [NSString stringWithFormat:@"%d°", (int)[self getHeatSettingPoint]];
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    [items addObject:[[SchedulerSettingOption createSideValue:@"TEMPERATURE"
                                                    sideValue:[NSString stringWithFormat:@"%d°", (int)[self getHeatSettingPoint]]
                                                   eventOwner:self
                                                      onClick:@selector(chooseTemperature)] setTag:1]];

    return items;
}

- (void)chooseTemperature {
    NSInteger maxHeatSetPoint = [DeviceController getWaterHeaterMaxSetPoint:(DeviceModel *)[ScheduleController scheduleController].schedulingModel];
    
    OrderedDictionary *list = [[OrderedDictionary alloc] init];
    [list setObject:@(60) forKey:@"60"];
    for (int i = 80; i <= maxHeatSetPoint ; i++) {
        [list setObject:@(i) forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    PopupSelectionTextPickerView *popupSelection = [PopupSelectionTextPickerView create:@"Temperature" list:list];
    [popupSelection setSign:@"°F" withFrame:YES];
    
    NSNumber *currentValue = @([self getHeatSettingPoint]);
    if (currentValue == 0) {
            currentValue = @(maxHeatSetPoint);
    }
    [popupSelection setCurrentKey:[NSString stringWithFormat:@"%@", currentValue]];
    
    [self.delegate popup:popupSelection complete:@selector(updateTemperature:) withOwner:self];
}

- (void)updateTemperature:(NSNumber *)selected {
    [self setHeatSettingPoint:[selected integerValue]];
    [self.delegate reloadData];
}

- (NSString *)timeDescription {
    return @"Arcus will inform the water heater to start heating";
}

- (int)indexOfTimeOption {
    return 0;
}

@end
