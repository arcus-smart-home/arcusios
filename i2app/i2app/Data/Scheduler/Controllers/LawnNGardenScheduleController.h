//
//  LawnNGardenScheduleController.h
//  i2app
//
//  Created by Arcus Team on 3/2/16.
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

#import "ScheduleController.h"

typedef NS_ENUM(int, IrrigationSystemMode) {
    IrrigationSystemModeWeekly = 0,
    IrrigationSystemModeInterval,
    IrrigationSystemModeOddDays,
    IrrigationSystemModeEvenDays,
    IrrigationSystemModeManual
};

#define IrrigationModeStringToType(str) (IrrigationSystemMode)[@[@"WEEKLY", @"INTERVAL", @"ODD", @"EVEN", @"MANUAL"] indexOfObject:str]
#define IrrigationModeTypeToString(enum) (NSString *)[@[@"WEEKLY", @"INTERVAL", @"ODD", @"EVEN", @"MANUAL"] objectAtIndex:enum]

@class CommonCheckableImageCell;
@class IrrigationScheduledEventModel;

@interface LawnNGardenScheduleController : ScheduleController

- (IrrigationSystemMode)getCurrentMode;

- (void)onClickCheckbox:(CommonCheckableImageCell *)cell withMode:(IrrigationSystemMode)mode allCells:(NSArray *)allCells;

- (PMKPromise *)configureWithEventModel:(IrrigationScheduledEventModel *)eventModel;

+ (BOOL)isValidEvent:(NSDictionary *)event;

@end
