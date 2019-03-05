//
//  DeviceFirmwareUpdateViewController.m
//  i2app
//
//  Created by Arcus Team on 10/12/15.
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
#import "DeviceFirmwareUpdateViewController.h"

@interface DeviceFirmwareUpdateViewController ()

@end

@implementation DeviceFirmwareUpdateViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBackground];
}

#pragma mark - UI Configuration

- (void)configureNavigationBarWithCloseButton:(BOOL)showClose {
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self setNavBarTitle:self.navigationItem.title];
    if (showClose) {
        [self addRightButtonItem:@"button_close" selector:@selector(closeButtonPressed:)];
    }
}

- (void)configureBackground {
    [self setBackgroundColorToLastNavigateColor];
    [self addWhiteOverlay:BackgroupOverlayLightLevel];
}

#pragma mark - Getters & Setters

- (NSDictionary *)primaryTextAttributes {
    // Use default if not overriden in extended class.
    if (!_primaryTextAttributes) {
        _primaryTextAttributes = [FontData getFontWithSize:17.0f
                                                      bold:NO
                                                   kerning:0.0f
                                                     color:[UIColor blackColor]];
    }
    return _primaryTextAttributes;
}

- (NSDictionary *)secondaryTextAttributes {
    // Use default if not overriden in extended class.
    if (!_secondaryTextAttributes) {
        _secondaryTextAttributes = [FontData getFontWithSize:13.0f
                                                        bold:NO
                                                     kerning:0.0f
                                                       color:[UIColor blackColor]];
    }
    return _secondaryTextAttributes;
    
}

#pragma mark - IBActions

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
