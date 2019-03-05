//
//  LawnNGardenScheduleController.m
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
#import "LawnNGardenScheduleController.h"
#import "IrrigationScheduledEventModel.h"
#import "HoseScheduledEventModel.h"
#import "IrrigationSchedulableCapability.h"
#import "LawnNGardenSubsystemCapability.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "NSDate+Convert.h"
#import "IrrigationZoneModel.h"
#import "CommonCheckableImageCell.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "IrrigationControllerCapability.h"
#import "OrderedDictionary.h"
#import "LawnNGardenZoneController.h"
#import "ArcusDateTime.h"
#import "PopupSelectionSchedulerTimeView.h"

NSString *const kLawnNGarden = @"IRRIGATION";

@interface LawnNGardenScheduleController ()

@property (nonatomic, assign) SubsystemModel *subsystem;

- (NSArray *)getAllEventsWithStatusNotDeletedAndNotDeleting:(NSArray *)events;
- (BOOL)hasEventsWithStatusNotDeletedAndNotDeleting:(NSDictionary *)events;

@end

@implementation LawnNGardenScheduleController

@dynamic subsystem;

- (instancetype)init {
  if (self = [super init]) {
    ScheduleController.scheduleController = self;
  }
  return self;
}

+ (NSString *)scheduleModeToString:(int)mode {
    switch (mode) {
        case IrrigationSystemModeWeekly:
            return NSLocalizedString(@"WEEKLY", nil);
            
        case IrrigationSystemModeInterval:
            return NSLocalizedString(@"INTERVAL", nil);
            
        case IrrigationSystemModeOddDays:
            return NSLocalizedString(@"ODD DAYS", nil);
            
        case IrrigationSystemModeEvenDays:
            return NSLocalizedString(@"EVEN DAYS", nil);
            
        case IrrigationSystemModeManual:
            return NSLocalizedString(@"MANUAL", nil);
            
        default:
            return @"";
    }
}

+ (int)scheduleStringToMode:(NSString *)mode {
    return IrrigationModeStringToType(mode);
}


#pragma mark - dynamic properties
- (NSString *)scheduleName {
    return @"Lawn & Garden";
}

- (BOOL)isWeeklySchedule {
    return (super.scheduleMode == IrrigationSystemModeWeekly);
}

+ (LawnNGardenScheduleController *)scheduleController {
    return (LawnNGardenScheduleController *)ScheduleController.scheduleController;
}

#pragma mark - Current Mode
- (SubsystemModel *)subsystem {
    return [SubsystemsController sharedInstance].lawnNGardenController.subsystemModel;
}

- (IrrigationSystemMode)getCurrentMode {
    NSString *modeStr = [[SubsystemsController sharedInstance].lawnNGardenController getCurrentIrrigationModeForModel:self.schedulingModelAddress];
    return [LawnNGardenScheduleController scheduleStringToMode:modeStr];
}

- (NSString *)scheduleViewControllerNavBarTitle {
    NSString *title;
    switch (self.scheduleMode) {
        case IrrigationSystemModeWeekly:
            title = @"Weekly";
            break;
            
        case IrrigationSystemModeOddDays:
            title = @"Odd Days";
            break;
            
        case IrrigationSystemModeEvenDays:
            title = @"Even Days";
            break;
            
        case IrrigationSystemModeInterval:
            title = @"Interval";
            break;
            
        case IrrigationSystemModeManual:
        default:
            title = @"Schedule";
            break;
    }
    return title.uppercaseString;
}

#pragma mark - ScheduledEventModel
- (IrrigationScheduledEventModel *)getNewEventModel {
    return [[IrrigationScheduledEventModel alloc] init];
}

- (IrrigationScheduledEventModel *)createNewEventItem:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    IrrigationScheduledEventModel *eventModel = [[IrrigationScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
    [eventModel preload];
    return eventModel;
}

#pragma mark - Enable Schedule
- (BOOL)isScheduleEnabledForCurrentModel {
    return [self isScheduleEnabledForModel:self.schedulingModel];
}

- (BOOL)isScheduleEnabledForModel:(Model *)model {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getScheduleStatusFromModel:self.subsystem];
    dict = dict[model.address];
    return [dict[@"enabled"] boolValue];
}

- (void)onClickCheckbox:(CommonCheckableImageCell *)cell withMode:(IrrigationSystemMode)mode allCells:(NSArray *)allCells {
    // Do not allow to uncheck checked button: only allow to check a new button
    if ([cell getChecked]) {
        return;
    }

    // We are trying to switch to a different irrigation mode
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        IrrigationSystemMode currentMode = [self getCurrentMode];
        BOOL disableScheduling = NO;
        BOOL cellIsChecked = ![cell getChecked];
        if (mode == IrrigationSystemModeManual && cellIsChecked) {
            disableScheduling = YES;
        }
        else if (mode == currentMode && !cellIsChecked) {
            disableScheduling = YES;
        }
        
        if (disableScheduling) {
            [LawnNGardenSubsystemCapability disableSchedulingWithController:self.schedulingModelAddress onModel:self.subsystem].then(^ {
                [self checkCell:cell selected:cellIsChecked allCells:allCells];
                DDLogInfo(@"success");
            }).catch(^(NSError *error) {
                DDLogInfo(@"fail");
            });
            return;
        }
        
        if (mode == IrrigationSystemModeManual && !cellIsChecked) {
            [LawnNGardenSubsystemCapability enableSchedulingWithController:self.schedulingModelAddress onModel:self.subsystem].then(^ {
                [self checkCell:cell selected:cellIsChecked allCells:allCells];
                DDLogInfo(@"success");
            }).catch(^(NSError *error) {
                DDLogInfo(@"fail");
            });
        }
        else {
            if (![self isScheduleEnabledForCurrentModel]) {
                [LawnNGardenSubsystemCapability enableSchedulingWithController:self.schedulingModelAddress onModel:self.subsystem].then(^ {
                    if (mode == currentMode) {
                        [self checkCell:cell selected:cellIsChecked allCells:allCells];
                        DDLogInfo(@"success");
                    }
                    else {
                        [LawnNGardenSubsystemCapability switchScheduleModeWithController:self.schedulingModelAddress withMode:IrrigationModeTypeToString(mode) onModel:self.subsystem].then(^ {
                            [self checkCell:cell selected:cellIsChecked allCells:allCells];
                            DDLogInfo(@"success");
                        }).catch(^(NSError *error) {
                            DDLogInfo(@"fail");
                        });
                    }
                }).catch(^(NSError *error) {
                    DDLogInfo(@"fail");
                });
            }
            else {
                [LawnNGardenSubsystemCapability switchScheduleModeWithController:self.schedulingModelAddress withMode:IrrigationModeTypeToString(mode) onModel:self.subsystem].then(^ {
                    [self checkCell:cell selected:cellIsChecked allCells:allCells];
                    DDLogInfo(@"success");
                }).catch(^(NSError *error) {
                    DDLogInfo(@"fail");
                });
            }
        }
    });
}

- (void)checkCell:(CommonCheckableImageCell *)theCell selected:(BOOL)selected allCells:(NSArray *)allCells {
    if (selected) {
        // Unselect all cells first
        for (CommonCheckableImageCell *cell in allCells) {
            if ([cell isKindOfClass:[CommonCheckableImageCell class]]) {
                [cell setCheck:NO styleBlack:NO];
            }
        }
    }
    [theCell setCheck:selected styleBlack:NO];
}

- (PMKPromise *)setSchedulerForModel:(Model *)model enable:(BOOL)enable {
    if (enable) {
        return [LawnNGardenSubsystemCapability switchScheduleModeWithController:self.schedulingModelAddress withMode:IrrigationModeTypeToString(self.scheduleMode) onModel:self.subsystem].thenInBackground(^ {
            return [LawnNGardenSubsystemCapability enableSchedulingWithController:self.schedulingModelAddress onModel:self.subsystem];
        });
    }
    return [LawnNGardenSubsystemCapability disableSchedulingWithController:self.schedulingModelAddress onModel:self.subsystem];
}

#pragma mark - Schedule Type
- (NSString *)getScheduleType {
    return kLawnNGarden;
}

#pragma mark - Load events
- (NSArray *)getAllEventsWithStatusNotDeletedAndNotDeleting:(NSArray *)events {
    NSMutableArray *nonDeletedEvents = [[NSMutableArray alloc] initWithCapacity:events.count];
    for (NSDictionary *event in events) {
        if ([LawnNGardenScheduleController isValidEvent:event]) {
            [nonDeletedEvents addObject:event];
        }
    }
    return nonDeletedEvents;
}

- (BOOL)hasEventsWithStatusNotDeletedAndNotDeleting:(NSDictionary *)events {
     for (NSDictionary *event in events) {
        if ([LawnNGardenScheduleController isValidEvent:event]) {
            return YES;
        }
    }
    return NO;
}

// Events that has a status which is not "DELETING" or "DELETED"
+ (BOOL)isValidEvent:(NSDictionary *)event {
    NSString *status = event[@"status"];
    return (![status isEqualToString:@"DELETING"] &&
            ![status isEqualToString:@"DELETED"] &&
            ![status isEqualToString:@"DELETE_FAILED"]);
}

// We need to get those events for the current mode only
- (BOOL)hasScheduledEventsForModelWithAddress:(NSString *)address {
    NSDictionary *dict;
    switch (self.scheduleMode) {
        case IrrigationSystemModeWeekly:
            dict = [LawnNGardenSubsystemCapability getWeeklySchedulesFromModel:self.subsystem];
            break;
            
        case IrrigationSystemModeInterval:
            dict = [LawnNGardenSubsystemCapability getIntervalSchedulesFromModel:self.subsystem];
            break;
            
        case IrrigationSystemModeOddDays:
            dict = [LawnNGardenSubsystemCapability getOddSchedulesFromModel:self.subsystem];
            break;
            
        case IrrigationSystemModeEvenDays:
            dict = [LawnNGardenSubsystemCapability getEvenSchedulesFromModel:self.subsystem];
            break;
            
        default:
            dict = [NSDictionary new];
            break;
    }
    dict = dict[address];
    return [self hasEventsWithStatusNotDeletedAndNotDeleting:dict[@"events"]];
}

- (BOOL)hasScheduledEventsForCurrentModel {
    return [self hasScheduledEventsForModelWithAddress:self.schedulingModelAddress];
}

- (int)getScheduledEventsCount {
    NSDictionary *dict;
    switch (self.scheduleMode) {
        case IrrigationSystemModeWeekly:
            dict = [LawnNGardenSubsystemCapability getWeeklySchedulesFromModel:self.subsystem];
            break;
            
        case IrrigationSystemModeInterval:
            dict = [LawnNGardenSubsystemCapability getIntervalSchedulesFromModel:self.subsystem];
            break;
            
        case IrrigationSystemModeOddDays:
            dict = [LawnNGardenSubsystemCapability getOddSchedulesFromModel:self.subsystem];
            break;
            
        case IrrigationSystemModeEvenDays:
            dict = [LawnNGardenSubsystemCapability getEvenSchedulesFromModel:self.subsystem];
            break;
            
        default:
            dict = [NSDictionary new];
            break;
    }
    dict = dict[self.schedulingModelAddress];
    return (int)[self getAllEventsWithStatusNotDeletedAndNotDeleting:dict[@"events"]].count;
}

- (NSArray *)loadScheduledEvents {
    NSDictionary *dict;
    
    switch (self.scheduleMode) {
        case IrrigationSystemModeWeekly: {
            dict = [LawnNGardenSubsystemCapability getWeeklySchedulesFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            
            // Get the events for the current controller
            dict = dict[self.schedulingModelAddress];
            NSArray *events = [self getAllEventsWithStatusNotDeletedAndNotDeleting:dict[@"events"]];
            NSMutableArray *eventModels = [NSMutableArray array];
            
            for (NSDictionary *event in events) {
                [eventModels addObjectsFromArray:[self modelsWithCommand:event]];
            }
            return eventModels.copy;
        }
            
        case IrrigationSystemModeInterval:
            dict = [LawnNGardenSubsystemCapability getIntervalSchedulesFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            // Get the events for the current controller
            dict = dict[self.schedulingModelAddress];
            return [self modelsWithCommand:dict];
            
        case IrrigationSystemModeOddDays:
            dict = [LawnNGardenSubsystemCapability getOddSchedulesFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            // Get the events for the current controller
            dict = dict[self.schedulingModelAddress];
            return [self modelsWithCommand:dict];
            
        case IrrigationSystemModeEvenDays:
            dict = [LawnNGardenSubsystemCapability getEvenSchedulesFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            // Get the events for the current controller
            dict = dict[self.schedulingModelAddress];
            return [self modelsWithCommand:dict];
            
        case IrrigationSystemModeManual:
        default:
            break;
    }
    return nil;
}

- (NSArray *)loadEventForSelectedDay:(ScheduleRepeatType)selectedDay {
    NSMutableArray *events = [NSMutableArray array];
    
    NSArray *allEventModels = [self loadScheduledEvents];
    
    for (ScheduledEventModel *item in allEventModels) {
        if (item.eventDay & selectedDay) {
            [events addObject:item];
        }
    }
    NSArray *sortedEvents = [events sortedArrayUsingComparator:^NSComparisonResult(ScheduledEventModel *a, ScheduledEventModel *b) {
        return [a.eventTime compare:b.eventTime];
    }];
    return sortedEvents;
}

- (BOOL)hasEventsForSelectedDay:(ScheduleRepeatType)selectedDay {
    NSArray *allEventModels = [self loadScheduledEvents];
    
    for (ScheduledEventModel *item in allEventModels) {
        if (item.eventDay & selectedDay) {
            return YES;
        }
    }
    return NO;
}

// For the current schedulingModel
- (BOOL)hasScheduledEventsForMode:(int)mode {
    NSDictionary *dict;
    
    switch (mode) {
        case IrrigationSystemModeWeekly:
            dict = [LawnNGardenSubsystemCapability getWeeklySchedulesFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            break;
            
        case IrrigationSystemModeInterval:
            dict = [LawnNGardenSubsystemCapability getIntervalSchedulesFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            break;
            
        case IrrigationSystemModeOddDays:
            dict = [LawnNGardenSubsystemCapability getOddSchedulesFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            break;
            
        case IrrigationSystemModeEvenDays:
            dict = [LawnNGardenSubsystemCapability getEvenSchedulesFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            break;
            
        case IrrigationSystemModeManual:
        default:
            break;
    }
    if (dict.count > 0) {
        dict = dict[self.schedulingModelAddress];
        if (dict.count > 0) {
            NSArray *events = [self getAllEventsWithStatusNotDeletedAndNotDeleting:dict[@"events"]];
            return (events.count > 0);
        }
    }
    
    return NO;
}

- (NSArray *)modelsWithCommand:(NSDictionary *)command {
    NSMutableArray *models = [NSMutableArray array];
    
    NSString *messageType = command[@"type"];

    switch (super.scheduleMode) {
        case IrrigationSystemModeWeekly: {
            if ([LawnNGardenScheduleController isValidEvent:command]) {
                NSArray *days = command[@"days"];
                NSString *eventId = command[@"eventId"];
                NSArray *zones = [self createZones:command[@"events"]];
                
                for (NSString *day in days) {
                    IrrigationScheduledEventModel *eventModel = (IrrigationScheduledEventModel *)[self getNewEventModel];
                    
                    [eventModel preload];
                    eventModel.eventDay = [self scheduleRepeatTypeWithString:day];
                    eventModel.eventTime = [LawnNGardenScheduleController dateForCommand:command];
                    eventModel.eventId = eventId;
                    eventModel.attributes = [NSMutableDictionary new];
                    eventModel.messageType = messageType;
                    eventModel.originalCommand = command;
                    eventModel.allZones = zones;
                    [models addObject:eventModel];
                }
            }
        }
            break;
            
        case IrrigationSystemModeInterval: {
            NSNumber *daysInterval = command[@"days"];
            NSArray *events = command[@"events"];
            
            for (NSDictionary *event in events) {
                if ([LawnNGardenScheduleController isValidEvent:event]) {
                    IrrigationScheduledEventModel *eventModel = (IrrigationScheduledEventModel *)[self getNewEventModel];
                    
                    eventModel.eventId = event[@"eventId"];
                    eventModel.attributes = [NSMutableDictionary new];
                    eventModel.messageType = messageType;
                    eventModel.originalCommand = command;
                    eventModel.allZones = [self createZones:event[@"events"]];
                    eventModel.eventTime = [LawnNGardenScheduleController dateForCommand:event];
                    
                    eventModel.wateringIntervalInDays = daysInterval.intValue;
                    
                    [models addObject:eventModel];
                }
            }
        }
            break;
            
        case IrrigationSystemModeOddDays:
        case IrrigationSystemModeEvenDays: {
            
            NSArray *events = command[@"events"];
            for (NSDictionary *event in events) {
                if ([LawnNGardenScheduleController isValidEvent:event]) {
                    IrrigationScheduledEventModel *eventModel = (IrrigationScheduledEventModel *)[self getNewEventModel];
                    
                    eventModel.eventId = event[@"eventId"];
                    eventModel.attributes = [NSMutableDictionary new];
                    eventModel.messageType = messageType;
                    eventModel.originalCommand = command;
                    eventModel.allZones = [self createZones:event[@"events"]];
                    eventModel.eventTime = [LawnNGardenScheduleController dateForCommand:event];
                    
                    [models addObject:eventModel];
                }
            }
    }
            break;
            
        default:
            break;
    }
    
    return models;
}

- (NSArray *)createZones:(NSArray *)zoneAttribs {
    OrderedDictionary *allZones = [LawnNGardenSubsystemController getAllZonesForModel:ScheduleController.scheduleController.schedulingModelAddress];
    DeviceModel *device = (DeviceModel *)ScheduleController.scheduleController.schedulingModel;
    NSMutableArray *zones = [[NSMutableArray alloc] initWithCapacity:allZones.allValues.count];
    IrrigationZoneModel *zone;
    // We need to preserve the order of the zones
    // First need to be the zones that are selected and in the order they come from the platform
    for (NSDictionary *dict in zoneAttribs) {
        zone = [[IrrigationZoneModel alloc] initWithDictionary:dict];
        [zones addObject:zone];
        [allZones removeObjectForKey:dict[@"zone"]];
    }
    for (NSString *zoneKey in allZones) {
        zone = [[IrrigationZoneModel alloc] initWithKey:zoneKey andDeviceModel:device];
        [zones addObject:zone];
    }
    return zones.copy;
}

+ (ArcusDateTime *)dateForCommand:(NSDictionary *)command {
    NSString *timeString  = (NSString *)[command objectForKey:@"timeOfDay"];
    NSArray<NSString *> *components = [timeString componentsSeparatedByString:@":"];
    int hours = components[0].intValue;
    int mins = components[1].intValue;
    
    ArcusDateTime *schedulerTime = [[ArcusDateTime alloc] initWithHours:hours andMins:mins];
    
    return schedulerTime;
}

#pragma mark - Add/Update/Delete schedule events
- (PMKPromise *)configureWithEventModel:(IrrigationScheduledEventModel *)eventModel {
    // We need to cnvert the day of the week to a date, that will be sent to platform
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int dayOfWeekScheduled = (int)[calendar.weekdaySymbols indexOfObject:[ScheduledEventModel getWeekDayForDayType:eventModel.wateringIntervalInDays]];
    NSDate *today = [NSDate date];
    int dayOfWeekToday = (int)[calendar component:NSCalendarUnitWeekday fromDate:today];
    NSDate *scheduledDate;
    if (dayOfWeekScheduled == dayOfWeekToday) {
        scheduledDate = today;
    }
    else if (dayOfWeekScheduled > dayOfWeekToday) {
        scheduledDate = [today dateByAddingTimeInterval:60 * 60 * 24 * (dayOfWeekScheduled - dayOfWeekToday)];
    }
    else {
        scheduledDate = [today dateByAddingTimeInterval:60 * 60 * 24 * (7 - dayOfWeekToday + dayOfWeekScheduled)];
    }
    // Check what day of the week is at the end
    return [LawnNGardenSubsystemCapability configureIntervalScheduleWithController:self.schedulingModelAddress
                                                                     withStartTime:[scheduledDate timeIntervalSince1970]
                                                                          withDays:eventModel.wateringIntervalInDays
                                                                           onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
        return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
    });
}

- (PMKPromise *)saveScheduleWithEvent:(IrrigationScheduledEventModel *)eventModel
                             withDays:(NSArray *)days {
    
    switch (self.scheduleMode) {
        case IrrigationSystemModeWeekly: {
            return [LawnNGardenSubsystemCapability createWeeklyEventWithController:super.schedulingModelAddress
                                                                          withDays:days withTimeOfDay:eventModel.eventTimeFormatted
                                                                 withZoneDurations:[self irrigationZonesToString:eventModel.allZones]
                                                                           onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
              return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
            });
        }
            
        case IrrigationSystemModeInterval: {
            if ([self loadScheduledEvents].count == 0) {
                return [self configureWithEventModel:eventModel].thenInBackground(^{
                    return [self saveIntervalScheduleWithEvent:eventModel];
                });
            }
            else {
                return [self saveIntervalScheduleWithEvent:eventModel];
             }
        }
        case IrrigationSystemModeOddDays:
            return [LawnNGardenSubsystemCapability createScheduleEventWithController:self.schedulingModelAddress
                                                                            withMode:@"ODD" withTimeOfDay:eventModel.eventTimeFormatted
                                                                   withZoneDurations:[self irrigationZonesToString:eventModel.selectedZones]
                                                                             onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
                return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
            });

            
        case IrrigationSystemModeEvenDays:
            return [LawnNGardenSubsystemCapability createScheduleEventWithController:self.schedulingModelAddress
                                                                            withMode:@"EVEN" withTimeOfDay:eventModel.eventTimeFormatted
                                                                   withZoneDurations:[self irrigationZonesToString:eventModel.selectedZones]
                                                                             onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
                return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
            });

            
        default:
            break;
    }
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {}];
}

- (PMKPromise *)saveIntervalScheduleWithEvent:(IrrigationScheduledEventModel *)eventModel {
    return [LawnNGardenSubsystemCapability createScheduleEventWithController:self.schedulingModelAddress
                                                                    withMode:@"INTERVAL" withTimeOfDay:eventModel.eventTimeFormatted
                                                           withZoneDurations:[self irrigationZonesToString:eventModel.selectedZones]
                                                                     onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
        return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
    });
}

- (NSArray *)irrigationZonesToString:(NSArray *)zones {
    NSMutableArray *zonesStr = [[NSMutableArray alloc] initWithCapacity:zones.count];
    
    for (IrrigationZoneModel *zone in zones) {
        if (zone.selected) {
            [zonesStr addObject:@{@"zone" : zone.zoneValue, @"duration" : @(zone.defaultDuration)}];
        }
    }
    return zonesStr.copy;
}

- (PMKPromise *)updateScheduleWithEvent:(IrrigationScheduledEventModel *)eventModel
                               withDays:(NSArray *)days {
    
    switch (self.scheduleMode) {
        case IrrigationSystemModeWeekly:
            return [LawnNGardenSubsystemCapability updateWeeklyEventWithController:self.schedulingModelAddress
                                                                       withEventId:eventModel.eventId
                                                                          withDays:days
                                                                     withTimeOfDay:eventModel.eventTimeFormatted
                                                                 withZoneDurations:[self irrigationZonesToString:eventModel.selectedZones]
                                                                           withDay:days.count > 1 ? @"" : days[0]
                                                                           onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            
        case IrrigationSystemModeInterval:
            return [LawnNGardenSubsystemCapability updateScheduleEventWithController:self.schedulingModelAddress
                                                                            withMode:@"INTERVAL"
                                                                         withEventId:eventModel.eventId
                                                                       withTimeOfDay:eventModel.eventTimeFormatted withZoneDurations:[self irrigationZonesToString:eventModel.selectedZones]
                                                                             onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            
        case IrrigationSystemModeOddDays:
            return [LawnNGardenSubsystemCapability updateScheduleEventWithController:self.schedulingModelAddress
                                                                            withMode:@"ODD"
                                                                         withEventId:eventModel.eventId
                                                                       withTimeOfDay:eventModel.eventTimeFormatted withZoneDurations:[self irrigationZonesToString:eventModel.selectedZones]
                                                                             onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];

        case IrrigationSystemModeEvenDays:
            return [LawnNGardenSubsystemCapability updateScheduleEventWithController:self.schedulingModelAddress
                                                                            withMode:@"EVEN"
                                                                         withEventId:eventModel.eventId
                                                                       withTimeOfDay:eventModel.eventTimeFormatted withZoneDurations:[self irrigationZonesToString:eventModel.selectedZones]
                                                                             onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel];
            
        default:
            break;
    }
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {}];
}

- (PMKPromise *)deleteScheduleWithEventId:(NSString *)eventId withDay:(NSString *)day {
    switch (self.scheduleMode) {
        case IrrigationSystemModeWeekly:
            return [LawnNGardenSubsystemCapability removeWeeklyEventWithController:self.schedulingModelAddress
                                                                       withEventId:eventId
                                                                           withDay:day
                                                                           onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
                return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
            });
            
        case IrrigationSystemModeInterval:
            return [LawnNGardenSubsystemCapability removeScheduleEventWithController:self.schedulingModelAddress
                                                                            withMode:@"INTERVAL"
                                                                         withEventId:eventId
                                                                             onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
                return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
            });
            
        case IrrigationSystemModeOddDays:
            return [LawnNGardenSubsystemCapability removeScheduleEventWithController:self.schedulingModelAddress
                                                                            withMode:@"ODD"
                                                                         withEventId:eventId
                                                                             onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
                return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
            });
            
        case IrrigationSystemModeEvenDays:
            return [LawnNGardenSubsystemCapability removeScheduleEventWithController:self.schedulingModelAddress
                                                                            withMode:@"EVEN"
                                                                         withEventId:eventId
                                                                             onModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel].thenInBackground(^{
                return [[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel refresh];
            });
            
        default:
            break;
    }
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {}];
}

+ (BOOL)nextEventForModel:(DeviceModel *)deviceModel eventTime:(NSDate **)nextEventTime eventValue:(NSString **)nextEventValue {
    *nextEventTime = nil;
    *nextEventValue = @"";

    // Check if schedule is not enabled for the model
    if (![ScheduleController.scheduleController isScheduleEnabledForModel:deviceModel]) {
        // scheduler is disabled
        return NO;
    }
    
    NSString *currentModeStr;
    if (![[SubsystemsController sharedInstance].lawnNGardenController isScheduleForCurrentIrrigationModeForModelEnabled:ScheduleController.scheduleController.schedulingModelAddress currentMode:&currentModeStr]) {
        // scheduler is disabled
        return NO;
    }
    
    NSDictionary *dict = [LawnNGardenSubsystemCapability getScheduleStatusFromModel:[SubsystemsController sharedInstance].lawnNGardenController.subsystemModel][deviceModel.address];
    if ([self scheduleStringToMode:dict[@"mode"]] == ScheduleController.scheduleController.scheduleMode) {
        if (![dict[@"enabled"] boolValue]) {
            return NO;
        }
        dict = dict[@"nextEvent"];
        *nextEventTime = [NSDate dateWithTimeIntervalSince1970:([dict[@"startTime"] doubleValue] / 1000)];
        return YES;
    }
 
    // schedule model doesn't exist
    return NO;
}


- (BOOL)canSaveEvent:(IrrigationScheduledEventModel *)event {
    return (event.selectedZones.count > 0);
}

#pragma mark - Sunrise Sunset
- (PopupSelectionBaseContainer *)getScheduledTimePickerWithDateTime:(ArcusDateTime *)dateTime {
    return [PopupSelectionSchedulerTimeView createWithDateTime:dateTime showJustDate:YES];
}

@end
