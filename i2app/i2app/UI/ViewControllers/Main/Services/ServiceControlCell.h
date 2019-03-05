//
//  ServiceControlCell.h
//  i2app
//
//  Created by Arcus Team on 9/2/15.
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
#import "DeviceDetailsBase.h"
#import "DeviceDetailsThermostatDelegate.h"
#import "ArcusLabel.h"

@class PopupSelectionWindow;

typedef enum : NSUInteger {
    bottomAlertInPink = 0,
    bottomAlertInGray,
} buttomAlertColor;

@class ServiceControlCell;

@protocol ServiceControlCellDelegate <NSObject>

- (void)bottomButtonPressed:(id)sender serviceControlCell:(ServiceControlCell *)cell;

@end

@interface ServiceControlCell : UITableViewCell <DeviceDetailsThermostatDelegate>

@property (strong, nonatomic) DeviceModel *deviceModel;
@property (strong, nonatomic) DeviceDetailsBase<DeviceDetailsDelegate> *deviceDataModel;

@property (weak, nonatomic) IBOutlet DeviceButtonBaseControl *leftButton;
@property (weak, nonatomic) IBOutlet DeviceButtonBaseControl *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *centerIcon;
@property (weak, nonatomic) IBOutlet UIView *centerDivider;
@property (weak, nonatomic) IBOutlet UIView *bottomBanner;
@property (weak, nonatomic) IBOutlet UIImageView *sideIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomIconCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomIconWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *sideLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brandIcon;

@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet ArcusLabel *titleLabel;
@property (weak, nonatomic) IBOutlet ArcusLabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLogoTopConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeight;

@property (strong, nonatomic) UIViewController *parentController;

@property (strong, nonatomic) PopupSelectionWindow *popupWindow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleSizeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitleSizeConstraint;
@property (strong, nonatomic) UIViewController *popupController;

@property (nonatomic) BOOL isInOfflineMode;

@property (nonatomic, assign) id<ServiceControlCellDelegate> delegate;

+ (ServiceControlCell *)createCell:(DeviceModel *)deviceModel owner:(UIViewController *)owner;

- (void)loadData;

- (void)disableLefRightButtons:(BOOL)disable;
- (void)displayGreyOverlay:(BOOL)display;
- (void)displayOfflineOverlay:(BOOL)display;
- (void)displayOfflineScreen: (BOOL)display;
- (void)displayBottomBannerWithColor:(buttomAlertColor)color vendor:(NSString *)vendor sideText:(NSString *)sideText sideIcon:(UIImage *)sideIcon;
- (void)displayBottomBannerWithColor:(buttomAlertColor)color
                          middleText:(NSString *)middleText
                            sideIcon:(UIImage *)sideIcon;
- (void)hideBottomBanner;

- (void)colorConfigButtonPressed:(id)sender;

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner inRootViewControllerWindow:(BOOL)inRootVC;

- (void)setupDeviceError:(NSString*)errorMessage;
- (void)teardownDeviceError;

- (void)setupPinkBannerOfflineModeView;
- (void)tearDownPinkBannerOfflineModeView;

// Obstruction Specific Alert
- (void)setupDeviceWarning:(NSString *)warningMessage;
- (void)teardownDeviceWarning;

// Honeywell Specific Alert
- (void)displayAutoModeAlertForHoneywell;

- (void)loadDeviceImageFromPlatform;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;

- (IBAction)onClickBackgroup:(id)sender;

- (void)getDeviceStateChangedNotification:(NSNotification *)note;
@end
