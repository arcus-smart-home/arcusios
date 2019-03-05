//
//  CareTimeWindowModel.m
//  i2app
//
//  Created by Arcus Team on 3/1/16.
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
#import "CareTimeWindowModel.h"
#import "NSDate+Convert.h"

@implementation CareTimeWindowModel

- (instancetype)copy {
    CareTimeWindowModel *timeWindowCopy = [CareTimeWindowModel new];
    timeWindowCopy.startDayTime = [self.startDayTime copy];
    timeWindowCopy.endDayTime = [self.endDayTime copy];
    return timeWindowCopy;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self copy];
}

#pragma mark - Setters
- (void)setStartDayTime:(NSDate *)startDayTime {
    _startDayTime = startDayTime;
    [self adjustEndDateToBeAfterStart];
}

- (void)setEndDayTime:(NSDate *)endDayTime {
    _endDayTime = endDayTime;
    [self adjustEndDateToBeAfterStart];
}

#pragma mark - Maintain proper state
- (void)adjustEndDateToBeAfterStart {
    if (self.startDayTime && self.endDayTime) {//Ensure end date is directly after start in terms of weeks, so duration is correct
        while ([self.endDayTime compare:self.startDayTime] == NSOrderedAscending) {
            self.endDayTime = [self.endDayTime dateByAddingTimeInterval:7 * NUMBER_SECONDS_IN_DAY];
        }
    }
}

@end
