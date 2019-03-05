//
//  DeviceDetailsThermostatHoneywell.m
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
#import "DeviceDetailsThermostatHoneywell.h"
#import "ServiceControlCell.h"
#import "DeviceConnectionCapability.h"
#import "ThermostatCapability.h"
#import "HoneywellTCCCapability.h"
#import "DeviceController.h"
#import "DeviceButtonBaseControl.h"

const float ddtHoneywellThermostatDebounceDuration = 1.5;
const float ddtHoneywellThermostatEventTimer = 120;

const double ddthSecBetweenUpdates = 0.5f;

@interface DeviceDetailsThermostatHoneywell()

@property (strong, nonatomic) NSTimer *waitEventTimer;

@end

@implementation DeviceDetailsThermostatHoneywell

- (void)displayNextEvent:(NSString *)mode eventLabel:(UILabel *)eventLabel eventCloseButton:(UIButton *)eventCloseButton animationDuration:(float)duration {

}

- (void)loadData {
    [super loadData];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.controlCell) {
            // Check if we should disable the screen or not for pending events
            if ([self.deviceModel hasEvents]) {
                [self showWaitingBanner];
            }
            // Clear old events and start timer
            NSTimeInterval duration = [self.deviceModel clearStaleEventsAndReturnLongestDuration:ddtHoneywellThermostatEventTimer];

            if (duration > 0) {
                [self startTimerWithDuration:duration];
            } else if (self.deviceModel.isDisabledDevice) {
                [self showAlertBanner];
            } else {
                [self closeBanner];
            }
        }
    });
}

- (void)loadOnlineMode {
    [super loadOnlineMode];

    self.controlCell.leftButton.hidden = NO;
    self.controlCell.rightButton.hidden = NO;
    self.controlCell.bottomButton.hidden = NO;
}

- (void)commitThermostatMode:(NSString *)mode {
    [self startDebounceTimer:0.0 event:^{
        if ([self.deviceModel isC2CDevice]) {
            // Add event for the device model's attribute
            [self.deviceModel addNewEventForAttribute:kAttrThermostatHvacmode];

            // Start Timer for 2 Minutes
            [self startTimerWithDuration:ddtHoneywellThermostatEventTimer];
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [ThermostatCapability setHvacmode:mode onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }];
}

- (void)commitSetPoints:(int)coolTemp heatPoint:(int)heatTemp {
    NSTimeInterval duration = ddthSecBetweenUpdates;

    super.heatTemp = heatTemp;
    super.coolTemp = coolTemp;
    
    if ([self.deviceModel isC2CDevice]) {
        duration = ddtHoneywellThermostatDebounceDuration;
    }

    [self startDebounceTimer:duration event:^{
        if ([self.deviceModel isC2CDevice]) {
        // Add event for the device model's attribute
            [self.deviceModel addNewEventForAttribute:kAttrThermostatCoolsetpoint];
            [self.deviceModel addNewEventForAttribute:kAttrThermostatHeatsetpoint];

        // Start Timer for 2 Minutes
            [self startTimerWithDuration:ddtHoneywellThermostatEventTimer];
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [DeviceController setThermostatSetPoints:super.coolTemp heatPoint:super.heatTemp onModel:self.deviceModel];
            self.controlUpdateStartTime = [[NSDate date] timeIntervalSince1970];
        });
    }];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    [super updateDeviceState:attributes initialUpdate:isInitial];

    // Honeywell Device Handling
    if ([self.deviceModel isC2CDevice]) {

        if ([self.deviceModel hasEvents]) {
            [self.deviceModel clearStaleEventsWithDuration:ddtHoneywellThermostatEventTimer];
            [self.deviceModel removeEventForAttribute:kAttrThermostatHeatsetpoint];
            [self.deviceModel removeEventForAttribute:kAttrThermostatCoolsetpoint];
            [self.deviceModel removeEventForAttribute:kAttrThermostatHvacmode];

            // If we have no more events then stop the timer and clear screen
            if (![self.deviceModel hasEvents])
                [self stopTimer];

            // If we still have more events then keep waiting screen up longer
        }
        [self checkCurrentAccountState];
    }
}

- (void)checkCurrentAccountState {
    if ([self.deviceModel isC2CDevice]) {
        BOOL requiresLogin = [HoneywellTCCCapability getRequiresLoginFromModel:self.deviceModel];

        if (requiresLogin) {
            [self showAlertBanner];
        } else {
            if (!self.deviceModel.isAuthorizedC2CDevice) {
                [self showAlertBanner];
            }
        }
    }
}

#pragma Device Function

- (void)turnThermostatAutoMode {
    // Honeywell Thermostats do not have access to Auto if therm:supportsAuto is false
    if ([self.deviceModel isC2CDevice] && ![ThermostatCapability getSupportsAutoFromModel:self.deviceModel]) {
        [self.controlCell displayAutoModeAlertForHoneywell];
        return;
    }
    
    [self commitThermostatMode:kEnumThermostatHvacmodeAUTO];
}

#pragma mark Show Event Banner
- (void)showAlertBanner {
    [self.controlCell displayBottomBannerWithColor:bottomAlertInPink
                                            vendor:self.deviceModel.vendor
                                          sideText:@""
                                          sideIcon:[UIImage imageNamed:@"icon_c2c_success"]];
}

- (void)showWaitingBanner {
    [self.controlCell displayGreyOverlay:YES];
    [self.controlCell displayBottomBannerWithColor:bottomAlertInGray
                                            vendor:self.deviceModel.vendor
                                          sideText:@"Waiting for"
                                          sideIcon:[UIImage imageNamed:@"icon_c2c_success"]];
}

- (void)closeBanner {
    [self.controlCell displayGreyOverlay:NO];
    [self.controlCell hideBottomBanner];
}

#pragma mark Honeywell Event Timer

- (void)startTimerWithDuration:(NSTimeInterval)duration  {
    // Stop the timer if it's active
    [self stopTimer];

    dispatch_async(dispatch_get_main_queue(), ^{
        // Show waiting screen if not already shown
        [self showWaitingBanner];

        // Start the timer over
        _waitEventTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    });
}

/**
 * Explicitely stop the timer and remove the attribute that stopped it
 */
- (void)stopTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_waitEventTimer != nil) {
            [_waitEventTimer invalidate];
            _waitEventTimer = nil;

            [self closeBanner];
        }
    });
}

/**
 * Timer fired without resolution
 */
- (void)timerFired:(NSTimer*)timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        _waitEventTimer = nil;

        [self closeBanner];
    });
}

@end
