//
//  UIView+Blur.m
//  i2app
//
//  Created by Arcus Team on 5/25/15.
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
#import "UIView+Blur.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"
#import "AKFileManager.h"
#import "ArcusBorderedImageView.h"
#import <i2app-Swift.h>

@interface UIView (Blur_Private)


@end


@implementation UIView (Blur)

- (void)createBlurredBackground:(UIViewController *)presentingViewController {
    
    // This view controller is not presented modally
    if (!presentingViewController) {
        return;
    }

    @autoreleasepool {
        self.backgroundColor = [self createBackgroundColorFromView:presentingViewController.view];
    }
}

- (void)createBlurredBackgroundFromImageNamed:(NSString *)imageName {
    @autoreleasepool {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
        self.backgroundColor = [self createBackgroundColorFromView:self];
    }
}

- (void)setBackgroundColorWithColor:(UIColor *)color {
    self.backgroundColor = color;
}

- (UIColor *)createBackgroundWithBlurScale:(NSString *)imageName {
    if (imageName.length == 0) {
        DDLogWarn(@"**** ERROR - image name is nil");
        return nil;
    }
    
    return [self createImageBackgroundWithBlurScale:[UIImage imageNamed:imageName]];
}

- (UIColor *)createImageBackgroundWithBlurScale:(UIImage *)image {
    if (!image) {
        DDLogWarn(@"**** ERROR - cannot find the image");
        return nil;
    }
    CGSize size = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.bounds.size;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:[retImage applyLightEffect]];
}


#pragma mark - Private Methods
- (UIColor *)createBackgroundColorFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:[capturedScreen applyLightEffect]];
}


// Used to set the background image and the photo image for Dashboard and devices
- (BOOL)renderLogoAndBackgroundWithImageNamed:(NSString *)imageName forLogoControl:(UIView *)photoView {
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:imageName
                                                                 atSize:[UIScreen mainScreen].bounds.size
                                                              withScale:[UIScreen mainScreen].scale];
    if (!image) {
        // Check if it is not in the bundle
        image = [UIImage imageNamed:imageName];
    }
    
    return [self renderLogoAndBackgroundWithImage:image forLogoControl:photoView];
}

- (BOOL)renderLogoAndBackgroundWithImage:(UIImage *)image forLogoControl:(UIView *)photoView {
    
    if (image) {
        UIImage *logoImage = image.copy;
        
        if ([photoView isKindOfClass:[ArcusBorderedImageView class]]) {
            ArcusBorderedImageView *borderedImageView = (ArcusBorderedImageView *)photoView;
            [borderedImageView setImage:logoImage];
        }
        else {
          if (photoView) {
            photoView.layer.cornerRadius = photoView.frame.size.width / 2.0f;
            photoView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
            photoView.layer.borderWidth = 5.0f;
            
            CGSize logoSize = photoView.bounds.size;
            logoSize.height -= 9;
            logoSize.width -= 9;
            
            logoImage = [logoImage scaleImageToFillSize:logoSize];
            logoImage = [logoImage cutImageInCenter:logoSize];
            logoImage = [logoImage roundCornerImageNoAspectChange];
            
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
            
            if ([photoView isKindOfClass:[UIImageView class]]) {
                [(UIImageView *)photoView setImage:logoImage];
            }
            else {
                [((UIButton *)photoView) setImage:logoImage forState:UIControlStateNormal];
            }
          }
        }

        image = [image scaleImageToFillSize:[UIScreen mainScreen].bounds.size];
        image = [image cutImageInCenter:[UIScreen mainScreen].bounds.size];
        image = [image applyLightEffect];

        @autoreleasepool {
            self.backgroundColor = [UIColor colorWithPatternImage:image];
        }

        [self setNeedsLayout];
        return YES;
    }
    else {
        return NO;
    }
}

@end
