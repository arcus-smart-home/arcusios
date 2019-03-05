// 
// IrrigationZoneModel.h
//
// Created by Arcus Team on 3/11/16.
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


@interface IrrigationZoneModel : NSObject

- (instancetype)initWithZoneKey:(NSString *)key
                withDeviceModel:(DeviceModel *)device;
- (instancetype)initWithKey:(NSString *)key andDeviceModel:(DeviceModel *)device;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (strong, nonatomic) NSString *controller;
@property (strong, nonatomic) NSString *zoneValue;
@property (strong, nonatomic) NSString *name;
@property (readonly, atomic) int zoneNumber;
@property (nonatomic, readonly) NSString *defaultZoneName;
@property (nonatomic, readonly) NSString *safeName;
// duration is in MIN
@property (assign, atomic) int defaultDuration;

@property (atomic, assign) BOOL selected;

@end
