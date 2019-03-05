//
//  DeviceManager.m
//  i2app
//
//  Created by Arcus Team on 6/4/15.
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
#import "DeviceManager.h"
#import "DeviceCapability.h"
#import "DeviceOTACapability.h"


#import "DeviceController.h"

NSString *const kDeviceBackgroupUpdateNotification = @"DeviceBackgroupUpdate";

@interface DeviceManager()

@end

@implementation DeviceManager

@dynamic devices;

+ (DeviceManager *)instance {
    static dispatch_once_t pred = 0;
    __strong static DeviceManager *_manager = nil;
    dispatch_once(&pred, ^{
        _manager = [[DeviceManager alloc] init];
    });
    
    return _manager;
}

#pragma mark - Dynamic Properties
 - (void)deviceListChanged:(NSNotification *)note {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceListRefreshedNotification object:nil];
}

/// This is a computed variable if you use it cache it
- (NSArray *)devices {
  NSArray *hubModels = [[[CorneaHolder shared] modelCache] fetchModels:[HubCapability namespace]];
  if (hubModels == nil) {
    hubModels = @[];
  }
  NSMutableArray *devices = [[NSMutableArray alloc] initWithArray:hubModels];

  NSArray *keys = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
  NSArray *sortedArray = [[[[CorneaHolder shared] modelCache] fetchModels:[DeviceCapability namespace]] sortedArrayUsingDescriptors:keys];
  [devices addObjectsFromArray:sortedArray];
  return devices;
}

- (Model *)getDeviceByModelID: (NSString *)modelID {
    NSString *address = [DeviceModel addressForId:modelID];
    Model *deviceModel = (Model *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    if (deviceModel) {
        return deviceModel;
    }
    address = [HubModel addressForId:modelID];
    Model *hubModel = (Model *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    if (hubModel != nil) {
      return hubModel;
    }
    return nil;
}

- (NSInteger)getDeviceIndexBy:(DeviceModel *)device {
    NSArray *deviceList = self.devices;
    
    for (NSInteger i = 0; i < deviceList.count; i++) {
        if ([deviceList[i] isEqual:device]) {
            return i;
        }
    }
    return -1;
}

- (void)removeAllControllers {
    for (DeviceModel *device in self.devices) {
        device.operationController = nil;
    }
}


#pragma mark - filter devices
- (NSArray *)filterDevices:(DeviceType)type {
    NSArray *devices = [self devices];
    NSMutableArray *filteredDevices = [[NSMutableArray alloc] init];
    for (DeviceModel *model in devices) {
        if (model.deviceType == type) {
            [filteredDevices addObject:model];
        }
    }
    return filteredDevices;
}

- (NSArray *)filterDevicesWithMultiType:(NSArray *)types {
    NSArray *devices = [self devices];
    NSMutableArray *filteredDevices = [[NSMutableArray alloc] init];
    for (DeviceModel *model in devices) {
        for (id type in types) {
            if (model.deviceType == [type intValue]) {
                [filteredDevices addObject:model];
            }
        }
    }
    return filteredDevices;
}

- (NSArray *)devicesUndergoingFirmwareUpdate {
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    NSArray *keys = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    
    NSArray *sortedArray = [[[[CorneaHolder shared] modelCache] fetchModels:[DeviceCapability namespace]] sortedArrayUsingDescriptors:keys];
    for (DeviceModel *device in sortedArray) {
        if (device.deviceType != DeviceTypeHub) {
            NSString *otaStatus = [DeviceOtaCapability getStatusFromModel:device];
            if (otaStatus.length > 0) {
                if ([otaStatus isEqualToString:kEnumDeviceOtaStatusINPROGRESS]) {
                    [devices addObject:device];
                }
            }
        }
    }
    
    return devices;
}

@end
