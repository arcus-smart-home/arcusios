//
//  CareBehaviorSerialization.m
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
#import "CareBehaviorSerialization.h"
#import "CareBehaviorEnums.h"
#import "TemperatureMath.h"

#define PRESENCE_BEHAVIOR_DATE_FORMAT_STRING @"HH:mm:ss"
#define TIME_WINDOW_SEND_DATE_FORMAT_STRING @"cccc HH:mm:ss"

@implementation CareBehaviorSerialization

#pragma mark - Dictionary-ification
+ (NSMutableDictionary *)getJSONDictForCreationOfBehavior:(CareBehaviorModel *)behavior {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"devices"] = behavior.participatingDevices;
    dict[@"timeWindows"] = [self getTimeWindowsArrayFromBehavior:behavior];
    dict[@"enabled"] = @(behavior.enabled);
    dict[@"name"] = behavior.name;
    dict[@"type"] = [CareBehaviorEnums stringForBehaviorType:behavior.type];
    dict[@"templateId"] = behavior.templateId;
    for (id key in behavior.behaviorProperties) {
        NSString *propertyKey = (NSString *)key;
        if ([propertyKey isEqualToString:kCareBehaviorPropertyPresenceTimeOfDay]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = PRESENCE_BEHAVIOR_DATE_FORMAT_STRING;
            dict[key] = [formatter stringFromDate:behavior.behaviorProperties[key]];
        } else if ([propertyKey isEqualToString:kCareBehaviorPropertyLowTemp] || [propertyKey isEqualToString:kCareBehaviorPropertyHighTemp]) {
            NSNumber *temp = (NSNumber *)behavior.behaviorProperties[key];
            if (temp && ![[NSNull null] isEqual:temp]) {
                dict[key] = [NSNumber numberWithDouble:[TemperatureMath celsiusFromFahrenheitValue:temp.doubleValue]];
            }
        } else {
            dict[key] = behavior.behaviorProperties[key];
        }
        
    }
    
    return dict;
}

+ (NSMutableDictionary *)getJSONDictForEditingOfBehavior:(CareBehaviorModel *)behavior {
    NSMutableDictionary *dict = [self getJSONDictForCreationOfBehavior:behavior];
    dict[@"id"] = behavior.identifier;
    return dict;
}

+ (NSArray *)getTimeWindowsArrayFromBehavior:(CareBehaviorModel *)behavior {
    NSMutableArray<NSMutableDictionary *> *timeWindowsForJSON = [NSMutableArray array];
    static NSDateFormatter *timeWindowDateFormatter;
    if (!timeWindowDateFormatter) {
        timeWindowDateFormatter = [NSDateFormatter new];
        timeWindowDateFormatter.dateFormat = TIME_WINDOW_SEND_DATE_FORMAT_STRING;
    }
    
    for (CareTimeWindowModel *timeWindow in behavior.timeWindows) {
        NSMutableDictionary *timeWindowDict = [NSMutableDictionary dictionary];
        
        if (timeWindow.startDayTime && timeWindow.endDayTime) {
            NSArray *dayAndStartTimeArray = [[timeWindowDateFormatter stringFromDate:timeWindow.startDayTime] componentsSeparatedByString:@" "];
            NSString *day = dayAndStartTimeArray[0];
            NSString *timeString = dayAndStartTimeArray[1];
            NSInteger duration = [timeWindow.endDayTime timeIntervalSinceDate:timeWindow.startDayTime];
            
            timeWindowDict[kCareBehaviorTimeWindowDay] = day;
            timeWindowDict[kCareBehaviorTimeWindowStartTime] = timeString;
            timeWindowDict[kCareBehaviorPropertyDurationSecs] = @(duration);
        }
        
        if (timeWindowDict.count > 0) {
            [timeWindowsForJSON addObject:timeWindowDict];
        }
    }
    
    return timeWindowsForJSON;
}


#pragma mark - De-dictionary-ification
+ (CareBehaviorModel *)createModelFrom:(NSDictionary *)dictionary {
    CareBehaviorModel *behavior = [[CareBehaviorModel alloc] init];
    
    behavior.identifier = [self getIdentifierFrom:dictionary];
    behavior.name = [self getNameFrom:dictionary];
    behavior.templateId = [self getTemplateIdFrom:dictionary];
    behavior.enabled = [self getEnabledFrom:dictionary];
    behavior.lastActivated = [self getLastActivatedFrom:dictionary];
    behavior.lastFired = [self getLastFiredFrom:dictionary];
    behavior.participatingDevices = [self getParticipatingDevicesFrom:dictionary];
    behavior.availableDevices = [self getAvailableDevicesFrom:dictionary];
    behavior.type = [self getTypeFrom:dictionary];
    behavior.timeWindows = [self getTimeWindowsFrom:dictionary];
    [self populatePropertiesFor:behavior from:dictionary];
    
    return behavior;
}

#pragma mark - De-dictionary-ification helpers
+ (NSString *)getIdentifierFrom:(NSDictionary *)dictionary {
    NSString *identifier = dictionary[@"id"];
    
    if (!identifier || [identifier isEqual:[NSNull null]]) {
        identifier = nil;
    }
    
    return identifier;
}

+ (NSString *)getNameFrom:(NSDictionary *)dictionary {
    NSString *name = dictionary[@"name"];
    
    if (!name || [name isEqual:[NSNull null]]) {
        name = nil;
    }
    
    return name;
}

+ (NSString *)getTemplateIdFrom:(NSDictionary *)dictionary {
    NSString *templateId = dictionary[@"templateId"];
    
    if (!templateId || [templateId isEqual:[NSNull null]]) {
        templateId = nil;
    }
    
    return templateId;
}

+ (BOOL)getEnabledFrom:(NSDictionary *)dictionary {
    NSNumber *enabledInt = (NSNumber *) dictionary[@"enabled"];
    BOOL enabled = false;
    if (enabledInt && ![enabledInt isEqual:[NSNull null]]) {
        enabled = [enabledInt boolValue];
    }
    return enabled;
}

+ (NSDate *)getLastActivatedFrom:(NSDictionary *)dictionary {
    NSNumber *lastActivatedNumber = dictionary[@"lastActivated"];
    NSDate *lastActivatedDate;
    if (lastActivatedNumber && ![lastActivatedNumber isEqual:[NSNull null]]) {
        lastActivatedDate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastActivatedNumber doubleValue]/1000.0f];
    }
    return lastActivatedDate;
}

+ (NSDate *)getLastFiredFrom:(NSDictionary *)dictionary {
    NSNumber *lastFiredNumber = dictionary[@"lastFired"];
    NSDate *lastFiredDate;
    if (lastFiredNumber && ![lastFiredNumber isEqual:[NSNull null]]) {
        lastFiredDate = [[NSDate alloc] initWithTimeIntervalSince1970:[lastFiredNumber doubleValue]/1000.0f];
    }
    return lastFiredDate;
}

+ (NSArray *)getParticipatingDevicesFrom:(NSDictionary *)dictionary {
    NSArray *participatingDevices = dictionary[@"devices"];
    if (!participatingDevices || [participatingDevices isEqual:[NSNull null]]) {
        participatingDevices = nil;
    }
    return participatingDevices;
}

+ (NSArray *)getAvailableDevicesFrom:(NSDictionary *)dictionary {
    NSArray *availableDevices = dictionary[@"availableDevices"];
    if (!availableDevices || [availableDevices isEqual:[NSNull null]]) {
        availableDevices = nil;
    }
    return availableDevices;
}

+ (CareBehaviorType)getTypeFrom:(NSDictionary *)dictionary {
    NSString *typeString = dictionary[@"type"];
    CareBehaviorType type;
    if (typeString && ![typeString isEqual:[NSNull null]]) {
        type = [CareBehaviorEnums behaviorTypeForString:typeString];
    } else {
        type = CareBehaviorTypePresence;
    }
    return type;
}

+ (NSArray<CareTimeWindowModel *> *)getTimeWindowsFrom:(NSDictionary *)dictionary {
    NSMutableArray<CareTimeWindowModel *> *timeWindows = [NSMutableArray array];
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = TIME_WINDOW_SEND_DATE_FORMAT_STRING;
    }
    
    NSArray<NSDictionary *> *timeWindowArray = dictionary[kCareBehaviorAttributeTimeWindows];
    if (timeWindowArray && ![timeWindowArray isEqual:[NSNull null]]) {
        for (NSDictionary *timeWindowDict in timeWindowArray) {
            NSString *day = timeWindowDict[kCareBehaviorTimeWindowDay];
            NSString *startTimeString = timeWindowDict[kCareBehaviorTimeWindowStartTime];
            NSNumber *duration = timeWindowDict[kCareBehaviorPropertyDurationSecs];
            
            if (duration
                && day
                && startTimeString
                && ![day isEqual:[NSNull null]]
                && ![duration isEqual:[NSNull null]]
                && ![startTimeString isEqual:[NSNull null]]) {
                
                NSDate *startDayTime = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", day, startTimeString]];
                NSDate *endDayTime = [startDayTime dateByAddingTimeInterval:[duration integerValue]];
                
                CareTimeWindowModel *timeWindow = [CareTimeWindowModel new];
                timeWindow.startDayTime = startDayTime;
                timeWindow.endDayTime = endDayTime;
                
                [timeWindows addObject:timeWindow];
            }
        }
    }
    
    return timeWindows;
}

+ (void)populatePropertiesFor:(CareBehaviorModel *)behavior from:(NSDictionary *)dictionary {
    behavior.behaviorProperties = [NSMutableDictionary dictionary];
    switch (behavior.type) {
        case CareBehaviorTypeInactivity: {
            NSNumber *durationSecs = dictionary[kCareBehaviorPropertyDurationSecs];
            if (durationSecs && ![durationSecs isEqual:[NSNull null]]) {
                behavior.behaviorProperties[kCareBehaviorPropertyDurationSecs] = durationSecs;
            }
            break;
        }
        case CareBehaviorTypeOpen: {
            NSNumber *durationSecs = dictionary[kCareBehaviorPropertyDurationSecs];
            if (durationSecs && ![durationSecs isEqual:[NSNull null]]) {
                behavior.behaviorProperties[kCareBehaviorPropertyDurationSecs] = durationSecs;
            }
            break;
        }
        case CareBehaviorTypeTemperature: {
            NSNumber *lowTemp = dictionary[@"lowTemp"];
            NSNumber *highTemp = dictionary[@"highTemp"];
            if (lowTemp && ![lowTemp isEqual:[NSNull null]]) {
                behavior.behaviorProperties[@"lowTemp"] = [NSNumber numberWithInteger:[TemperatureMath roundedFarenheitFromCelsisuValue:lowTemp.doubleValue]];
            }
            if (highTemp && ![highTemp isEqual:[NSNull null]]) {
                behavior.behaviorProperties[@"highTemp"] = [NSNumber numberWithInteger:[TemperatureMath roundedFarenheitFromCelsisuValue:highTemp.doubleValue]];
            }
            break;
        }
        case CareBehaviorTypeOpenCount: {
            NSDictionary *openCountDict = dictionary[@"openCount"];
            if (openCountDict && ![openCountDict isEqual:[NSNull null]] && [openCountDict isKindOfClass:[NSDictionary class]]) {
                behavior.behaviorProperties[@"openCount"] = [openCountDict mutableCopy];
            }
            break;
        }
        case CareBehaviorTypePresence : {
            NSString *curfewTime = dictionary[kCareBehaviorPropertyPresenceTimeOfDay];
            if (curfewTime && ![curfewTime isEqual:[NSNull null]]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = PRESENCE_BEHAVIOR_DATE_FORMAT_STRING;
                behavior.behaviorProperties[kCareBehaviorPropertyPresenceTimeOfDay] = [formatter dateFromString:curfewTime];
            }
        }
        default:
            break;
    }
}

@end
