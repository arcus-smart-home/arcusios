//
//  TiltSensorOperationController.m
//  i2app
//
//  Created by Arcus Team on 7/28/15.
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
#import "TiltSensorOperationController.h"
#import "TiltCapability.h"
#import  "DevicePowerCapability.h"
#import  "DeviceController.h"

@interface TiltSensorOperationController ()

@end

@implementation TiltSensorOperationController {
    DeviceTextAttributeControl *_state;
    DevicePercentageAttributeControl *_battery;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _state = [DeviceTextAttributeControl create:NSLocalizedString(@"State", nil) withValue: NSLocalizedString(@"open", nil)];
    _battery = [DevicePercentageAttributeControl createWithBatteryPercentage:94];
    [self.attributesView loadControl:_state control2:_battery];
}

- (void)tiltSensorFlat {
    if ([DeviceController isCurrentTiltClosedPositionHorizontal:self.deviceModel]) {
        [_state setValueText: NSLocalizedString(@"Open", nil)];
        [self startRubberBandExpandAnimation];
    }else {
        [_state setValueText: NSLocalizedString(@"Closed", nil)];
        [self startRubberBandContractAnimation];
    }
}

- (void)tiltSensorUpright {
    if ([DeviceController isCurrentTiltClosedPositionHorizontal:self.deviceModel]) {
        [_state setValueText: NSLocalizedString(@"Closed", nil)];
        [self startRubberBandContractAnimation];
    }else {
        [_state setValueText: NSLocalizedString(@"Open", nil)];
        [self startRubberBandExpandAnimation];
    }
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *tiltState = [TiltCapability getTiltstateFromModel:self.deviceModel];
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    
    if ([tiltState isEqualToString:kEnumTiltTiltstateFLAT]) {
        [self tiltSensorFlat];
    }
    
    if ([tiltState isEqualToString: kEnumTiltTiltstateUPRIGHT]) {
        [self tiltSensorUpright];
    }
    
    [_battery setPercentage:batteryState];
}

@end
