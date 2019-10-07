//
//  UIImage+CustomEffects.h
//  i2app
//
//  Created by Arcus Team on 10/6/19.
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
 *///

#ifndef UIImage_CustomEffects_h
#define UIImage_CustomEffects_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,
    GradientTypeLeftToRight = 1,
    GradientTypeUpleftToLowright = 2,
    GradientTypeUprightToLowleft = 3,
};

@interface UIImage (CustomEffects)
- (CGImageRef)imageRotatedByDegrees:(CGFloat)degrees;

+ (UIImage *)imageFromLayer:(CALayer *)layer;

- (UIImage *)convertImageToGrayScale;
- (UIImage *)invertColor;
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end


#endif /* UIImage_CustomEffects_h */
