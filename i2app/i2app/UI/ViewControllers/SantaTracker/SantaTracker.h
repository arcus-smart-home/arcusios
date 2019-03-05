//
//  SantaTracker.h
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

#import <Foundation/Foundation.h>

typedef enum {
    SantaTrackerStatusGetStart      = 0,
    SantaTrackerStatusConfigured,
    SantaTrackerStatusConfirmed,
} SantaTrackerStatus;

typedef enum {
    SantaReindeerSensor = 0,
    SantaChimneySensor,
    SantaMilkCookiesSensor,
    SantaChristmasStockingSensor,
    SantaChristmasTreeSensor,
    SantaContactSensor,
    SantaMotionSensor
    
} SantaHistoryItemType;

/* SANTA TRACKER CONFIGURATION - Seasonal Change Instructions:
 *
 * Provided there are no UI/UX changes required to Santa Tracker, 
 * this feature can be seasonally refreshed by:
 *
 * 1. Updating the kSantaSeasonOpenTime, kSantaSeasonCloseTime,
 *    kSantaVisitTime, kSantaSetupReminderTime, and kSantaSomethingHappenedTime
 *    event times. 
 *
 * 2. Updating the kSantaTrackerConfig configuration key with a new year
 *    suffix
 *
 * 3. Updating the blurred santa photo (santa_blurred asset) with a new
 *    overlay image
 *
 * 4. Modify the relative positioning of the Santa overlay (as needed)
 *    in SantaTracker.storyboard.
 */

#define kSantaSeasonOpenTime                @"2017:11:24 00:00:00"      // Time tracker becomes available in app
#define kSantaSeasonCloseTime               @"2018:01:07 23:59:59"      // Time tracker disappears from app
#define kSantaVisitTime                     @"2017:12:25 00:25:00"      // Time Santa visits home

#define kSantaSetupReminderTime             @"2017:12:24 17:00:00"      // Time when user is reminded to configure tracker
#define kSantaSetupReminderType             @"ST_SETUP"

#define kSantaSomethingHappenedTime         @"2017:12:25 11:00:00"      // Time when user gets reminded that Santa has visited
#define kSantaSomethingHappenedReminderType @"ST_SOMETHING_HAPPENED"

#define kSantaTrackerImageId                @"santaTackerImage"         // Santa overlay image for this season
#define kSantaTrackerConfig                 @"2018_SantaTrackerConfig"  // Config data for this season

@interface SantaHistoryItemModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (assign) SantaHistoryItemType type;

@end

@interface SantaTracker : NSObject

+ (SantaTracker *)shareInstance;

- (NSMutableArray*) participatingDevices;

- (void) setUpdatedSantaPhoto:(UIImage*)photo;

- (SantaTrackerStatus) getStatus;
- (void) setStatus:(SantaTrackerStatus)status;

- (UIViewController *) getController;

- (void) saveReindeerLand:(NSNumber *)status;
- (NSNumber *) getReindeerLandStatus;

- (void) saveSantaEnterSensors:(NSArray *)sensors;
- (NSArray *) getSantaEnterSensors;
- (BOOL) matchSantaEnterSensors:(NSString *)tag;

- (void) saveSantaMotionSensors:(NSArray *)sensors;
- (NSArray *) getSantaMotionSensors;
- (BOOL) matchSantaMotionSensors:(NSString *)tag;

- (UIImage *) getSantaImage;

- (void) provisionReminders;
- (void) save;
- (void) cancel;

- (void)removeSetupReminderNotification;
- (void)removeSomethingHappenedReminderNotification;

+ (NSDate *)dynamicOpenTime;
+ (NSDate *)dynamicCloseTime;
+ (NSDate *)dynamicVisitTime;

@end
