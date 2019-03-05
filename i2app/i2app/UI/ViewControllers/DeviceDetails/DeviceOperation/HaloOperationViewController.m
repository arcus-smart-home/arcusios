//
//  HaloOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 8/25/16.
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
#import "HaloOperationViewController.h"
#import "SwitchCapability.h"
#import "LightCapability.h"
#import "DimmerCapability.h"
#import "DevicePowerCapability.h"
#import "RelativeHumidityCapability.h"
#import "AtmosCapability.h"
#import "DeviceController.h"
#import "ColorCapability.h"
#import "WeatherRadioCapability.h"
#import "UIViewController+AlertBar.h"
#import "HaloCapability.h"

#import "DeviceButtonLabelledSwitchControl.h"
#import "HaloAttributeGroupView.h"
#import "DeviceButtonLabelledControl.h"
#import <PureLayout/PureLayout.h>
#import "DeviceControlViewController.h"
#import "DeviceDetailsTabBarController.h"
#import "DeviceAdvancedCapability.h"
#import "MultipleErrorsViewController.h"
#import "UIViewController+AlertBar.h"
#import "DeviceDetailsHalo.h"
#import <i2app-Swift.h>

const int kHaloMinBrightnessValue = 1;
const int kHaloMaxBrightnessValue = 100;

@interface HaloOperationViewController () <ArcusColorSelectionDelegate>

@property (weak, nonatomic) IBOutlet HaloAttributeGroupView *haloAttributesView;

@property (nonatomic, strong) DevicePercentageAttributeControl *brightnessControl;
@property (nonatomic, strong) DevicePercentageAttributeControl *batteryControl;
@property (nonatomic, strong) DeviceTextIconAttributeControl *batteryACLineControl;
@property (nonatomic, strong) DeviceButtonLabelledControl *rgbButton;
@property (nonatomic, strong) DeviceButtonLabelledControl *radioButton;
@property (nonatomic, strong) DeviceButtonLabelledSwitchControl *lightSwitch;
@property (atomic, assign) BOOL isHaloPlus;

@property (atomic, strong) HaloWeatherRadioPresenter *presenter;

@property (nonatomic, weak) DeviceDetailsHalo *haloDeviceDetails;
@property (atomic, assign) NSInteger errorBannerTag;

@end

@implementation HaloOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.errorBannerTag = NSNotFound;

    [self configureAttributesView];
    [self configureButtonsView];
    [self configureImageAttributesView];

    self.presenter = [[HaloWeatherRadioPresenter alloc] initWithDeviceModel:self.deviceModel];
    [self setPlayButtonState];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setPlayButtonState)
                                                 name:[Model attributeChangedNotification:kAttrWeatherRadioPlayingstate]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(renderDisplayColor)
                                                 name:[Model attributeChangedNotification:kAttrColorHue]
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self deviceDidAppear:YES];
}

- (DeviceDetailsHalo *)haloDeviceDetails {
    return  (DeviceDetailsHalo *)self.deviceOpDetails;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = AdjusterDeviceAbilityButtonsView | AdjusterDeviceAbilityAttributesView;
}

- (void)configureAttributesView {
    self.brightnessControl = [DevicePercentageAttributeControl createWithPercentage:0 title:@"BRIGHTNESS"];
    self.batteryControl = [DevicePercentageAttributeControl createWithBatteryPercentage:0];
    self.batteryACLineControl = [DeviceTextIconAttributeControl create:NSLocalizedString(@"Power", nil) withValue:@"AC" andIcon:[UIImage imageNamed:@"HubPower"]];

    [self.attributesView loadControl:self.brightnessControl control2:self.batteryControl];
}

- (void)configureButtonsView {
    if ([self.deviceModel isHaloPlus]) {
        [self.buttonsView loadControl:self.lightSwitch control2:self.rgbButton control3:self.radioButton];
    }
    else {
        [self.buttonsView loadControl:self.lightSwitch control2:self.rgbButton];
    }
}

- (void)configureImageAttributesView {
    self.haloAttributesView = [[NSBundle mainBundle] loadNibNamed:@"HaloAttributeGroupView" owner:self options:nil][0];
    self.haloAttributesView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.haloAttributesView];

    [self.haloAttributesView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:IS_IPHONE_5 ? -5.f : 20.0f];
    [self.haloAttributesView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.haloAttributesView autoSetDimensionsToSize:CGSizeMake(320, 40)];
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:animated];

    [self renderDisplayColor];
    [self setPlayButtonState];
}

- (void)deviceWillDisappear:(BOOL)animated {
    [super deviceWillDisappear:animated];

    [super removeColoredOverlay];
}

- (DeviceButtonLabelledSwitchControl *)lightSwitch {
    if (!_lightSwitch) {
        __block typeof(self) blockSelf = self;
        _lightSwitch = [DeviceButtonLabelledSwitchControl create:@"Light" withSelect:^BOOL(id sender) {
            return [blockSelf lightSwitchOn];
        } withUnselect:^BOOL(id sender) {
            return [blockSelf lightSwitchOff];
        }];
    }
    return _lightSwitch;
}

- (DeviceButtonLabelledControl *)rgbButton {
    if (!_rgbButton) {
        _rgbButton = [DeviceButtonLabelledControl create:@"color" withImageName:@"rgb_filled_white" withClick:^BOOL(id sender) {
            [self rgbButtonPressed:_rgbButton];
            return YES;
        }];
    }
    return _rgbButton;
}

- (DeviceButtonLabelledControl *)radioButton {
    if (!_radioButton) {
        _radioButton = [DeviceButtonLabelledControl create:@"radio" withImageName:@"radioPlayWhite" withSelectedImageName:@"radioPauseWhite" withClick:^BOOL(id sender) {
            [self radioButtonPressed:_radioButton];
             return YES;
        }];
    }
    return _radioButton;
}


- (void)rgbButtonPressed:(id)sender {
    HaloColorSelectionViewController *colorSelectionViewController = [HaloColorSelectionViewController create];
    
    colorSelectionViewController.selectionType = ColorSelectionTypeColor;
    colorSelectionViewController.currentColor = [self getOnlineColor:1.0];
    colorSelectionViewController.delegate = self;
    
    [self.deviceController.tabBarController presentViewController:colorSelectionViewController
                                                         animated:YES
                                                       completion:nil];
}

- (void)radioButtonPressed:(id)sender {
    NSString *state = [WeatherRadioCapability getPlayingstateFromModel:self.deviceModel];
    if ([state isEqualToString:kEnumWeatherRadioPlayingstatePLAYING]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [self.presenter stopPlayingStation:^(BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!success) {
                        [self displayGenericErrorMessage];
                    }
                });
            }];
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            int stationId = [WeatherRadioCapability getStationselectedFromModel:self.deviceModel];
            // For duration, pass -2 which means "play indefinitely"
            [self.presenter playStation:stationId duration: -2 completionBlock:^(BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!success) {
                        [self displayGenericErrorMessage];
                    }
                });
            }];
        });
    }
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
        [self.deviceModel commit].thenInBackground(^ {
            [self renderDisplayColor];
        });
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

        return [UIColor colorWithHue:hue/360.0 saturation:saturation/100.0 brightness:brightness alpha:1];
    }

    return [UIColor whiteColor];
}

- (void)renderDisplayColor {
    UIColor *displayColor = [self getOnlineDisplayColor];
    [super addColoredOverlay:displayColor];
    [self setSliderBarColor:displayColor];
}

#pragma mark - Light Switch
- (void)setLightSwitchState:(BOOL)turnOn {
    [self.lightSwitch setSelected:turnOn];
}

- (BOOL)lightSwitchOn {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];
        [self.deviceModel commit];
    });

    return YES;
}

- (BOOL)lightSwitchOff {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [SwitchCapability setState:kEnumSwitchStateOFF onModel:self.deviceModel];
        [self.deviceModel commit];
    });

    return YES;
}


- (BOOL)lightIsOn {
    NSString *state = [SwitchCapability getStateFromModel:self.deviceModel];
    return [state isEqualToString:kEnumSwitchStateON];
}

- (void)toggle {
    if ([self lightIsOn]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [SwitchCapability setState:kEnumSwitchStateOFF onModel:self.deviceModel];
            [self setAdjusterValue:0];

            [self.deviceModel commit];
        });
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];

            if ([DimmerCapability getBrightnessFromModel:self.deviceModel] == 0) {
                [DimmerCapability setBrightness:kHaloMaxBrightnessValue onModel:self.deviceModel];
            }
            else {
                [self setAdjusterValue:[DimmerCapability getBrightnessFromModel:self.deviceModel]];
            }

            [self.deviceModel commit];
        });
    }
}

- (void)setPlayButtonState {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSString *state = [WeatherRadioCapability getPlayingstateFromModel:self.deviceModel];
        if ([state isEqualToString:kEnumWeatherRadioPlayingstateQUIET]) {
            self.radioButton.selected = NO;
        }
        else if ([state isEqualToString:kEnumWeatherRadioPlayingstatePLAYING]) {
            self.radioButton.selected = YES;
        }
        [self.radioButton setNeedsLayout];
        [self.radioButton layoutIfNeeded];
    });
}

- (BOOL)hasBrightnessChange:(NSDictionary *)attributes {
    return [attributes.allKeys containsObject:kAttrDimmerBrightness];
}

- (BOOL)hasSwitchStateChange:(NSDictionary *)attributes {
    return [attributes.allKeys containsObject:kAttrSwitchState];
}

- (void)updateUIWithPercentage:(int)percentage andAttributes:(NSDictionary *)attributes {
    if (![self hasSwitchStateChange:attributes]) {
        if ([self hasBrightnessChange:attributes]) {
            if (percentage > 0) {
                [self setLightSwitchState:YES];
                [self setAdjusterValue:percentage];
            }
            else {
                [self setLightSwitchState:NO];
            }
        }
    }
    else {
        if (![self lightIsOn]) {
            [self setLightSwitchState:NO];
        }
        else {
            [self setAdjusterValue:percentage];
            [self setLightSwitchState:YES];
        }
    }
}

#pragma mark - adjtster control for override
// for update value to platform
- (BOOL)submitChangedValue:(int)value becauseOf:(ValueChangeCause)reason {
    if (value < kHaloMinBrightnessValue) {
        value = kHaloMinBrightnessValue;
    }
    if (!self.currentlySliding) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [DimmerCapability setBrightness:value onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }

    return !self.currentlySliding;
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *powerSource = [DevicePowerCapability getSourceFromModel:self.deviceModel];
    if ([powerSource isEqualToString:kEnumDevicePowerSourceLINE]) {
        [self.attributesView loadControl:self.brightnessControl control2:self.batteryACLineControl];
    }
    else {
        [self.attributesView loadControl:self.brightnessControl control2:self.batteryControl];
        [self.batteryControl setPercentage:[DevicePowerCapability getBatteryFromModel:self.deviceModel]];
    }
    
    int brightness = [DimmerCapability getBrightnessFromModel:self.deviceModel];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setAdjusterValue:brightness];

    [self.brightnessControl setPercentage:brightness];
    [self updateUIWithPercentage:brightness andAttributes:attributes];

    [self renderDisplayColor];

    [self.haloAttributesView setHumidityLevel:[RelativeHumidityCapability getHumidityFromModel:self.deviceModel]];
    [self.haloAttributesView setTemperatureLevel:[DeviceController getTemperatureForModel:self.deviceModel]];
    [self.haloAttributesView setPressureLevel:[AtmosCapability getPressureFromModel:self.deviceModel] * 0.2961339710085];

    if (!self.deviceModel.isDeviceOffline && !super.inFirmwareUpdate) {
        [self updateErrorBanner];
    }
}

- (void)displayDeviceBatteryPoweredMessage {
    [self popupMessageWindow:@"Battery powered" subtitle:@"To conserve battery life for emergency situations\nlighting controls are disabled when the\n device is battery powered."];
}

#pragma mark - multiple errors
- (void)updateErrorBanner {
    NSTimeInterval delay = 1;

    NSDictionary *errors = [self.haloDeviceDetails getAllErrors:self.deviceModel];
    // Multiple errors
    if (errors.count > 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissErrorBanner];
            self.errorBannerTag = [self popupLinkAlert:@"Multiple Errors" type:AlertBarTypeClickableWarning sceneType:AlertBarSceneInDevice grayScale:NO linkText:nil selector:@selector(onOpenErrorsView) displayArrow:YES];
        });
    }

    // One error
    else if (errors.count == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if ([((NSString *)errors.allKeys[0]) isEqualToString:kEnumHaloDevicestatePRE_SMOKE]) {
                [self dismissErrorBanner];
                self.errorBannerTag = [self popupLinkAlert:errors.allValues[0] type:AlertBarTypeOrangeWarning sceneType:AlertBarSceneInDevice grayScale:NO linkText:nil selector:@selector(openPresmokeWarningView) displayArrow:YES];
            }
            else {
                [self dismissErrorBanner];
                NSString *key = errors.allKeys[0];
                BOOL callSupport = ![key isEqualToString:@"Failed Battery"] && ![key isEqualToString:@"End of Life"];
                self.errorBannerTag = [self popupErrorMessage:errors.allValues[0] withCallSupportButton:callSupport];
            }
        });
    }
    // No errors
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissErrorBanner];
        });
    }
}

- (void) dismissErrorBanner {
    @synchronized (self) {
        if (self.errorBannerTag != NSNotFound) {
            [self closePopupAlertWithTag:self.errorBannerTag];
            self.errorBannerTag = NSNotFound;
        }
    }
}

- (NSInteger)popupErrorMessage:(NSString *)errorMessage withCallSupportButton:(BOOL)callSupportButton {
    if (callSupportButton) {
         return [self popupAlert:errorMessage type:AlertBarTypeWarning sceneType:AlertBarSceneInDevice bottomButton:@"GET SUPPORT" grayScale:NO selector:@selector(goToSupportPressed)];
    }
    else {
        return [self popupAlert:errorMessage type:AlertBarTypeWarning sceneType:AlertBarSceneInDevice bottomButton:@"SHOP" grayScale:NO selector:@selector(shopPressed)];
    }
}

- (void)startFirmwareUpdate {
    [self startFirmwareUpdate:NO];
}

#pragma mark - popups
- (void)onOpenErrorsView {
    dispatch_async(dispatch_get_main_queue(), ^{
        MultipleErrorsViewController *vc = [MultipleErrorsViewController createWithErrorList:[self.haloDeviceDetails getAllErrors:self.deviceModel].allValues];
        [self.deviceController.navigationController pushViewController:vc animated:YES];
    });
}

- (void)openPresmokeWarningView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPreSmokeModalAlert" object:nil];
}

- (void)goToSupportPressed {
    [[UIApplication sharedApplication] openURL:[NSURL SupportDeviceTroubleshooting]];
}

- (void)shopPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @""]];
}

@end
