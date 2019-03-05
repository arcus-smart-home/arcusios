//
//  DeviceDetailsSomfyBlinds.m
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
#import "DeviceDetailsSomfyBlinds.h"
#import "DeviceButtonBaseControl.h"
#import "Somfyv1Capability.h"

const float kEventDuration = 5;

@interface DeviceDetailsBase ()

- (void)animateRubberBandExpand:(UIView *)ringLogo;
- (void)animateRubberBandContract:(UIView *)ringLogo;

@end

@interface DeviceDetailsSomfyBlinds()

@property (strong, nonatomic) NSTimer *waitEventTimer;

@property (nonatomic, strong) DeviceButtonBaseControl *leftButton;
@property (nonatomic, strong) DeviceButtonBaseControl *centerButton;
@property (nonatomic, strong) DeviceButtonBaseControl *rightButton;
@property (nonatomic, strong) UIView *logoView;
@end


@implementation DeviceDetailsSomfyBlinds

- (void)configureCellWithLogo:(UIView *)logoView
                   leftButton:(DeviceButtonBaseControl *)leftButton
                 centerButton:(DeviceButtonBaseControl *)centerButton
                  rightButton:(DeviceButtonBaseControl *)rightButton
                   upDownMode:(BOOL)mode {

    self.logoView = logoView;
    self.leftButton = leftButton;
    self.centerButton = centerButton;
    self.rightButton = rightButton;

    if (!mode) {
        [self.leftButton setDefaultStyle:NSLocalizedString(@"OPEN", nil) withSelector:@selector(openButtonPressed:) owner:self];
        [self.centerButton setDefaultStyle:NSLocalizedString(@"CLOSE", nil) withSelector:@selector(closeButtonPressed:) owner:self];
        [self.rightButton setDefaultStyle:NSLocalizedString(@"FAV", nil) withSelector:@selector(favButtonPressed:) owner:self];
    } else {
        [self.leftButton setDefaultStyle:NSLocalizedString(@"UP", nil) withSelector:@selector(upButtonPressed:) owner:self];
        [self.centerButton setDefaultStyle:NSLocalizedString(@"DOWN", nil) withSelector:@selector(downButtonPressed:) owner:self];
        [self.rightButton setDefaultStyle:NSLocalizedString(@"FAV", nil) withSelector:@selector(favButtonPressed:) owner:self];
    }
}

- (void)openButtonPressed: (UIButton *)sender {
    [self startTimerWithDuration:kEventDuration];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [Somfyv1Capability goToOpenOnModel:self.deviceModel];
    });
}

- (void)closeButtonPressed: (UIButton *)sender {
    [self startTimerWithDuration:kEventDuration];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [Somfyv1Capability goToClosedOnModel:self.deviceModel];
    });}

- (void)upButtonPressed: (UIButton *)sender {
    [self startTimerWithDuration:kEventDuration];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [Somfyv1Capability goToOpenOnModel:self.deviceModel];
    });
}

- (void)downButtonPressed: (UIButton *)sender {
    [self startTimerWithDuration:kEventDuration];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [Somfyv1Capability goToClosedOnModel:self.deviceModel];
    });
}

- (void)favButtonPressed: (UIButton *)sender {
    [self startTimerWithDuration:kEventDuration];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Somfyv1Capability goToFavoriteOnModel:self.deviceModel];
    });
}

- (void)disableButtons:(BOOL)disable {
    self.leftButton.button.enabled = !disable;
    self.centerButton.button.enabled = !disable;
    self.rightButton.button.enabled = !disable;
}

#pragma mark Honeywell Event Timer

- (void)startTimerWithDuration:(NSTimeInterval)duration  {
    // Stop the timer if it's active
    [self stopTimer];

    dispatch_async(dispatch_get_main_queue(), ^{
        // Show waiting screen if not already shown
        [self disableButtons:YES];

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

            [self disableButtons:NO];
        }
    });
}

/**
 * Timer fired without resolution
 */
- (void)timerFired:(NSTimer*)timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        _waitEventTimer = nil;

        [self disableButtons:NO];
    });
}

@end
