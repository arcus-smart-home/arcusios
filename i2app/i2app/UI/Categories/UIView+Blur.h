//
//  UIView+Blur.h
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

#import <UIKit/UIKit.h>

@interface UIView (Blur)

- (void)createBlurredBackground:(UIViewController *)presentingViewController;

- (UIColor *)createBackgroundColorFromView:(UIView *)view;
- (void)createBlurredBackgroundFromImageNamed:(NSString *)imageName;
- (void)setBackgroundColorWithColor:(UIColor *)color;

- (UIColor *)createBackgroundWithBlurScale:(NSString *)imageName;
- (UIColor *)createImageBackgroundWithBlurScale:(UIImage *)image;


- (BOOL)renderLogoAndBackgroundWithImageNamed:(NSString *)imageName forLogoControl:(UIView *)photoView;
- (BOOL)renderLogoAndBackgroundWithImage:(UIImage *)image forLogoControl:(UIView *)photoView;

@end
