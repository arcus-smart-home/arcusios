//
//  PopupSelectionWindow.h
//  i2app
//
//  Created by Arcus Team on 7/22/15.
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

@class PopupSelectionBaseContainer;

typedef enum {
    PopupWindowStyleMessageWindow   = 0,
    PopupWindowStyleCautionWindow,
} PopupWindowStyle;


@interface PopupSelectionWindow : UIViewController

@property (weak, nonatomic) UIView *container;
@property (weak, nonatomic) NSObject *owner;
@property (strong, nonatomic) PopupSelectionBaseContainer *subview;
@property (atomic, assign) BOOL displayCloseButton;
@property (readonly, atomic) BOOL displaying;

+ (PopupSelectionWindow *)present:(UIViewController *)container
                          subview:(PopupSelectionBaseContainer *)subview
                            owner:(NSObject *)owner
                    closeSelector:(SEL)selector;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector
     inRootViewControllerWindow:(BOOL)inRootVc;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
              displyCloseButton:(BOOL)state;

+ (PopupSelectionWindow *)popupWithBlock:(UIView *)container
                                 subview:(PopupSelectionBaseContainer *)subview
                                   owner:(NSObject *)owner
                              closeBlock:(void (^)(id obj))closeBlock;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
              displyCloseButton:(BOOL)state
                  closeSelector:(SEL)selector
                          style:(PopupWindowStyle)style;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector
                          style:(PopupWindowStyle)style;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector
                          style:(PopupWindowStyle)style
                     closeBlock:(void (^)(id obj))closeBlock;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector
                          style:(PopupWindowStyle)style
              displyCloseButton:(BOOL)state;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview;

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          style:(PopupWindowStyle)style;


- (void)open;
- (void)openWithHeight:(CGFloat)height offset:(CGFloat)offset;
- (void)close;


@end
