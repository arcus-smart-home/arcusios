//
//  UIViewController+DisplayError.h
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
#import "FontData.h"

@interface UIViewController (DisplayError)

@property (nonatomic, strong, readonly) NSString *genericErrorMessage;

- (void)displayGenericErrorMessage;
- (void)displayGenericErrorMessageWithError:(NSError *)error;
- (void)displayGenericErrorMessageWithMessage:(NSString *)errorMessage;

- (void)displayErrorMessage:(NSString *)errorMessageKey withTitle:(NSString *)titleKey;
- (void)displayErrorMessageWhite:(NSString *)errorMessageKey withTitle:(NSString *)titleKey;
- (void)displayErrorMessage:(NSString *)errorMessageKey;
- (void)displayMessage:(NSString *)title subtitle:(NSString *)subtitle buttonOne:(NSString *)button1 buttonTwo:(NSString *)button2;
- (void)displayMessage:(NSString *)title subtitle:(NSString *)subtitle buttonOne:(NSString *)button1 buttonTwo:(NSString *)button2 withTarget:(id)target withButtonOneSelector:(SEL)buttonOneTapped andButtonTwoSelector:(SEL)buttonTwoTapped;
- (void)displayMessage:(NSString *)title subtitle:(NSString *)subtitle backgroundColor:(UIColor *)bgColor buttonOne:(NSString *)button1 buttonTwo:(NSString *)button2  buttoneOneStyle:(FontDataType)buttonOneStyle buttonTwoStyle:(FontDataType)buttonTwoStyle withTarget:(id)target withButtonOneSelector:(SEL)buttonOneTapped andButtonTwoSelector:(SEL)buttonTwoTapped;
- (void)slideOutTwoButtonAlert;

- (void)popupMessageWindow:(NSString *)title subtitle:(NSString *)subtitle;
- (void)popupErrorWindow:(NSString *)title subtitle:(NSString *)subtitle;

@end
