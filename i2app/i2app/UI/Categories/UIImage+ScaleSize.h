//
//  UIImage+ScaleSize.h
//  i2app
//
//  Created by Arcus Team on 6/8/15.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(ScaleSize)

//Getting images from image names
+ (UIImage *)getImage:(NSString *)imageName andScale:(CGSize)size;
+ (UIImage *)getImageScaleToWindowSize:(NSString *)imageName;
+ (UIImage *)getImage:(NSString *)imageName cutAndScaleTo:(CGSize)size;
+ (UIImage *)image:(NSString *)imageName withCut:(CGRect)rect;

//Scaling images
- (UIImage *)scaleImageToSize:(CGSize)size;
- (UIImage *)scaleImageToFillSize:(CGSize)size;

//Cropping images
- (UIImage *)cutImage:(CGRect) rect;
- (UIImage *)cutImageInCenter:(CGSize)size;

//Scale and crop
- (UIImage *)exactZoomScaleAndCutSizeInCenter:(CGSize)size;
- (UIImage *)backgroundZoomScaleAndCutSizeInCenter:(CGSize)size;

//Make images round
- (UIImage *)roundCornerImageWithsize:(CGSize)size;
- (UIImage *)roundCornerImageWithsize:(CGSize)size radius:(float)radius;
- (UIImage *)roundCornerImageNoAspectChange;

- (UIImage *)setAlpha:(CGFloat)alpha;

@end
