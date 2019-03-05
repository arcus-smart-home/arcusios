//
//  ArcusDateTime.h
//  i2app
//
//  Created by Arcus Team on 4/7/16.
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

typedef NS_ENUM(unsigned int, DateTimeType) {
    DateTimeNone,
    DateTimeAbsolute,
    DateTimeDay,
    DateTimeNight,
    DateTimeSunrise     = 11,
    DateTimeSunset      = 22
};

extern NSString *const kScheduleTimeModeAbsolute;
extern NSString *const kScheduleTimeModeSunrise;
extern NSString *const kScheduleTimeModeSunset;


@interface ArcusDateTime : NSObject <NSCopying>

- (instancetype)initWithDate:(NSDate *)date;
- (instancetype)initWithHours:(int)hours andMins:(int)minutes;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (instancetype)initWithArcusTimestamp:(double) timestamp;

@property (nonatomic, strong) NSDate *date;
@property (atomic, readonly) DateTimeType dateTimeType;

@property (atomic, assign) int offsetMinutes;
@property (atomic, readonly) BOOL beforeSunriseSunset;

@property (atomic, assign) DateTimeType currentTimeType;

- (BOOL)updateTime:(ArcusDateTime *)eventTime;
- (NSComparisonResult)compare:(ArcusDateTime *)eventTime;

- (NSString *)formatDateTimeStamp;
- (NSString *)formatDateTimeStampShort;

- (NSString *)formatDate:(NSString *)format;

@end
