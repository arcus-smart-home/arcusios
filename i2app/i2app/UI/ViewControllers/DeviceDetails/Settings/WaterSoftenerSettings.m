//
//  WaterSoftenerSettings.m
//  i2app
//
//  Created by Arcus Team on 10/12/15.
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
#import "WaterSoftenerSettings.h"
#import "WaterSoftenerRechargeNowController.h"
#import "WaterSoftenerRechargeTimeController.h"
#import "WaterSoftenerWaterHardnessLvController.h"
#import "WaterSoftenerSaltTypeController.h"
#import "WaterSoftenerWaterFlowController.h"
#import "WiFiCapability.h"

@implementation DeviceSettingDeviceWaterSoftenerPackage

- (void)loadSettings {
    [super loadSettings];
    
    [self.unitCollection addUnit:[[DeviceWaterSoftenerWifiSettingUnit alloc] init]];
    
    [self.unitCollection addUnit:[[DeviceWaterSoftenerRechargeNowSettingUnit alloc] init]];

    [self.unitCollection addUnit:[[DeviceWaterSoftenerRechargeTimeSettingUnit alloc] init]];
    
    [self.unitCollection addUnit:[[DeviceWaterSoftenerWaterHardnessLvSettingUnit alloc] init]];
    
    [self.unitCollection addUnit:[[DeviceWaterSoftenerSaltTypeSettingUnit alloc] init]];

//    [self.unitCollection addUnit:[[DeviceWaterSoftenerWaterFlowSettingUnit alloc] init]];
}

@end

#pragma mark - Setting units

@implementation DeviceWaterSoftenerWifiSettingUnit

- (void)loadData {
    [self setTitle:NSLocalizedString(@"wi-fi & network", nil)];
    [self setSubtitle:NSLocalizedString(@"If this device is connected to the incorrect Wi-Fi network, please update it on the device.", nil)];
    [self setDisableArrow:YES];
    
    NSString *ssid = [WiFiCapability getSsidFromModel:self.deviceModel];
    [self setValue:ssid];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
}

@end


@implementation DeviceWaterSoftenerRechargeNowSettingUnit

- (void)loadData {
    [self setTitle:NSLocalizedString(@"Recharge Now", nil)];
    [self setSubtitle:NSLocalizedString(@"Manually Recharge Your Water Softener.", nil)];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    WaterSoftenerRechargeNowController *vc = [WaterSoftenerRechargeNowController createWithDeviceModel:self.deviceModel];
    [self.controlOwner.navigationController pushViewController:vc animated:YES];
}

@end

@implementation DeviceWaterSoftenerRechargeTimeSettingUnit

- (void)loadData {
    [self setTitle:NSLocalizedString(@"Recharge Time", nil)];
    [self setSubtitle:NSLocalizedString(@"Set the Recharge time.", nil)];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    WaterSoftenerRechargeTimeController *vc = [WaterSoftenerRechargeTimeController createWithDeviceModel:self.deviceModel];
    [self.controlOwner.navigationController pushViewController:vc animated:YES];
}

@end

@implementation DeviceWaterSoftenerWaterHardnessLvSettingUnit

- (void)loadData {
    [self setTitle:NSLocalizedString(@"water hardness level", nil)];
    [self setSubtitle:NSLocalizedString(@"Edit Your Water Hardness.", nil)];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    WaterSoftenerWaterHardnessLvController *vc = [WaterSoftenerWaterHardnessLvController createWithDeviceModel:self.deviceModel];
    [self.controlOwner.navigationController pushViewController:vc animated:YES];
}

@end

@implementation DeviceWaterSoftenerSaltTypeSettingUnit

- (void)loadData {
    [self setTitle:NSLocalizedString(@"salt type", nil)];
    [self setSubtitle:NSLocalizedString(@"Recommendations.", nil)];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    WaterSoftenerSaltTypeController *vc = [WaterSoftenerSaltTypeController create];
    [self.controlOwner.navigationController pushViewController:vc animated:YES];
}

@end

@implementation DeviceWaterSoftenerWaterFlowSettingUnit

- (void)loadData {
    [self setTitle:NSLocalizedString(@"Water Flow", nil)];
    [self setSubtitle:NSLocalizedString(@"-", nil)];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    WaterSoftenerWaterFlowController *vc = [WaterSoftenerWaterFlowController create];
    [self.controlOwner.navigationController pushViewController:vc animated:YES];
}

@end






