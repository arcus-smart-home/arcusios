//
//  CareTimeMath.m
//  i2app
//
//  Created by Arcus Team on 2/24/16.
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
#import "CareTimeMath.h"

@implementation CareTimeMath

+ (NSInteger)convertToSeconds:(NSNumber *)originalNumber ofUnit:(CareBehaviorFieldUnit)unit {
    NSInteger seconds;
    
    switch (unit) {
        case CareBehaviorFieldUnitMinutes:
            seconds = [originalNumber integerValue] * SECONDS_IN_MINUTE;
            break;
            
        case CareBehaviorFieldUnitDays:
            seconds = [originalNumber integerValue] * SECONDS_IN_DAY;
            break;
        default:
            seconds = 0;
            break;
    }
    
    return seconds;
}

+ (NSInteger)convertFromSeconds:(NSNumber *)seconds toUnit:(CareBehaviorFieldUnit)unit {
    NSInteger durationValue;
    
    switch (unit) {
        case CareBehaviorFieldUnitDays:
            durationValue = [seconds floatValue] / SECONDS_IN_DAY;
            break;
            
        default:
            durationValue = [seconds floatValue] / SECONDS_IN_MINUTE;
            break;
    }
    
    return durationValue;
}

@end
