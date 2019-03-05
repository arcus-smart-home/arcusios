//
//  UIViewController+Navigation.h
//  i2app
//
//  Created by Arcus Team on 4/7/15.
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

@interface UIViewController (Navigation)

@property (nonatomic, strong) NSDictionary *navigationIconsWhite;
@property (nonatomic, strong) NSDictionary *navigationIconsBlack;

- (void)navBarWithTitleImage;
- (void)navBarWithBackButtonAndTitleImage;
- (void)navBarWithCloseButtonAndTitle:(NSString *)title;
- (void)navBarWithTitle:(NSString *)title enableBackButton:(BOOL)enabled;
- (void)navBarWithBackButtonAndTitle:(NSString *)title;
- (void)navBarWithCloseButtonAndTitleImage;
- (void)navBarWithTitle:(NSString *) title;
- (void)navBarWithTitle:(NSString *)title textColor:(UIColor *)textColor;

- (void)navBarWithBackButtonAndTitle:(NSString *)title
                rightButtonImageName:(NSString *)imageName
                 rightButtonSelector:(SEL)selector;

- (void)navBarWithLeftButton:(NSString *)leftButtonImageName
          leftButtonSelector:(SEL)leftButtonSelector
              andRightButton:(NSString *)rightButtonImageName
         rightButtonSelector:(SEL)rightButtonSelector
         withTitleImageNamed:(NSString *)imageName;

- (void)navBarWithLeftButtonImage:(UIImage *)leftButtonImage
               leftButtonSelector:(SEL)leftButtonSelector
              andRightButtonImage:(UIImage *)rightButtonImage
              rightButtonSelector:(SEL)rightButtonSelector
                   withTitleImage:(UIImage *)image;

- (void)navBarWithLeftButtonImage:(UIImage *)leftButtonImage
               leftButtonSelector:(SEL)leftButtonSelector
              andRightButtonImage:(UIImage *)rightButtonImage
              rightButtonSelector:(SEL)rightButtonSelector
                   withTitleImage:(UIImage *)image
                        animation:(BOOL)animation;

- (void)navBarWithTitle:(NSString *)title
     andRightButtonText:(NSString *)text
           withSelector:(SEL)selector;

- (void)navBarWithTitle:(NSString *)title
     andRightButtonText:(NSString *)text
              textColor:(UIColor *)textColor
           withSelector:(SEL)selector
         selectorTarget:(id)target;

- (void)navBarWithTitle:(NSString *)title
     andRightButtonText:(NSString *)text
           withSelector:(SEL)selector
         selectorTarget:(id)target;

- (void)addRightButtonItem:(NSString *)imageName selector:(SEL)selector;

- (void)addRightButtonText:(NSString *)name selector:(SEL)selector;

- (void)addCloseButtonItem;

- (void)addBackButtonItemAsLeftButtonItem;

- (void)hideBackButton;
- (void)hideRightButton;

- (void)navBarWithSearchBar;

- (void)setNavBarTitle:(NSString *)title;

// Find the UIViewController with class type is aClass
- (UIViewController *)findLastViewController:(Class)aClass;
- (UIViewController *)findViewControllerByIndex:(int)numberOfIndex;

@end
