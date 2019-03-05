//
//  KeypadDeviceViewController.m
//  i2app
//
//  Created by Arcus Team on 7/21/15.
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
#import "KeypadDeviceViewController.h"
#import "DevicePowerCapability.h"
#import "DeviceController.h"

@interface KeypadDeviceViewController ()

@end

@implementation KeypadDeviceViewController  {
    DevicePercentageAttributeControl *_battery;
    DeviceTempAttributeControl       *_tempControl;

}

#pragma mark - life cycle
- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilitySecurityIcon | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _battery = [DevicePercentageAttributeControl createWithBatteryPercentage:0];

    if ([self.deviceModel.caps containsObject:@"temp"]) {
        _tempControl = [DeviceTempAttributeControl create];
        [self.attributesView loadControl:_battery control2:_tempControl];
    }
    else {
        [self.attributesView loadControl:_battery];
    }
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    
    double temperature = [DeviceController getTemperatureForModel:self.deviceModel];
    [_battery setPercentage:batteryState];

    if (_tempControl) {
        [_tempControl setTemp:temperature];
    }
}

@end
