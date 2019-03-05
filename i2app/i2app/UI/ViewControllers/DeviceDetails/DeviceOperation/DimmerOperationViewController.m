//
//  DimmerOperationViewController.m
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
#import "DimmerOperationViewController.h"
#import "DeviceDetailsDimmer.h"
#import <PureLayout/PureLayout.h>
#import "DimmerCapability.h"
#import "SwitchCapability.h"
#import "ColorCapability.h"
#import "LightCapability.h"
#import "ColorTemperatureCapability.h"
#import "PowerUseCapability.h"
#import <i2app-Swift.h>

#import "DeviceControlViewController.h"
#import "DeviceDetailsTabBarController.h"

#import "DeviceButtonLabelledSwitchControl.h"

#define kDimmerMinBrightnessValue 1
#define kDimmerMaxBrightnessValue 100

@interface DimmerOperationViewController () <ArcusColorSelectionDelegate>

@property (nonatomic, assign, readonly) DeviceDetailsDimmer *deviceOpDetails;

@property (nonatomic, strong) DevicePercentageAttributeControl *brightnessControl;
@property (nonatomic, strong) DeviceTextWithUnitAttributeControl *energyControl;
@property (nonatomic, strong) DeviceButtonBaseControl *rgbButton;
@property (nonatomic, strong) DeviceButtonSwitchControl *switchBtn;
@property (atomic, assign) NSInteger errorBannerTag;

@end

@implementation DimmerOperationViewController

@dynamic deviceOpDetails;

#pragma mark - Life Cycle

- (void)loadDeviceAbilities {
    self.deviceAbilities = [self.deviceModel isSwitch] ? AdjusterDeviceAbilityAttributesView | AdjusterDeviceAbilityButtonsView : AdjusterDeviceAbilityAttributesView;
}

- (DeviceDetailsDimmer *)deviceOpDetails {
    return (DeviceDetailsDimmer *)super.deviceOpDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureButtonViewForLightType];
    [self configureAttributesView]; 
}

#pragma mark - UI Configuration

- (void)configureButtonViewForLightType {
    switch (self.deviceOpDetails.colorType) {
        case LightColorTypeNone:
            [self.buttonsView loadControl:self.switchBtn];
            break;

        // All other modes show color settings button
        default:
            [self.buttonsView loadControl:self.switchBtn control2:self.rgbButton control3:nil withHorizSpacing:0.0];
            break;
    }
}

- (void)configureAttributesView {
    if (self.deviceModel.deviceSupportsPower) {
        [self.attributesView loadControl:self.brightnessControl control2:self.energyControl];
    } else {
        [self.attributesView loadControl:self.brightnessControl];
    }
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:animated];

    UIColor *displayColor = [self getOnlineDisplayColor];
    if (displayColor != [UIColor whiteColor]) {
      [super addColoredOverlay:displayColor];
    } else {
      [super removeColoredOverlay];
    }

    [self setSliderBarColor:displayColor];
}

- (void)deviceWillDisappear:(BOOL)animated {
    [super deviceWillDisappear:animated];
    [super removeColoredOverlay];
}


#pragma mark - Switch Handling
- (void)switchOn {
    _switchBtn.button.selected = YES;
}

- (void)switchOff {
    _switchBtn.button.selected = NO;
}

- (void)toggle {
    if (_switchBtn.button.selected) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [SwitchCapability setState:kEnumSwitchStateOFF onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }
}

- (void)rgbButtonPressed:(id)sender {
    
    ArcusNormalColorTempSelectionViewController* picker = [self.deviceOpDetails colorPickerUsingDelegate:self];
    
    if (picker) {
        [self.deviceController.tabBarController presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - Getters & Setters

- (DevicePercentageAttributeControl *)brightnessControl {
    if (!_brightnessControl) {
        _brightnessControl = [DevicePercentageAttributeControl createWithPercentage:82 title:NSLocalizedString(@"Brightness", nil)];
    }
    return _brightnessControl;
}

- (DeviceTextWithUnitAttributeControl *)energyControl {
    if (!_energyControl) {
        NSString *instantaneousUse = [[self.deviceModel getAttribute:kAttrPowerUseInstantaneous] stringValue];

        if (!instantaneousUse) {
            instantaneousUse = @"0";
        }

        _energyControl = [DeviceTextWithUnitAttributeControl create:NSLocalizedString(@"Energy", nil) withValue:instantaneousUse andUnit:@"W"];
    }
    return _energyControl;
}

- (DeviceButtonBaseControl *)rgbButton {
    if (!_rgbButton) {
        _rgbButton = [DeviceButtonBaseControl create:[UIImage imageNamed:@"rgb_filled_white"]
                                                name:@""
                                        withSelector:@selector(rgbButtonPressed:)
                                               owner:self
                                         shiftButton:YES];
    }
    return _rgbButton;
}

- (DeviceButtonSwitchControl *)switchBtn {
    if (!_switchBtn) {
        __block typeof(self) blockSelf = self;
        _switchBtn = [DeviceButtonSwitchControl create:^BOOL(id sender) {
            [blockSelf toggle];
            return YES;
        } withUnselect:^BOOL(id sender) {
            [blockSelf toggle];
            return YES;
        }];
    }
    
    return _switchBtn;
}

#pragma mark - override with call back when value change

// for update value to platform
- (BOOL)submitChangedValue:(int)value becauseOf:(ValueChangeCause)reason {

    if (value < kDimmerMinBrightnessValue) {
        value = kDimmerMinBrightnessValue;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DimmerCapability setBrightness:value onModel:self.deviceModel];
        [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];    // Always turn on switch when brightness is changed
        
        [self.deviceModel commit];
    });

    return YES;
}

// for update UI change
- (void)adjusterValueChanged:(int)percentageValue {
    [self.brightnessControl setPercentage:percentageValue];
}

- (void)handleTap:(id)sender {
    // No behavior defined when user taps device icon; don't do anything
}

- (BOOL)isOn {
    NSString *state = [SwitchCapability getStateFromModel:self.deviceModel];
    return [state isEqualToString:kEnumSwitchStateON];
}


#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    
    if ([attributes objectForKey:kAttrSwitchState] != nil) {
        if ([kEnumSwitchStateOFF isEqualToString:[attributes objectForKey:kAttrSwitchState]]) {
            [self switchOff];
        } else {
            [self switchOn];
        }
    }
    
    if ([attributes objectForKey:kAttrDimmerBrightness] != nil) {
        int updatedPercentageValue = [DimmerCapability getBrightnessFromModel:self.deviceModel];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        NSMutableDictionary *attributesDictionary = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        [attributesDictionary setObject:@(updatedPercentageValue) forKey:@"percentageValue"];
        [self updateUIWithAttributes:attributesDictionary];
    }

    id powerUse = [self.deviceModel getAttribute:kAttrPowerUseInstantaneous];
    if ( powerUse && ![powerUse isEqual:[NSNull null]]) {
        NSString *instantaneousUse = [[self.deviceModel getAttribute:kAttrPowerUseInstantaneous] stringValue];
        [self.energyControl setValueText:instantaneousUse];
    }

    NSString *colorMode = [attributes objectForKey:kAttrLightColormode];
    NSString *colorSautration = [attributes objectForKey:kAttrColorSaturation];
    NSString *colorHue = [attributes objectForKey:kAttrColorHue];
    NSString *colorTemp = [attributes objectForKey:kAttrColorTemperatureColortemp];
    
    // Update slider color anytime color mode, saturation, hue or temp change on the platform
    if (colorMode || colorSautration || colorHue || colorTemp) {
        if ([colorMode isEqualToString:kEnumLightColormodeNORMAL]) {
            [super removeColoredOverlay];
            [self setSliderBarColor:[UIColor whiteColor]];
        } else {
            UIColor *displayColor = [self getOnlineDisplayColor];
            if (displayColor != [UIColor whiteColor]) {
              [super addColoredOverlay:[self getOnlineDisplayColor]];
            } else {
              [super removeColoredOverlay];
            }

            [self setSliderBarColor:[self getOnlineDisplayColor]];
        }
    }
    [self updateErrorBanner];
}

- (void)updateUIWithAttributes:(NSDictionary *)attributes {
    id percentageValue = [attributes objectForKey:@"percentageValue"];
    [self updateUIWithPercentage:[percentageValue intValue] andAttributes:attributes];
}

- (void)updateUIWithPercentage:(int)percentage andAttributes:(NSDictionary *)attributes {
    if ([self hasBrightnessChange:attributes] && ![self hasSwitchStateChange:attributes]) {
        [self setAdjusterValue:percentage];
        [self.brightnessControl setPercentage:percentage];
    }

    if ([self hasSwitchStateChange:attributes]) {
        if ([self isOn]) {
            [self switchOn];
        } else {
            [self switchOff];
        }
        
        [self setAdjusterValue:percentage];
    }
}

- (BOOL)hasBrightnessChange:(NSDictionary *)attributes {
    for (NSString *key in attributes.allKeys) {
        if ([key isEqualToString: kAttrDimmerBrightness]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasSwitchStateChange:(NSDictionary *)attributes {
    for (NSString *key in attributes.allKeys) {
        if ([key isEqualToString: kAttrSwitchState]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - ArcusColorSelectionDelegate

- (void)didSelectColor:(UIColor *)color
                   hue:(double)hue
            saturation:(double)saturation
            brightness:(double)brightness
                 alpha:(double)alpha
                sender:(ArcusNormalColorTempSelectionViewController *)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [ColorCapability setHue:hue * 360 onModel:self.deviceModel];
        [ColorCapability setSaturation:saturation * 100 onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (void)didSelectColorTemperature:(UIColor *)color
                      temperature:(double)temperature
                           sender:(ArcusNormalColorTempSelectionViewController *)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [ColorTemperatureCapability setColortemp:(int)temperature onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (void)didChangeColorSelectionType:(enum ColorSelectionType)selectionType
                             sender:(ArcusNormalColorTempSelectionViewController *)sender {
    
    NSString *colorMode = [LightCapability getColormodeFromModel:self.deviceModel];
    if (selectionType == ColorSelectionTypeColor && ![colorMode isEqualToString:kEnumLightColormodeCOLOR]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [LightCapability setColormode:kEnumLightColormodeCOLOR
                                  onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    } else if (selectionType == ColorSelectionTypeTemperature && ![colorMode isEqualToString:kEnumLightColormodeCOLORTEMP]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [LightCapability setColormode:kEnumLightColormodeCOLORTEMP
                                  onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    } else if (selectionType == ColorSelectionTypeNormal && ![colorMode isEqualToString:kEnumLightColormodeNORMAL]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [LightCapability setColormode:kEnumLightColormodeNORMAL
                                  onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }
}
#pragma mark - Device Color

- (UIColor *)getOnlineDisplayColor {
    return [self getOnlineColor:0.75];
}

- (UIColor *)getOnlineColor:(double)brightness {
    if (self.deviceModel) {
        NSString *colorMode = [LightCapability getColormodeFromModel:self.deviceModel];
        if (colorMode) {
            if ([colorMode isEqualToString:kEnumLightColormodeCOLOR]) {
                int hue = [ColorCapability getHueFromModel:self.deviceModel];
                int saturation = [ColorCapability getSaturationFromModel:self.deviceModel];

                return [UIColor colorWithHue:hue/360.0
                                  saturation:saturation/100.0
                                  brightness:brightness
                                       alpha:1.0];
            } else if ([colorMode isEqualToString:kEnumLightColormodeCOLORTEMP]) {
                int colorTemp = [ColorTemperatureCapability getColortempFromModel:self.deviceModel];
                
                return [UIColor colorWithKelvin:colorTemp];
            } else if ([colorMode isEqualToString:kEnumLightColormodeNORMAL]) {
                return [UIColor whiteColor];
            }
        }
    }
    
    return [UIColor whiteColor];
}

#pragma mark - Error Handling State

- (void)updateErrorBanner {
    NSDictionary *errorsPrecheck = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
    if (errorsPrecheck != nil && errorsPrecheck.allKeys.count > 0 && ![self.deviceModel isDeviceOffline]) {
        [self dismissErrorBanner];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSDictionary *errors = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
            if (!(errors != nil  && errors.allKeys.count > 0  && ![self.deviceModel isDeviceOffline])){
                [self dismissErrorBanner];
                [self setFooterToPink:false];
                return;
            }
            if (errors[@"ERR_UNAUTHED_LUTRON"]) {
                [self showRevokedBanner];
            }
            else if (errors[@"ERR_DELETED_LUTRON"]) {
                [self showDeviceRemovedBanner];
            }
            else if (errors[@"ERR_BRIDGE_LUTRON"]) {
                [self showBridgeErrorBanner];
            }
            [self setFooterToPink:true];

        });
    } else {
        [self dismissErrorBanner];
        [self setFooterToPink:false];
    }
}

- (void)getSupportRevokedPressed {
  LutronRevokedViewController *vc = [LutronRevokedViewController create];
  [self.deviceController.navigationController presentViewController:vc animated:true completion:nil];
}

- (void)getSupportRemovedPressed {
  LutronDeviceRemovedViewController *vc = [LutronDeviceRemovedViewController create];
  [self.deviceController.navigationController presentViewController:vc animated:true completion:nil];
}

- (void)getSupportBridgeErrorPressed {
    [self getSupportPressed:@"err_bridge_lutron"];
}

- (void)getSupportPressed:(NSString *)error {
    NSString *deviceTypeHint = [DeviceCapability getDevtypehintFromModel:self.deviceModel];
    NSURL *productSupportUrl = [NSURL productSupportUrlWithDeviceType:deviceTypeHint
                                                            productId:self.deviceModel.productId
                                                            devadvErr:error];
    [[UIApplication sharedApplication] openURL:productSupportUrl];
}

- (void) dismissErrorBanner {
    if (self.errorBannerTag != NSNotFound) {
        [self closePopupAlert];
        self.errorBannerTag = NSNotFound;
    }
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
        NSString *text = NSLocalizedString(@"Lutron account information revoked", nil);
        self.errorBannerTag = [self popupLinkAlert:text
                                              type:AlertBarTypeWarning
                                         sceneType:AlertBarSceneInDevice
                                         grayScale:NO
                                          linkText:nil
                                          selector:@selector(getSupportRevokedPressed)
                                      displayArrow:YES];
    });
}

- (void)showDeviceRemovedBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = NSLocalizedString(@"Device removed in Lutron app", nil);
        self.errorBannerTag = [self popupLinkAlert:text
                                              type:AlertBarTypeWarning
                                         sceneType:AlertBarSceneInDevice
                                         grayScale:NO
                                          linkText:nil
                                          selector:@selector(getSupportRemovedPressed)
                                      displayArrow:YES];
    });
}

- (void)showBridgeErrorBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = NSLocalizedString(@"Lutron bridge has an error", nil);
        NSString *linkText = NSLocalizedString(@"Get Support", nil);
        self.errorBannerTag = [self popupLinkAlert:text
                                              type:AlertBarTypeWarning
                                         sceneType:AlertBarSceneInDevice
                                         grayScale:NO
                                          linkText:linkText
                                          selector:@selector(getSupportBridgeErrorPressed)
                                      displayArrow:YES];
    });
}

@end
