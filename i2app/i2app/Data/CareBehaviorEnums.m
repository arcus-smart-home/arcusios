//
//  CareBehaviorEnums.m
//  i2app
//
//  Created by Arcus Team on 2/17/16.
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
#import <Foundation/Foundation.h>
#import "CareBehaviorEnums.h"

@implementation CareBehaviorEnums

NSString *const kCareBehaviorAttributeTimeWindows = @"timeWindows";
NSString *const kCareBehaviorPropertyPresenceTimeOfDay = @"presenceRequiredTime";
NSString *const kCareBehaviorPropertyOpenCount = @"openCount";
NSString *const kCareBehaviorPropertyDurationSecs = @"durationSecs";
NSString *const kCareBehaviorPropertyLowTemp = @"lowTemp";
NSString *const kCareBehaviorPropertyHighTemp = @"highTemp";
NSString *const kCareBehaviorTimeWindowDay = @"day";
NSString *const kCareBehaviorTimeWindowStartTime = @"startTime";

NSString *const kCareBehaviorTypeInactivityString = @"INACTIVITY";
NSString *const kCareBehaviorTypeOpenString = @"OPEN";
NSString *const kCareBehaviorTypePresenceString = @"PRESENCE";
NSString *const kCareBehaviorTypeTemperatureString = @"TEMPERATURE";
NSString *const kCareBehaviorTypeOpenCountString = @"OPEN_COUNT";

#pragma mark - Behaviors
+ (NSString *)stringForBehaviorType:(CareBehaviorType)type {
    switch (type) {
        case CareBehaviorTypeInactivity:
            return kCareBehaviorTypeInactivityString;
        
        case CareBehaviorTypeOpen:
            return kCareBehaviorTypeOpenString;
            
        case CareBehaviorTypePresence:
            return kCareBehaviorTypePresenceString;
            
        case CareBehaviorTypeTemperature:
            return kCareBehaviorTypeTemperatureString;
            
        case CareBehaviorTypeOpenCount:
            return kCareBehaviorTypeOpenCountString;
    }
}

+ (CareBehaviorType)behaviorTypeForString:(NSString *)string {
    if ([string isEqualToString:kCareBehaviorTypeInactivityString]) {
        return CareBehaviorTypeInactivity;
    } else if ([string isEqualToString:kCareBehaviorTypeOpenString]) {
        return CareBehaviorTypeOpen;
    } else if ([string isEqualToString:kCareBehaviorTypePresenceString]) {
        return CareBehaviorTypePresence;
    } else if ([string isEqualToString:kCareBehaviorTypeTemperatureString]) {
        return CareBehaviorTypeTemperature;
    } else {
        return CareBehaviorTypeOpenCount;
    }
}

#pragma mark - Behavior fields
+ (NSString *)postFixForUnit:(CareBehaviorFieldUnit)unit isPlural:(BOOL)isPlural {
    switch (unit) {
        case CareBehaviorFieldUnitDays: {
            return isPlural ? @" Days" : @" Day";
            break;
        } case CareBehaviorFieldUnitFahrenheit: {
            return @"°";
            break;
        } case CareBehaviorFieldUnitMinutes: {
            return  @" Min";
        } default: {
            return @"";
            break;
        }
    }
}

@end
