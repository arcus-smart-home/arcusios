//
//  CareBehaviorValidation.m
//  i2app
//
//  Created by Arcus Team on 2/29/16.
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
#import "CareBehaviorValidation.h"

#define MIN_TEMP_DIFFERENCE 3

@implementation CareBehaviorValidation

NSString *const kCareBehaviorDoorOpenedUnexpectedlyTemplateIdentifier = @"2";

+ (BOOL)behavior:(CareBehaviorModel *)behavior isValidForTemplate:(CareBehaviorTemplateModel *)template {
    BOOL isValid = YES;
    
    if (template.type != CareBehaviorTypeOpenCount && behavior.participatingDevices.count == 0) {
        isValid = NO;
    }
    
    //Template specific
    switch (template.type) {
        case CareBehaviorTypeOpenCount: {
            NSMutableDictionary<NSString *, NSNumber *> *openCountDict = behavior.behaviorProperties[kCareBehaviorPropertyOpenCount];
            if (!openCountDict || [openCountDict isEqual:[NSNull null]] || openCountDict.count == 0) {
                isValid = NO;
            }
            break;
        }
        case CareBehaviorTypePresence: {
            NSDate *presenceDate = behavior.behaviorProperties[kCareBehaviorPropertyPresenceTimeOfDay];
            if (!presenceDate || [presenceDate isEqual:[NSNull null]]) {
                isValid = NO;
            }
            break;
        }
        case CareBehaviorTypeOpen: {
            //Only check for an open behavior duration if it is not "door opened unexpectedly"
            //This is an open behavior according to the platform, but does not require a duration like the others
            if (![template.templateIdentifier isEqualToString:kCareBehaviorDoorOpenedUnexpectedlyTemplateIdentifier]) {
                NSNumber *duration = behavior.behaviorProperties[kCareBehaviorPropertyDurationSecs];
                if (!duration || [duration isEqual:[NSNull null]] || [duration isEqualToNumber:@(0)]) {
                    isValid = NO;
                }
            }
            
            break;
        }
        case CareBehaviorTypeInactivity: {
            NSNumber *duration = behavior.behaviorProperties[kCareBehaviorPropertyDurationSecs];
            if (!duration || [duration isEqual:[NSNull null]]) {
                isValid = NO;
            }
            break;
        }
        case CareBehaviorTypeTemperature: {
            NSNumber *lowTemp = behavior.behaviorProperties[@"lowTemp"];
            NSNumber *highTemp = behavior.behaviorProperties[@"highTemp"];
            
            if (!lowTemp || !highTemp || [lowTemp isEqual:[NSNull null]] || [highTemp isEqual:[NSNull null]]) {
                isValid = NO;
            } else {
                if ([highTemp integerValue] - [lowTemp integerValue] < MIN_TEMP_DIFFERENCE) {
                    isValid = NO;
                }
            }
            break;
        }
    }
    
    return isValid;
}

@end
