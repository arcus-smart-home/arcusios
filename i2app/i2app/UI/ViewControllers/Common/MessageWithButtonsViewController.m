//
//  MessageWithButtonsViewController.m
//  i2app
//
//  Created by Arcus Team on 9/30/15.
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
#import "MessageWithButtonsViewController.h"
#import "DeviceDetailsTabBarController.h"
#import "DeviceListViewController.h"
#import "UIView+Subviews.h"

#pragma mark - MessageWithButtonsControllerModel
@implementation MessageWithButtonsControllerModel

- (instancetype)init {
    if (self = [super init]) {
        self.viewController = [MessageWithButtonsViewController create:self];
    }
    return self;
}

- (void)beginRuning {
    
}

@end


@interface MessageWithButtonsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *clickabeButton;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (strong, nonatomic) MessageWithButtonsControllerModel *controllerModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraint;

@end

#pragma mark - MessageWithButtonsViewController
@implementation MessageWithButtonsViewController

+ (MessageWithButtonsViewController *)create:(MessageWithButtonsControllerModel *)controlModel {
    MessageWithButtonsViewController *vc = [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.controllerModel = controlModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundColorToLastNavigateColor];
    [self addWhiteOverlay:BackgroupOverlayHeavyLevel];

    if (self.controllerModel.hasCloseButton) {
        [self navBarWithCloseButtonAndTitle:self.controllerModel.controllerTitle];
    }
    else {
        [self setNavBarTitle:self.controllerModel.controllerTitle];
        [self hideBackButton];
    }

    if (self.controllerModel.iconImage) {
        [self.iconView setImage:self.controllerModel.iconImage];
    } else {
        self.iconView.hidden = YES;
        [self.iconView removeFromSuperview];
    }

    if (self.controllerModel.clickableButtonName && self.controllerModel.clickableButtonSelector) {
        [self.clickabeButton styleSet:[NSString stringWithFormat:@" %@ ",self.controllerModel.clickableButtonName] andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:YES space:YES alpha:YES]];
        self.clickabeButton.layer.cornerRadius = 4.0f;
        self.clickabeButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f].CGColor;
        self.clickabeButton.layer.borderWidth = 1.0f;

        [self.clickabeButton addTarget:self.controllerModel action:self.controllerModel.clickableButtonSelector forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.clickabeButton setHidden:YES];
    }

    if (self.controllerModel.topButtonName && self.controllerModel.topButtonSelector) {
        [self.topButton styleSet:self.controllerModel.topButtonName andButtonType:FontDataTypeButtonDark upperCase:YES];
        [self.topButton addTarget:self.controllerModel action:self.controllerModel.topButtonSelector forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.topButton setHidden:YES];
        _scrollViewConstraint.constant = 65;
    }

    if (self.controllerModel.secondButtonName && self.controllerModel.secondButtonSelector) {
        [self.secondButton styleSet:self.controllerModel.secondButtonName andButtonType:FontDataTypeButtonDark upperCase:YES];
        [self.secondButton addTarget:self.controllerModel action:self.controllerModel.secondButtonSelector forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.secondButton setHidden:YES];
        _scrollViewConstraint.constant = 10;
    }

    [self refresh];
    
    [self.controllerModel beginRuning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.controllerModel.openSelector) {
        [self.controllerModel performSelector:self.controllerModel.openSelector withObject:nil afterDelay:0];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.controllerModel.closeSelector) {
        [self.controllerModel performSelector:self.controllerModel.closeSelector withObject:nil afterDelay:0];
    }
}

#pragma mark -

- (void)refresh {
    self.titleLabel.text = self.controllerModel.title;
    self.subtitleLabel.text = self.controllerModel.subtitle;
}

- (void)close:(NSObject *)sender {
    if (self.controllerModel.goToDeviceList) {
        UIViewController *vc = [self findLastViewController:[DeviceListViewController class]];
        if (vc) {
            [self.navigationController popToViewController:vc animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else {
        [self.navigationController popToViewController:[self findLastViewController:[DeviceDetailsTabBarController class]] animated:YES];
    }
}

@end
