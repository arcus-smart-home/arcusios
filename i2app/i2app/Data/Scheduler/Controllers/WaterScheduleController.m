//
//  WaterScheduleController.m
//  i2app
//
//  Created by Arcus Team on 1/13/16.
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
#import "WaterScheduleController.h"
#import "ImageDownloader.h"
#import "CommonCheckableImageCell.h"

#import "DeviceController.h"
#import "DeviceCapability.h"
#import "SubsystemsController.h"


#import "WeeklyScheduleViewController.h"
#import "WaterDevicesController.h"
#import "WaterSubsystemController.h"
#import "WaterSubsystemCapability.h"
#import "ScheduleController.h"
#import "WaterHeaterScheduledEventModel.h"
#import "WaterValveScheduledEventModel.h"


NSString *const kWaterSchedule = @"WATER";


@interface WaterScheduleController ()

@end


@implementation WaterScheduleController


- (instancetype)init {
    if (self = [super init]) {
        ScheduleController.scheduleController = self;
    }
    return self;
}

#pragma mark - dynamic properties
- (NSString *)scheduleName {
    return @"Water";
}

#pragma mark - WeeklyScheduleViewController Overriden Methods
- (void) initializeData {
    NSArray *waterDevices = [[SubsystemsController sharedInstance].waterController allWaterDevices];
    self.modelsIds = [[NSMutableArray alloc] init];
    for (DeviceModel *device in waterDevices) {
        if (device.deviceType == DeviceTypeWaterHeater || device.deviceType == DeviceTypeWaterValve) {
            [self.modelsIds addObject:device.modelId];
        }
    }
    
    [self refresh];
}

- (NSString *)getSubheaderText {
    return @"Turn on the schedule by selecting the checkmark, Uncheck to deactivate the schedule.";
}

#pragma mark - Scheduler Utilities
- (ScheduledEventModel *)getNewEventModel {
    if (((DeviceModel *)ScheduleController.scheduleController.schedulingModel).deviceType == DeviceTypeWaterHeater) {
        return [[WaterHeaterScheduledEventModel alloc] init];
    }
    else if (((DeviceModel *)ScheduleController.scheduleController.schedulingModel).deviceType == DeviceTypeWaterValve) {
        return [[WaterValveScheduledEventModel alloc] init];
    }
    return nil;
}

- (ScheduledEventModel *)createNewEventItem:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    ScheduledEventModel *eventModel;
    if (((DeviceModel *)ScheduleController.scheduleController.schedulingModel).deviceType == DeviceTypeWaterHeater) {
        eventModel = [[WaterHeaterScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
    }
    else if (((DeviceModel *)ScheduleController.scheduleController.schedulingModel).deviceType == DeviceTypeWaterValve) {
        eventModel = [[WaterValveScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
    }
    
    [eventModel preload];
    
    return eventModel;
}

#pragma mark - Schedule Type
- (NSString *)getScheduleType {
    return kWaterSchedule;
}

@end
