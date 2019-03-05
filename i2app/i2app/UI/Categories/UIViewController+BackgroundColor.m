//
//  UIViewController+BackgroundColor.m
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

#import <i2app-Swift.h>
#import "UIViewController+BackgroundColor.h"
#import <objc/runtime.h>
#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"
#import <i2app-Swift.h>

@implementation UIViewController (BackgroundColor)

static char _aBackgroundOverlayer;

- (BOOL)setBackgroundColorToParentColor {
    if (self.parentViewController && [self.parentViewController.view.backgroundColor isKindOfClass:[UIColor class]]) {
        self.view.backgroundColor = self.parentViewController.view.backgroundColor;        
        self.parentViewController.navigationController.view.backgroundColor = self.view.backgroundColor;
        return YES;
    }
    else {
        return NO;
    }
}

- (void)setBackgroundColorToDashboardColor {
  // TODO: Need better long term solution.
  NSString *modelId = [[[[CorneaHolder shared] settings] currentPlace] modelId];
  UIImage *image = [ArcusSettingsHomeImageHelper fetchHomeImage:modelId];

  [self.view renderLogoAndBackgroundWithImage:image forLogoControl:nil];
  self.navigationController.view.backgroundColor = self.view.backgroundColor;
}

- (void)setBackgroundColorToLastNavigateColor {
    if (self.navigationController && self.navigationController.viewControllers && self.navigationController.viewControllers.count >= 2) {
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        self.view.backgroundColor = controller.view.backgroundColor;
    }
    else {
        [self setBackgroundColorToDashboardColor];
    }
}

- (void)setBackgroundToDeviceBackground {
  [self setBackgroundColorToDashboardColor];
}

- (void)addOverlay:(BackgroupOverlayType)type withOpactiy:(float)opacity {
    [self removeOverlay];
    
    UIView *backgroupOverlay = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    switch (type) {
        case BackgroupOverlayTypeWhite:
            backgroupOverlay.layer.backgroundColor = [[UIColor whiteColor] CGColor];
            break;
        case BackgroupOverlayTypeDark:
            backgroupOverlay.layer.backgroundColor = [[UIColor blackColor] CGColor];
            break;
        default:
            break;
    }
    backgroupOverlay.layer.opacity = opacity;
    objc_setAssociatedObject(self, &_aBackgroundOverlayer, backgroupOverlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self.view insertSubview:backgroupOverlay atIndex:0];
}

- (void)removeOverlay {
    UIView *backgroupOverlay = objc_getAssociatedObject(self, &_aBackgroundOverlayer);
    
    if (backgroupOverlay) {
        [backgroupOverlay removeFromSuperview];
    }
}

- (void)addWhiteOverlay:(BackgroupOverlayLevel)level {
    switch (level) {
        case BackgroupOverlayLightLevel:
            [self addOverlay:BackgroupOverlayTypeWhite withOpactiy:0.2];
            break;
        case BackgroupOverlayMiddleLevel:
            [self addOverlay:BackgroupOverlayTypeWhite withOpactiy:0.5];
            break;
        case BackgroupOverlayHeavyLevel:
            [self addOverlay:BackgroupOverlayTypeWhite withOpactiy:0.8];
            break;
        default:
            break;
    }
}

- (void)addDarkOverlay:(BackgroupOverlayLevel)level {
    switch (level) {
        case BackgroupOverlayLightLevel:
            [self addOverlay:BackgroupOverlayTypeDark withOpactiy:0.2];
            break;
        case BackgroupOverlayLightMiddleLevel:
          [self addOverlay:BackgroupOverlayTypeDark withOpactiy:0.35];
          break;
        case BackgroupOverlayMiddleLevel:
            [self addOverlay:BackgroupOverlayTypeDark withOpactiy:0.5];
            break;
        case BackgroupOverlayHeavyLevel:
            [self addOverlay:BackgroupOverlayTypeDark withOpactiy:0.8];
            break;
        default:
            break;
    }
}

- (void)addColoredOverlay:(UIColor*)color withOpacity:(float)opacity {
    [self removeOverlay];

    UIView *backgroupOverlay = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    backgroupOverlay.layer.backgroundColor = [color CGColor];

    backgroupOverlay.layer.opacity = opacity;
    objc_setAssociatedObject(self, &_aBackgroundOverlayer, backgroupOverlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self.view insertSubview:backgroupOverlay atIndex:0];
}

- (void)addOverlay:(BOOL)isBlack {
    if (isBlack) {
        [self addDarkOverlay:BackgroupOverlayLightLevel];
    }
    else {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    }
}

- (void)setCurrentBackgroup:(UIImage *)image {
    if (image) {
        image = [image applyLightEffect];
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        [self.view setNeedsLayout];
    }
}

- (UIColor*)getBackgroundColorWithBlur {
    UIViewController *root = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    
    UIImage *backgroundImage = [[UIImage imageFromLayer:root.view.layer] applyExtraLightEffect];
    return [UIColor colorWithPatternImage:backgroundImage];
}


- (void)createGradientBackgroundWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    gradientLayer.colors = @[(__bridge id)topColor.CGColor, (__bridge id)bottomColor.CGColor];
    gradientLayer.locations = @[@(0.3f), @(1.0f)];
    
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

@end
