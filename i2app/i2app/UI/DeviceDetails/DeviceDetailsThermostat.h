//
//  DeviceDetailsThermostat.h
//  i2app
//
//  Created by Arcus Team on 9/17/15.
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
#import "DeviceDetailsBase.h"
#import "DeviceDetailsThermostatDelegate.h"

@class ServiceControlCell;

@interface DeviceDetailsThermostat : DeviceDetailsBase <DeviceDetailsThermostatDelegate>

@property (atomic) NSInteger heatTemp;
@property (atomic) NSInteger coolTemp;
@property (nonatomic, weak) id<DeviceDetailsThermostatDelegate>   delegate;
@property (nonatomic) NSTimeInterval controlUpdateStartTime;

// Thermostat Operations
- (void)commitThermostatMode:(NSString *)mode;
- (void)commitSetPoints:(int)coolTemp heatPoint:(int)heatTemp;
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial;

#pragma mark Device Function
- (void)turnThermostatAutoMode;

#pragma mark Device Event Timer
- (void)startDebounceTimer:(NSTimeInterval)duration event:(void (^)(void))block;
- (void)stopDebounceTimer;

#pragma mark Configuration
- (NSString *)autoModeText;

@end
