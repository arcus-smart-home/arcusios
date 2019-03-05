//
//  UIView+Overlay.m
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

#import <i2app-Swift.h>
#import "UIView+Overlay.h"
#import <PureLayout/PureLayout.h>
#import "FontData.h"
#import "ArcusLabel.h"
#import <i2app-Swift.h>

const float kTwoRowBannerHeight = 56;
const float kSingleRowBannerHeight = 35;

@implementation UIView (Overlay)

- (UIView *)addGrayOverlayWithTapSelector:(SEL)selector andTarget:(NSObject *)target andIndex:(int)index {
    UIView *grayCover = [[UIView alloc] initForAutoLayout];
    [self addSubview:grayCover];
    [grayCover autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [grayCover autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    [grayCover autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [grayCover autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    grayCover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    grayCover.userInteractionEnabled = YES;
    grayCover.tag = kGrayViewTag;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    singleTap.view.tag = index;
    [grayCover addGestureRecognizer:singleTap];
    
    return grayCover;
}

- (UIView *)addOfflineOverlayForDevice:(DeviceModel *)deviceModel withBackgroundTapSelector:(SEL)selector andTarget:(NSObject*)target {
    return [self addOfflineOverlayForDevice:deviceModel withDeviceIndex:-1 withImageName:@"" withBackgroundTapSelector:selector withTarget:target];
}

- (UIView *)addFirmwareUpgradeOverlayForDevice:(DeviceModel *)deviceModel
                             withImageName:(NSString *)imageName {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.alpha = 0.4f;
            view.userInteractionEnabled = NO;
        }
    }

    return [self createBannerForModeWithDeviceName:deviceModel.name
                                 bannerType:BannerTypeFirmwareUpgrage
                            withDeviceIndex:-1
                              withImageName:imageName
                     withDeviceErrorMessage:nil
                  withBackgroundTapSelector:nil
                                 withTarget:nil];
}

- (UIView *)addOfflineOverlayForDevice:(DeviceModel *)deviceModel
                   withDeviceIndex:(int)index
                     withImageName:(NSString *)imageName
         withBackgroundTapSelector:(SEL)selector
                        withTarget:(NSObject *)target {
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.alpha = 0.4f;
            view.userInteractionEnabled = NO;
        }
    }
    
    return [self createBannerForModeWithDeviceName:deviceModel.name
                                        bannerType:BannerTypeOffline
                                   withDeviceIndex:index
                                     withImageName:imageName
                            withDeviceErrorMessage:nil
                         withBackgroundTapSelector:selector
                                        withTarget:target
                                          andCloud: [deviceModel isC2CDevice]];
}

- (UIView *)addDeviceNameErrorOverlay:(NSString *)deviceName
                            withError:(NSString*)errorMessage
                         withSelector:(SEL)selector
                             andCloud:(BOOL)cloud {
    return [self createBannerForModeWithDeviceName:deviceName
                                        bannerType:BannerTypeDeviceNameError
                                   withDeviceIndex:-1
                                     withImageName:nil
                            withDeviceErrorMessage:errorMessage
                         withBackgroundTapSelector:selector
                                        withTarget:self
                                          andCloud:cloud];
}

- (UIView *)addErrorOverlay:(NSString *)errorMessage withSelector:(SEL)selector {
    return [self createBannerForModeWithDeviceName:errorMessage
                                        bannerType:BannerTypeError
                                   withDeviceIndex:-1
                                     withImageName:nil
                            withDeviceErrorMessage:nil
                         withBackgroundTapSelector:selector
                                        withTarget:self];
}

- (UIView *)addWarningTitle:(NSString *)message
        withWarningSubtitle:(NSString *)warning
               withSelector:(SEL)selector {
  return [self createBannerForModeWithDeviceName:message
                                      bannerType:BannerTypeWarning
                                 withDeviceIndex:-1
                                   withImageName:nil
                          withDeviceErrorMessage:warning
                       withBackgroundTapSelector:selector
                                      withTarget:self];
}

- (UIView *)createBannerForModeWithDeviceName:(NSString *)deviceName
                                   bannerType:(BannerType)bannerType
                              withDeviceIndex:(int)index
                                withImageName:(NSString *)imageName
                       withDeviceErrorMessage:(NSString *)errorMessage
                    withBackgroundTapSelector:(SEL)selector
                                   withTarget:(NSObject *)target
                                     andCloud:(BOOL) cloud {
  UIView *grayOverlay = [self addGrayOverlayWithTapSelector:selector andTarget:target andIndex:index];

  if (imageName.length > 0) {
    UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
    [grayOverlay addSubview:imageView];
    imageView.image = [UIImage imageNamed:imageName];
    [imageView autoSetDimension:ALDimensionWidth toSize:50.f];
    [imageView autoSetDimension:ALDimensionHeight toSize:50.f];
    [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [imageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    imageView.alpha = 0.4f;
  }

  UIView *bannerView = [[UIView alloc] initForAutoLayout];
  [grayOverlay addSubview:bannerView];
  [bannerView autoSetDimension:ALDimensionHeight
                        toSize: bannerType != BannerTypeError ? kTwoRowBannerHeight : kSingleRowBannerHeight];
  [bannerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
  [bannerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
  [bannerView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];

  ArcusLabel *deviceNameLabel = [[ArcusLabel alloc] initForAutoLayout];
  [grayOverlay addSubview:deviceNameLabel];
  [deviceNameLabel autoSetDimension:ALDimensionHeight toSize:21.f];
  [deviceNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bannerView withOffset:10.f];
  [deviceNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bannerView];
  [deviceNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bannerView];
  deviceNameLabel.textAlignment = NSTextAlignmentCenter;
  deviceNameLabel.text = deviceName;
  deviceNameLabel.wideSpacing = YES;

  //colorWithAlphaComponent
  ArcusLabel *reasonLabel;
  if (bannerType != BannerTypeError) {
    reasonLabel = [[ArcusLabel alloc] initForAutoLayout];
    [bannerView addSubview:reasonLabel];
    [reasonLabel autoSetDimension:ALDimensionHeight toSize:21.f];
    [reasonLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bannerView withOffset:30.f];
    [reasonLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bannerView];
    [reasonLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bannerView];
    reasonLabel.textAlignment = NSTextAlignmentCenter;
  }
  else {
    reasonLabel = nil;
  }
  if (bannerType == BannerTypeOffline) {
    bannerView.backgroundColor = pinkAlertColor;
    NSDictionary *subTitleFontData = [FontData getWhiteFontWithSize:14.0 bold:NO];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:deviceName
                                                                   attributes:subTitleFontData];
    [deviceNameLabel setAttributedText:descText];
    subTitleFontData = [FontData getItalicFontWithColor:[UIColor whiteColor] size:13.0 kerning:0.0];
    descText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"No Connection", nil)
                                               attributes:subTitleFontData];
    [reasonLabel setAttributedText:descText];
  }
  else if (bannerType == BannerTypeDeviceNameError) {
    bannerView.backgroundColor = pinkAlertColor;
    NSDictionary *subTitleFontData = [FontData getWhiteFontWithSize:14.0 bold:NO];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:deviceName
                                                                   attributes:subTitleFontData];
    [deviceNameLabel setAttributedText:descText];
    FontData *fd = [FontData createFontData:FontTypeMediumItalic size:13.0 blackColor:false alpha:true];
    descText = [fd getFontAttributed:errorMessage];
    [reasonLabel setAttributedText:descText];
  }
  else if (bannerType == BannerTypeFirmwareUpgrage) {
    bannerView.backgroundColor = [UIColor whiteColor];
    NSDictionary *subTitleFontData = [FontData getBlackFontWithSize:14.0 bold:NO];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:deviceName
                                                                   attributes:subTitleFontData];
    [deviceNameLabel setAttributedText:descText];
    subTitleFontData = [FontData getItalicFontWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f] size:13.0 kerning:0.0];
    descText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Firmware Update", nil)
                                               attributes:subTitleFontData];
    [reasonLabel setAttributedText:descText];
  }
  else if (bannerType == BannerTypeWarning) {
    bannerView.backgroundColor = [Appearance warningYellow];
    NSDictionary *subTitleFontData = [FontData getBlackFontWithSize:14.0 bold:NO];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:deviceName
                                                                   attributes:subTitleFontData];
    [deviceNameLabel setAttributedText:descText];
    FontData *fd = [FontData createFontData:FontTypeMediumItalic size:13.0 blackColor:true alpha:true];
    descText = [fd getFontAttributed:errorMessage];
    [reasonLabel setAttributedText:descText];
  }
  else {
    bannerView.backgroundColor = pinkAlertColor;
    NSDictionary *subTitleFontData = [FontData getWhiteFontWithSize:13.0 bold:NO];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:deviceName
                                                                   attributes:subTitleFontData];
    [deviceNameLabel setAttributedText:descText];
  }

  UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
  [bannerView addGestureRecognizer:singleTap];

  if (cloud == YES) {
    UIImageView *cloudImage = [[UIImageView alloc] initForAutoLayout];
    [cloudImage setImage: [UIImage imageNamed:@"icon_c2c_success"]];
    [bannerView addSubview:cloudImage];
    [cloudImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [cloudImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
  }

  return grayOverlay;

}

- (UIView *)createBannerForModeWithDeviceName:(NSString *)deviceName
                                   bannerType:(BannerType)bannerType
                              withDeviceIndex:(int)index
                                withImageName:(NSString *)imageName
                       withDeviceErrorMessage:(NSString *)errorMessage
                    withBackgroundTapSelector:(SEL)selector
                                   withTarget:(NSObject *)target {

  return [self createBannerForModeWithDeviceName:deviceName
                                      bannerType:bannerType
                                 withDeviceIndex:index
                                   withImageName:imageName
                          withDeviceErrorMessage:errorMessage
                       withBackgroundTapSelector:selector
                                      withTarget:target
                                        andCloud:false];
}

- (BOOL)hasOverlay {
    for (UIView *view in self.subviews) {
        if (view.tag == kGrayViewTag) {
            return YES;
        }
    }
    return NO;
}

- (void)removeOverlay {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.alpha = 1.f;
            view.userInteractionEnabled = YES;
        }
        else if (view.tag == kGrayViewTag) {
            [view removeFromSuperview];
        }
    }
}

@end
