//
//  CareTimeMath.h
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

#import <Foundation/Foundation.h>
#import "CareBehaviorEnums.h"

#define SECONDS_IN_MINUTE 60
#define SECONDS_IN_DAY 86400

@interface CareTimeMath : NSObject

+ (NSInteger)convertToSeconds:(NSNumber *)originalNumber ofUnit:(CareBehaviorFieldUnit)unit;
+ (NSInteger)convertFromSeconds:(NSNumber *)seconds toUnit:(CareBehaviorFieldUnit)unit;

@end
