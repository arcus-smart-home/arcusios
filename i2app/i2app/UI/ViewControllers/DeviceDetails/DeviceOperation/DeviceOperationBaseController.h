//
//  DeviceOperationBaseController.h
//  i2app
//
//  Created by Arcus Team on 6/4/15.
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

#import <UIKit/UIKit.h>
#import "PopupSelectionWindow.h"
#import "DeviceDetailsBase.h"
#import "UIView+Animation.h"

@class DeviceControlViewController;
@class DeviceModel;
@class PopupSelectionWindow;

typedef enum {
    DeviceOperationAnimationStateNothing = 0,
    DeviceOperationAnimationStateStartedShining,
    DeviceOperationAnimationStateStopedShining,
    DeviceOperationAnimationStateExpandedRubberBand,
    DeviceOperationAnimationStateContractRubberBand,
} DeviceOperationAnimationState;


@interface DeviceOperationBaseController : UIViewController

extern NSString *const kDeviceOperationNoConnectionSupportDefaultUrl;

+ (DeviceOperationBaseController *)create;
+ (DeviceOperationBaseController *)createWithDeviceId:(NSString *)deviceId;
+ (DeviceOperationBaseController *)createWithIdentifier:(NSString *)nibName;
+ (DeviceOperationBaseController *)createWithIdentifier:(NSString *)nibName withDeviceID:(NSString *)deviceID;

@property (readonly, nonatomic) DeviceOperationAnimationState animationState;
@property (strong, nonatomic) DeviceModel *deviceModel;
@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic, readonly) DeviceDetailsBase <DeviceDetailsDelegate> *deviceOpDetails;
@property (weak, nonatomic) DeviceControlViewController *deviceController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLogoLocation;

@property (strong, nonatomic) UIImage *vendorImage;
@property (weak, nonatomic) IBOutlet UIImageView *deviceLogo;

@property (strong, nonatomic) UIColor *backgroupColor;
@property (readonly, strong, nonatomic) PopupSelectionWindow *popupWindow;

- (void)parentSwipe:(BOOL)enable;
- (void)edgeMode:(SEL)onClick;
- (void)centerMode;

#pragma mark - Popup window 
- (void)popup:(PopupSelectionBaseContainer *)container;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector;
- (void)closePopup;
- (void)popupErrorTitle:(NSString *)title withMessage:(NSString *)message;

#pragma mark - Device view left cycle
- (void)deviceWillAppear:(BOOL)animated;
- (void)deviceDidAppear:(BOOL)animated;
- (void)deviceWillDisappear:(BOOL)animated;
- (void)deviceDidDisappear:(BOOL)animated;

- (BOOL)isCenterMode;

#pragma mark - Alert bar
//Override this method for customizing the alert bar that is shown for no connection
- (NSInteger)showNoConnectionAlertBar;
//Override this method if you only need to change what happens when the no connection bar is tapped
- (void)didTapNoConnectionAlertBar;

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial;

#pragma mark - Animation
- (void)startShiningAnimation;
- (void)stopShiningAnimation;
- (void)startRubberBandExpandAnimation;
- (void)startRubberBandContractAnimation;

#pragma mark - Firmware Update
@property (atomic, readonly) BOOL inFirmwareUpdate;
- (void)startFirmwareUpdate;
- (void)startFirmwareUpdate:(BOOL)grayScale;
- (void)stopFirmwareUpdate;

#pragma mark - footer style control
- (void)setFooterToPink:(BOOL)status;
- (void)setFooterSideText:(NSString *)text;

#pragma mark - Offline
- (void)checkDeviceIsOfflineOrUpdating;

#pragma mark - Colored Overlay

- (void)addColoredOverlay:(UIColor*)color;
- (void)removeColoredOverlay;

#pragma mark - Update device image
- (BOOL)updateDeviceLogo;
- (void)setDeviceLogo;

@end


