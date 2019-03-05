//
//  LightbulbDeviceViewController.m
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
#import "LightbulbDeviceViewController.h"
#import "SwitchCapability.h"

@interface LightbulbDeviceViewController ()

@end

@implementation LightbulbDeviceViewController {
    DeviceButtonSwitchControl *_switchBtn;
    NSString *_switchState;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityButtonsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;

    _switchBtn = [DeviceButtonSwitchControl create:^BOOL(id sender) {
        [weakSelf toggle];
        return YES;
    } withUnselect:^BOOL(id sender) {
        [weakSelf toggle];
        return YES;
    }];
    [self.buttonsView loadControl:_switchBtn];
}

- (void)lightBulbOn {
    [self startShiningAnimation];
    [_switchBtn.button setSelected:YES];
}

- (void)lightBulbOff {
    [_switchBtn.button setSelected:NO];
    [self stopShiningAnimation];
}

- (void)toggle {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([self.deviceModel isSwitchedOn]) {
            [SwitchCapability setState:kEnumSwitchStateOFF onModel:self.deviceModel];
        }
        else {
            [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];
        }
        [self.deviceModel commit];
    });
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    
    NSString *switchState;
    switchState = [SwitchCapability getStateFromModel:self.deviceModel];
    
    if ([switchState isEqualToString:_switchState]) {
        return;
    }
    else {
        _switchState = switchState;
    }
    
    if ([switchState isEqualToString:kEnumSwitchStateOFF]) {
        [self lightBulbOff];
    }
    else if ([switchState isEqualToString:kEnumSwitchStateON]) {
        [self lightBulbOn];
    }
}


@end
