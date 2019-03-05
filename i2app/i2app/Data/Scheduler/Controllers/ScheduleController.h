//
//  ScheduleController.h
//  i2app
//
//  Created by Arcus Team on 2/5/16.
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

#import "SimpleTableViewController.h"
#import "ScheduledEventModel.h"


@class Model;
@class CommonCheckableImageCell;
@class SchedulerModel;

@interface ScheduleController : SimpleTableDelegateBase

+ (SchedulerModel *)getSchedulerForModelWithAddress:(NSString *)modelAddress;
- (SchedulerModel *)getSchedulerForModelWithAddress:(NSString *)modelAddress;

+ (ScheduleController *)scheduleController;
+ (ScheduleController *)staticController; // Swift use
+ (void)setScheduleController:(ScheduleController *)scheduleController;

+ (NSString *)scheduleModeToString:(int)mode;
+ (int)scheduleStringToMode:(NSString *)mode;

@property (nonatomic, strong) NSMutableArray *modelsIds;

@property (nonatomic, strong) NSString *scheduleName;

// Used by thermostats and Lawn & Garden
// Derived classes will provide an enumeration for the scheduleMode for readability
@property (atomic, assign) int scheduleMode;

// For Lawn & Garden it might be NO, for all other schedules - they are always weekly
@property (atomic, assign) BOOL isWeeklySchedule;

// The model that needs to have its schedule added/deleted/modified
@property (nonatomic, strong) NSString *schedulingModelAddress;

@property (nonatomic, strong) ScheduledEventModel *scheduledEventModel;
@property (nonatomic, strong) ScheduledEventModel *updatedEventModel;

- (Model *)schedulingModel;

- (NSString *)emptyScheduleTitleText;
- (NSString *)scheduleViewControllerNavBarTitle;
- (NSString *)emptyScheduleSubtitleText;

- (void)onClickCell:(SimpleTableCell *)cell;
- (void)onCheckEnable:(CommonCheckableImageCell *)cell withModel:(Model *)model;

#pragma mark - SchedulerSettingViewController Overriden Methods
- (NSString *)getSchedulerSettingViewControllerSubheader;

#pragma mark - ScheduledEventModel
- (ScheduledEventModel *)getNewEventModel;
- (ScheduledEventModel *)createNewEventItem:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate;

#pragma mark - Schedule Type
- (NSString *)getScheduleType;


#pragma mark - Schedule Enable
- (BOOL)isScheduleEnabledForModel:(Model *)deviceModel;
- (PMKPromise *)setSchedulerForModel:(Model *)model enable:(BOOL)enable;

- (BOOL)isScheduleEnabledForCurrentModel;
- (PMKPromise *)enableSchedulerForCurrentModel:(BOOL)enable;


#pragma mark - Load events
- (BOOL)hasScheduledEventsForModelWithAddress:(NSString *)address;
- (BOOL)hasScheduledEventsForCurrentModel;
- (int)getScheduledEventsCount;
- (NSArray *)loadScheduledEvents;
- (NSArray *)loadEventForSelectedDay:(ScheduleRepeatType)selectedDay;
- (BOOL)hasEventsForSelectedDay:(ScheduleRepeatType)selectedDay;
- (BOOL)hasScheduledEventsForMode:(int)mode;
+ (ArcusDateTime *)dateForCommand:(NSDictionary *)command;
- (ScheduleRepeatType)scheduleRepeatTypeWithString:(NSString *)day;
- (NSArray *)modelsWithCommand:(NSDictionary *)command;

#pragma mark - Add/Update/Delete schedule events
- (PMKPromise *)saveScheduleWithEvent:(ScheduledEventModel *)eventModel
                             withDays:(NSArray *)days;

- (PMKPromise *)updateScheduleWithEvent:(ScheduledEventModel *)eventModel
                               withDays:(NSArray *)days;

- (PMKPromise *)deleteScheduleWithEventId:(NSString *)eventId withDay:(NSString *)day;

#pragma mark - Get Next Scheduled Event
+ (BOOL)nextEventForModel:(Model *)model eventTime:(NSDate **)nextEventTime eventValue:(NSString **)nextEventValue;

- (BOOL)canSaveEvent:(ScheduledEventModel *)event;

#pragma mark - Sunrise Sunset
- (PopupSelectionBaseContainer *)getScheduledTimePickerWithDateTime:(ArcusDateTime *)dateTime;

@end


