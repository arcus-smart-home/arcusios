//
//  PopupSelectionWindow.m
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

#import <i2app-Swift.h>
#import "PopupSelectionWindow.h"
#import <PureLayout/PureLayout.h>
#import "PopupSelectionBaseContainer.h"
#import "UIImage+ImageEffects.h"
#import "NSObject+PerformSelector.h"
#import <i2app-Swift.h>

@interface PopupSelectionWindow ()

@property (weak, nonatomic) IBOutlet UIView *selestionContainerView;
@property (weak, nonatomic) IBOutlet UIButton *backgroupButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerBottomConstraint;

@property (assign, nonatomic) SEL closeSelector;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButtonWhite;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeButtonTopConstraint;

@property (nonatomic) PopupWindowStyle style;

@property (nonatomic, copy) void (^closeBlock)(id obj);

@property (atomic, assign) BOOL inRootViewControllerWindow;

@property (strong, nonatomic) UIViewController *containerController;

@end

@implementation PopupSelectionWindow
- (void)awakeFromNib {
    [super awakeFromNib];

    _displayCloseButton = YES;
}

- (instancetype)init {
    if (self = [super init]) {
        _displayCloseButton = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        _displayCloseButton = YES;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _displayCloseButton = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.containerController) {
        CGFloat margin = 64;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
            UIScreen.mainScreen.nativeBounds.size.height == 2436)  {
            if (@available(iOS 11.0, *)) {
              margin += UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
              self.closeButtonTopConstraint.constant += UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
            }
        }
        self.containerHeightConstraint.constant = self.container.bounds.size.height + margin;
        
        [self.view addSubview:_subview.view];
        [_subview.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.closeButton];
        [_subview.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_subview.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_subview.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    }
    
    switch (_style) {
        case PopupWindowStyleMessageWindow:
            [self.selestionContainerView setBackgroundColor:[UIColor whiteColor]];
            [self.subview.view setBackgroundColor:[UIColor whiteColor]];
            self.closeButton.hidden = !_displayCloseButton;
            self.closeButtonWhite.hidden = YES;
            break;

        case PopupWindowStyleCautionWindow:
            [self.selestionContainerView setBackgroundColor:pinkAlertColor];
            [self.subview.view setBackgroundColor:pinkAlertColor];
            self.closeButtonWhite.hidden = !_displayCloseButton;
            self.closeButton.hidden = YES;
            break;

        default:
            break;
    }

    [self.view bringSubviewToFront:self.closeButton];
}

+ (PopupSelectionWindow *)present:(UIViewController *)container subview:(PopupSelectionBaseContainer *)subview owner:(NSObject *)owner closeSelector:(SEL)selector {
    
    PopupSelectionWindow *window = [[PopupSelectionWindow alloc] initWithNibName:@"PopupSelectionWindow" bundle:nil];
    
    window.container = container.view;
    window.containerController = container;
    window.subview = subview;
    [window.subview setStyle:PopupWindowStyleMessageWindow];
    window.closeSelector = selector;
    window.displayCloseButton = YES;
    window.owner = owner;
    [subview setWindow:window];
    window.style = PopupWindowStyleMessageWindow;
    
    [container presentViewController:window animated:YES completion:nil];
    
    return window;
}

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector {
    return [self popup:container subview:subview owner:owner closeSelector:selector style:PopupWindowStyleMessageWindow];
}

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector
     inRootViewControllerWindow:(BOOL)inRootVc {
    PopupSelectionWindow *window = [self popup:container subview:subview owner:owner closeSelector:selector style:PopupWindowStyleMessageWindow];
    window.inRootViewControllerWindow = inRootVc;
    return window;
}

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
              displyCloseButton:(BOOL)state {
    return [self popup:container subview:subview owner:owner closeSelector:nil style:PopupWindowStyleMessageWindow displyCloseButton:state];
}

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
              displyCloseButton:(BOOL)state
                  closeSelector:(SEL)selector
                          style:(PopupWindowStyle)style {
    return [self popup:container subview:subview owner:owner closeSelector:selector style:style displyCloseButton:state];
}

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector
                          style:(PopupWindowStyle)style {
    return [self popup:container subview:subview owner:owner closeSelector:selector style:style displyCloseButton:YES];
}

+ (PopupSelectionWindow *)popup:(UIView *)container
                        subview:(PopupSelectionBaseContainer *)subview
                          owner:(NSObject *)owner
                  closeSelector:(SEL)selector
                          style:(PopupWindowStyle)style
                     closeBlock:(void (^)(id obj))closeBlock {
    PopupSelectionWindow *window = [self popup:container subview:subview owner:owner closeSelector:selector style:style displyCloseButton:YES];
    window.closeBlock = closeBlock;
    return window;
}

+ (PopupSelectionWindow *)popup:(UIView *)container subview:(PopupSelectionBaseContainer *)subview owner:(NSObject *)owner closeSelector:(SEL)selector style:(PopupWindowStyle)style displyCloseButton:(BOOL)state {
    
    PopupSelectionWindow *window = [[PopupSelectionWindow alloc] initWithNibName:@"PopupSelectionWindow" bundle:nil];
    
    window.container = container;
    window.subview = subview;
    [window.subview setStyle:style];
    window.closeSelector = selector;
    window.displayCloseButton = state;
    
    window.owner = owner;
    [subview setWindow:window];
    
    window.style = style;
    
    [window open];
    return window;
}

+ (PopupSelectionWindow *)popupWithBlock:(UIView *)container subview:(PopupSelectionBaseContainer *)subview owner:(NSObject *)owner closeBlock:(void (^)(id obj))closeBlock {
    
    PopupSelectionWindow *window = [[PopupSelectionWindow alloc] initWithNibName:@"PopupSelectionWindow" bundle:nil];
    
    window.container = container;
    window.subview = subview;
    window.closeBlock = closeBlock;
    window.owner = owner;
    [subview setWindow:window];
    
    [window open];
    return window;
}

+ (PopupSelectionWindow *)popup:(UIView *)container subview:(PopupSelectionBaseContainer *)subview {
    return [self popup:container subview:subview style:PopupWindowStyleMessageWindow];
}

+ (PopupSelectionWindow *)popup:(UIView *)container subview:(PopupSelectionBaseContainer *)subview style:(PopupWindowStyle)style {
    PopupSelectionWindow *window = [[PopupSelectionWindow alloc] initWithNibName:@"PopupSelectionWindow" bundle:nil];
    
    window.container = container;
    window.subview = subview;
    [window.subview setStyle:style];
    [subview setWindow:window];
    
    window.style = style;
    
    [window open];
    return window;
}

- (void)open {
  CGFloat padding = 40;
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
      UIScreen.mainScreen.nativeBounds.size.height == 2436)  {
      if (@available(iOS 11.0, *)) {
        CGFloat distanceToTop = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
        padding += distanceToTop;
      }
  }
  
  CGFloat height = [self.subview getHeight] + padding;
  [self openWithHeight:height offset:padding];
}

- (void)openWithHeight:(CGFloat)height offset:(CGFloat)offset {
  if (_displaying) {
    return;
  }

  if (!self.inRootViewControllerWindow) {
    [_container addSubview:self.view];
  }
  else {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.view addSubview:self.view];
  }

  _displaying = YES;

  [self.view autoPinEdgeToSuperviewEdge:ALEdgeTop];
  [self.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
  [self.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
  [self.view autoPinEdgeToSuperviewEdge:ALEdgeRight];

  self.containerHeightConstraint.constant = height;
  self.containerBottomConstraint.constant = -height;

  [self.selestionContainerView addSubview:_subview.view];
  [_subview.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.selestionContainerView withOffset:offset];
  [_subview.view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.selestionContainerView];
  [_subview.view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.selestionContainerView];
  [_subview.view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.selestionContainerView];

  [_container layoutIfNeeded];
  [UIView animateWithDuration:0.5f animations:^{
    self.containerBottomConstraint.constant = 0;
    [_container layoutIfNeeded];
  } completion:^(BOOL finished) {

  }];
}

- (void)close {
    if (self.containerController) {
        [self.containerController dismissViewControllerAnimated:YES completion:^{
            id obj = [self.subview getSelectedValue];
            if (_closeSelector && _owner && [_owner respondsToSelector:_closeSelector]) {
                [_owner performSelector:_closeSelector withTarget:_owner withObject:obj withObject:self.subview.dataObject];
            }
            if (self.closeBlock) {
                self.closeBlock(obj);
            }
        }];
        return;
    }
    
    if (!_displaying) {
        return;
    }
    
    NSNumber *selectedValue = (NSNumber *)[self.subview getSelectedValue];
    if (_closeSelector && _owner && [_owner respondsToSelector:_closeSelector]) {
        [_owner performSelector:_closeSelector withTarget:_owner withObject:selectedValue withObject:self.subview.dataObject];
    }
    
    if (self.closeBlock) {
        self.closeBlock(selectedValue);
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.containerBottomConstraint.constant = -([self.subview getHeight] + 40);
        [self.view.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        _displaying = NO;
        [self.view removeFromSuperview];
    }];
}

- (IBAction)clickClose:(id)sender {
    [self close];
}

- (IBAction)clickBackgroupButton:(id)sender {
}

@end
