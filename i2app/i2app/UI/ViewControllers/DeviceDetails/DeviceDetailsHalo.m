//
//  DeviceDetailsHalo.m
//  i2app
//
//  Created by Arcus Team on 8/30/16.
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
#import "DeviceDetailsHalo.h"
#import "DeviceButtonBaseControl.h"
#import "UIView+Animation.h"
#import "SwitchCapability.h"
#import "DimmerCapability.h"
#import "PopupSelectionNumberView.h"
#import "ColorCapability.h"
#import "ColorTemperatureCapability.h"
#import "DevicePowerCapability.h"
#import "ServiceControlCell.h"
#import "HaloCapability.h"
#import "DeviceController.h"
#import "UIView+Overlay.h"

#define kDimmerMinBrightnessValue   0
#define kDimmerMaxBrightnessValue   100

#define DIMMER_ON                   YES
#define DIMMER_OFF                  NO

@interface DeviceDetailsHalo ()

@property (nonatomic, assign) int brightnessValueForDisplay;
@property (nonatomic, assign) BOOL switchStateOnValueForDisplay;

@end

@implementation DeviceDetailsHalo {
    CAShapeLayer                *_backgoundCircleLayer;
    CAShapeLayer                *_foregoundCircleLayer;
}

- (instancetype)initWithDeviceId:(NSString *)modelId {
    if (self = [super init]) {
        self.deviceId = modelId;
    }
    return self;
}

- (void)loadData {
    [self.controlCell.bottomButton setTitle:nil forState:UIControlStateNormal];
    [self.controlCell.bottomButton setImage:[UIImage imageNamed:@"rgb_filled_white"]
                       forState:UIControlStateNormal];

    self.controlCell.bottomButtonWidth.constant = 45.0f;
    self.controlCell.bottomButtonHeight.constant = 45.0f;

    [self loadDetailData];
    [self refresh];

    self.controlCell.bottomButton.hidden = NO;
    [self.controlCell.bottomButton addTarget:self.controlCell action:@selector(colorConfigButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.controlCell bringSubviewToFront:self.controlCell.bottomButton];

    NSDictionary *errors = [self getAllErrors:self.deviceModel];
    if (errors.count > 0) {
        if (errors.count == 1) {
            [self.controlCell addErrorOverlay:errors.allValues[0] withSelector:@selector(onClickBackgroup:)];
        }
        else {
            // Display "Multiple Errors"
            [self.controlCell addErrorOverlay:@"Multiple Errors" withSelector:@selector(onClickBackgroup:)];
        }
    }
}

- (void)loadDetailData {

    self.controlCell.centerIcon.layer.cornerRadius = self.controlCell.centerIcon.frame.size.width / 2.0f;
    self.controlCell.centerIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.controlCell.leftButton setDefaultStyle:NSLocalizedString(@"ON", nil) withSelector:@selector(pressedOnButton:) owner:self];
    [self.controlCell.rightButton setDefaultStyle:NSLocalizedString(@"OFF", nil) withSelector:@selector(pressedOffButton:) owner:self];
    
    self.controlCell.centerIcon.layer.masksToBounds = NO;

    if (!_backgoundCircleLayer) {
        [_backgoundCircleLayer removeFromSuperlayer];
        _backgoundCircleLayer = [self.controlCell.centerIcon createCircleFrame:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
        [self.controlCell.centerIcon.layer addSublayer:_backgoundCircleLayer];
    }
    
    if (_foregoundCircleLayer) {
        [_foregoundCircleLayer removeFromSuperlayer];
    }
    _foregoundCircleLayer = [self.controlCell.centerIcon createCircleFrame:[[self getOnlineColor:0.75] colorWithAlphaComponent:0.6f]];
    [self.controlCell.centerIcon.layer addSublayer:_foregoundCircleLayer];

    _foregoundCircleLayer.strokeEnd = aDimmerCirclePoint([DimmerCapability getBrightnessFromModel:self.deviceModel] / 100);
}

- (void)refresh {
    [self updateDeviceState:nil initialUpdate:NO];
}

#pragma mark - actions
- (void)pressedOnButton:(DeviceButtonBaseControl *)onButton {
    if (self.switchStateOnValueForDisplay) {
        PopupSelectionNumberView *numberPicker = [PopupSelectionNumberView create:@"BRIGHTNESS" withMinNumber:10 maxNumber:100 stepNumber:10 withSign:@"%"];
        
        NSInteger currentValue = self.brightnessValueForDisplay;
        currentValue = ((NSInteger)(currentValue / 10) * 10);
        if (currentValue < 10) currentValue = 10;
        if (currentValue > 100) currentValue = 100;
        
        [numberPicker setCurrentKey:@(currentValue)];
        [self.controlCell popup:numberPicker complete:@selector(brightnessUpdate:) withOwner:self];
    } else {
        NSString *powerSource = [DevicePowerCapability getSourceFromModel:self.deviceModel];
        if (![powerSource isEqualToString:kEnumDevicePowerSourceLINE]) {
            [self displayDeviceBatteryPoweredMessage];
            return;
        }
        [self updateUIForDimmerState:DIMMER_ON withBrightness:self.brightnessValueForDisplay];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }
    self.switchStateOnValueForDisplay = DIMMER_ON;
}


- (void)displayDeviceBatteryPoweredMessage {
    [self.controlCell.parentController popupMessageWindow:@"Battery powered" subtitle:@"Battery powered message"];
}

- (void)brightnessUpdate:(NSNumber *)value {
    int newBrightness = [value intValue];
    self.brightnessValueForDisplay = newBrightness;
    self.switchStateOnValueForDisplay = DIMMER_ON;
    [self updateUIForDimmerState:DIMMER_ON withBrightness:self.brightnessValueForDisplay];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DimmerCapability setBrightness:newBrightness onModel:self.deviceModel];
        if (![self.deviceModel isSwitchedOn]) {
            [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];
        }
        [self.deviceModel commit];
    });
}

- (void)pressedOffButton:(DeviceButtonBaseControl *)offButton {
    self.switchStateOnValueForDisplay = NO;
    [self updateUIForDimmerState:self.switchStateOnValueForDisplay withBrightness:self.brightnessValueForDisplay];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([self.deviceModel isSwitchedOn]) {
            [SwitchCapability setState:kEnumSwitchStateOFF onModel:self.deviceModel];
            [self.deviceModel commit];
        }
    });
}

#pragma mark - UI
//Updates the UI for the given dimmer state and brightness, to condense UI logic to one place
//The brightness parameter is ignored if the dimmer state is off, so that the card always shows no brightness when off
- (void)updateUIForDimmerState:(BOOL)deviceIsOn withBrightness:(int)brightness {
    if (deviceIsOn) {
        [self.controlCell.rightButton setDisable:NO];
        [self.controlCell.leftButton setDisable:NO];
        
        [self.controlCell.leftButton setLabelText:[NSString stringWithFormat:@"%d%%", brightness]];
        if (![self.deviceModel isSwitch] && brightness == 0) {
            [self.controlCell.leftButton setLabelText:NSLocalizedString(@"ON", nil)];
        }
        
        [self updateDimmerUI:brightness];
    } else {
        [self.controlCell.rightButton setDisable:YES];
        [self.controlCell.leftButton setDisable:NO];
        
        [self.controlCell.leftButton setLabelText:NSLocalizedString(@"ON", nil)];
        [self updateDimmerUI:0];
    }
}

// Helper function that sets the dimmer UI
- (void)updateDimmerUI:(int)brightness {
    CGFloat newPercentage = aDimmerCirclePoint(brightness / 100.0f);
    CGFloat currentStrokeBeginning = _foregoundCircleLayer.strokeEnd;
    
    CABasicAnimation *stroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    stroke.fromValue = @(currentStrokeBeginning - 0.025);
    stroke.toValue = @(newPercentage - 0.025);
    stroke.duration = 0.5f;

    if (brightness == 0) {
        if (_foregoundCircleLayer) {
            [_foregoundCircleLayer removeFromSuperlayer];
            _foregoundCircleLayer = nil;
        }
    }
    else {
        if (fabs(newPercentage - currentStrokeBeginning) < 0.001) {
            // Can't simply check they're equal because of precision; Don't animate
            // to a value if we're already animating to it
            [_foregoundCircleLayer addAnimation:stroke forKey:nil];
        }
        _foregoundCircleLayer.strokeEnd = newPercentage;
    }
}

#pragma mark - override
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.brightnessValueForDisplay = [DimmerCapability getBrightnessFromModel:self.deviceModel];
        self.switchStateOnValueForDisplay = [self.deviceModel isSwitchedOn];
        [self updateUIForDimmerState:self.switchStateOnValueForDisplay
                      withBrightness:self.brightnessValueForDisplay];

        if ([attributes objectForKey:kAttrColorSaturation] != nil
            || [attributes objectForKey:kAttrColorHue] != nil
            || [attributes objectForKey:kAttrColorTemperatureColortemp]) {

            if (_foregoundCircleLayer) {
                [_foregoundCircleLayer removeFromSuperlayer];
            }
            _foregoundCircleLayer = [self.controlCell.centerIcon createCircleFrame:[[self getOnlineColor:0.75] colorWithAlphaComponent:0.6f]];
            [self.controlCell.centerIcon.layer addSublayer:_foregoundCircleLayer];
        }
    });
}

#pragma mark - Device Color

- (UIColor *)getOnlineDisplayColor {
    return [self getOnlineColor:0.75];
}

- (UIColor *)getOnlineColor:(double)brightness {
    if (self.deviceModel) {
        int hue = [ColorCapability getHueFromModel:self.deviceModel];
        int saturation = [ColorCapability getSaturationFromModel:self.deviceModel];

        return [UIColor colorWithHue:hue/360.0
                          saturation:saturation/100.0
                          brightness:brightness
                               alpha:1.0];
    }

    return [UIColor whiteColor];
}

#pragma mark - Device Errors
- (NSDictionary *)getAllErrors:(DeviceModel *)device {
    NSDictionary *errors = [DeviceController getDeviceErrors:device];
    if ([self isInPreSmokeState:[HaloCapability getDevicestateFromModel:device]]) {
        // add the pre smoke error message
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:errors];
        [dict setObject:@"Early Smoke Warning" forKey:kEnumHaloDevicestatePRE_SMOKE];
        errors = dict.copy;
    }
    return errors;
}

- (BOOL)isInPreSmokeState:(NSString *)state {
    if ([state isEqualToString:kEnumHaloDevicestateSAFE]) {
        // no warnings to display
        return NO;
    }

    if ([state containsString:kEnumHaloDevicestatePRE_SMOKE]) {
        return YES;
    }
    return NO;
}

@end
