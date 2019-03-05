//
//  CareActivityManager.h
//  i2app
//
//  Created by Arcus Team on 2/3/16.
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

@class CareActivityManager;
@class CareSubsystemController;
@class CareActivitySection;
@class CareActivityUnit;
@class CareActivityInterval;
@class CareActivityEventInfo;

/**
 * Completion Block used to return CareActivitySection and its configured CareActivityIntervals.
 * Required for use with fetching of activity from the platform.
 **/
typedef void (^CareActivityFetchCompletion)(CareActivitySection *section, NSArray <CareActivityInterval *> *intervals);

/**
 * Completion Block used to return CareActivitySection and its configured CareActivityEventInfo objects.
 * Required for use with fetching of activity details from the platform.
 **/
typedef void (^CareActivityDetailFetchCompletion)(CareActivitySection *section, NSArray <CareActivityEventInfo *> *events);

/**
 * Extended enumeration of NSCalendarUnit, which restricts the options to those
 * supported by the CareActivityManager.
 **/
typedef NS_OPTIONS(NSUInteger, CareCalendarUnit) {
    CareCalendarUnitDay                = NSCalendarUnitDay,
    CareCalendarUnitHour               = NSCalendarUnitHour,
    CareCalendarUnitMinute             = NSCalendarUnitMinute,
    CareCalendarUnitSecond             = NSCalendarUnitSecond
};

/**
 * Protocol used to enable delegation of CareActivityManager tasks.
 **/
@protocol CareActivityManagerDelegate <NSObject>
@required

/**
 * If the CareActivityManager receives a changeEvent notification from the platform,
 * the delegate will receive this callback.
 *
 * @params: Reference to CareActivityManager that is calling upon the delegate
 *          NSNotification received.
 **/
- (void)careActivityManager:(CareActivityManager *)manager receivedChangeEventNotification:(NSNotification *)notification;

@end

/**
 * CareActivityManager will utilize the CareSubsystemController to fetch Care 
 * Activity data from the Platform and will parse it into a series of objects
 * that can be used to configure the Care CollectionViews used to display 
 * ActivityGraphViews.
 *
 * Data fetched from the platform via the CareSubsystemCapabilities will be parsed into
 * CareActivitySection -> CareActivityUnit -> CareActivityInterval.
 **/
@interface CareActivityManager : NSObject

/**
 * Reference to object acting as CareActivityManager's delegate.
 **/
@property (nonatomic, assign) id <CareActivityManagerDelegate> delegate;

/**
 * Reference to CareSubsystemController, which will be used to fetch data from the plaform.
 **/
@property (nonatomic, strong) CareSubsystemController *careSubsystem;

/**
 * Read-only reference to the activitySections that the activityManager has already fetched
 * previously.  Array is used to cut down on the number of times the app has to hit
 * the platform for Care Activity Data.
 **/
@property (nonatomic, strong, readonly) NSArray *activitySections;

/**
 * Method used to search previously fetched sections from the platform based on their
 * startDates.
 *
 * @params: Date of activitySection to search for.
 *          FilterDevices of the activitySection to search for.
 * @return: The CareActivitySection found for the received date;
 **/
- (CareActivitySection *)careActivitySectionForStartDate:(NSDate *)startDate
                                           filterDevices:(NSArray *)filterDevices;
/**
 * Method used to fetch activity data from the platform via the CareSubsystemController.
 *
 * @params: CareActivitySection configured with the appropriate properties to fetch 
 *          data from the platform: (stateDate, endDate, resolution, filterDevices.)
 *          CareActivityFetchCompletion block to handle the return of data.
 **/
- (void)fetchActivityForSection:(CareActivitySection *)section
                     completion:(CareActivityFetchCompletion)completion;

/**
 * Method used to fetch activity detail data from the platform via the CareSubsystemController.
 *
 * When detailToken is nil or empty, this method will advance the detailToken cursor 
 * (by repeatedly invoking the platform) until the cursor has advanced past the endDate
 * window of time. If no activity data exists earlier than endDate, then the last window
 * of data (oldest activity) will be returned in the completion block.
 *
 * Note that this method does not guarantee that all data returned are within the endDate/
 * startDate window of time.
 *
 * @params: CareActivitySection configured with the appropriate properties to fetch
 *          data from the platform: (stateDate, endDate, resolution, filterDevices.)
 *          CareActivityDetailsFetchCompletion block to handle the return of data.
 **/
- (void)fetchActivityDetailForSection:(CareActivitySection *)section
                           completion:(CareActivityDetailFetchCompletion)completion;

/**
 * Convenience method used to return the constant used to determine the size of
 * the result returned by fetchActivityDetailForSection:completion:
 * 
 * @return: Integer constant used to determine result size.
 **/
- (NSInteger)eventInfoPageSize;

/**
 * Convenience method used to get the startDate of a CareActivity Object.
 *
 * @params: Integer index of the start date.
 *          The CareCalendarUnit to calculate the date for.
 *          The multiplier used to multiply the CareCalendarUnit.
 *          The reference date from which to calculate the date from.
 * @return: The calculated date.
 **/
+ (NSDate *)startDateForIndex:(NSInteger)index
                         unit:(CareCalendarUnit)unit
                   multiplier:(NSInteger)multiplier
                referenceDate:(NSDate *)referenceDate;

/**
 * Convenience method used to get the endDate of a CareActivity Object.
 *
 * @params: Integer index of the start date.
 *          The CareCalendarUnit to calculate the date for.
 *          The multiplier used to multiply the CareCalendarUnit.
 *          The reference date from which to calculate the date from.
 * @return: The calculated date.
 **/
+ (NSDate *)endDateForIndex:(NSInteger)index
                       unit:(CareCalendarUnit)unit
                 multiplier:(NSInteger)multiplier
              referenceDate:(NSDate *)referenceDate;

/**
 * Convenience method used to get the number of a CareCalendarUnits for the received
 * parameters.
 *
 * @params: The start date
 *          The end date
 *          The CareCalendarUnit used to count.
 * @return: Number of CareCalendarUnits found.
 **/
+ (NSInteger)careCalendarUnitCountBetweenStartDate:(NSDate *)start
                                           endDate:(NSDate *)end
                                      calendarUnit:(CareCalendarUnit)unit;

/**
 * Convenience method used to get the timeInterval represented by the parameters.
 *
 * @params: The CareCalendarUnit used to represnt the timeInterval
 *          The date to calculate the interval from.
 *          The multiplier used to multiply the CareCalendarUnit.
 * @return: The calculated timeInterval.
 **/
+ (NSTimeInterval)intervalForCalendarUnit:(CareCalendarUnit)unit
                                startDate:(NSDate *)startDate
                           unitMultiplier:(NSInteger)multiplier;

@end
