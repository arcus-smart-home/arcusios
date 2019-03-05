//
//  ScheduledEventModel.h
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

#import <Foundation/Foundation.h>
#import "ArcusDateTime.h"

typedef NS_OPTIONS(NSUInteger, ScheduleRepeatType) {
    ScheduleRepeatTypeMon = 1 << 1,
    ScheduleRepeatTypeTue = 1 << 2,
    ScheduleRepeatTypeWed = 1 << 3,
    ScheduleRepeatTypeThu = 1 << 4,
    ScheduleRepeatTypeFri = 1 << 5,
    ScheduleRepeatTypeSat = 1 << 6,
    ScheduleRepeatTypeSun = 1 << 7,
};


@class SchedulerSettingOption;
@class PopupSelectionBaseContainer;

@protocol ScheduledEventModelDelegate <NSObject>

- (void)reloadData;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner;
- (void)present:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner;

@end


@interface ScheduledEventModel : NSObject<NSCopying>

+ (ScheduledEventModel *)create;

+ (NSArray *)generateArrayOfRepeatDays:(ScheduleRepeatType)eventType;
+ (NSString *)generateStringOfRepeatDays:(ScheduleRepeatType)eventType;
+ (NSString *)stringWithRepeatDayType:(ScheduleRepeatType)dayType;
+ (NSString *)getWeekDayForDayType:(ScheduleRepeatType)dayType;
+ (ScheduleRepeatType)getDayTypeForFullWeekDayName:(NSString *)day;

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate;
- (void)preload;

@property (atomic, assign) ScheduleRepeatType eventDay;
@property (atomic, strong) ArcusDateTime *eventTime;
@property (nonatomic, strong) NSString *eventTimeFormatted;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, weak) UIViewController<ScheduledEventModelDelegate> *delegate;
@property (strong, nonatomic) NSDictionary *originalCommand;
@property (atomic, assign) BOOL isNewModel;

- (BOOL)hasRelatedEvents;
- (NSArray *)getRelatedEvents;

- (ScheduleRepeatType)repeatDays;
- (NSString*)getRepeatDescription;

#pragma mark - Abstract methods
- (NSString *)getSideValue;
- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions;

- (NSString *)title;
- (NSString *)details;
- (NSString *)timeTitle;
- (NSString *)timeDescription;
- (int)indexOfTimeOption;

@end

