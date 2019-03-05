//
// Created by Arcus Team on 2/26/16.
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


@class OrderedDictionary;


@interface LawnNGardenSubsystemController : NSObject <SubsystemProtocol>

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, strong) SubsystemModel *subsystemModel;

- (NSString *)getCurrentIrrigationModeForModel:(NSString *)deviceAddress;
- (BOOL)isScheduleForCurrentIrrigationModeForModelEnabled:(NSString *)deviceAddress currentMode:(NSString **)mode;
- (NSDictionary *)getCurrentEventForModel:(NSString *)deviceAddress;
- (NSDictionary *)getNextEventForCurrentIrrigationModeForModel:(NSString *)deviceAddress;
- (NSTimeInterval)getCurrentWateringTimeRemaining:(NSString *)deviceAddress;
- (NSTimeInterval)getSkipUntilForModel:(NSString *)deviceAddress;

- (void)skipWithController:(NSString *)address withHours:(int)hours;
- (PMKPromise *)stopWithController:(NSString *)address currentOnly:(BOOL)currentOnly;
- (PMKPromise *)cancelSkipWithController:(NSString *)address;

#pragma mark - Dashboard Card Getters
- (BOOL)isAvailable;
- (int)getCurrentlyWateringZonesCount:(NSString *)deviceAddress;
- (NSString *)getCurrentlyWateringZonesString:(NSString **)deviceAddress;
- (BOOL)getCurrentlyWateringZone:(NSString **)zoneId withStartTime:(NSDate **)startTime withDuration:(int *)durationInMin;
- (NSString *)getNextZone;
- (NSDate *)getNextZoneTime;
- (NSDate *)getNextZoneTime:(NSString*)deviceAddress;

#pragma mark - Zone Names and Ids
+ (OrderedDictionary *)getZones:(NSArray *)zones forDeviceAddress:(NSString *)deviceAddress;
+ (OrderedDictionary *)getAllZonesForModel:(NSString *)deviceAddress;
- (OrderedDictionary *)getAllZones;
+ (OrderedDictionary *)getZonesForDeviceAddresses:(NSArray *)deviceAddresses;

#pragma mark - Watering now Triggers
- (NSString *)getCurrentWateringTrigger;
- (BOOL)isManualWateringTrigger;
- (BOOL)isScheduledWateringTrigger;

@end
