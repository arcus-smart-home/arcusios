//
//  KeyFobOperationViewController.m
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
#import "KeyFobOperationViewController.h"
#import "DeviceControlViewController.h"
#import "DevicePowerCapability.h"
#import "PresenceCapability.h"

#import "DeviceConnectionCapability.h"
#import "DeviceSettingsViewController.h"


#import <i2app-Swift.h>

@implementation KeyFobOperationViewController {
    
    DevicePercentageAttributeControl                *_percentageControl;
    DeviceButtonBaseControl                         *_btnControl;
}

- (void)loadDeviceAbilities {

    DeviceModel *keyfobDevice = self.deviceModel;
    if ([keyfobDevice instances].count > 0) {

        self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityAttributesView | GeneralDeviceAbilityButtonsView;
    }
    else {
        self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityAttributesView;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _percentageControl = [DevicePercentageAttributeControl createWithBatteryPercentage:82];
    [self.attributesView loadControl:_percentageControl];
    
    _btnControl = [DeviceButtonBaseControl create:[UIImage imageNamed:@"settings_icon"] name:@"" withSelector:@selector(pressedFobButton:) owner:self];
    
    if (self.deviceModel.getInstances.count > 0) {
        [self.buttonsView loadControl:_btnControl];
    }
}

- (void)pressedFobButton:(UIButton *)sender {
    KeyFobRulesListViewController *vc = [KeyFobRulesListViewController create:self.deviceModel];

    [self.deviceController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *state = [PresenceCapability getPresenceFromModel:self.deviceModel];
    NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    
    [_percentageControl setPercentage:batteryState];

    if ([state isEqualToString:kEnumPresencePresencePRESENT]) {
        [self.eventLabel setTitle:NSLocalizedString(@"HOME", nil) withLeftIcon:[UIImage imageNamed:@"keyfob_home"]];
        [self startRubberBandContractAnimation];
    }
    else {
        [self.eventLabel setTitle:NSLocalizedString(@"AWAY", nil) withLeftIcon:[UIImage imageNamed:@"keyfob_away"]];
        [self startRubberBandExpandAnimation];
    }
}

@end
