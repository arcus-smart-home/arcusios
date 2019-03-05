//
//  CareBehaviorModel.h
//  i2app
//
//  Created by Arcus Team on 2/4/16.
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
#import "CareBehaviorTemplateModel.h"
#import "CareTimeWindowModel.h"

@interface CareBehaviorModel : NSObject

@property(nonatomic) NSString *name;
@property(nonatomic) NSArray  *participatingDevices;
@property(nonatomic) NSArray  *availableDevices;
@property(nonatomic) NSString *identifier;
@property(nonatomic) CareBehaviorType type;
@property(nonatomic) NSString *templateId;

@property(nonatomic) NSArray<CareTimeWindowModel *> *timeWindows;
@property(nonatomic) BOOL    enabled;
@property(nonatomic) NSDate *lastActivated;
@property(nonatomic) NSDate *lastFired;

@property(nonatomic) NSMutableDictionary *behaviorProperties;

- (instancetype)initWithTemplate:(CareBehaviorTemplateModel *)template;

@end
