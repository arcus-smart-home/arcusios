//
//  PopupSelectionNumberView.h
//  i2app
//
//  Created by Arcus Team on 8/28/15.
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

#import "PopupSelectionBaseContainer.h"

@interface PopupSelectionNumberView : PopupSelectionBaseContainer

+ (PopupSelectionNumberView *)create:(NSString *)title withMaxNumber:(CGFloat)max;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min andMaxNumber:(CGFloat)max;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max andPostfix:(NSString *)postfix;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max andPostfix:(NSString *)postfix ignoreMinMaxRule:(BOOL)ignoreMinMaxRule;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step andPostfix:(NSString *)postfix;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max withSign:(NSString *)sign;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step withSign:(NSString *)sign;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max postfix:(NSString *)postfix sign:(NSString *)sign;
+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step postfix:(NSString *)postfix sign:(NSString *)sign;

+ (PopupSelectionNumberView *)create:(NSString *)title subtitle:(NSString *)subtitle withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step withSign:(NSString *)sign;

+ (PopupSelectionNumberView *)create:(NSString *)title withNumbers:(NSArray<NSNumber *> *)numbers postfix:(NSString *)postfix;
+ (PopupSelectionNumberView *)create:(NSString *)title withNumbers:(NSArray<NSNumber *> *)numbers labelTransform:(NSString*(^)(NSNumber*))transform;

- (PopupSelectionNumberView *)setSignWithFrame:(BOOL)frame;

@end
