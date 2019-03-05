//
//  CareBehaviorEnums.h
//  i2app
//
//  Created by Arcus Team on 2/9/16.
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

//Care behaviors
typedef NS_ENUM(NSInteger, CareBehaviorType) {
    CareBehaviorTypeInactivity,
    CareBehaviorTypeOpen,
    CareBehaviorTypePresence,
    CareBehaviorTypeOpenCount,
    CareBehaviorTypeTemperature
};

typedef NS_ENUM(NSInteger, CareBehaviorTimeWindowSupport) {
    CareBehaviorTimeWindowSupportNone,
    CareBehaviorTimeWindowSupportOptional,
    CareBehaviorTimeWindowSupporrtRequired
};

//Care behavior fields
typedef NS_ENUM(NSInteger, CareBehaviorFieldUnit) {
    CareBehaviorFieldUnitMinutes,
    CareBehaviorFieldUnitDays,
    CareBehaviorFieldUnitFahrenheit,
    CareBehaviorFieldUnitNoDuration,
    CareBehaviorFieldUnitNone
};

typedef NS_ENUM(NSInteger, CareBehaviorFieldType) {
    CareBehaviorFieldTypeDevices,
    CareBehaviorFieldTypeSchedule,
    CareBehaviorFieldTypeLowTemperature,
    CareBehaviorFieldTypeHighTemperature,
    CareBehaviorFieldTypeDuration,
    CareBehaviorFieldTypeOther
};

@interface CareBehaviorEnums : NSObject

extern NSString *const kCareBehaviorAttributeTimeWindows;
extern NSString *const kCareBehaviorPropertyPresenceTimeOfDay;
extern NSString *const kCareBehaviorPropertyOpenCount;
extern NSString *const kCareBehaviorPropertyDurationSecs;
extern NSString *const kCareBehaviorPropertyLowTemp;
extern NSString *const kCareBehaviorPropertyHighTemp;
extern NSString *const kCareBehaviorTimeWindowDay;
extern NSString *const kCareBehaviorTimeWindowStartTime;

#pragma mark - CareBehaviorType enum helpers
+ (NSString *)stringForBehaviorType:(CareBehaviorType)type;
+ (CareBehaviorType)behaviorTypeForString:(NSString *)string;

#pragma mark - CareBehaviorField enum helpers
+ (NSString *)postFixForUnit:(CareBehaviorFieldUnit)unit isPlural:(BOOL)isPlural;

@end
