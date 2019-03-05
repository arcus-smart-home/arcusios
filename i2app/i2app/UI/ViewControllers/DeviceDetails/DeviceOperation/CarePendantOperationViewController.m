//
//  CarePendantOperationViewController.m
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
#import "CarePendantOperationViewController.h"
#import "DevicePercentageAttributeControl.h"
#import "ButtonCapability.h"
#import "DevicePowerCapability.h"
#import "PresenceCapability.h"
#import "DeviceConnectionCapability.h"

@interface CarePendantOperationViewController ()

@end

@implementation CarePendantOperationViewController {
    DevicePercentageAttributeControl *_battery;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.eventLabel setTitle:NSLocalizedString(@"HOME", nil) withLeftIcon:[UIImage imageNamed:@"keyfob_home"]];
    
    _battery = [DevicePercentageAttributeControl createWithBatteryPercentage:-1];
    [self.attributesView loadControl:_battery];
}

- (void)atHome {
    [self.eventLabel setTitle:NSLocalizedString(@"HOME", nil) withLeftIcon:[UIImage imageNamed:@"keyfob_home"]];
    [super startRubberBandContractAnimation];

}

- (void)awayFromHome {
    [self.eventLabel setTitle:NSLocalizedString(@"Away", nil) withLeftIcon:[UIImage imageNamed:@"keyfob_away"]];
    [super startRubberBandExpandAnimation];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *presenceState = [PresenceCapability getPresenceFromModel:self.deviceModel];
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    
    [_battery setPercentage:batteryState];
    
    if ([presenceState isEqualToString:kEnumPresencePresencePRESENT]) {
        if (isInitial) {
            return;
        }
        else {
            [self atHome];
        }
    }
    else if ([presenceState isEqualToString:kEnumPresencePresenceABSENT]) {
        [self awayFromHome];
    }
}


@end
