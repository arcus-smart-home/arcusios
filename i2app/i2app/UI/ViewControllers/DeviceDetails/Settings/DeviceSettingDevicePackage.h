//
//  DeviceSettingDevicePackage.h
//  i2app
//
//  Created by Arcus Team on 8/7/15.
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
#import "DeviceSettingModels.h"

#pragma mark - functional package
@interface DeviceSettingDevicePackage : DeviceSettingPackage

@property (weak, nonatomic) UIViewController *controlOwner;
@property (weak, nonatomic) DeviceModel *deviceModel;

- (void)loadSettings; 

@end


#pragma mark - device setting package
/*
 * naming rule of setting package is DeviceSetting[DeviceType]Package. 
 * From: "DeviceModel+Extension.h", DeviceTypeToString(enum)
 */
@interface  DeviceSettingDeviceCameraPackage : DeviceSettingDevicePackage

@end

@interface  DeviceSettingDeviceSercommCameraPackage : DeviceSettingDevicePackage

@end

@interface  DeviceSettingDeviceKeyFobPackage : DeviceSettingDevicePackage

@end

@interface DeviceSettingDeviceCarePendantPackage : DeviceSettingDevicePackage

@end


