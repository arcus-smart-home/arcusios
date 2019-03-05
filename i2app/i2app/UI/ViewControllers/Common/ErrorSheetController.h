//
//  ErrorSheetController.h
//  i2app
//
//  Created by Arcus Team on 2/8/16.
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

@interface ErrorSheetModel : NSObject

@property (weak, nonatomic) id eventOwner;
@property (weak, nonatomic) UIViewController *popupController;

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSAttributedString *firstText;
@property (strong, nonatomic) NSAttributedString *secondText;
@property (strong, nonatomic) NSAttributedString *thirdText;
@property (strong, nonatomic) NSString *buttonText;
@property (assign, nonatomic) SEL onClickBottom;

@property (strong, nonatomic) UIColor *backgoundTopColor;
@property (strong, nonatomic) UIColor *backgoundBottomColor;

@end

@interface ErrorSheetController : UIViewController

+ (ErrorSheetController *)popup:(ErrorSheetModel *)model;

@end
