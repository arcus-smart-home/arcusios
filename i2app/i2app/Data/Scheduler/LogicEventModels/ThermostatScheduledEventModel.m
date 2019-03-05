//
//  ThermostatScheduledEventModel.m
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
#import "ThermostatScheduledEventModel.h"
#import "ScheduleController.h"
#import "SchedulerSettingViewController.h"
#import "PopupSelectionNumberView.h"
#import "VentCapability.h"
#import "SwitchCapability.h"
#import "DeviceController.h"
#import "ThermostatCapability.h"
#import "FanCapability.h"
#import "ClimateSubSystemController.h"

@implementation ThermostatScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate inMode:(int)schedulerMode {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        
        if (schedulerMode == ThermostatHeatMode || schedulerMode == ThermostatAutoMode) {
            [self setHeat:kThermostatDefaultHeatTemperature];
        }
        
        if (schedulerMode == ThermostatCoolMode || schedulerMode == ThermostatAutoMode) {
            [self setCool:kThermostatDefaultCoolTemperature];
        }
        
        self.eventTime = [[ArcusDateTime alloc] initWithHours:6 andMins:0];
    }
    
    return self;
}

- (double)getCool {
    if (![self.attributes objectForKey:kAttrThermostatCoolsetpoint] || ![self.attributes[kAttrThermostatCoolsetpoint] isKindOfClass:[NSNumber class]] ) {
        return 0;
    }
    
    return [DeviceController celsiusToFahrenheit:[self.attributes[kAttrThermostatCoolsetpoint] doubleValue]];
}

- (double)getHeat {
    if (![self.attributes objectForKey:kAttrThermostatHeatsetpoint] || ![self.attributes[kAttrThermostatHeatsetpoint] isKindOfClass:[NSNumber class]] ) {
        return 0;
    }
    
    return [DeviceController celsiusToFahrenheit:[self.attributes[kAttrThermostatHeatsetpoint] doubleValue]];
}

- (void)setCool:(double)value {
    [self.attributes setObject:@([DeviceController fahrenheitToCelsius:value]) forKey:kAttrThermostatCoolsetpoint];
}

- (void)setHeat:(double)value {
    [self.attributes setObject:@([DeviceController fahrenheitToCelsius:value]) forKey:kAttrThermostatHeatsetpoint];
}

#pragma mark - override
- (NSString *)getSideValue {
    switch (ScheduleController.scheduleController.scheduleMode) {
        case ThermostatHeatMode:
            return [NSString stringWithFormat:@"%d°", (int)lround([self getHeat])];
            
        case ThermostatCoolMode:
            return [NSString stringWithFormat:@"%d°", (int)lround([self getCool])];
            
        case ThermostatAutoMode:
            return [NSString stringWithFormat:@"%d° - %d°", (int)lround([self getHeat]), (int)lround([self getCool])];
            
        default:
            return @"";
    }
}
- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    switch (ScheduleController.scheduleController.scheduleMode) {
        case ThermostatHeatMode:
            [items addObject:[[SchedulerSettingOption createSideValue:@"TEMPERATURE" sideValue:[NSString stringWithFormat:@"%d°", (int)lround([self getHeat])]
                                                           eventOwner:self onClick:@selector(chooseHeatTemp)] setTag:1]];
            break;
            
        case ThermostatCoolMode:
            [items addObject:[[SchedulerSettingOption createSideValue:@"TEMPERATURE" sideValue:[NSString stringWithFormat:@"%d°", (int)lround([self getCool])]
                                                           eventOwner:self onClick:@selector(chooseCoolTemp)] setTag:1]];
            break;
            
        case ThermostatAutoMode:
            [items addObject:[[[SchedulerSettingOption createSideValue:@"COOL TO"
                                                             sideValue:[NSString stringWithFormat:@"%d°", (int)lround([self getCool])]
                                                            eventOwner:self
                                                               onClick:@selector(chooseCoolTemp)] setTag:1] setDescription:@"Choose the target cooling setpoint"]];
            [items addObject:[[[SchedulerSettingOption createSideValue:@"HEAT TO"
                                                             sideValue:[NSString stringWithFormat:@"%d°", (int)lround([self getHeat])]
                                                            eventOwner:self
                                                               onClick:@selector(chooseHeatTemp)] setTag:2] setDescription:@"Choose the target heating setpoint"]];
            break;
            
        case ThermostatOffMode:
            break;
            
        default:
            break;
    }
    return items;
}

- (int)getValidateTemp:(int)temp {
    if (temp < kThermostatMinTemperature) {
        return kThermostatMinTemperature;
    }
    else if (temp > kThermostatMaxTemperature) {
        return kThermostatMinTemperature;
        
    }
    return temp;
}

#pragma mark - on click actions
- (void)chooseCoolTemp {
    NSInteger minTemp = kThermostatMinTemperature + kThermostatDefaultTempDifference;
    NSInteger maxTemp = kThermostatMaxTemperature;
    
    if (ScheduleController.scheduleController.scheduleMode == ThermostatAutoMode && [self getHeat] >= minTemp) {
        minTemp = [self getHeat] + kThermostatDefaultTempDifference;
    }
    PopupSelectionNumberView *popupSelection = [PopupSelectionNumberView create:@"Temperature" withMinNumber:minTemp maxNumber:maxTemp andPostfix:@"°"];
    
    NSNumber *currentValue = @([self getValidateTemp:[self getCool]]);
    if (currentValue == 0) {
        currentValue = @(maxTemp);
    }
    [popupSelection setCurrentKey:currentValue];
    [self.delegate popup:popupSelection complete:@selector(chooseCoolTemperature:) withOwner:self];
}

- (void)chooseHeatTemp {
    NSInteger minTemp = kThermostatMinTemperature;
    NSInteger maxTemp = kThermostatMaxTemperature - kThermostatDefaultTempDifference;
    
    if (ScheduleController.scheduleController.scheduleMode == ThermostatAutoMode && [self getCool] >= minTemp) {
        maxTemp = [self getCool] - kThermostatDefaultTempDifference;
    }
    PopupSelectionNumberView *popupSelection = [PopupSelectionNumberView create:@"Temperature" withMinNumber:minTemp maxNumber:maxTemp andPostfix:@"°"];
    
    NSNumber *currentValue = @([self getValidateTemp:[self getHeat]]);
    if (currentValue == 0) {
        currentValue = @(minTemp);
    }
    [popupSelection setCurrentKey:currentValue];
    [self.delegate popup:popupSelection complete:@selector(chooseHeatTemperature:) withOwner:self];
}

- (void)chooseCoolTemperature: (id)value {
    [self setCool:[value integerValue]];
    [self.delegate reloadData];
}

- (void)chooseHeatTemperature: (id)value {
    [self setHeat:[value integerValue]];
    [self.delegate reloadData];
}

@end
