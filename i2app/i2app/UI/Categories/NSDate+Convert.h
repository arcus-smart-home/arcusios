//
//  NSDate+Convert.h
//  i2app
//
//  Created by Arcus Team on 6/26/15.
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

#define NUMBER_SECONDS_IN_DAY 86400

@interface NSDate(Covert)

- (NSDate *) toPlaceTime;
- (NSDate *) toLocalTime;
- (NSDate *) toGlobalTime;
- (NSDate *) toDay;
+ (NSDate *) dateForMinutesFromNow:(int)minutes;
+ (NSDate *) date2000Year;
+ (NSDate *) date2000YearWithMins:(int)mins andSecs:(int)secs;
+ (NSDate *) dateWithTimeInHour:(int)timeInHour;
+ (NSDate *) dateWithTimeInHour:(int)timeInHour withMins:(int)mins;
+ (NSDate *) dateForTotalDelaySeconds:(int)totalSeconds;
+ (NSDate *) dateFromTimeUuid:(NSString*)timeUuid;

- (NSDate *) dateByAddingDays: (NSInteger) dDays;

- (BOOL) isSameDayWith:(NSDate *)day;
- (BOOL) isSameTimeWith:(NSDate *)date;

- (NSString *)formatDate: (NSString *)format;

- (NSInteger)daysSince:(NSDate *)date;
- (NSString *)lastChangedTime;
- (int)getYear;
- (int)getMinutes;
- (int)getMinute;
- (int)getSecond;
- (int)getHours;
- (int)getSeconds;
- (NSString *)getShortWeekDay;
- (NSString *)getWeekDay;

- (NSString *)formatDateTimeStamp;
- (NSString *)formatTimeStamp;
- (NSString *)formatDateStamp;
- (NSString *)formatDateStampWithYear;
- (NSString *)formatDateByDay;
- (NSString *)formatBaseOnDayHours;
- (NSString *)formatDeviceLastEvent;
- (NSString *)formatBasedOnDayOfWeekAndHours;
- (NSString *)formatBasedOnDayOfWeekAndHoursIncludingToday;
- (NSString *)formatBasedOnDayOfWeekAndHoursExceptToday;
- (NSString *)formatDateLongDescription;
- (NSString *)formatFullDate;
- (NSString *)addMinToDateWithMin:(int)min;
- (NSString *)formatToPlaceDateLongDescription;
+ (BOOL)isTimeOfDate:(NSDate *)targetDate betweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
+ (BOOL)isDate:(NSDate *)targetDate
greaterThanEqualToStartDate:(NSDate *)startDate
andLessThanEndDate:(NSDate *)endDate;

+ (NSArray<NSNumber *> *)weekDaysInvolvedFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;//This weekdays are using the same numbers NSDateComponents would, so Sunday is 1, Saturday is 7
- (NSComparisonResult)dateIndependentTimeComparison:(NSDate *)aDate;
- (NSString *)timeSinceNow;

/// Transforms a date to a string the platform called `nextToken`
/// `nextTokens` can be used for starting pagination from a specific time
- (NSString *)toNextToken;

@end
