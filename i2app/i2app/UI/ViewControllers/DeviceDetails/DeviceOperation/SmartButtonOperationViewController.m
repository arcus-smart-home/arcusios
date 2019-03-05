//
//  SmartButtonOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 6/23/15.
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
#import "SmartButtonOperationViewController.h"
#import "ButtonCapability.h"
#import "DevicePowerCapability.h"
#import "DeviceController.h"

@interface SmartButtonOperationViewController ()

@end

@implementation SmartButtonOperationViewController {
    BOOL            _isPressed;
    
    DevicePercentageAttributeControl    *_percentageControl;
    DeviceTempAttributeControl          *_tempControl;

}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilitySecurityIcon | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _percentageControl = [DevicePercentageAttributeControl createWithBatteryPercentage:82];
    _tempControl = [DeviceTempAttributeControl create];

    [self.attributesView loadControl:_percentageControl control2:_tempControl];
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    
    double temperature = [DeviceController getTemperatureForModel:self.deviceModel];
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    
    if (temperature != NSNotFound) {
        [_tempControl setTemp:temperature];
    }
    [_percentageControl setPercentage:batteryState];
}

@end
