//
//  SettingsBaseViewController.m
//  i2app
//
//  Created by Arcus Team on 8/11/15.
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
#import "SettingsBaseViewController.h"

#import "PopupSelectionWindow.h"

#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"
#import "AKFileManager.h"

@interface SettingsBaseViewController ()

@end

@implementation SettingsBaseViewController {
    PopupSelectionWindow *_popupWindow;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
}

#pragma mark - Background Image Configuration

- (void)configureViewBackgroundWithColor:(UIColor *)backgroundColor {
    if (backgroundColor) {
        self.view.backgroundColor = backgroundColor;
        self.navigationController.view.backgroundColor = backgroundColor;
    }
}

#pragma mark - Background Image Handling

- (void)setDashboardBackgroundImage:(UIImage *)image {
    if (image) {
        image = [image backgroundZoomScaleAndCutSizeInCenter:[UIScreen mainScreen].bounds.size];
        image = [image applyLightEffect];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        [self.view setNeedsLayout];
    }
    
    self.navigationController.view.backgroundColor = self.view.backgroundColor;
    [self.view setNeedsLayout];
    [self.navigationController.view setNeedsLayout];
}

- (void)setDashboardBackgroundImage:(UIImage *)image forImageView:(UIImageView *)imageView {
    [self.view renderLogoAndBackgroundWithImage:image forLogoControl:imageView];
    self.navigationController.view.backgroundColor = self.view.backgroundColor;
    [self.view setNeedsLayout];
    [self.navigationController.view setNeedsLayout];
}

#pragma mark - Popup

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)popupWarning:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector
                                         style:PopupWindowStyleCautionWindow];
}

- (void)closePopup {
    [_popupWindow close];
}

@end

