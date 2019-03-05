//
//  CareBehaviorField.m
//  i2app
//
//  Created by Arcus Team on 2/8/16.
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
#import "CareBehaviorField.h"

#define MINUTES @"MINUTES"
#define DAYS @"DAYS"
#define NO_DURATION @"NODURATION"
#define FAHRENHEIT @"fahrenheit"

#define DEVICES @"devices"
#define TIME_WINDOWS @"timeWindows"
#define LOW_TEMP @"lowTemp"
#define HIGH_TEMP @"highTemp"
#define DURATION @"duration"

@implementation CareBehaviorField

#pragma mark - Class method helpers
+ (CareBehaviorFieldUnit)unitFromString:(NSString *)unitString {
    if (!unitString || [unitString isEqual:[NSNull null]]) {
        return CareBehaviorFieldUnitNone;
    } else if ([unitString isEqualToString:MINUTES]) {
        return CareBehaviorFieldUnitMinutes;
    } else if ([unitString isEqualToString:DAYS]) {
        return CareBehaviorFieldUnitDays;
    } else if ([unitString isEqualToString:NO_DURATION]) {
        return CareBehaviorFieldUnitNoDuration;
    } else if ([unitString isEqualToString:FAHRENHEIT]) {
        return CareBehaviorFieldUnitFahrenheit;
    } else {
        return CareBehaviorFieldUnitNone;
    }
}

+ (NSArray<NSNumber *> *)possibleValuesFromString:(NSString *)possibleValuesString {
    NSMutableArray *possibleValues = [NSMutableArray array];
    if (possibleValuesString && ![possibleValuesString isEqual:[NSNull null]]) {
        NSArray<NSString *> *splitString = [possibleValuesString componentsSeparatedByString:@"-"];
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        
        if (splitString.count == 2) {//String is of format "40-70"
            NSNumber *lowValue = [numberFormatter numberFromString:splitString[0]];
            NSNumber *highValue = [numberFormatter numberFromString:splitString[1]];
            [possibleValues addObject:lowValue];
            [possibleValues addObject:highValue];
        } else {
            splitString = [possibleValuesString componentsSeparatedByString:@","];
            if (splitString.count > 1) {//String is of format "30,60,90"
                for (NSString *valueString in splitString) {
                    NSNumber *possibleValue = [numberFormatter numberFromString:valueString];
                    if (possibleValue) {
                        [possibleValues addObject:possibleValue];
                    }
                }
            }
        }
        return possibleValues;
    }
    return nil;
}

+ (CareBehaviorFieldType)typeFromString:(NSString *)typeString {
    if ([typeString isEqualToString:DEVICES]) {
        return CareBehaviorFieldTypeDevices;
    } else if ([typeString isEqualToString:TIME_WINDOWS]) {
        return CareBehaviorFieldTypeSchedule;
    } else if ([typeString isEqualToString:LOW_TEMP]) {
        return CareBehaviorFieldTypeLowTemperature;
    } else if ([typeString isEqualToString:HIGH_TEMP]) {
        return CareBehaviorFieldTypeHighTemperature;
    } else if ([typeString isEqualToString:DURATION]){
        return CareBehaviorFieldTypeDuration;
    } else {
        return CareBehaviorFieldTypeOther;
    }
}

#pragma mark - Init
- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                        unit:(NSString *)unit
              possibleValues:(NSString *)possibleValues
                        key:(NSString *)key {
    if (self = [super init]) {
        self.name = name;
        self.fieldDescription = description;
        self.unit = [[self class] unitFromString:unit];
        self.possibleValues = [[self class] possibleValuesFromString:possibleValues];
        self.fieldKey = key;
        self.fieldType = [[self class] typeFromString:key];
        
    }
    return self;
}



@end
