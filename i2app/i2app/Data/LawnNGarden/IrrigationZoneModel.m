// 
// IrrigationZoneModel.m
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

#import <i2app-Swift.h>
#import "IrrigationZoneModel.h"

#import "ScheduleController.h"
#import "IrrigationZoneCapability.h"
#import "LawnNGardenZoneController.h"
#import "LawnNGardenSubsystemController.h"

@implementation IrrigationZoneModel

@dynamic zoneNumber;
@dynamic defaultZoneName;
@dynamic safeName;

- (instancetype)initWithZoneKey:(NSString *)key
                withDeviceModel:(DeviceModel *)device {
    if (self = [super init]) {
        _zoneValue = key;
        _controller = device.address;
        _name = [LawnNGardenZoneController getNameForZone:_zoneValue device:device];
        _defaultDuration = [LawnNGardenZoneController getDefaultDurationForZone:key device:device];
        if (_defaultDuration == 0) {
            _defaultDuration = 1;
        }
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key andDeviceModel:(DeviceModel *)device {
    if (self = [super init]) {
        _zoneValue = key;
        _name = [LawnNGardenZoneController getNameForZone:_zoneValue device:device];
        _selected = NO;
        _controller = device.address;
        _defaultDuration = [LawnNGardenZoneController getDefaultDurationForZone:key device:device];
        if (_defaultDuration == 0) {
            _defaultDuration = 1;
        }
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if (dict) {
            NSString *controllerAddress = dict[@"controller"];
            if (controllerAddress.length == 0) {
                controllerAddress = ScheduleController.scheduleController.schedulingModelAddress;
            }
            DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:controllerAddress];
            _zoneValue = dict[@"zone"];
            _name = [LawnNGardenZoneController getSafeNameForZone:_zoneValue device:device];
            _selected = YES;
            _defaultDuration = [dict[@"duration"] intValue];
            if (_defaultDuration == 0) {
                _defaultDuration = 1;
            }
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@ selected:%@", self.zoneValue, self.name, self.selected ? @"YES" : @"NO"];
}

-  (int)zoneNumber {
    return [self.zoneValue substringFromIndex:1].intValue;
}

- (NSString *)defaultZoneName {
    return [NSString stringWithFormat:@"Zone %d", self.zoneNumber];
}

- (NSString *)safeName {
    if (self.name.length > 0) {
        return self.name;
    }
    return self.defaultZoneName;
}

@end
