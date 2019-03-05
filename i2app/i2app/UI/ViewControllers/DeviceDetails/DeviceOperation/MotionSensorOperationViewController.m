//
//  MotionSensorOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 6/6/15.
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
#import "MotionSensorOperationViewController.h"
#import "MotionCapability.h"
#import "DevicePowerCapability.h"
#import "DeviceConnectionCapability.h"
#import "DeviceAttributeGroupView.h"
#import "DeviceTimeAttributeControl.h"
#import "DeviceController.h"

@interface MotionSensorOperationViewController()


@end

@implementation MotionSensorOperationViewController {
    
    DeviceTimeAttributeControl          *_motionControl;
    DeviceTempAttributeControl          *_tempControl;
    DevicePercentageAttributeControl    *_percentageControl;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilitySecurityIcon | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _motionControl = [DeviceTimeAttributeControl create];
    _tempControl = [DeviceTempAttributeControl create];
    _percentageControl = [DevicePercentageAttributeControl createWithBatteryPercentage:82];
    
    [self.attributesView loadControl:_motionControl control2:_tempControl control3:_percentageControl];
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    double temperature = [DeviceController getTemperatureForModel:self.deviceModel];
    NSDate *time = [MotionCapability getMotionchangedFromModel:self.deviceModel];
    
    [_percentageControl setPercentage:batteryState];
    [_tempControl setTemp:temperature];
    
    [_motionControl setDateTime:time andState:NSLocalizedString(@"Motion", nil)];
}

@end
