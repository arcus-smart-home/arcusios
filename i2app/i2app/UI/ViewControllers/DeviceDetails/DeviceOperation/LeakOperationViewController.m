//
//  LeakOperationViewController.m
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
#import "LeakOperationViewController.h"
#import "DevicePowerCapability.h"
#import "LeakH2OCapability.h"
#import "DeviceConnectionCapability.h"
#import "DeviceAttributeGroupView.h"
#import "DeviceNotificationLabel.h"

@interface LeakOperationViewController ()

@end


@implementation LeakOperationViewController {
    DevicePercentageAttributeControl *_percentageControl;
}

- (void)loadDeviceAbilities {
    [super loadDeviceAbilities];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _percentageControl = [DevicePercentageAttributeControl createWithBatteryPercentage:45];
    [self.attributesView loadControl:_percentageControl];
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    NSDate *date = [LeakH2OCapability getStatechangedFromModel:self.deviceModel];
    
    [_percentageControl setPercentage:batteryState];
    
    [self.eventLabel setTitle:NSLocalizedString(@"Last leak", nil) andTime:date];
}

@end
