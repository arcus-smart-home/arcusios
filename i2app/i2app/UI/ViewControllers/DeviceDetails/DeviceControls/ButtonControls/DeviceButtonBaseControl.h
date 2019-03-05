//
//  DeviceButtonBaseControl.h
//  i2app
//
//  Created by Arcus Team on 7/20/15.
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
#import "DeviceButtonBase.h"
#import "TransparentTextButton.h"

typedef void(^buttonEventBlock)(id sender);

@interface DeviceButtonBaseControl : DeviceButtonBase

@property (copy) buttonEventBlock buttonEvent;
@property (strong, nonatomic) TransparentTextButton *button;
@property (assign, nonatomic) BOOL disable;


- (void)setButtonImage:(UIImage *)image;
- (void)setLabel:(NSAttributedString *)string;
- (void)setLabelText:(NSString *)string;

+ (DeviceButtonBaseControl *)create:(UIImage *)buttonImage name:(NSString *)name owner:(NSObject *)controller;
+ (DeviceButtonBaseControl *)createDefaultButton:(NSString *)name withSelector:(SEL)selector owner:(NSObject*)controller;
+ (DeviceButtonBaseControl *)create:(UIImage *)buttonImage name:(NSString *)name withSelector:(SEL)selector owner:(NSObject*)controller;
+ (DeviceButtonBaseControl *)create:(UIImage *)buttonImage name:(NSString *)name withSelector:(SEL)selector owner:(NSObject *)controller shiftButton:(BOOL)shiftButton;

- (void)setDefaultStyle:(NSString *)name withSelector:(SEL)selector owner:(NSObject*)controller;
- (void)setDefaultTransparenceStyle:(NSString *)name withSelector:(SEL)selector owner:(NSObject*)controller;
- (void)setImageStyle:(UIImage *)buttonImage withSelector:(SEL)selector owner:(NSObject*)controller;
- (void)setImageStyle:(UIImage *)buttonImage name:(NSString *)name withSelector:(SEL)selector owner:(NSObject*)controller;

@end
