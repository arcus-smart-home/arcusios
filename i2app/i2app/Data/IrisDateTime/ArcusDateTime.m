//
//  ArcusDateTime.m
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

#import <i2app-Swift.h>
#import "ArcusDateTime.h"
#import "NSDate+Convert.h"

const int kScheduleSunrise = 6;
const int kScheduleSunset = 18;

NSString *const kScheduleTimeModeAbsolute = @"ABSOLUTE";
NSString *const kScheduleTimeModeSunrise = @"SUNRISE";
NSString *const kScheduleTimeModeSunset = @"SUNSET";

@implementation ArcusDateTime

@dynamic dateTimeType;
@dynamic beforeSunriseSunset;

- (instancetype)init {
    if (self = [super init]) {
        self.date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
        self.currentTimeType = DateTimeAbsolute;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.date = date;
        _currentTimeType = DateTimeAbsolute;
        _offsetMinutes = 0;
    }
    return self;
}

- (instancetype)initWithHours:(int)hours andMins:(int)minutes {
    if (self = [super init]) {
        self.date = [NSDate dateWithTimeInHour:hours withMins:minutes];
        _currentTimeType = DateTimeAbsolute;
    }
    return self;
}

- (instancetype)initWithArcusTimestamp:(double) timestamp {
    if (self == [super init]) {
        self.date = [NSDate dateWithTimeIntervalSince1970: (timestamp / 1000)];
        _currentTimeType = DateTimeAbsolute;
    }
    return self;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        NSString *mode = (NSString *)attributes[@"mode"];
        if ([mode isEqual:[NSNull null]] || mode.length == 0 || [mode isEqualToString:kScheduleTimeModeAbsolute]) {
            // This is a date
            NSString *timeString  = (NSString *)[attributes objectForKey:@"time"];
            NSArray<NSString *> *components = [timeString componentsSeparatedByString:@":"];
            int hours = components[0].intValue;
            int mins = components[1].intValue;
            self.date = [NSDate dateWithTimeInHour:hours withMins:mins];
            _currentTimeType = DateTimeAbsolute;
            _offsetMinutes = 0;
        }
        else {
            if ([mode isEqualToString:kScheduleTimeModeSunrise]) {
                _currentTimeType = DateTimeSunrise;
            }
            else if ([mode isEqualToString:kScheduleTimeModeSunset]) {
                _currentTimeType = DateTimeSunset;
            }
            NSNumber *offsetMinutes = (NSNumber *)attributes[@"offsetMinutes"];
            if (![offsetMinutes isEqual:[NSNull null]]) {
                _offsetMinutes = offsetMinutes.intValue;
            }
            self.date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Date: %@ min:%d dateTimeType:%d", self.date, self.offsetMinutes, self.currentTimeType];
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
    ArcusDateTime *time = [self.class new];
    
    time.date = self.date;
    time.offsetMinutes = self.offsetMinutes;

    time.currentTimeType = self.currentTimeType;
    
    return time;
}

#pragma mark - dynamic properties
- (DateTimeType)dateTimeType {
    if (self.currentTimeType == DateTimeAbsolute) {
        if (self.date.getHours >= kScheduleSunrise && self.date.getHours < kScheduleSunset) {
            return DateTimeDay;
        }
        else {
            return DateTimeNight;
        }
    }
    return self.currentTimeType;
}

- (BOOL)beforeSunriseSunset {
    return _offsetMinutes <= 0;
}

// Returns true if the eventTime has changed
- (BOOL)updateTime:(ArcusDateTime *)eventTime {
    if (eventTime.currentTimeType == DateTimeAbsolute) {
        // Date type changed to Absolute
        if (eventTime.currentTimeType != self.currentTimeType) {
            self.currentTimeType = eventTime.currentTimeType;
            self.date = (NSDate *)eventTime.date;
            self.offsetMinutes = 0;
            return YES;
        }
        // Date type did not change - still Absolute
        if ([self.date compare:(NSDate *)eventTime.date] != NSOrderedSame) {
            self.date = (NSDate *)eventTime.date;
            self.offsetMinutes  = 0;
            return YES;
        }
        return NO;
    }
    if (self.currentTimeType != eventTime.currentTimeType ||
        self.offsetMinutes != eventTime.offsetMinutes) {
        self.offsetMinutes = eventTime.offsetMinutes;
        self.currentTimeType = eventTime.currentTimeType;
        self.date = eventTime.date;
        
        return YES;
    }
    return NO;
}

- (NSComparisonResult)compare:(ArcusDateTime *)eventTime {
    if (self.currentTimeType == DateTimeAbsolute ||
        eventTime.currentTimeType == DateTimeAbsolute) {
        if (self.currentTimeType == DateTimeAbsolute) {
            if (eventTime.currentTimeType == DateTimeAbsolute) {
                return [self.date compare:eventTime.date];
            }
            return NSOrderedDescending;
        }
        else if (eventTime.currentTimeType == DateTimeAbsolute) {
            return NSOrderedAscending;
        }
    }
    if (self.currentTimeType == DateTimeSunrise) {
        if (eventTime.currentTimeType == DateTimeSunrise) {
            return (self.offsetMinutes < eventTime.offsetMinutes ? NSOrderedAscending : NSOrderedDescending);
        }
        // evenTime is sunset related - goes after self
        return NSOrderedAscending;
    }
    
    // self is a Sunset related time
    if (eventTime.currentTimeType == DateTimeSunrise) {
        if (self.currentTimeType == DateTimeSunset) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }
    return (self.offsetMinutes < eventTime.offsetMinutes ? NSOrderedAscending : NSOrderedDescending);
}

- (NSString *)formatDateTimeStamp {
    if (self.currentTimeType == DateTimeAbsolute) {
        return [self.date formatDateTimeStamp];
    }
    
    if (self.currentTimeType == DateTimeSunrise) {
        if (self.offsetMinutes == 0) {
            return @"At Sunrise";
        }
        return [NSString stringWithFormat:@"%d Min %@ Sunrise", abs(self.offsetMinutes), self.beforeSunriseSunset ? NSLocalizedString(@"Before", nil) : NSLocalizedString(@"After", nil)];
    }
    if (self.currentTimeType == DateTimeSunset) {
        if (self.offsetMinutes == 0) {
            return @"At Sunset";
        }
        return [NSString stringWithFormat:@"%d Min %@ Sunset", abs(self.offsetMinutes), self.beforeSunriseSunset ? NSLocalizedString(@"Before", nil) : NSLocalizedString(@"After", nil)];
    }
    return @"";
}

- (NSString *)formatDateTimeStampShort {
    if (self.currentTimeType == DateTimeAbsolute) {
        return [self.date formatDateTimeStamp];
    }
    
    if (self.currentTimeType == DateTimeSunrise) {
        if (self.offsetMinutes == 0) {
            return @"At Sunrise";
        }
        return [NSString stringWithFormat:@"%d Min %@", abs(self.offsetMinutes), self.beforeSunriseSunset ? NSLocalizedString(@"Before", nil) : NSLocalizedString(@"After", nil)];
    }
    if (self.currentTimeType == DateTimeSunset) {
        if (self.offsetMinutes == 0) {
            return @"At Sunset";
        }
        return [NSString stringWithFormat:@"%d Min %@", abs(self.offsetMinutes), self.beforeSunriseSunset ? NSLocalizedString(@"Before", nil) : NSLocalizedString(@"After", nil)];
    }
    return @"";
}

- (NSString *)formatDate:(NSString *)format {
    if (self.currentTimeType == DateTimeAbsolute) {
        return [self.date formatDate:@"HH:mm:ss"];
    }
    if (self.currentTimeType == DateTimeSunrise) {
        return [NSString stringWithFormat:@"%d Min %@", abs(self.offsetMinutes), self.beforeSunriseSunset ? NSLocalizedString(@"Before", nil) : NSLocalizedString(@"After", nil)];
    }
    if (self.currentTimeType == DateTimeSunset) {
        return [NSString stringWithFormat:@"%d Min %@", abs(self.offsetMinutes), self.beforeSunriseSunset ? NSLocalizedString(@"Before", nil) : NSLocalizedString(@"After", nil)];
    }
    return @"";
}

@end
