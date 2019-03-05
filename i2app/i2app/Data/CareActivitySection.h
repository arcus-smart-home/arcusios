//
//  CareActivitySection.h
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
#import "CareActivityManager.h"

@class CareSubsystemController;
@class CareActivitySection;
@class CareActivityUnit;
@class CareActivityInterval;
@class CareActivityEventInfo;

@interface CareActivitySection : NSObject

/**
 * Reference to CareSubsystemController, which will be used to fetch data from the plaform.
 **/
@property (nonatomic, strong) CareSubsystemController *careSubsystem;

/**
 * Represents the starting point in time that the Section contains Activity Intervals for.
 **/
@property (nonatomic, strong) NSDate *startDate;

/**
 * Represents the ending point in time that the Section contains Activity Intervals for.
 **/
@property (nonatomic, strong) NSDate *endDate;

/**
 * Determines the amount of time each section will represent.
 * i.e. NSCalendarUnitDay is used to create sections representing a day worth of
 * Care Activity
 **/
@property (nonatomic, assign) CareCalendarUnit sectionType;

/**
 * sectionMultiplier is used to indicate if a section should represent multiple
 * units of the chosen sectionType.  i.e. if sectionType == NSCalendarUnitDay &&
 * sectionMultiplier == 2, then a section will represent 2 days of Care Activity.
 * Value defaults to 1 if unset & 0 is not allowed and will revert to the default.
 **/
@property (nonatomic, assign) NSInteger sectionMultiplier;

/**
 * Determines the amount of time each unit will represent.
 * i.e. NSCalendarUnitHour is used to create units representing an hour worth of
 * Care Activity
 **/
@property (nonatomic, assign) CareCalendarUnit unitType;

/**
 * sectionMultiplier is used to indicate if a unit should represent multiple
 * units of the chosen units.  i.e. if unitType == NSCalendarUnitHour &&
 * unitMultiplier == 2, then a unit will represent 2 hours of Care Activity.
 * Value defaults to 1 if unset & 0 is not allowed and will revert to the default.
 **/
@property (nonatomic, assign) NSInteger unitMultiplier;

/**
 * Determines the resolution (or detail) of the Activity returned by the platform.
 * i.e. NSCalendarUnitSecond is used to request a care activity list from the
 * platform, which return intervals of 1 second.
 **/
@property (nonatomic, assign) CareCalendarUnit intervalResolution;

/**
 * resolutionMultipler is used to indicate if intervalResolution should
 * represent multiple units of the chosen resolution.
 * i.e. if intervalResolution == NSCalendarUnitSecond &&
 * resolutionMultipler == 2, then the resolution will represent intervals of 2 seconds.
 * Value defaults to 1 if unset & 0 is not allowed and will revert to the default.
 **/
@property (nonatomic, assign) NSInteger resolutionMultipler;

/**
 * Array of Devices to use to fetch activity data.
 **/
@property (nonatomic, strong) NSArray *filterDevices;

/**
 * String token for activityEvent's last fetched result.  
 * Defaults to self.endDate.
 **/
@property (nonatomic, strong) NSString *detailsToken;

/**
 * Reference to generated CareActivityUnits.
 **/
@property (nonatomic, strong) NSArray <CareActivityUnit *> *activityUnits;

/**
 * Reference to generated CareActivityIntervals.
 **/
@property (nonatomic, strong) NSArray <CareActivityInterval *> *activityIntervals;

/**
 * Reference to generated CareActivityEventInfo array.
 **/
@property (nonatomic, strong) NSArray <CareActivityEventInfo *> *activityEvents;

/**
 * Method used to configure object with an array of intervals.
 *
 * @params: Array of CareActivityIntervals.
 **/
- (void)configureSectionWithIntervals:(NSArray <CareActivityInterval *> *)intervals;

@end
