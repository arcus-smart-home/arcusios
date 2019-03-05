//
//  WaterSubsystemController.m
//  i2app
//
//  Created by Arcus Team on 1/18/16.
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
#import "WaterSubsystemController.h"
#import "WaterSubsystemCapability.h"


@implementation WaterSubsystemController 

@synthesize subsystemModel;
@synthesize numberOfDevices;
@dynamic allDeviceIds;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self  = [super init]) {
        subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    
    return self;
}

- (DeviceModel *)primaryWaterHeater {
    NSString *address = [WaterSubsystemCapability getPrimaryWaterHeaterFromModel:self.subsystemModel];
    if (address.length > 0) {
        return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    }
    return nil;
}

- (DeviceModel *)primaryWaterSoftener {
    NSString *address = [WaterSubsystemCapability getPrimaryWaterSoftenerFromModel:self.subsystemModel];
    if (address.length > 0) {
        return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    }
    return nil;
}

- (NSArray<NSString *> *)allWaterDeviceAddresses {
    return [WaterSubsystemCapability getWaterDevicesFromModel:self.subsystemModel];
}

- (NSArray<DeviceModel *> *)allWaterDevices {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSString *address in [self allWaterDeviceAddresses]) {
        DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
        if (device != nil) {
            [results addObject:device];
        }
    }
    return [NSArray arrayWithArray:results];
}

- (NSArray<NSString *> *)allClosedWaterValveAddresses {
    return (NSArray<NSString *> *)[WaterSubsystemCapability getClosedWaterValvesFromModel:self.subsystemModel];
}

- (NSArray<DeviceModel *> *) allClosedWaterValves {
  NSMutableArray *results = [[NSMutableArray alloc] init];
  for (NSString *address in [self allClosedWaterValveAddresses]) {
      DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
      if (device != nil) {
          [results addObject:device];
      }
    }
    return [NSArray arrayWithArray:results];
}

- (BOOL)hasDeviceWithAddress:(NSString *)address {
    for (NSString *dnlId in [self allWaterDeviceAddresses]) {
        if([dnlId isEqualToString:address]) {
            return YES;
        }
    }
    
    return NO;
}

@end
