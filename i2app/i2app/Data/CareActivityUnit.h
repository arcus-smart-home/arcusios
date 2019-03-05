//
//  CareActivityUnit.h
//  i2app
//
//  Created by Arcus Team on 1/25/16.
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

@class CareActivityInterval;

@interface CareActivityUnit : NSObject

/**
 * Represents the starting point in time that the Unit contains Activity Intervals for.
 **/
@property (nonatomic, strong) NSDate *startDate;

/**
 * Represents the ending point in time that the Unit contains Activity Intervals for.
 **/
@property (nonatomic, strong) NSDate *endDate;

/**
 * Array of Activity Intervals for the Activity Unit.
 **/
@property (nonatomic, strong) NSArray <CareActivityInterval *> *unitIntervals;

@end
