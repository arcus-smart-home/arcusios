//
//  SantaTracker.m
//  i2app
//
//  Created by Arcus Team on 11/3/15.
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
#import "SantaTracker.h"
#import "SantaGetStartViewController.h"
#import "SantaConfigruredController.h"
#import "SantaConfirmViewController.h"
#import "AKFileManager.h"
#import "DeviceManager.h"
#import "NSDate+Convert.h"

@interface SantaTracker()

@property (strong, nonatomic) NSMutableDictionary *config;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SantaHistoryItemModel

@end

@implementation SantaTracker {
    UIImage *newSantaPhoto;
}

#pragma mark - Singleton

+ (SantaTracker *)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static SantaTracker *_manager = nil;
    dispatch_once(&pred, ^{
        _manager = [[SantaTracker alloc] init];
    });
    
    return _manager;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *savedConfig = [self getSavedConfig];
        self.config = [[NSMutableDictionary alloc] initWithDictionary:savedConfig];
    }
    return self;
}

#pragma mark - Getters & Setters

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    }
    return _dateFormatter;
}

- (NSMutableArray*) participatingDevices {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    // Reindeer Landing
    [list addObject:[self reindeerLandingStatus]];
    
    // Santa Entering Home
    NSArray *sensors = [self getSantaEnterSensors];
    if (sensors.count > 0) {
        SantaHistoryItemModel* santaLeavingHomeDeviceTitle = [self santaEnteringExitingHomeDevice:sensors];
        
        // Title may not be resolvable if device has been removed or place/account has changed
        if (santaLeavingHomeDeviceTitle) {
            [list addObject: santaLeavingHomeDeviceTitle];
        }
    }

    // Santa Motion in Home
    [list addObjectsFromArray:[self santaMotionInHomeStatus:[self getSantaMotionSensors]]];
    
    // Santa Exiting Home
    SantaHistoryItemModel* santaEnteringHomeDeviceTitle = [self santaEnteringExitingHomeDevice:sensors];
    if (santaEnteringHomeDeviceTitle) {
        [list addObject:santaEnteringHomeDeviceTitle];
    }
    
    // Reindeer Leaving
    [list addObject:[self reindeerLandingStatus]];
    
    return list;
}

// Reindeer Leaving
- (SantaHistoryItemModel *)reindeerLeavingStatus {
    SantaHistoryItemModel *model = [[SantaHistoryItemModel alloc] init];
    
    model.type = SantaReindeerSensor;
    NSInteger reindeerStatus = [[self getReindeerLandStatus] integerValue];
    
    switch (reindeerStatus) {
        case 0:
            model.title = @"ROOF SENSOR";
            break;
        case 1:
            model.title = @"LAWN SENSOR";
            break;
        case 2:
            model.title = @"BACK DECK/PATIO SENSOR";
            break;
        case 3:
            model.title = @"NEARBY PARK SENSOR";
            break;
        default:
            break;
    }
    
    return model;
}

// Santa Entering/Exiting Home
- (SantaHistoryItemModel *)santaEnteringExitingHomeDevice:(NSArray *)devices {
    SantaHistoryItemModel *model = [[SantaHistoryItemModel alloc] init];
    Model *deviceModel;
    
    if ([devices count] == 1) {
        deviceModel = [[DeviceManager instance] getDeviceByModelID:devices[0]];
    }
    
    if ([devices containsObject:@"Chimney"] || deviceModel == nil || ![deviceModel isKindOfClass:[DeviceModel class]]) {
        model.title = @"Chimney";
        model.type = SantaChimneySensor;
    } else {
        model.title = deviceModel.name;
        model.type = SantaContactSensor;
    }
    
    return model;
}


// Santa Motion in Home
- (NSArray *)santaMotionInHomeStatus:(NSArray *)selectedDevices {
    NSMutableArray *motionDevices = [[NSMutableArray alloc] init];
    
    if ([selectedDevices containsObject:@"Milk & Cookies Sensor"]) {
        SantaHistoryItemModel *model = [[SantaHistoryItemModel alloc] init];
        model.title = @"Milk & Cookies Sensor";
        model.type = SantaMilkCookiesSensor;
        
        [motionDevices addObject:model];
    }
    
    if ([selectedDevices containsObject:@"Christmas stocking sensor"]) {
        SantaHistoryItemModel *model = [[SantaHistoryItemModel alloc] init];
        model.title = @"Christmas stocking sensor";
        model.type = SantaChristmasStockingSensor;

        [motionDevices addObject:model];
    }
    
    if ([selectedDevices containsObject:@"Christmas tree sensor"]) {
        SantaHistoryItemModel *model = [[SantaHistoryItemModel alloc] init];
        model.title = @"Christmas tree sensor";
        model.type = SantaChristmasTreeSensor;

        [motionDevices addObject:model];
    }
    
    for (NSString *device in selectedDevices) {
        Model *deviceModel = [[DeviceManager instance] getDeviceByModelID:device];
        if (deviceModel && [deviceModel isKindOfClass:[DeviceModel class]]) {
            SantaHistoryItemModel *model = [[SantaHistoryItemModel alloc] init];
            model.title = deviceModel.getName;
            model.type = SantaMotionSensor;
            
            [motionDevices addObject:model];
        }
    }
    
    return motionDevices;
}

// Reindeer Landing
- (SantaHistoryItemModel *)reindeerLandingStatus {
    SantaHistoryItemModel *model = [[SantaHistoryItemModel alloc] init];
    
    NSInteger reindeerStatus = [[self getReindeerLandStatus] integerValue];
    model.type = SantaReindeerSensor;
    
    switch (reindeerStatus) {
        case 0:
            model.title = @"ROOF SENSOR";
            break;
        case 1:
            model.title = @"LAWN SENSOR";
            break;
        case 2:
            model.title = @"BACK DECK/PATIO SENSOR";
            break;
        case 3:
            model.title = @"NEARBY PARK SENSOR";
            break;
        default:
            break;
    }
    
    return model;
}

- (void) setUpdatedSantaPhoto:(UIImage*)photo {
    newSantaPhoto = photo;
}

- (SantaTrackerStatus)getStatus {
    NSDate *openingDate = [SantaTracker dynamicVisitTime];
    NSDate *closingDate = [SantaTracker dynamicCloseTime];
    
    if ([NSDate isTimeOfDate:[NSDate date] betweenStartDate:openingDate andEndDate:closingDate]) {
        return SantaTrackerStatusConfirmed;
    }
    else {
        return [[self.config objectForKey:@"status"] intValue];
    }
}

- (void)setStatus:(SantaTrackerStatus)status {
    [self.config setObject:@(status) forKey:@"status"];
}

- (UIViewController *) getController {
    UIViewController *controller = nil;

    [self provisionReminders];
    
    switch ([self getStatus]) {
        case SantaTrackerStatusGetStart:
            controller = [SantaGetStartViewController create:YES];
            break;
        case SantaTrackerStatusConfigured:
            controller = [SantaConfigruredController create];
            break;
        case SantaTrackerStatusConfirmed:
            controller = [SantaConfirmViewController create];
            break;
        default:
            break;
    }
    
    return controller;
}

- (void) provisionReminders {

    [self removeSomethingHappenedReminderNotification];
    [self removeSetupReminderNotification];

    switch ([self getStatus]) {
        case SantaTrackerStatusGetStart:
            [self scheduleSetupReminderNotification];
            break;
        case SantaTrackerStatusConfigured:
        case SantaTrackerStatusConfirmed:
            [self scheduleSomethingHappenedReminderNotification];
            break;
            
        default:
            break;
    }
}

- (void) saveReindeerLand:(NSNumber *)status {
    [self.config setObject:status forKey:@"reindeerLand_status"];
}
- (NSNumber *) getReindeerLandStatus {
    return [self.config objectForKey:@"reindeerLand_status"];
}

- (void) saveSantaEnterSensors:(NSArray *)sensors {
    [self.config setObject:sensors forKey:@"santaEnterSensors"];
}
- (NSArray *) getSantaEnterSensors {
    NSArray *selectedEnterSensors = [self.config objectForKey:@"santaEnterSensors"];
    
    if (selectedEnterSensors.count == 0) {
        return @[@"Chimney"];
    }
    
    return selectedEnterSensors;
}
- (BOOL) matchSantaEnterSensors:(NSString *)tag {
    NSArray *list = [self getSantaEnterSensors];
    for (NSString *item in list) {
        if ([item isEqualToString:tag]) {
            return YES;
        }
    }
    return NO;
}


- (void) saveSantaMotionSensors:(NSArray *)sensors {
    [self.config setObject:sensors forKey:@"santaMotionSensors"];
}
- (NSArray *) getSantaMotionSensors {
    NSArray *selectedMotionSensors = [self.config objectForKey:@"santaMotionSensors"];
    
    if (!selectedMotionSensors && selectedMotionSensors.count == 0) {
        return @[@"Christmas tree sensor", @"Milk & Cookies Sensor", @"Christmas stocking sensor"];
    }
    
    return selectedMotionSensors;
}
- (BOOL) matchSantaMotionSensors:(NSString *)tag {
    NSArray *list = [self getSantaMotionSensors];
    for (NSString *item in list) {
        if ([item isEqualToString:tag]) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *) getSantaImage {
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:kSantaTrackerImageId atSize:[UIScreen mainScreen].bounds.size withScale:[UIScreen mainScreen].scale];
    return image;
}

- (void)save {
    if (newSantaPhoto) {
        [[AKFileManager defaultManager] cacheImage:newSantaPhoto forHash:kSantaTrackerImageId];
        newSantaPhoto = nil;
    }
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_config];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:kSantaTrackerConfig];
    [userDefaults synchronize];
    
    [self removeSetupReminderNotification];
    [self scheduleSomethingHappenedReminderNotification];
}
- (void)cancel {
    if (newSantaPhoto) {
        newSantaPhoto = nil;
    }
    
    NSDictionary *savedConfig = [self getSavedConfig];
    self.config = [[NSMutableDictionary alloc] initWithDictionary:savedConfig];
}

- (NSDictionary *)getSavedConfig {
    NSDictionary *config = nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:kSantaTrackerConfig];
    if (encodedObject) {
        config = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return config;
}

- (void)scheduleSetupReminderNotification {
    NSDate *reminderDate = [self dynamicSetupTime];
    NSDate *now = [NSDate date];

    // Don't schedule a reminder if one has already been scheduled, or if the reminder time has elapsed
    if ([self notificationForType:kSantaSetupReminderType] || [now compare:reminderDate] == NSOrderedDescending) {
        return;
    }
    
    UILocalNotification *setupReminderNotification;
    
    setupReminderNotification = [[UILocalNotification alloc] init];
    setupReminderNotification.fireDate = reminderDate;
    setupReminderNotification.alertBody = @"Santa's coming to town soon! Be sure to set up Arcus' Santa Tracker, so no one has to try to stay up to see him. Arcus is on the job for you!";
    setupReminderNotification.timeZone = [NSTimeZone defaultTimeZone];
    setupReminderNotification.userInfo = @{@"type" : kSantaSetupReminderType};
        
    DDLogInfo(@"[SantaTracker] Added Notification For Setup.");
        
    [[UIApplication sharedApplication] scheduleLocalNotification:setupReminderNotification];
}

- (void)removeSetupReminderNotification {
    [self removeNotificationForType:kSantaSetupReminderType];
}

- (void)scheduleSomethingHappenedReminderNotification {
    NSDate *reminderDate = [self dynamicSomethingHappenedTime];
    NSDate *now = [NSDate date];

    // Don't schedule a reminder if one has already been scheduled, or if the reminder time has elapsed
    if ([self notificationForType:kSantaSomethingHappenedReminderType] || [now compare:reminderDate] == NSOrderedDescending) {
        return;
    }
    
    UILocalNotification *somethingHappenedReminderNotification;
    
    somethingHappenedReminderNotification = [[UILocalNotification alloc] init];
    somethingHappenedReminderNotification.fireDate = reminderDate;
    somethingHappenedReminderNotification.alertBody = @"Arcus detected activity from your Santa Sensors late last night.  Check Arcus’ Santa Tracker to see what happened!";
    somethingHappenedReminderNotification.timeZone = [NSTimeZone defaultTimeZone];
    somethingHappenedReminderNotification.userInfo = @{@"type" : kSantaSomethingHappenedReminderType};
        
    DDLogInfo(@"[SantaTracker] Added Notification For Something Happened.");
    
    [[UIApplication sharedApplication] scheduleLocalNotification:somethingHappenedReminderNotification];
}

- (void)removeSomethingHappenedReminderNotification {
    [self removeNotificationForType:kSantaSomethingHappenedReminderType];
}

- (UILocalNotification*) notificationForType:(NSString *) typeInfo {
    UILocalNotification *notificationForType = nil;
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if (notification.userInfo[@"type"]) {
            if ([notification.userInfo[@"type"] isEqualToString:typeInfo]) {
                notificationForType = notification;
            }
        }
    }
    
    return notificationForType;
}

- (void)removeNotificationForType:(NSString *)typeInfo {
    
    UILocalNotification *notificationToRemove = [self notificationForType:typeInfo];
    
    if (notificationToRemove) {
        DDLogInfo(@"[SantaTracker] Removed Notification With Type: %@.", typeInfo);
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToRemove];
    }
}

#pragma mark - Dynamic Dating Methods for Santa Tracker


- (NSDate *)dynamicSetupTime {
  NSDate *date = [self.dateFormatter dateFromString:kSantaSetupReminderTime];

  return [SantaTracker dynamicSantaTrackerDate:date];
}

+ (NSDate *)dynamicOpenTime {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];

  NSDate *date = [dateFormatter dateFromString:kSantaSeasonOpenTime];

  return [SantaTracker dynamicSantaTrackerDate:date];
}

+ (NSDate *)dynamicCloseTime {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];

  NSDate *closeDate = [dateFormatter dateFromString:kSantaSeasonCloseTime];
  NSDate *now = [NSDate date];

  NSCalendar *calendar = [NSCalendar currentCalendar];
  int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

  NSDateComponents *closeComponents = [calendar components:flags fromDate:closeDate];
  NSDateComponents *nowComponents = [calendar components:flags fromDate:now];

  closeComponents.year = nowComponents.year;
  if (closeComponents.month < nowComponents.month) {
    closeComponents.year += 1;
  }

  return [calendar dateFromComponents:closeComponents];
}

+ (NSDate *)dynamicVisitTime {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];

  NSDate *date = [dateFormatter dateFromString:kSantaVisitTime];

  return [SantaTracker dynamicSantaTrackerDate:date];
}

- (NSDate *)dynamicSomethingHappenedTime {
  NSDate *date = [self.dateFormatter dateFromString:kSantaSomethingHappenedTime];

  return [SantaTracker dynamicSantaTrackerDate:date];
}

+ (NSDate *)dynamicSantaTrackerDate:(NSDate *)date {
  return [self dynamicSantaTrackerDate:date compareDate:[NSDate date] shouldIncrement:NO];
}

+ (NSDate *)dynamicSantaTrackerDate:(NSDate *)date
                        compareDate:(NSDate *)compareDate
                    shouldIncrement:(BOOL)shouldIncrement  {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

  NSDateComponents *dateComponents = [calendar components:flags fromDate:date];
  NSDateComponents *compareComponents = [calendar components:flags fromDate:compareDate];

  dateComponents.year = compareComponents.year;

  if (shouldIncrement) {
    dateComponents.year += 1;
  }

    dateComponents.hour = date.getHours;
  return [calendar dateFromComponents:dateComponents];
}

@end
