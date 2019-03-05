//
// Created by Arcus Team on 3/1/16.
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

#import "DeviceDetailsBase.h"

@class DeviceButtonBaseControl;
@class OrderedDictionary;


@protocol DeviceDetailsLawnNGardenDeviceProtocol <NSObject>

@required
- (void)enabledForEvent:(BOOL)enabled;

- (void)showCurrentlyWatering:(NSString*)mode;
- (void)showNotWatering:(NSString *)mode;
- (void)showTimeRemaining:(NSString *)remaining;
- (void)showRainDelay:(NSString *)until withMode:(NSString*)mode;
- (void)showCurrentSchedule:(BOOL)shown zone:(NSString *)zone;
- (void)showNextSchedule:(BOOL)shown zone:(NSString *)zone;

@optional
- (void)refreshData;
@end

@interface DeviceDetailsLawnNGardenDeviceController : DeviceDetailsBase

- (void)loadData:(id<DeviceDetailsLawnNGardenDeviceProtocol>)callback;

- (void)skip:(int)hours;

- (void)setWaterPercentage:(int)percentage;

- (int)numberOfZones;

- (OrderedDictionary*)zonePopupModels;

- (int)maxIrrigationTime;

- (void)waterNowWithZone:(NSString *)zone duration:(int)duration;

- (void)stopWatering:(BOOL)currentOnly;

- (void)cancelSkip;

+ (BOOL)isInTransitionState:(NSString *)deviceAddress;

@end
