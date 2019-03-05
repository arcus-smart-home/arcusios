//
//  CareSubsystemController.h
//  i2app
//
//  Created by Arcus Team on 2/2/16.
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
#import "SubsystemsController.h"
#import "CareSubsystemControllerEnums.h"
#import "PersonCallTreeListViewController.h"


@class CareBehaviorModel;

@interface CareSubsystemController : NSObject <AlarmSubsystemProtocol, PersonCallTreeDataProtocol>

extern NSString *const kErrorCareNameInUse;
extern NSString *const kErrorCareDuplicateWindows;

@property (nonatomic, assign, readonly) NSString *stateString;
@property (nonatomic, assign, readonly) NSDate *lastAlertTime;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSArray *)activeDeviceIds;
- (PMKPromise *)careActivityListWithStart:(NSDate *)startDate
                                  withEnd:(NSDate *)endDate
                           withResolution:(NSTimeInterval)resolution
                              withDevices:(NSArray *)devices;
- (PMKPromise *)careActivityDetailsWithLimit:(NSInteger)limit
                                   withToken:(NSString *)token
                                 withDevices:(NSArray *)devices;
- (void)setCareDevices:(NSArray *)careDevices;
- (PMKPromise *)careAlarmHistoryWithLimit:(NSInteger)limit
                                withToken:(NSString *)token;
- (NSDictionary *)getLastAlertTrigger;
- (NSString *)getLastAlertCause;
- (PMKPromise *)clear;
- (PMKPromise *)panic;
- (BOOL)setSilent:(BOOL)silent;
- (BOOL)getSilentStatus;
- (NSArray *)triggerDeviceIds;
- (CareAlarmMode)getCareAlarmMode;
- (void)setCareAlarmMode:(CareAlarmMode)mode;

- (NSArray *) allBehaviorIDs;
- (NSArray *) allActiveBehaviorIDs;
- (NSInteger)numberOfBehaviors;
- (NSInteger)numberOfActiveBehaviors;


- (PMKPromise *)listBehaviorTemplates;
- (PMKPromise *)getTemplateForBehaviorWithID:(NSString *)behaviorTemplateID;
- (NSArray *)getCallTree;
- (NSString *)lastTriggeredString;
- (PMKPromise *)listBehaviors;
- (PMKPromise *)addBehavior:(CareBehaviorModel *)behavior;
- (PMKPromise *)updateBehavior:(CareBehaviorModel *)behavior;
- (PMKPromise *)removeBehavior:(CareBehaviorModel *)behavior;


@end
