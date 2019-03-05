//
//  DeviceDetailsDimmer.m
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
#import "DeviceDetailsDimmer.h"
#import "DeviceButtonBaseControl.h"
#import "UIView+Animation.h"
#import "SwitchCapability.h"
#import "DimmerCapability.h"
#import "PopupSelectionNumberView.h"
#import "ColorCapability.h"
#import "LightCapability.h"
#import "ColorTemperatureCapability.h"
#import "ServiceControlCell.h"
#import <i2app-Swift.h>

#define kDimmerMinBrightnessValue   0
#define kDimmerMaxBrightnessValue   100

#define DIMMER_ON                   YES
#define DIMMER_OFF                  NO

@interface DeviceDetailsDimmer ()

@property (nonatomic, assign) int brightnessValueForDisplay;
@property (nonatomic, assign) BOOL switchStateOnValueForDisplay;

@end

@implementation DeviceDetailsDimmer {
    CAShapeLayer                *_backgoundCircleLayer;
    CAShapeLayer                *_foregoundCircleLayer;
}

@dynamic colorType;

- (void)loadData {
    [self.controlCell.bottomButton setTitle:nil forState:UIControlStateNormal];
    [self.controlCell.bottomButton setImage:[UIImage imageNamed:@"rgb_filled_white"]
                       forState:UIControlStateNormal];

    self.controlCell.bottomButtonWidth.constant = 45.0f;
    self.controlCell.bottomButtonHeight.constant = 45.0f;

    [self loadDataDetails];
    self.delegate = (id<DeviceDetailsDimmerDelegate>)self.controlCell;
    [self refresh];

    [self.controlCell.bottomButton addTarget:self.delegate action:@selector(colorConfigButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.controlCell.bottomButton.hidden = self.colorType == LightColorTypeNone;

    [self.controlCell bringSubviewToFront:self.controlCell.bottomButton];

    [self updateErrorState];
}

- (void)loadDataDetails {
    self.controlCell.centerIcon.layer.cornerRadius = self.controlCell.centerIcon.frame.size.width / 2.0f;
    self.controlCell.centerIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.controlCell.leftButton setDefaultStyle:NSLocalizedString(@"ON", nil) withSelector:@selector(pressedOnButton:) owner:self];
    [self.controlCell.rightButton setDefaultStyle:NSLocalizedString(@"OFF", nil) withSelector:@selector(pressedOffButton:) owner:self];
    
    self.controlCell.centerIcon.layer.masksToBounds = NO;
    
    if (!_backgoundCircleLayer) {
        _backgoundCircleLayer = [self.controlCell.centerIcon createCircleFrame:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
        [self.controlCell.centerIcon.layer addSublayer:_backgoundCircleLayer];
    }
    if (!_foregoundCircleLayer) {
        _foregoundCircleLayer = [self.controlCell.centerIcon createCircleFrame:[[self getOnlineColor:0.75] colorWithAlphaComponent:0.6f]];
        [self.controlCell.centerIcon.layer addSublayer:_foregoundCircleLayer];
    }
    _foregoundCircleLayer.strokeEnd = aDimmerCirclePoint(0);
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
        [self.delegate popup:numberPicker complete:@selector(brightnessUpdate:) withOwner:self];
    } else {
        [self updateUIForDimmerState:DIMMER_ON withBrightness:self.brightnessValueForDisplay];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }
    self.switchStateOnValueForDisplay = DIMMER_ON;
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
//The brightness parameter is ignoed if the dimmer state is off, so that the card always shows no brightness when off
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

//Helper function that sets the dimmer UI
- (void)updateDimmerUI:(int)percentage {
    CGFloat newPercentage = aDimmerCirclePoint(percentage / 100.0f);
    CGFloat currentStrokeEnd = _foregoundCircleLayer.strokeEnd;
    
    CABasicAnimation *stroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    stroke.fromValue = @(currentStrokeEnd - 0.025);
    stroke.toValue = @(newPercentage - 0.025);
    stroke.duration = 0.5f;

    if (fabs(newPercentage - currentStrokeEnd) < 0.001) {//Can't simply check they're equal because of precision; Don't animate to a value if we're already animating to it
        [_foregoundCircleLayer addAnimation:stroke forKey:nil];
    }
    _foregoundCircleLayer.strokeEnd = newPercentage;
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

#pragma mark - override
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([attributes objectForKey:kAttrLightColormode] != nil) {
            self.controlCell.bottomButton.hidden = self.colorType == LightColorTypeNone;
        }

        if ([attributes objectForKey:kAttrLightColormode] != nil) {
            self.controlCell.bottomButton.hidden = self.colorType == LightColorTypeNone;
        }
        
        if ([attributes objectForKey:kAttrColorSaturation] != nil
            || [attributes objectForKey:kAttrColorHue] != nil
            || [attributes objectForKey:kAttrColorTemperatureColortemp] != nil
            || [attributes objectForKey:kAttrLightColormode] != nil) {

            if (_foregoundCircleLayer) {
                [_foregoundCircleLayer removeFromSuperlayer];
            }
            
            _foregoundCircleLayer = [self.controlCell.centerIcon createCircleFrame:[[self getOnlineColor:0.75] colorWithAlphaComponent:0.6f]];
            [self.controlCell.centerIcon.layer addSublayer:_foregoundCircleLayer];
        }
        
        self.brightnessValueForDisplay = [DimmerCapability getBrightnessFromModel:self.deviceModel];
        self.switchStateOnValueForDisplay = [self.deviceModel isSwitchedOn];
        
        [self updateUIForDimmerState:self.switchStateOnValueForDisplay withBrightness:self.brightnessValueForDisplay];
    });
}

#pragma mark - Device Color

- (ArcusNormalColorTempSelectionViewController*)colorPickerUsingDelegate:(id) delegate {
    ColorSelectionType initialSelection = self.currentColorMode;
    
    switch (self.colorType) {
        case LightColorTypeNone:
            return nil;   // No color picker for on/off/dim bulbs
        case LightColorTypeColor:
            return [self colorPickerForType:initialSelection withColor:YES andTemperature:NO andNormal:NO usingDelegate: delegate];
            break;
        case LightColorTypeColorNormal:
            return [self colorPickerForType:initialSelection withColor:YES andTemperature:NO andNormal:YES usingDelegate: delegate];
            break;
        case LightColorTypeTemperature:
            return [self colorPickerForType:initialSelection withColor:NO andTemperature:YES andNormal:NO usingDelegate: delegate];
            break;
        case LightColorTypeTemperatureNormal:
            return [self colorPickerForType:initialSelection withColor:NO andTemperature:YES andNormal:YES usingDelegate: delegate];
            break;
        case LightColorTypeColorTemperatureNormal:
            return [self colorPickerForType:initialSelection withColor:YES andTemperature:YES andNormal:YES usingDelegate: delegate];
            break;
    }
}

- (ArcusNormalColorTempSelectionViewController*)colorPickerForType:(ColorSelectionType) type withColor:(BOOL) showColor andTemperature:(BOOL) showTemp andNormal:(BOOL) showNormal usingDelegate:(id) delegate {

    NSAssert(showColor || showTemp, @"One or more color modes (color or temperature) must be enabled.");
    
    // Has no effect on unsupported color picker modes or devices that don't support these attributes
    double minValue = [ColorTemperatureCapability getMincolortempFromModel:self.deviceModel];
    double maxValue = [ColorTemperatureCapability getMaxcolortempFromModel:self.deviceModel];
    double currentValue = [ColorTemperatureCapability getColortempFromModel:self.deviceModel];
    
    int hue = [ColorCapability getHueFromModel:self.deviceModel];
    int saturation = [ColorCapability getSaturationFromModel:self.deviceModel];
    UIColor *currentColor = [UIColor colorWithHue:hue/360.0 saturation:saturation/100.0 brightness:0.75 alpha:1];
    
    ArcusNormalColorTempSelectionViewController *colorSelectionViewController;
    
    if (showNormal && showColor && showTemp) {
        colorSelectionViewController = [ArcusNormalColorTempSelectionViewController create];
    } else if (showNormal && showColor) {
        colorSelectionViewController = [ArcusNormalColorSelectionViewController create];
    } else if (showNormal && showTemp) {
        colorSelectionViewController = [ArcusNormalTempSelectionViewController create];
    } else if (showColor) {
        colorSelectionViewController = [ArcusColorSelectionViewController create];
    } else if (showTemp) {
        colorSelectionViewController = [ArcusTempSelectionViewController create];
    }

    colorSelectionViewController.selectionType = type;
    colorSelectionViewController.currentColor = currentColor;
    colorSelectionViewController.colorTemperatureMin = minValue;
    colorSelectionViewController.colorTemperatureMax = maxValue;
    colorSelectionViewController.currentTemperature = currentValue;
    colorSelectionViewController.delegate = delegate;
    
    return colorSelectionViewController;
}

- (LightColorType)colorType {
    BOOL supportsRGB = [self.deviceModel isRGBLight];
    BOOL supportsTemp = [self.deviceModel isColorTemperatureLight];
    BOOL supportsNormal = [self.deviceModel isColorModeLight];
    
    if (supportsRGB && supportsTemp && supportsNormal) {
        return LightColorTypeColorTemperatureNormal;
    } else if (supportsNormal && supportsRGB) {
        return LightColorTypeColorNormal;
    } else if (supportsRGB) {
        return LightColorTypeColor;
    } else if (supportsNormal && supportsTemp) {
        return LightColorTypeTemperatureNormal;
    } else if (supportsTemp) {
        return LightColorTypeTemperature;
    } else {
        return LightColorTypeNone;
    }
}

-(ColorSelectionType)currentColorMode {
    
    if ([self.deviceModel isColorModeLight]) {
        if ([kEnumLightColormodeNORMAL isEqualToString:[LightCapability getColormodeFromModel:self.deviceModel]]) {
            return ColorSelectionTypeNormal;
        } else if ([kEnumLightColormodeCOLOR isEqualToString:[LightCapability getColormodeFromModel:self.deviceModel]]) {
            return ColorSelectionTypeColor;
        } else if ([kEnumLightColormodeCOLORTEMP isEqualToString:[LightCapability getColormodeFromModel:self.deviceModel]]) {
            return ColorSelectionTypeTemperature;
        }
    }
    
    else if ([self.deviceModel isColorTemperatureLight]) {
        return ColorSelectionTypeTemperature;
    }
    
    return ColorSelectionTypeColor;
}

- (UIColor *)getOnlineDisplayColor {
    return [self getOnlineColor:0.75];
}

- (UIColor *)getOnlineColor:(double)brightness {
    if (self.deviceModel) {
        int hue = [ColorCapability getHueFromModel:self.deviceModel];
        int saturation = [ColorCapability getSaturationFromModel:self.deviceModel];
        int colorTemp = [ColorTemperatureCapability getColortempFromModel:self.deviceModel];
        
        switch (self.currentColorMode) {
            case ColorSelectionTypeNormal:
                return [UIColor whiteColor];
                break;
                
            case ColorSelectionTypeColor:
                return [UIColor colorWithHue:hue/360.0 saturation:saturation/100.0 brightness:brightness alpha:1.0];
                break;
                
            case ColorSelectionTypeTemperature:
                return [UIColor colorWithKelvin:colorTemp];
                break;
        }
    }

    return [UIColor whiteColor];
}

@end
