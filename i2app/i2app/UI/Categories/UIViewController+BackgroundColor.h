//
//  UIViewController+BackgroundColor.h
//  i2app
//
//  Created by Arcus Team on 6/5/15.
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


typedef enum {
    BackgroupOverlayTypeWhite   = 0,
    BackgroupOverlayTypeDark,
} BackgroupOverlayType;

typedef enum {
    BackgroupOverlayLightLevel   = 0,
    BackgroupOverlayMiddleLevel,
    BackgroupOverlayHeavyLevel,
    BackgroupOverlayLightMiddleLevel,
} BackgroupOverlayLevel;

@interface UIViewController (BackgroundColor)

- (BOOL)setBackgroundColorToParentColor;

- (void)setBackgroundColorToDashboardColor;

- (void)setBackgroundColorToLastNavigateColor;

- (void)setBackgroundToDeviceBackground;

- (void)removeOverlay;

- (void)addWhiteOverlay:(BackgroupOverlayLevel)level;
- (void)addDarkOverlay:(BackgroupOverlayLevel)level;
- (void)addColoredOverlay:(UIColor*)color withOpacity:(float)opacity;
- (void)addOverlay:(BOOL)isBlack;

- (void)setCurrentBackgroup:(UIImage *)image;

- (UIColor *)getBackgroundColorWithBlur;

- (void)createGradientBackgroundWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

@end
