//
//  ScheduleController.m
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

#import <i2app-Swift.h>
#import "ScheduleController.h"
#import "ImageDownloader.h"
#import "CommonCheckableImageCell.h"
#import "Capability.h"
#import "DeviceCapability.h"
#import "SubsystemsController.h"

#import "WeeklyScheduleViewController.h"
#import "ClimateSubSystemController.h"
#import "WaterSubsystemController.h"
#import "SchedulerService.h"


#import "SchedulerCapability.h"
#import "NSDate+Convert.h"
#import "PopupSelectionTimerView.h"
#import "PopupSelectionSchedulerTimeView.h"

#import "WeeklyScheduleCapability.h"
#import "DeviceController.h"
#import "SimpleTableViewController.h"
#import "UIView+Subviews.h"
#import <i2app-Swift.h>
#import "UIViewController+DisplayError.h"

@interface ScheduleController ()

@end


@implementation ScheduleController {
    NSArray         *_currentCells;
    UITableView     *_tableView;
}

static ScheduleController *_scheduleController = nil;

@dynamic scheduleName;
@dynamic isWeeklySchedule;

- (instancetype)init {
  if (self = [super init]) {
    ScheduleController.scheduleController = self;
    self.schedulingModelAddress = nil;
    self.scheduleMode = -1;

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(devicesRefreshed:)
     name:kDeviceListRefreshedNotification object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(devicesRefreshed:)
     name:@"UpdateSchedulerModelNotification"
     object:nil];

  }
  return self;
}

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (SchedulerModel *)getSchedulerForModelWithAddress:(NSString *)modelAddress {
    return [ScheduleController.scheduleController getSchedulerForModelWithAddress:modelAddress];
}

- (SchedulerModel *)getSchedulerForModelWithAddress:(NSString *)modelAddress {
    for (SchedulerModel *scheduler in [[[CorneaHolder shared] modelCache] fetchModels:[SchedulerCapability namespace]]) {
        if ([[SchedulerCapability getTargetFromModel:scheduler] isEqualToString:modelAddress]) {
            return scheduler;
        }
    }
    
    return nil;
}

+ (ScheduleController *)staticController {
  return _scheduleController;
}

+ (ScheduleController *)scheduleController {
    return _scheduleController;
}

+ (void)setScheduleController:(ScheduleController *)scheduleController {
    _scheduleController = scheduleController;
}

+ (NSString *)scheduleModeToString:(int)mode {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"ScheduleController:scheduleModeToString: Needs to be implemented in the derived class" userInfo:nil];
}

+ (int)scheduleStringToMode:(NSString *)mode {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"ScheduleController:scheduleStringToMode: Needs to be implemented in the derived class" userInfo:nil];
}

#pragma mark - dynamic properties
- (NSString *)scheduleName {
    return @"Base";
}

- (BOOL)isWeeklySchedule {
    return YES;
}

- (DeviceModel *)schedulingModel {
    return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.schedulingModelAddress];
}

#pragma mark - WeeklyScheduleViewController Overriden Methods
- (NSString *)getTitle {
    return NSLocalizedString(@"Schedule", nil);
}

- (void)initializeData {
}

- (NSString *)getHeaderText {
    return NSLocalizedString(@"Tap on the device below to manage its schedule.", nil);
}

- (NSString *)getSubheaderText {
    return NSLocalizedString(@"Unchecking a device will put the device", nil);
}

- (NSString *)emptyScheduleTitleText {
    return NSLocalizedString(@"Create a Schedule", nil);;
}

- (NSString *)scheduleViewControllerNavBarTitle {
    return NSLocalizedString(@"Schedule", nil).uppercaseString;
}

- (NSString *)emptyScheduleSubtitleText {
    return NSLocalizedString(@"Tap Add Event below to create a schedule for this day.", nil);
}

- (NSArray<SimpleTableCell *> *)getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    _tableView = tableView;
    if ([[[CorneaHolder shared] modelCache] fetchModels:[DeviceCapability namespace]].count == 0 &&
        [[[CorneaHolder shared] modelCache] fetchModels:[SchedulerCapability namespace]].count == 0 ) {
      // Store hasn't refreshed yet
        return _currentCells;
    }
    NSMutableArray<SimpleTableCell *> *cells = [[NSMutableArray alloc] init];

    for (NSString *deviceId in self.modelsIds) {
        DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[DeviceModel addressForId:deviceId]];
        if (device != nil) {
            CommonCheckableImageCell *cell = [CommonCheckableImageCell create:tableView];
            [cell setIcon:nil withTitle:device.name subtitle:nil andSide:nil withBlackFont:NO];

            [cell setCheck:[self isScheduleEnabledForModel:device] styleBlack:NO];
            [cell setOnClickEvent:@selector(onCheckEnable:withModel:) owner:self withObj:device];
            [cell displayArrow:YES];

            if ([self hasScheduledEventsForModelWithAddress:device.address]) {
                [cell attachSideIcon:[UIImage imageNamed:@"schedule_icon"] inverseColor:NO];
            }
            else {
                [cell removeSideIcon];
            }

            SimpleTableCell *tableCell = [SimpleTableCell create:cell withOwner:self andPressSelector:@selector(onClickCell:)];
            [tableCell setDataObject:device];
            [cells addObject:tableCell];

            [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device] withDevTypeId:[device devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
                [cell setIcon:image];
            });
        }
    }
    _currentCells = cells;

    return cells;
}

- (void)onCheckEnable:(CommonCheckableImageCell *)cell withModel:(Model *)model {
    if (![cell getChecked] && ![self hasScheduledEventsForModelWithAddress:model.address]) {
        [self.ownerController displayErrorMessage:NSLocalizedString(@"You need to add at least 1 event to the schedule", nil)
                                        withTitle:NSLocalizedString(@"NO EVENTS ON SCHEDULE", nil)];
    }
    else {
      [self setSchedulerForModel:model enable:![cell getChecked]].then(^{
        [cell setCheck:![cell getChecked] styleBlack:NO];
        DDLogInfo(@"success");
      }).catch(^(NSError *error) {
        DDLogInfo(@"fail");
      });
    }
}

- (void)onClickCell:(SimpleTableCell *)cell {
    WeeklyScheduleViewController *vc = [WeeklyScheduleViewController create];
    self.schedulingModelAddress = ((Model *)cell.dataObject).address;
    self.scheduleMode = -1;
    vc.hasLightBackground = NO;
    [self.ownerController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SchedulerSettingViewController Overriden Methods
- (NSString *)getSchedulerSettingViewControllerSubheader {
    return @"";
}

#pragma mark - ScheduledEventModel
- (ScheduledEventModel *)getNewEventModel {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"ScheduleController:getNewEventModel: Needs to be implemented in the derived class" userInfo:nil];
}

- (ScheduledEventModel *)createNewEventItem:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"ScheduleController:createNewEventItem: Needs to be implemented in the derived class" userInfo:nil];
    return nil;
}

#pragma mark - Schedule Type
- (NSString *)getScheduleType {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"ScheduleController:getScheduleType Needs to be implemented in the derived class" userInfo:nil];
}

#pragma mark - Schedule Enable
- (BOOL)isScheduleEnabledForCurrentModel {
    return [self isScheduleEnabledForModel:self.schedulingModel];
}

- (BOOL)isScheduleEnabledForModel:(Model *)model {
    SchedulerModel *schedulerModel = [self getSchedulerForModelWithAddress:model.address];
    if (schedulerModel) {
        NSString *schedulerEnableKey = [NSString stringWithFormat:@"sched:enabled:%@", [self getScheduleType]];

        BOOL isEnabled = ((NSNumber *)[schedulerModel getAttribute:schedulerEnableKey]).boolValue;
        BOOL hasCommands = ((NSArray *)[schedulerModel getAttribute:kAttrSchedulerCommands]).count > 0;
      
        return isEnabled && hasCommands;
    }
    return NO;
}

- (PMKPromise *)enableSchedulerForCurrentModel:(BOOL)enable {
    return [self setSchedulerForModel:self.schedulingModel enable:enable];
}

- (PMKPromise *)setSchedulerForModel:(Model *)model enable:(BOOL)enable {
    __block SchedulerModel *schedulerModel = [self getSchedulerForModelWithAddress:model.address];
    
    if (!schedulerModel) {
        return [SchedulerService getSchedulerWithTarget:model.address].thenInBackground(^(SchedulerServiceGetSchedulerResponse *response) {
            SchedulerModel *model = [[SchedulerModel alloc] initWithAttributes:response.getScheduler];

            schedulerModel = model;

            NSString *schedulerEnableKey = [NSString stringWithFormat:@"sched:enabled:%@", [self getScheduleType]];
            [schedulerModel set:@{schedulerEnableKey:[NSNumber numberWithBool:enable]}];

            [schedulerModel commit];
            return nil;
        });
    }
    else {
        NSString *schedulerEnableKey = [NSString stringWithFormat:@"sched:enabled:%@", [self getScheduleType]];
        [schedulerModel set:@{schedulerEnableKey:[NSNumber numberWithBool:enable]}];

      return [schedulerModel commit];
    }
}

#pragma mark - Load events
- (BOOL)hasScheduledEventsForModelWithAddress:(NSString *)address {
    return ([SchedulerCapability getCommandsFromModel:[self getSchedulerForModelWithAddress:address]].allValues.count > 0);
}

- (BOOL)hasScheduledEventsForCurrentModel {
    return ([SchedulerCapability getCommandsFromModel:[self getSchedulerForModelWithAddress:self.schedulingModelAddress]].allValues.count > 0);
}

- (int)getScheduledEventsCount {
    return (int)[SchedulerCapability getCommandsFromModel:[self getSchedulerForModelWithAddress:self.schedulingModel.address]].allValues.count;
}

- (NSArray *)loadScheduledEvents {
    NSMutableArray *eventModels = [NSMutableArray array];
    
    for (NSDictionary *command in [SchedulerCapability getCommandsFromModel:[self getSchedulerForModelWithAddress:self.schedulingModel.address]].allValues) {
        [eventModels addObjectsFromArray:[self modelsWithCommand:command]];
    }
    
    return eventModels.copy;
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

- (BOOL)hasScheduledEventsForMode:(int)mode {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"ScheduleController:hasScheduledEventsForMode: Needs to be implemented in the derived class" userInfo:nil];
}

- (NSArray *)modelsWithCommand:(NSDictionary *)command {
    NSMutableArray *models = [NSMutableArray array];
    
    NSArray *days = command[@"days"];
    NSString *eventId = command[@"id"];
    NSString *messageType = command[@"messageType"];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:command[@"attributes"]];
    for (NSString *day in days) {
        ScheduledEventModel *eventModel = [self getNewEventModel];
        
        [eventModel preload];
        eventModel.eventDay = [self scheduleRepeatTypeWithString:day];
        eventModel.eventTime = [ScheduleController dateForCommand:command];
        eventModel.eventId = eventId;
        eventModel.attributes = attributes;
        eventModel.messageType = messageType;
        eventModel.originalCommand = command;
        [models addObject:eventModel];
    }
    
    return models;
}

+ (ArcusDateTime *)dateForCommand:(NSDictionary *)attributes {

    return [[ArcusDateTime alloc] initWithAttributes:attributes];
}

- (ScheduleRepeatType)scheduleRepeatTypeWithString:(NSString *)day {
    day = [day uppercaseString];
    
    NSArray *days = @[@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", @"SUN"];
    switch ([days indexOfObject:day]) {
        case 0:
            return ScheduleRepeatTypeMon;
            
        case 1:
            return ScheduleRepeatTypeTue;
            
        case 2:
            return ScheduleRepeatTypeWed;
            
        case 3:
            return ScheduleRepeatTypeThu;
            
        case 4:
            return ScheduleRepeatTypeFri;
            
        case 5:
            return ScheduleRepeatTypeSat;
            
        default:
            return ScheduleRepeatTypeSun;
    }
}

#pragma mark - Add/Update/Delete schedule events
- (NSString *)getScheduleMode:(ArcusDateTime *)eventTime {
    if (eventTime.currentTimeType == DateTimeSunrise) {
        return kScheduleTimeModeSunrise;
    }
    if (eventTime.currentTimeType == DateTimeSunset) {
        return kScheduleTimeModeSunset;
    }
    return kScheduleTimeModeAbsolute;
}

- (NSString *)getFormattedTime:(ScheduledEventModel *)eventModel {
    if (eventModel.eventTime.currentTimeType == DateTimeAbsolute) {
        return eventModel.eventTimeFormatted;
    }
    return @"";
}

- (PMKPromise *)saveScheduleWithEvent:(ScheduledEventModel *)eventModel
                             withDays:(NSArray *)days {
    NSAssert(eventModel.messageType, @"messageType should never by nil");
    
    return [SchedulerService scheduleWeeklyCommandWithTarget:self.schedulingModel.address
                                                withSchedule:[self getScheduleType]
                                                    withDays:days
                                                    withMode:[self getScheduleMode:eventModel.eventTime]
                                                    withTime:[self getFormattedTime:eventModel]
                                           withOffsetMinutes:eventModel.eventTime.offsetMinutes
                                             withMessageType:eventModel.messageType
                                              withAttributes:eventModel.attributes];
}

- (PMKPromise *)updateScheduleWithEvent:(ScheduledEventModel *)eventModel
                               withDays:(NSArray *)days {
    return [SchedulerService updateWeeklyCommandWithTarget:self.schedulingModel.address
                                              withSchedule:[self getScheduleType]
                                             withCommandId:eventModel.eventId
                                                  withDays:days
                                                  withMode:[self getScheduleMode:eventModel.eventTime]
                                                  withTime:[self getFormattedTime:eventModel]
                                         withOffsetMinutes:eventModel.eventTime.offsetMinutes
                                           withMessageType:eventModel.messageType
                                            withAttributes:eventModel.attributes].then(^ {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            
            //Tag Edit Scene
            [ArcusAnalytics tag:[NSString stringWithFormat:@"Scheduler - Edited %@ schedule", self.scheduleName] attributes:@{}];
            fulfill(self);
        }];
    });
}

// "day" is needed only for Lawn&Garden
- (PMKPromise *)deleteScheduleWithEventId:(NSString *)eventId withDay:(NSString *)day {
 
    return [SchedulerService deleteCommandWithTarget:self.schedulingModel.address withSchedule:[self getScheduleType] withCommandId:eventId];
}

#pragma mark - Get Next Scheduled Event
+ (BOOL)nextEventForModel:(Model *)model eventTime:(NSDate **)nextEventTime eventValue:(NSString **)nextEventValue {
    return NO;
}

- (BOOL)canSaveEvent:(ScheduledEventModel *)event {
    return YES;
}

#pragma mark - Sunrise Sunset
- (PopupSelectionBaseContainer *)getScheduledTimePickerWithDateTime:(ArcusDateTime *)dateTime {
    return [PopupSelectionSchedulerTimeView createWithDateTime:dateTime showJustDate:NO];
}

#pragma mark - Notifications
- (void)devicesRefreshed:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        SimpleTableViewController *vc = (SimpleTableViewController *)[_tableView getParentViewController];
        [vc refresh];
    });
}
@end
