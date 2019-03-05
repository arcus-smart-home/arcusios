//
//  GlassBreakViewController.m
//  i2app
//
//  Created by Arcus Team on 9/29/15.
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
#import "GlassBreakViewController.h"
#import "DevicePowerCapability.h"

@interface GlassBreakViewController ()

@end

@implementation GlassBreakViewController  {
    DevicePercentageAttributeControl *_battery;
}

#pragma mark - Life Cycle
- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilitySecurityIcon | GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.eventLabel setTitle:@"Event:" andContent:@"xxx"];
    
    _battery = [DevicePercentageAttributeControl createWithBatteryPercentage:0];
    [self.attributesView loadControl:_battery];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    [_battery setPercentage:batteryState];
}
@end
