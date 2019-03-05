//
//  DeviceDetailsContactSensor.m
//  i2app
//
//  Created by Arcus Team on 9/17/15.
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
#import "DeviceDetailsContactSensor.h"

#import "DevicePowerCapability.h"
#import "ContactCapability.h"

#import "DeviceConnectionCapability.h"
#import "DeviceController.h"
#import "DeviceAttributeGroupView.h"
#import "ServiceControlCell.h"
#import "DeviceButtonBaseControl.h"
#import "NSDate+Convert.h"

@interface DeviceDetailsBase ()

- (void)animateRubberBandExpand:(UIView *)ringLogo;
- (void)animateRubberBandContract:(UIView *)ringLogo;

@end

@implementation DeviceDetailsContactSensor {
    BOOL  _contactSensorIsOpen;
}

@dynamic sensorState;
@dynamic time;
@dynamic batteryState;
@dynamic temperature;


- (void)loadData {
    [self.controlCell.rightButton setHidden:YES];
    [self updateDeviceState:[self.deviceModel get] initialUpdate:NO];

    [self.controlCell setSubtitle:[NSString stringWithFormat:@"%@ %@",[self.sensorState isEqualToString:@"CLOSED"] ? @"Closed" : @"Opened", [self.time formatDeviceLastEvent]]];
}

- (void)setSensorEnable:(BOOL)open {
    if (open) {
        [self animateRubberBandExpand:self.controlCell.centerIcon];
    }
    else {
        [self animateRubberBandContract:self.controlCell.centerIcon];
    }
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *sensorState = [ContactCapability getContactFromModel:self.deviceModel];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self setSensorEnable:[sensorState isEqualToString:kEnumContactContactOPENED]];
    });
}

- (NSString *)sensorState {
    return [ContactCapability getContactFromModel:self.deviceModel];
}

- (NSDate *)time {
    return [ContactCapability getContactchangedFromModel:self.deviceModel];
}

- (int)batteryState {
    return [DevicePowerCapability getBatteryFromModel:self.deviceModel];
}

- (NSInteger)temperature {
    return [DeviceController getTemperatureForModel:self.deviceModel];
}

@end




