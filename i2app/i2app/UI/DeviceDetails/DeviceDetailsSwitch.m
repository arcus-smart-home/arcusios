//
//  DeviceDetailsSwitch.m
//  i2app
//
//  Created by Arcus Team on 12/2/15.
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
#import "DeviceDetailsSwitch.h"
#import "DeviceButtonBaseControl.h"
#import "UIView+Animation.h"
#import "SwitchCapability.h"
#import "ServiceControlCell.h"
#import "DeviceAdvancedCapability.h"

@implementation DeviceDetailsSwitch {
    DeviceButtonBaseControl     *_onButton;
    DeviceButtonBaseControl     *_offButton;
    UIView                      *_logoView;

}

- (void)loadData {
    _onButton = self.controlCell.leftButton;
    _offButton = self.controlCell.rightButton;
    _logoView = self.controlCell.centerIcon;

    _logoView.layer.cornerRadius = self.controlCell.centerIcon.frame.size.width / 2.0f;
    _logoView.layer.borderColor = [UIColor whiteColor].CGColor;

    [_onButton setDefaultStyle:NSLocalizedString(@"ON", nil) withSelector:@selector(pressedOnButton:) owner:self];
    [_offButton setDefaultStyle:NSLocalizedString(@"OFF", nil) withSelector:@selector(pressedOffButton:) owner:self];
    
    [self updateDeviceState:nil initialUpdate:YES];
}

#pragma mark - actions
- (void)pressedOnButton:(DeviceButtonBaseControl *)onButton {
    [_onButton setDisable:YES];
    
    [_logoView animateStartShining:nil withBoarderWidth:3.0];
    [_onButton setDisable:YES];
    [_offButton setDisable:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (![self.deviceModel isSwitchedOn]) {
            [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];
        }
        [self.deviceModel commit];
    });
}

- (void)pressedOffButton:(DeviceButtonBaseControl *)offButton {
    [_offButton setDisable:YES];
    
    [_logoView animateStopShining:nil withBoarderWidth:3.0];
    [_onButton setDisable:NO];
    [_offButton setDisable:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([self.deviceModel isSwitchedOn]) {
            [SwitchCapability setState:kEnumSwitchStateOFF onModel:self.deviceModel];
        }
        [self.deviceModel commit];
    });
}

#pragma mark - override
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.deviceModel isSwitchedOn]) {
            [_logoView animateStartShining:nil withBoarderWidth:3.0];
            [_onButton setDisable:YES];
            [_offButton setDisable:NO];
        }
        else {
            [_logoView animateStopShining:nil withBoarderWidth:3.0];
            [_onButton setDisable:NO];
            [_offButton setDisable:YES];
        }
        [self updateErrorState];
    });
}

- (void)updateErrorState {
    NSDictionary *errors = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
    if (errors != nil && errors.count > 0 && ![self.deviceModel isDeviceOffline]) {
        if (errors[@"ERR_UNAUTHED_LUTRON"]) {
            [self showRevokedBanner];
        }
        else if (errors[@"ERR_DELETED_LUTRON"]) {
            [self showDeviceRemovedBanner];
        }
        else if (errors[@"ERR_BRIDGE_LUTRON"]) {
            [self showBridgeErrorBanner];
        }
    }
}

- (void)showRevokedBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.controlCell teardownDeviceError];
        [self.controlCell setupDeviceError:@"Lutron account information revoked"];
    });
}

- (void)showDeviceRemovedBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.controlCell teardownDeviceError];
        [self.controlCell setupDeviceError:@"Device removed in Lutron app"];
    });
}

- (void)showBridgeErrorBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.controlCell teardownDeviceError];
        [self.controlCell setupDeviceError:@"Lutron bridge has an error"];
    });
}

@end
