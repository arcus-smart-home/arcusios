//
//  WaterHeaterOperationController.m
//  i2app
//
//  Created by Arcus Team on 7/28/15.
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
#import "WaterHeaterOperationController.h"
#import "PopupSelectionButtonsView.h"
#import "DeviceNotificationLabel.h"
#import "WaterHeaterCapability.h"
#import "DeviceController.h"
#import "DeviceController.h"
#import "UIViewController+AlertBar.h"
#import "MultipleErrorsViewController.h"
#import "DeviceControlViewController.h"
#import "ZWaveUnpairingController.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"

const int kMinHeatingPointInFah = 60;

@interface WaterHeaterOperationController ()

@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *attributableTitle;
@property (weak, nonatomic) IBOutlet UILabel *attributableValue;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet DeviceNotificationLabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *modeButton;

@end

@implementation WaterHeaterOperationController {
    IBOutletCollection(NSLayoutConstraint) NSArray *tagHighConstaints;
    __weak IBOutlet NSLayoutConstraint *modeHighConstraint;
    PopupSelectionButtonsView *_modePopup;
    int                 _maxHeatSetPoint;
    BOOL                _isCenter;
    BOOL                _isEdgeMode;
    NSArray             *_waterHeaterModes;
    int                 _currentTemp;
    
    NSTimer             *_setValueTimer;
    NSTimer             *_stopTimer;
}

- (void)viewDidLoad {
    [self.deviceLogo setImage:[[UIImage alloc] init]];
    [super viewDidLoad];
    
    if (IS_IPHONE_5) {
        modeHighConstraint.constant /= 3;
        for (NSLayoutConstraint *item in tagHighConstaints) {
            item.constant /= 2;
        }
    }

    [self.centerImage setImage:[[UIImage alloc] init]];
    [self updateDeviceState:nil initialUpdate:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopStopTimer];
    [self stopSetValueTimer];
}

- (void)centerMode {
    [super centerMode];
    [self.deviceLogo setImage:nil];
    [self updateDeviceState:nil initialUpdate:NO];
    _isCenter = YES;
    _isEdgeMode = NO;
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:YES];
    
    //get modes
    _waterHeaterModes = [DeviceController getWaterHeaterModes];
}

- (void)checkError {
    if ([self isDisplayingAlert]) {
        return;
    }
    
    NSArray *waterHeaterErrors = [DeviceController getWaterHeaterErrors:self.deviceModel];
    
    NSTimeInterval delay = 1;
    if (waterHeaterErrors.count > 1) {
        // Delay execution of my block while the UI has a chance to update first.
        // Not ideal but need a callback after the screen has loaded and device has loaded into the screen.
        // The hide alert banner being triggered by swiping to this cell is hiding our no connection banner
        // if we do not wait.
        // TODO Clean up device event notifications
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self popupLinkAlert:@"Multiple Errors" type:AlertBarTypeClickableWarning sceneType:AlertBarSceneInDevice grayScale:NO linkText:nil selector:@selector(onOpenErrorsView) displayArrow:YES];
        });
    } else if (waterHeaterErrors.count == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self popupError:waterHeaterErrors[0]];
        });
    }
}

- (void)edgeMode:(SEL)onClick {
    [super edgeMode:onClick];
    _isEdgeMode = YES;
    _isCenter = NO;
}


#pragma mark - popups
- (void)onOpenErrorsView {
    dispatch_async(dispatch_get_main_queue(), ^{
        MultipleErrorsViewController *vc = [MultipleErrorsViewController createWithErrorList:[DeviceController getWaterHeaterErrors:self.deviceModel]];
        [self.deviceController.navigationController pushViewController:vc animated:YES];
    });
}

- (void)popupError:(NSString *)errorMessage {
    [self popupAlert:errorMessage type:AlertBarTypeWarning sceneType:AlertBarSceneInDevice bottomButton:@"1-0" grayScale:NO selector:@selector(supportPhoneCall)];
}

- (void)supportPhoneCall {
    // This will need to be addressed if support is added.
//
//    NSURL *phoneUrl = [NSURL URLWithString:@"tel://+18887756937"];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//        [[UIApplication sharedApplication] openURL:phoneUrl];
//    }
}


#pragma mark - button functions

- (IBAction)pressedDecreaseButton:(id)sender {
    _plusButton.enabled = YES;
    [self stopStopTimer];

    if ([self checkIsOverMinTemp:_currentTemp - 1] == NO) {
        if (_currentTemp - 1 < 80 && _currentTemp > 60) {
            _currentTemp = 60;
        } else {
            _currentTemp -= 1;
        }
        [self setAttributableValueText: _currentTemp];
    }
    
    [self startTimers];
}

- (IBAction)pressedIncreaseButton:(id)sender {
    _minusButton.enabled = YES;
    [self stopStopTimer];

    if ([self checkIsOverMaxTemp:_currentTemp + 1] == NO) {
        if (_currentTemp < 80 && _currentTemp + 1 > 60) {
            _currentTemp = 80;
        } else {
            _currentTemp += 1;
        }
        [self setAttributableValueText: _currentTemp];
    }
    
    [self startTimers];
}

#pragma mark - Over limit temp methods
- (BOOL)checkIsOverMaxTemp:(int)temp {
    if ([self isOverMaxTemp:temp]) {
        _plusButton.enabled = NO;
        [self showErrorTempOverLimit];
        return YES;
    }
    
    return NO;
}

- (BOOL)checkIsOverMinTemp:(int)temp {
    if ([self isOverMinTemp:temp]) {
        _minusButton.enabled = NO;
        [self showErrorTempMinOverLimit];
        return YES;
    }
    
    return NO;
}

- (BOOL)isOverMaxTemp:(int)temp {
    if (temp > _maxHeatSetPoint) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isOverMinTemp:(int)temp {
    if (temp < kMinHeatingPointInFah) {
        return YES;
    }
    
    return NO;
}

#pragma mark - mode button functions
- (IBAction)pressedModeButton:(id)sender {
    NSMutableArray *popupModels = [[NSMutableArray alloc] init];
    for (NSString *item in _waterHeaterModes) {
        [popupModels addObject:[PopupSelectionButtonModel create:NSLocalizedString(item, nil) event:@selector(chooseMode:) obj:item]];
    }
    
    _modePopup = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Choose a mode", nil) buttons:popupModels];
    _modePopup.owner = self;
    [super popup:_modePopup];
}

- (void)chooseMode:(id)selectedMode {
    [DeviceController setWaterHeaterControlMode:self.deviceModel controlMode:selectedMode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self.deviceModel commit];
    });
    [self setAttributableTitleText:NSLocalizedString(selectedMode, nil)];
}

- (void)submitSetHeatingPoint:(float)temp {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DeviceController setWaterHeaterSetPoint:self.deviceModel setPoint:temp];
    });
}

#pragma mark - update functions
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if ([self isWifiRssiChanged:attributes] || [_setValueTimer isValid]) {
        return;
    }
    
    NSString *currentModel = [DeviceController getWaterHeaterControlMode:self.deviceModel];
    int heatSettingPoint = (int)[DeviceController getWaterHeaterSetPoint:self.deviceModel];
    _currentTemp = heatSettingPoint;
    
    BOOL waterHeating = [WaterHeaterCapability getHeatingstateFromModel:self.deviceModel];
    NSString *hotwaterLevel = [WaterHeaterCapability getHotwaterlevelFromModel:self.deviceModel];
    _maxHeatSetPoint = (int)[DeviceController getWaterHeaterMaxSetPoint:self.deviceModel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self.deviceModel isDeviceOffline]) {
            [self checkError];
        }
        
        [self setAttributableValueText: heatSettingPoint];
        [self setAttributableTitleText:NSLocalizedString(currentModel, nil)];
        
        if (_isCenter && !_isEdgeMode) {
            
            UIImage *deviceImage = nil;
            
            if (waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelLOW]) {
                deviceImage =[UIImage imageNamed:@"big_waterHeater_heating_low"];
            } else if (waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelMEDIUM]) {
                deviceImage =[UIImage imageNamed:@"big_waterHeater_heating_limited"];
            } else if (waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelHIGH]) {
                deviceImage =[UIImage imageNamed:@"big_waterHeater_heating_available"];
            } else if (!waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelLOW]) {
                deviceImage =[UIImage imageNamed:@"big_waterHeater_noHeating_low"];
            } else if (!waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelMEDIUM]) {
                deviceImage =[UIImage imageNamed:@"big_waterHeater_noHeating_limited"];
            } else if (!waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelHIGH]) {
                deviceImage =[UIImage imageNamed:@"big_waterHeater_noHeating_available"];
            }
            
            deviceImage = [[deviceImage roundCornerImageWithsize:CGSizeMake(180, 180)] invertColor];
            if (deviceImage) {
                self.deviceLogo.image = deviceImage;
            }
        }
    });
}

- (BOOL)isWifiRssiChanged:(NSDictionary *)attributes {
    if ((attributes.count == 1) && [attributes objectForKey:@"wifi:rssi"] != nil) {
        return YES;
    }
    return NO;
}

#pragma mark - helper functions
- (void)setAttributableTitleText: (NSString *)text {
    [_attributableTitle styleSet:text andButtonType:FontDataType_DemiBold_13_White upperCase:YES];
}

- (void)setAttributableValueText: (NSInteger)temp {
    [_attributableValue setAttributedText:[FontData getString:[NSString stringWithFormat:@"%ld", (long)temp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];
}

#pragma mark - error functions

- (void)showErrorLowWaterLevel {
    [self popupAlert: NSLocalizedString(@"Low water level error", nil) type:AlertBarTypeWarning canClose:YES sceneType:AlertBarSceneInDevice bottomButton:NSLocalizedString(@"Customer support phone", nil) selector:nil];
}

- (void)showErrorTempOverLimit {
    [self popupErrorTitle: NSLocalizedString(@"OOPS!", nil) withMessage: NSLocalizedString(@"Temperature over limit error", nil)];
}

- (void)showErrorTempMinOverLimit {
    [self popupErrorTitle: NSLocalizedString(@"OOPS!", nil) withMessage: NSLocalizedString(@"Temperature minimum limit error", nil)];
}

#pragma mark - Timer

- (void)startTimers {
    
    if (![_setValueTimer isValid]) {
        [self startSetValueTimer];
        [_setValueTimer fire];
    }
    
    [self startStopTimer];
    
}

- (void)startSetValueTimer {
    _setValueTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(handleSetValue)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)stopSetValueTimer {
    [_setValueTimer invalidate];
    _setValueTimer = nil;

    [self submitSetHeatingPoint:_currentTemp];
}

- (void)handleSetValue {
    [self submitSetHeatingPoint:_currentTemp];
}

- (void)startStopTimer {
    _stopTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                      target:self
                                                    selector:@selector(handleStopTimer)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void)stopStopTimer {
    [_stopTimer invalidate];
    _stopTimer = nil;
}

- (void)handleStopTimer {
    [self stopSetValueTimer];
}

@end
