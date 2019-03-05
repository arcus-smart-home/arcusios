//
//  UIView+Overlay.h
//  i2app
//
//  Created by Arcus Team on 5/24/16.
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

@class DeviceModel;

static const int kGrayViewTag = 6666;

typedef NS_ENUM(unsigned int, BannerType) {
  BannerTypeNone,
  BannerTypeOffline,
  BannerTypeFirmwareUpgrage,
  BannerTypeError,
  BannerTypeDeviceNameError,
  BannerTypeWarning
};

@interface UIView (Overlay)

- (UIView *)addGrayOverlayWithTapSelector:(SEL) selector
                                andTarget:(NSObject*) target
                                 andIndex:(int) index;

- (UIView *)addOfflineOverlayForDevice:(DeviceModel *)deviceModel
             withBackgroundTapSelector:(SEL)selector
                             andTarget:(NSObject*)target;

- (UIView *)addFirmwareUpgradeOverlayForDevice:(DeviceModel *)deviceModel
                                 withImageName:(NSString *)imageName;

- (UIView *)addOfflineOverlayForDevice:(DeviceModel *)deviceModel
                       withDeviceIndex:(int)index
                         withImageName:(NSString *)imageName
             withBackgroundTapSelector:(SEL)selector
                            withTarget:(NSObject *)target;

- (UIView *)createBannerForModeWithDeviceName:(NSString *)deviceName
                                   bannerType:(BannerType)bannerType
                              withDeviceIndex:(int)index
                                withImageName:(NSString *)imageName
                       withDeviceErrorMessage:(NSString *)errorMessage
                    withBackgroundTapSelector:(SEL)selector
                                   withTarget:(NSObject *)target
                                     andCloud:(BOOL)cloud;

- (UIView *)addDeviceNameErrorOverlay:(NSString *)deviceName
                            withError:(NSString*)errorMessage
                         withSelector:(SEL)selector
                             andCloud:(BOOL)cloud;

- (UIView *)addErrorOverlay:(NSString *)errorMessage
               withSelector:(SEL)selector;

- (UIView *)addWarningTitle:(NSString *)message
        withWarningSubtitle:(NSString *)warning
               withSelector:(SEL)selector;

- (BOOL)hasOverlay;
- (void)removeOverlay;

@end
