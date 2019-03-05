//
//  BaseTextViewController.h
//  i2app
//
//  Created by Arcus Team on 4/8/15.
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
    TextFieldStyleTypeDefault   = 0,
    TextFieldStyleTypeWhite,
} TextFieldStyleType;

@interface BaseTextViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *textFields;

- (BOOL)isDataValid:(NSString **)errorMessageKey;
- (BOOL)validateTextFields;
- (void)shakeAnimation:(UIView *)view;

// This selector needs to be implemented in the derived classes
- (void)saveRegistrationContext;

- (NSArray *)getAllSubviews:(UIView *)view;

- (UIButton *)getNextButton;

- (void)goToNextControl:(NSInteger)tagOfCurrentControl;

- (void)configureTextFieldStyle:(TextFieldStyleType)style;

@end
