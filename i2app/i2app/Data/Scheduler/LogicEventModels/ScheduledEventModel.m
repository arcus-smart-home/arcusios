//
//  ScheduledEventModel.m
//  i2app
//
//  Created by Arcus Team on 10/23/15.
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
#import "ScheduledEventModel.h"
#import "ScheduleController.h"
#import "NSDate+Convert.h"
#import "SchedulerSettingViewController.h"
#import "WeeklyScheduleCapability.h"
#import "Capability.h"

@implementation ScheduledEventModel

@dynamic eventTimeFormatted;

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super init]) {
        _eventTime = [ArcusDateTime new];
        self.eventDay = eventDay;
        self.attributes = [NSMutableDictionary new];
        self.delegate = delegate;
        self.originalCommand = [[NSDictionary alloc] init];
        self.messageType = kCmdSetAttributes;
        _isNewModel = YES;
    }
    return self;
}

- (void)preload {
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d %@ %@", (int)self.eventDay, self.eventTime.description, self.attributes];
}

#pragma mark - Dynamic Properties
- (NSString *)eventTimeFormatted {
    return [self.eventTime formatDate:@"HH:mm:ss"];
}

- (BOOL)hasRelatedEvents {
    for (ScheduledEventModel *item in [ScheduleController.scheduleController loadScheduledEvents]) {
        if ([item.eventId isEqualToString:self.eventId] && item.eventDay != self.eventDay) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)getRelatedEvents {
    NSMutableArray *events = [[NSMutableArray alloc] init];
    for (ScheduledEventModel *item in [ScheduleController.scheduleController loadScheduledEvents]) {
        if ([item.eventId isEqualToString:self.eventId] && item.eventDay != self.eventDay) {
            [events addObject:item];
        }
    }
    
    return events;
}

- (NSString*)getRepeatDescription {
    return @"Tap below if you would like this event to happen on multiple days.";
}

- (ScheduleRepeatType)repeatDays {
    NSArray *days = [self getRelatedEvents];
    ScheduleRepeatType repeats = 0;
    for (ScheduledEventModel *item in days) {
        repeats |= item.eventDay;
    }
    repeats |= self.eventDay;
    
    return repeats;
}

+ (NSArray *)generateArrayOfRepeatDays:(ScheduleRepeatType)eventType {
    NSMutableArray *list = [NSMutableArray array];
    
    if (eventType & ScheduleRepeatTypeMon) {
        [list addObject:@"MON"];
    }
    if (eventType & ScheduleRepeatTypeTue) {
        [list addObject:@"TUE"];
    }
    if (eventType & ScheduleRepeatTypeWed) {
        [list addObject:@"WED"];
    }
    if (eventType & ScheduleRepeatTypeThu) {
        [list addObject:@"THU"];
    }
    if (eventType & ScheduleRepeatTypeFri) {
        [list addObject:@"FRI"];
    }
    if (eventType & ScheduleRepeatTypeSat) {
        [list addObject:@"SAT"];
    }
    if (eventType & ScheduleRepeatTypeSun) {
        [list addObject:@"SUN"];
    }
    
    return list;
}

+ (NSString *)generateStringOfRepeatDays:(ScheduleRepeatType)eventType {
    NSMutableArray *list = [NSMutableArray array];
    
    if (eventType & ScheduleRepeatTypeMon) {
        [list addObject:@"M"];
    }
    if (eventType & ScheduleRepeatTypeTue) {
        [list addObject:@"T"];
    }
    if (eventType & ScheduleRepeatTypeWed) {
        [list addObject:@"W"];
    }
    if (eventType & ScheduleRepeatTypeThu) {
        [list addObject:@"Th"];
    }
    if (eventType & ScheduleRepeatTypeFri) {
        [list addObject:@"F"];
    }
    
    if (list.count == 5) {
        [list removeAllObjects];
        [list addObject:@"Weekdays"];
    }
    
    if (eventType & ScheduleRepeatTypeSat && eventType & ScheduleRepeatTypeSun) {
        if (eventType & ScheduleRepeatTypeSat) {
            [list addObject:@"Weekend"];
        }
    }
    else {
        if (eventType & ScheduleRepeatTypeSat) {
            [list addObject:@"Sat"];
        }
        if (eventType & ScheduleRepeatTypeSun) {
            [list addObject:@"Sun"];
        }
    }
    
    if (list.count == 2 && [list[0] isEqualToString:@"Weekdays"] && [list[1] isEqualToString:@"Weekend"]) {
        [list removeAllObjects];
        [list addObject:@"Always"];
    }
    
    return [list componentsJoinedByString:@" , "];
}

+ (NSString *)stringWithRepeatDayType:(ScheduleRepeatType)dayType {
    switch (dayType) {
        case ScheduleRepeatTypeMon:
            return @"MON";

        case ScheduleRepeatTypeTue:
            return @"TUE";

        case ScheduleRepeatTypeWed:
            return @"WED";

        case ScheduleRepeatTypeThu:
            return @"THU";
            break;
        case ScheduleRepeatTypeFri:
            return @"FRI";

        case ScheduleRepeatTypeSat:
            return @"SAT";

        case ScheduleRepeatTypeSun:
            return @"SUN";

        default:
            break;
    }
}

+ (NSString *)getWeekDayForDayType:(ScheduleRepeatType)dayType {
    switch (dayType) {
        case ScheduleRepeatTypeMon:
            return @"Monday";
            
        case ScheduleRepeatTypeTue:
            return @"Tuesday";
            
        case ScheduleRepeatTypeWed:
            return @"Wednesday";
            
        case ScheduleRepeatTypeThu:
            return @"Thursday";
            
        case ScheduleRepeatTypeFri:
            return @"Friday";
            
        case ScheduleRepeatTypeSat:
            return @"Saturday";
            
        case ScheduleRepeatTypeSun:
            return @"Sunday";
            
        default:
            return @"";
    }
}

+ (ScheduleRepeatType)getDayTypeForFullWeekDayName:(NSString *)day {
    if ([day isEqualToString:@"Monday"]) {
        return ScheduleRepeatTypeMon;
    }
    else if ([day isEqualToString:@"Tuesday"]) {
        return ScheduleRepeatTypeTue;
    }
    else if ([day isEqualToString:@"Wednesday"]) {
        return ScheduleRepeatTypeWed;
    }
    else if ([day isEqualToString:@"Thursday"]) {
        return ScheduleRepeatTypeThu;
    }
    else if ([day isEqualToString:@"Friday"]) {
        return ScheduleRepeatTypeFri;
    }
    else if ([day isEqualToString:@"Saturday"]) {
        return ScheduleRepeatTypeSat;
    }
    else if ([day isEqualToString:@"Sunday"]) {
        return ScheduleRepeatTypeSun;
    }
    return ScheduleRepeatTypeMon;
}

//- (BOOL)updateEventTime:(NSObject *)eventTime {
//    if ([eventTime isKindOfClass:[NSDate class]]) {
//        NSDate *date = (NSDate *)eventTime;
//        if ([self.eventTime compare:date] != NSOrderedSame) {
//            _eventTime = date;
//            return YES;
//        }
//    }
//    return NO;
//}

+ (ScheduledEventModel *)create {
    return [[ScheduledEventModel alloc] init];
}

- (id)copyWithZone:(NSZone *)zone {
    ScheduledEventModel *another = [[self.class alloc] init];
    
    another.eventDay = self.eventDay;
    another.eventTime = self.eventTime.copy;
    another.eventId = self.eventId.copy;
    another.attributes = [[NSMutableDictionary alloc] initWithDictionary:self.attributes copyItems:YES];
    another.messageType = self.messageType.copy;
    another.delegate = self.delegate;
    another.originalCommand = self.originalCommand;
    
    return another;
}


#pragma mark - Abstract methods 
- (NSString *)getSideValue {
    return @"";
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    return @[];
}

- (NSString *)title {
    return @"";
}

- (NSString *)details {
    return @"";
}

- (NSString *)timeTitle {
    return @"Start Time";
}

- (NSString *)timeDescription {
    return nil;
}

- (int)indexOfTimeOption {
    return 0;
}

@end


