//
//  IrrigationScheduledEventModel.m
//  i2app
//
//  Created by Arcus Team on 3/2/16.
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
#import "IrrigationScheduledEventModel.h"
#import "ScheduleController.h"
#import "SchedulerSettingViewController.h"
#import "LawnNGardenSubsystemController.h"
#import "OrderedDictionary.h"
#import "ZoneSettingViewController.h"
#import "IrrigationZoneModel.h"
#import "SubsystemsController.h"
#import "LawnNGardenScheduleController.h"
#import "IrrigationZoneCapability.h"
#import "PopupSelectionTextPickerView.h"
#import "IrrigationControllerCapability.h"
#import <i2app-Swift.h>

int const kMaxWaterDelayInterval = 7;
NSString *const kWaterIntervalIndays = @"WaterIntervalIndays";

@implementation IrrigationScheduledEventModel

@dynamic title;
@dynamic details;
@dynamic wateringIntervalInDays;
@dynamic selectedZones;

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay
                    withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        // Set the default attributes
        OrderedDictionary *zones = [LawnNGardenSubsystemController getAllZonesForModel:ScheduleController.scheduleController.schedulingModelAddress];
        NSMutableArray *allZones = [[NSMutableArray alloc] initWithCapacity:zones.count];
        DeviceModel *device = (DeviceModel *)ScheduleController.scheduleController.schedulingModel;
        for (int i = 0; i < zones.count; i++) {
            IrrigationZoneModel *zone = [[IrrigationZoneModel alloc] initWithKey:zones.allKeys[i] andDeviceModel:device];
            [allZones addObject:zone];
        }
        _allZones = allZones.copy;

        self.eventTime = [[ArcusDateTime alloc] initWithHours:6 andMins:0];
        // Set any default attributes
        switch (ScheduleController.scheduleController.scheduleMode) {
            case IrrigationSystemModeWeekly:
                break;
                
            case IrrigationSystemModeInterval:
                 self.wateringIntervalInDays = 1;
                break;
                
            case IrrigationSystemModeOddDays:
                break;
                
            case IrrigationSystemModeEvenDays:
                break;
                
            default:
                break;
        }
        ((LawnNGardenScheduleController *)ScheduleController.scheduleController).updatedEventModel = self;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    IrrigationScheduledEventModel *another = [[self.class alloc] init];
    
    another.eventDay = self.eventDay;
    another.eventTime = self.eventTime;
    another.eventId = self.eventId.copy;
    another.attributes = [[NSMutableDictionary alloc] initWithDictionary:self.attributes copyItems:YES];
    another.messageType = self.messageType.copy;
    another.delegate = self.delegate;
    another.originalCommand = self.originalCommand;
    another.allZones = self.allZones;
    
    return another;
}

#pragma mark - Dynamic Properties
- (NSString *)title {
    if (self.allZones.count == 1) {
        return @"1 ZONE";
    }
    return [NSString stringWithFormat:@"%d ZONES", (int)self.selectedZones.count];
}

- (NSString *)details {
    NSMutableString *details = [[NSMutableString alloc] init];
    NSArray<IrrigationZoneModel *> *selectedZones = self.selectedZones;
    for (int i = 0; i < selectedZones.count; i++) {
        if (i == 0) {
            [details appendString:selectedZones[i].name];
        }
        else {
            [details appendFormat:@", %@", selectedZones[i].name];
        }
    }
    return details;
}

- (int)wateringIntervalInDays {
    return [self.attributes[kWaterIntervalIndays] intValue];
}

- (void)setWateringIntervalInDays:(int)wateringIntervalInDays {
    self.attributes[kWaterIntervalIndays] = @(wateringIntervalInDays);
}

- (NSArray<IrrigationZoneModel *> *)selectedZones {
    NSMutableArray *selectedZones = [[NSMutableArray alloc] initWithCapacity:self.allZones.count];
    for (IrrigationZoneModel *zone in self.allZones) {
        if (zone.selected) {
            [selectedZones addObject:zone];
        }
    }
    return selectedZones.copy;
}

- (int)indexOfTimeOption {
    return 0;
}

- (NSString *)timeDescription {
    return NSLocalizedString(@"Watering in the early morning or early evening", nil);
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    SchedulerSettingOption *option = [[SchedulerSettingOption createSideValue:@"ZONES" sideValue:[self getSideValue]
                                                                   eventOwner:self onClick:@selector(chooseZone)] setTag:1];
    [option setDescription:@"Select the zones and watering duration\nfor this event"];
    [items addObject:option];
    
    return items;
}

+ (NSString *)getWeekDayForDay:(int)day {
    switch (day) {
            
        case 0:
            return @"Sunday";
            
        case 1:
            return @"Monday";
            
        case 2:
            return @"Tuesday";
            
        case 3:
            return @"Wednesday";
            
        case 4:
            return @"Thursday";
            
        case 5:
            return @"Friday";
            
        case 6:
            return @"Saturday";
            
        default:
            return @"";
    }
}

#pragma mark - override
- (NSString *)getSideValue {
    int duration = 0;
    
    for (IrrigationZoneModel *zone in self.allZones) {
        if (zone.selected) {
            duration += zone.defaultDuration;
        }
    }
    return [NSString stringWithFormat:@"%d Min", duration];
}

#pragma mark - Event Attributes Selectors
- (void)chooseZone {
    ZoneSettingViewController *vc = [ZoneSettingViewController create];
    [[ApplicationRoutingService.defaultService displayingViewControllerInViewController:nil].navigationController pushViewController:vc animated:YES];
}

- (void)chooseWaterInterval {
    OrderedDictionary *dict = [[OrderedDictionary alloc] init];
    [dict setObject:@[@"1 Day", @(1).stringValue] forKey:@"1 Day"];
    
    for (int i = 2; i <= kMaxWaterDelayInterval; i++) {
        NSString *str = [NSString stringWithFormat:@"%d Days", i];
        [dict setObject:@[str, @(i).stringValue] forKey:str];
    }
    
    PopupSelectionTextPickerView *textPicker = [PopupSelectionTextPickerView create:@"WATER NOW" list:dict];
    [textPicker setCurrentKey:[NSString stringWithFormat:@"%d Days", self.wateringIntervalInDays]];
    [self.delegate popup:textPicker complete:@selector(waterIntervalUpdate:) withOwner:self];
}

- (void)waterIntervalUpdate:(NSArray *)selectedValue {
    if ([selectedValue[1] intValue] != self.wateringIntervalInDays) {
        self.wateringIntervalInDays = [selectedValue[1] intValue];
        
        [self.delegate reloadData];
    }
    
    if (!ScheduleController.scheduleController.scheduledEventModel.isNewModel) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            // Save to platform for updated events
            [((LawnNGardenScheduleController *)ScheduleController.scheduleController) configureWithEventModel:self].then(^ {
                [self.delegate reloadData];
            });
        });
    }
}

@end
