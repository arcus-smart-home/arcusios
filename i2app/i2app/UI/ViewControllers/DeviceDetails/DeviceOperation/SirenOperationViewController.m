//
//  SirenOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 7/24/15.
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
#import "SirenOperationViewController.h"
#import "AlertCapability.h"
#import "DevicePowerCapability.h"

@interface SirenOperationViewController ()

@end

@implementation SirenOperationViewController {
    DevicePercentageAttributeControl *_battery;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilitySecurityIcon | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _battery = [DevicePercentageAttributeControl createWithBatteryPercentage:94];
    [self.attributesView loadControl:_battery];
}

- (void)sirenAlert {
    [self startRubberBandExpandAnimation];
    //Set the alert icon in here
    
}

- (void)sirenQuiet {
    [self startRubberBandContractAnimation];
}


- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *alertState = [AlertCapability getStateFromModel:self.deviceModel];
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    
    if ([alertState isEqualToString:kEnumAlertStateQUIET]) {
        if (isInitial) {
            return;
        }
        else {
            [self sirenQuiet];
        }
    }
    
    if ([alertState isEqualToString:kEnumAlertStateALERTING]) {
        [self sirenAlert];
    }
    
    [_battery setPercentage:batteryState];
}


@end
