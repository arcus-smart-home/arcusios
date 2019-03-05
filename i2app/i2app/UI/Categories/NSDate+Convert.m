//
//  NSDate+Convert.m
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

#import <i2app-Swift.h>
#import "NSDate+Convert.h"
#import "PlaceCapability.h"


@implementation NSDate(Covert)

- (NSDate *)toGlobalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (NSDate *)toLocalTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setDateFormat:@"yyyy MMM dd hh:mm a"];
    [dateFormatter setAMSymbol:@"AM"];
    [dateFormatter setPMSymbol:@"PM"];
    
    return [dateFormatter dateFromString:self.formatDateFullDescription];
}

- (NSDate *)toPlaceTime {
    PlaceModel *currentPlace = [[CorneaHolder shared] settings].currentPlace;
    if ([PlaceCapability getTzNameFromModel:currentPlace].length == 0) {
        return [self toLocalTime];
    }
    
    double offSetTime = [PlaceCapability getTzOffsetFromModel:currentPlace];

    BOOL isDST = [PlaceCapability getTzUsesDSTFromModel:currentPlace];

    if (isDST){
        offSetTime += 1;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(offSetTime * 60 * 60)]];
    [dateFormatter setDateFormat:@"yyyy MMM dd hh:mm a"];
    [dateFormatter setAMSymbol:@"AM"];
    [dateFormatter setPMSymbol:@"PM"];
    
    return [dateFormatter dateFromString:self.formatDateFullDescription];
}


- (NSDate *)toDay {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)dateForMinutesFromNow:(int)minutes {
    return [NSDate dateWithTimeInterval: minutes * 60 sinceDate: [NSDate date]];
}

+ (NSDate *)date2000Year {
    NSString * dateString = @"2000-01-01 00:00:00";
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [myDateFormatter dateFromString:dateString];
    return date;
}

+ (NSDate *)dateWithTimeInHour:(int)timeInHour {
    
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    components.hour = timeInHour;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)dateWithTimeInHour:(int)timeInHour withMins:(int)mins {
    
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate dateWithTimeIntervalSince1970:0]];
    components.hour = timeInHour;
    components.minute = mins;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)date2000YearWithMins:(int)mins andSecs:(int)secs {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[self date2000Year]];
    components.minute = mins;
    components.second = secs;

    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)dateForTotalDelaySeconds:(int)totalSeconds {
    int minutes = totalSeconds/60;
    int seconds = totalSeconds%60;
    
    return [NSDate date2000YearWithMins:minutes andSecs:seconds];
}

+ (NSDate *) dateFromTimeUuid:(NSString*)timeUuid {
  
  // Empty uuids return current time
  if (timeUuid == nil || timeUuid.length < 36) {
    return [[NSDate alloc] init];
  }

  // Parse most-significant bits from UUID string.
  // Given a UUID string like 'b8bc6990-3f18-11e7-80257dd3de',
  // c1 == b8bc6990; c2 == 3f18; c3 == 11e7
  
  unsigned int c1, c2, c3;
  [[NSScanner scannerWithString:[timeUuid substringWithRange:NSMakeRange(0, 8)]] scanHexInt:&c1];
  [[NSScanner scannerWithString:[timeUuid substringWithRange:NSMakeRange(9, 4)]] scanHexInt:&c2];
  [[NSScanner scannerWithString:[timeUuid substringWithRange:NSMakeRange(14, 4)]] scanHexInt:&c3];

  unsigned long long mostSigBits = c1;
  mostSigBits <<= 16;
  mostSigBits |= c2;
  mostSigBits <<= 16;
  mostSigBits |= c3;
  
  // Parse time components from UUID bytes
  unsigned long long timeLow  = (mostSigBits & 0xFFFFFFFF00000000) >> 32;
  unsigned long long timeMid  = (mostSigBits & 0x00000000FFFF0000) << 16;
  unsigned long long timeHigh = (mostSigBits & 0x0000000000000FFF) << 48;
  
  // Number of 100ns quantums since midnight October 15, 1582 UTC
  unsigned long long uuidTime = timeLow | timeMid | timeHigh;
  
  // Milliseconds since January 1, 1970 GMT
  const unsigned long long NUM_100NS_INTERVALS_SINCE_UUID_EPOCH = 0x01b21dd213814000;
  unsigned long long timestamp = (uuidTime - NUM_100NS_INTERVALS_SINCE_UUID_EPOCH) / 10000;   // div by 10K to convert 100ns to ms
  
  return [[NSDate alloc] initWithTimeIntervalSince1970:(timestamp / 1000.0f)];
}

- (NSInteger)daysSince:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date toDate:self options:0];
    NSInteger daysBetween = labs([components day]);
    return daysBetween;
}

- (NSString *)lastChangedTime {
    // calculate whether to display days since last state change or time
    NSInteger days = [[NSDate date] daysSince:self];
    if (days > 1) {
        return [NSString stringWithFormat:@"%ld %@", (long)days, NSLocalizedString(@"days", nil)];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *time = [dateFormatter stringFromDate:self];
    
    return time;
}

- (NSString *)addMinToDateWithMin:(int)min {
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.minute = min;
    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                   toDate: self
                                                                  options:0];
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:@"E h:mm a"];
    [toDateFormatter setAMSymbol:@"AM"];
    [toDateFormatter setPMSymbol:@"PM"];
    return [toDateFormatter stringFromDate:newDate];
}

- (int)getYear {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:NSCalendarUnitYear fromDate:self];
    return (int)components.year;
}

- (int)getMinutes {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    
    return (int)components.hour * 60 + (int)components.minute;
}

- (int)getMinute {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    
    return (int)components.minute;
}


- (int)getHours {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    
    return (int)components.hour;
}

- (int)getSecond {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    
    return (int)components.second;
}

- (int)getSeconds {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitMinute| NSCalendarUnitSecond) fromDate:self];
    
    return (int)components.minute * 60 + (int)components.second;
}

- (NSString *)getShortWeekDay {
    return [self formatDate:@"EEE"];
}

- (NSString *)getWeekDay {
    return [self formatDate:@"EEEE"];
}

- (NSString *)formatDateTimeStamp {
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *twelveHourFormat = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [toDateFormatter setLocale:twelveHourFormat];
    [toDateFormatter setDateFormat:@"h:mm a"];
    
    return [toDateFormatter stringFromDate:self];
}

- (NSString *)formatTimeStamp {
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:@"h:mm a"];
    
    return [toDateFormatter stringFromDate:self];
}

- (NSString *)formatDateStamp {
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:@"MMM d"];
    
    return [toDateFormatter stringFromDate:self];
}

- (NSString *)formatDateStampWithYear {
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:@"MMM d, YYYY"];
    
    return [toDateFormatter stringFromDate:self];
}

- (NSString *)formatBaseOnDayHours {
    if ([[NSCalendar currentCalendar] isDateInToday:self]) {
        return [self formatDate:@"h:mm a"];
    } else {
        return [self formatDate:@"E MMM dd"];
    }
}

- (NSString *)formatDeviceLastEvent {
    if ([[NSCalendar currentCalendar] isDateInToday:self]) {
        return [NSString stringWithFormat:@"at %@", [self formatDate:@"h:mm a"]];
    }
    else if ([[NSCalendar currentCalendar] isDateInYesterday:self]) {
        return @"Yesterday";
    }
    else {
        return [self formatDate:@"MMM dd, YYYY"];
    }
}

- (NSString *)formatBasedOnDayOfWeekAndHours {
    return [self formatDate:@"EEEE h:mm a"];
}

- (NSString *)formatBasedOnDayOfWeekAndHoursIncludingToday {
    if ([[NSCalendar currentCalendar] isDateInToday:self]) {
        return [NSString stringWithFormat:@"Today %@", [self formatDate:@"h:mm a"].uppercaseString];
    }
    else {
        return [self formatDate:@"E h:mm a"].capitalizedString;
    }
}

- (NSString *)formatBasedOnDayOfWeekAndHoursExceptToday {
    if ([[NSCalendar currentCalendar] isDateInToday:self]) {
        return [self formatDate:@"h:mm a"].uppercaseString;
    }
    else {
         return [self formatDate:@"E h:mm a"].uppercaseString;
    }
}

- (NSString *)formatDateByDay {
    if ([[NSCalendar currentCalendar] isDateInToday:self]) {
        return NSLocalizedString(@"Today", nil);
    }
    else if ([[NSCalendar currentCalendar] isDateInYesterday:self]) {
      return NSLocalizedString(@"Yesterday", nil);
    }

    return [self formatDate:@"E MMM dd"];
}

- (NSString *)formatDate:(NSString *)format {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *twelveHourFormat = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  [dateFormatter setLocale:twelveHourFormat];
  [dateFormatter setDateFormat:format];
  NSString *dateString = [dateFormatter stringFromDate:self];
  return dateString;
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *)dateByAddingDays:(NSInteger)dDays {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSString *)formatDateLongDescription {
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:@"E MMM dd hh:mm a"];
    [toDateFormatter setAMSymbol:@"AM"];
    [toDateFormatter setPMSymbol:@"PM"];
    
    return[toDateFormatter stringFromDate:self];
}

- (NSString *)formatDateFullDescription {
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:@"yyyy MMM dd hh:mm a"];
    [toDateFormatter setAMSymbol:@"AM"];
    [toDateFormatter setPMSymbol:@"PM"];
    
    return[toDateFormatter stringFromDate:self];
}

- (NSString *)formatToPlaceDateLongDescription {
    NSDate *placeTime = [self toPlaceTime];
    return [placeTime formatDateLongDescription];
}

- (NSString *)formatFullDate {
    return [NSString stringWithFormat:@"%@ %@", [self formatDateByDay], [self formatDateTimeStamp]];
}

- (BOOL) isSameDayWith:(NSDate *)day {
    NSDateComponents *first = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *second = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:day];
    
    return (first.day == second.day && first.month == second.month && first.month == second.month && first.year == second.year && first.era == second.era);
}

- (BOOL) isSameTimeWith:(NSDate *)date {
    NSDateComponents *first = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSDateComponents *second = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    return (first.hour == second.hour && first.minute == second.minute && first.second == second.second);
}


+ (BOOL)isTimeOfDate:(NSDate *)targetDate betweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    if (!targetDate || !startDate || !endDate) {
        return NO;
    }
    
    NSComparisonResult compareTargetToStart = [targetDate compare:startDate];
    NSComparisonResult compareTargetToEnd = [targetDate compare:endDate];
    
    return (compareTargetToStart == NSOrderedDescending && compareTargetToEnd == NSOrderedAscending);
}

+ (NSArray<NSNumber *> *)weekDaysInvolvedFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSMutableArray<NSNumber *> *weekDaysInvolved = [NSMutableArray array];
    
    if ([endDate daysSince:startDate] >= 7) {
        weekDaysInvolved = [NSMutableArray arrayWithObjects:@(1), @(2), @(3), @(4), @(5), @(6), @(7), nil];//Every day of week involved
    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger startWeekDay = [calendar component:NSCalendarUnitWeekday fromDate:startDate];
        NSInteger endWeekDay = [calendar component:NSCalendarUnitWeekday fromDate:endDate];
        if (endWeekDay < startWeekDay) {
            for (NSInteger i = 1; i <= endWeekDay; i++) {
                [weekDaysInvolved addObject:@(i)];
            }
            for (NSInteger i = startWeekDay; i <= 7; i++) {
                [weekDaysInvolved addObject:@(i)];
            }
        } else {
            for (NSInteger i = startWeekDay; i <= endWeekDay; i++) {
                [weekDaysInvolved addObject:@(i)];
            }
        }
    }
    
    return weekDaysInvolved;
}

- (NSComparisonResult)dateIndependentTimeComparison:(NSDate *)aDate {
    NSComparisonResult comparisonResult;
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *startComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute
                                                    fromDate:self];
    NSDateComponents *endComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute
                                                  fromDate:aDate];
    
    if ([startComponents hour] > [endComponents hour]) {
        comparisonResult = NSOrderedDescending;
    } else if ([startComponents hour] == [endComponents hour]) {
        if ([startComponents minute] > [endComponents minute]) {
            comparisonResult = NSOrderedDescending;
        } else if ([startComponents minute] == [endComponents minute]) {
            comparisonResult = NSOrderedSame;
        } else {
            comparisonResult = NSOrderedAscending;
        }
    } else {
        comparisonResult = NSOrderedAscending;
    }
    
    return comparisonResult;
}

+ (BOOL)isDate:(NSDate *)targetDate
greaterThanEqualToStartDate:(NSDate *)startDate
andLessThanEndDate:(NSDate *)endDate {
    
    BOOL isBetween = NO;
    
    if (targetDate && startDate && endDate) {
        isBetween = YES;
        
        NSComparisonResult compareTargetToStart = [targetDate compare:startDate];
        NSComparisonResult compareTargetToEnd = [targetDate compare:endDate];
        
        if (compareTargetToStart != NSOrderedDescending && compareTargetToStart != NSOrderedSame) {
            isBetween = NO;
        }
        
        if (compareTargetToEnd != NSOrderedAscending) {
            isBetween = NO;
        }
    }
    
    return isBetween;
}

- (NSString *)timeSinceNow {
    NSMutableString *timeLeft = [[NSMutableString alloc] init];
    
    NSInteger seconds = (NSInteger)fabs([self timeIntervalSinceNow]);
    NSInteger minutes = (int) (floor(seconds / 60));
    NSInteger hours = (int) (floor(seconds / 3600));
    
    if(hours) {
        [timeLeft appendString:[NSString stringWithFormat:@"%ld Hour", (long)hours]];
    }
    
    [timeLeft appendString:[NSString stringWithFormat:@"%ld Min", (long)minutes]];
    
    return timeLeft;
}

- (NSString *)toNextToken {
    return [NSString stringWithFormat:@"%.0f", (self.timeIntervalSince1970 * 1000.0) ];
}

@end
