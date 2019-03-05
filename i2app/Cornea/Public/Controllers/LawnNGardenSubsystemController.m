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

#import <i2app-Swift.h>
#import "LawnNGardenSubsystemController.h"
#import "SubsystemCapability.h"

#import "LawnNGardenSubsystemCapability.h"
#import "OrderedDictionary.h"
#import "NSDate+Convert.h"

#import "IrrigationControllerCapability.h"
#import "IrrigationZoneCapability.h"
#import "DeviceCapability.h"
#import "IrrigationZoneModel.h"
#import "LawnNGardenZoneController.h"


@interface LawnNGardenSubsystemController()

@end

@implementation LawnNGardenSubsystemController {

}

@dynamic allDeviceIds;
@dynamic numberOfDevices;

#pragma mark - Initialization

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    return self;
}

- (NSString *)description {
    return self.subsystemModel.description;
}

- (NSArray<NSString *> *)allDeviceIds {
    return [LawnNGardenSubsystemCapability getControllersFromModel:self.subsystemModel];
}

- (int)numberOfDevices {
    return (int)self.allDeviceIds.count;
}

#pragma mark - Current Irrigation Mode Parameters
/*controller = "DRIV:dev:7deff9ea-a5fb-4ff1-8a87-dc7f16900146";
enabled = 1;
mode = WEEKLY;
nextEvent =     {
    duration = 10;
    retryCount = 0;
    startTime = 1457092800000;
    status = APPLIED;
    timeOfDay = "6:00:00";
    zone = z1;
};*/

- (NSString *)getCurrentIrrigationModeForModel:(NSString *)deviceAddress {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getScheduleStatusFromModel:self.subsystemModel];
    if (dict.count > 0) {
        dict = dict[deviceAddress];
    }
    if (dict.count > 0) {
        NSNumber *isEnabled = dict[@"enabled"];
        if (isEnabled != nil && [isEnabled boolValue])
         return dict[@"mode"];
    }
    return @"MANUAL";
}

- (BOOL)isScheduleForCurrentIrrigationModeForModelEnabled:(NSString *)deviceAddress currentMode:(NSString **)mode {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getScheduleStatusFromModel:self.subsystemModel];
    if (dict.count > 0) {
        dict = dict[deviceAddress];
    }
    if (dict.count > 0) {
        *mode = dict[@"mode"];
        return [dict[@"enabled"] boolValue];
    }
    return @"";
}

- (NSDictionary *)getCurrentEventForModel:(NSString *)deviceAddress {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getZonesWateringFromModel:self.subsystemModel];
    if (dict.count > 0) {
        dict = dict[deviceAddress];
    }
    if (dict.count > 0) {
        return dict;
    }
    return nil;
}

- (NSDictionary *)getNextEventForCurrentIrrigationModeForModel:(NSString *)deviceAddress {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getScheduleStatusFromModel:self.subsystemModel];
    if (dict.count > 0) {
        dict = dict[deviceAddress];
    }
    if (dict.count > 0) {
        return dict[@"nextEvent"];
    }
    return nil;
}

- (NSTimeInterval)getCurrentWateringTimeRemaining:(NSString *)deviceAddress {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getZonesWateringFromModel:self.subsystemModel];
    if (dict.count > 0) {
        dict = dict[deviceAddress];
    }
    if (dict.count > 0) {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)dict[@"startTime"]).doubleValue / 1000];

        // Duration is in min and we need to convert it to sec
        NSDate *endDate = [startDate dateByAddingTimeInterval:((NSNumber*)dict[@"duration"]).doubleValue * 60];

        return [endDate timeIntervalSinceDate:[NSDate date]];
    }
    return -1;
}

- (NSTimeInterval)getSkipUntilForModel:(NSString *)deviceAddress {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getScheduleStatusFromModel:self.subsystemModel];
    if (dict.count > 0) {
        dict = dict[deviceAddress];
    }
    if (dict.count > 0 && [[dict allKeys] containsObject:@"skippedUntil"]) {
        return ((NSNumber*)dict[@"skippedUntil"]).doubleValue / 1000;
    }
    return -1;
}

- (void)skipWithController:(NSString *)address withHours:(int)hours {
    [LawnNGardenSubsystemCapability skipWithController:address withHours:hours onModel:self.subsystemModel];
}

- (PMKPromise *)stopWithController:(NSString *)address currentOnly:(BOOL)currentOnly {
    return [LawnNGardenSubsystemCapability stopWateringWithController:address withCurrentOnly:currentOnly onModel:self.subsystemModel];
}

- (PMKPromise *)cancelSkipWithController:(NSString *)address {
    return [LawnNGardenSubsystemCapability cancelSkipWithController:address onModel:self.subsystemModel];
}

#pragma mark - Dashboard Card Getters
- (BOOL)isAvailable {
    return [SubsystemCapability getAvailableFromModel:self.subsystemModel];
}

- (int)getCurrentlyWateringZonesCount:(NSString *)deviceAddress {
    return (int)[LawnNGardenSubsystemCapability getZonesWateringFromModel:self.subsystemModel].count;
}

// If deviceAddress is nil, then return all the zones that are currently watering
// Otherwise, return only the watering zones of the device with the same address
- (NSString *)getCurrentlyWateringZonesString:(NSString **)deviceAddress {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getZonesWateringFromModel:self.subsystemModel];
    NSString *zones = @"";
    NSString *secondAppend = nil;
    int count = 0;
    NSString *address = *deviceAddress;

    if (dict.count > 0) {
        for (NSString *key in dict) {
            if (address.length == 0 || [address isEqualToString:key]) {
                DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:dict[key][@"controller"]];
                NSString *zoneName = [LawnNGardenZoneController getSafeNameForZone:dict[key][@"zone"] device:device];
                if (zoneName != nil) {
                    if (count == 1) {
                        secondAppend = [NSString stringWithFormat:@" & %@", zoneName];
                    } else if (count > 1) {
                        secondAppend = [NSString stringWithFormat:@" & %d More", count];
                    } else {
                        zones = [zones stringByAppendingString:zoneName];
                    }
                    count++;
                }
                *deviceAddress = device.address;
            }
        }

        if (secondAppend != nil) {
            zones = [zones stringByAppendingString:secondAppend];
        }

        return zones;
    }

    return nil;
}

- (BOOL)getCurrentlyWateringZone:(NSString **)zoneId withStartTime:(NSDate **)startTime withDuration:(int *)durationInMin {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getZonesWateringFromModel:self.subsystemModel];

    if (dict != nil && dict.count > 0) {
        for (NSString *key in dict) {
            DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:dict[key][@"controller"]];
            *zoneId = [LawnNGardenZoneController getSafeNameForZone:dict[key][@"zone"] device:device];
            *startTime = [NSDate dateWithTimeIntervalSince1970:[dict[key][@"startTime"] doubleValue] / 1000];
            *durationInMin = [dict[key][@"duration"] intValue];
            
            return YES;
       }
    }

    *zoneId = 0;
    *startTime = 0;
    *durationInMin = 0;
    return NO;
}

- (NSString *)getNextZone {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getNextEventFromModel:self.subsystemModel];
    if (dict != nil && dict.count > 0) {
        DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceModel];

        if (deviceModel) {
            return [LawnNGardenZoneController getSafeNameForZone:dict[@"zone"] device:deviceModel];
        }
    }

    return nil;
}

- (NSDate *)getNextZoneDate {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getNextEventFromModel:self.subsystemModel];
    if (dict != nil && dict.count > 0) {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:((NSNumber *)dict[@"startTime"]).doubleValue / 1000];
        return startDate;
    }
    return nil;
}

- (NSDate *)getNextZoneTime {
    NSDictionary *dict = [LawnNGardenSubsystemCapability getNextEventFromModel:self.subsystemModel];
    if (dict != nil && dict.count > 0) {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:((NSNumber *)dict[@"startTime"]).doubleValue / 1000];
        return startDate;
    }
    return nil;
}

- (NSDate *)getNextZoneTime:(NSString*)deviceAddress {
    NSDictionary *dict = [self getNextEventForCurrentIrrigationModeForModel:deviceAddress];
    if (dict != nil && dict.count > 0) {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:((NSNumber *)dict[@"startTime"]).doubleValue / 1000];
        return startDate;
    }
    return nil;
}

#pragma mark - Zone Names and Ids
+ (OrderedDictionary *)getZones:(NSArray *)zones forDeviceAddress:(NSString *)deviceAddress {
    OrderedDictionary *orderedDict = [[OrderedDictionary alloc] initWithCapacity:zones.count];
    
    DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAddress];
    for (NSString *zoneId in zones) {
        NSString *zoneName = [LawnNGardenZoneController getSafeNameForZone:zoneId device:deviceModel];
        [orderedDict setObject:[NSString stringWithFormat:@"%@", zoneName] forKey:zoneId];
    }
    [orderedDict sortArrayBasedOnNumberInKey];
    
    return orderedDict;
}

+ (OrderedDictionary *)getAllZonesForModel:(NSString *)deviceAddress {
    NSDictionary *instances = [[[[CorneaHolder shared] modelCache] fetchModel:deviceAddress] instances];
    return [self getZones:instances.allKeys forDeviceAddress:deviceAddress];
}

- (OrderedDictionary *)getAllZones {
    return [LawnNGardenSubsystemController getZonesForDeviceAddresses:[LawnNGardenSubsystemCapability getControllersFromModel:self.subsystemModel]];
}

+ (OrderedDictionary *)getZonesForDeviceAddresses:(NSArray *)deviceAddresses {
    OrderedDictionary *zones = [[OrderedDictionary alloc] init];

    for (NSString *controller in deviceAddresses) {
        DeviceModel *model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:controller];

        OrderedDictionary *allZones = [LawnNGardenSubsystemController getAllZonesForModel:controller];

        NSString *name = [DeviceCapability getNameFromModel:model];

        NSMutableArray *zonesForController = [[NSMutableArray alloc] init];

        for (NSString *key in allZones) {
            IrrigationZoneModel *zone = [[IrrigationZoneModel alloc] initWithZoneKey:key withDeviceModel:model];

            [zonesForController addObject:zone];
        }

        if (name != nil) {
            [zones setObject:zonesForController.copy forKey:name];
        }
    }

    return zones;
}

#pragma mark - Watering now Triggers
- (NSString *)getCurrentWateringTrigger {
    return [self.subsystemModel getAttribute:@"trigger"];
}

- (BOOL)isManualWateringTrigger {
    return [[self getCurrentWateringTrigger] isEqualToString:kEnumIrrigationZoneWateringTriggerMANUAL];
}

- (BOOL)isScheduledWateringTrigger {
    return [[self getCurrentWateringTrigger] isEqualToString:kEnumIrrigationZoneWateringTriggerSCHEDULED];
}
@end
