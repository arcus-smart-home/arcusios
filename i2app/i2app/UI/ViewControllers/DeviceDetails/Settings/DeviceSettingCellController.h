//
//  DeviceSettingCellController.h
//  i2app
//
//  Created by Arcus Team on 8/7/15.
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

#import "DeviceSettingModels.h"

typedef void(^DeviceSettingsOpenCloseViewControllerBlock)(UIViewController *viewController);

@class DeviceSettingUnitBase;
@class DeviceSettingCell;
@class PopupSelectionBaseContainer;

#pragma mark - Function unit
@interface DeviceSettingFunctionUnit : DeviceSettingUnitBase


- (void)pressedBackgroup:(DeviceSettingCell *)cell;
- (void)popup:(PopupSelectionBaseContainer *)container;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector;
- (void)closePopup;
- (void)popupErrorTitle:(NSString *)title withMessage:(NSString *)message;

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial;

@end

#pragma mark - Mid units
@interface DeviceSettingGroupUnit : DeviceSettingFunctionUnit

+ (DeviceSettingGroupUnit *)createWithTitle: (NSString *)title;

@end

// For text value style cell
@interface DeviceSettingTextValueUnit : DeviceSettingFunctionUnit

- (void) setSubtitle: (NSString *)subtitle;
- (void) setValue: (NSString *)value;
- (void) setDisableArrow: (BOOL)value;

@end

// For text switch style cell
@interface DeviceSettingTextSwitchUnit : DeviceSettingFunctionUnit

- (void) setSubtitle: (NSString *)subtitle;
- (void) setSwitchState: (BOOL)state;
//@Override
- (void) updatedSwitchState: (BOOL)state;

@end

@interface DeviceSettingLogoTitleUnit : DeviceSettingFunctionUnit

- (void) setLogoImage: (UIImage *)image;
- (void) setLogoImageUrl: (NSString *)url;
- (void) setDisableArrow: (BOOL)value;

@end

#pragma mark - Camera settings
@interface DeviceSettingWifiNetworkUnit : DeviceSettingTextValueUnit

@property (nonatomic, copy) DeviceSettingsOpenCloseViewControllerBlock openSettings;
@property (nonatomic, copy) DeviceSettingsOpenCloseViewControllerBlock closeSettings;

@end

@interface DeviceSettingCameraWifiNetworkUnit : DeviceSettingTextValueUnit

@property (nonatomic, copy) DeviceSettingsOpenCloseViewControllerBlock openSettings;
@property (nonatomic, copy) DeviceSettingsOpenCloseViewControllerBlock closeSettings;

@end

@interface DeviceSettingCameraSecuritySettingUnit : DeviceSettingTextValueUnit

@end


@interface DeviceSettingBatteryCameraImageQualityUnit : DeviceSettingTextValueUnit

@end

@interface DeviceSettingCameraImageQualityUnit : DeviceSettingTextValueUnit

@end

@interface DeviceSettingBatteryCameraMotionSensitivityUnit : DeviceSettingTextValueUnit

@end

@interface DeviceSettingCameraFrameRateUnit : DeviceSettingTextValueUnit

@end

@interface DeviceSettingCameraInfraredLightUnit : DeviceSettingTextValueUnit
@end

@interface DeviceSettingCameraRotateCamera180Unit : DeviceSettingTextSwitchUnit
@end

@interface DeviceSettingCameraLocalStreamingUnit : DeviceSettingTextValueUnit

@property (nonatomic, copy) DeviceSettingsOpenCloseViewControllerBlock openSettings;
@property (nonatomic, copy) DeviceSettingsOpenCloseViewControllerBlock closeSettings;

@end


#pragma mark - Fob settings
@interface DeviceSettingKeyFobButton : DeviceSettingLogoTitleUnit

- (instancetype)initWithButtonType:(ButtonType)type productId:(NSString *)name;

@property (nonatomic, strong, readonly) NSString *ruleTemplateId;

@end


#pragma make - Water softener

#pragma mark - Genie Garage Door Controller

@interface GenieControllerNetworkSettingsUnit : DeviceSettingTextValueUnit

@end



