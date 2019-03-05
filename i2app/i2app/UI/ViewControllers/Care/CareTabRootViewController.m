//
//  CareTabRootViewController.m
//  i2app
//
//  Created by Arcus Team on 1/28/16.
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
#import "CareTabRootViewController.h"
#import "AKFileManager.h"

#import "UIView+Blur.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"
#import "ArcusBorderedImageView.h"

@interface CareTabRootViewController ()

@end

@implementation CareTabRootViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBackgroundView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController) {
        [self.careSegementedControl setSelectedSegmentIndex:self.tabBarController.selectedIndex];
    }
}

#pragma mark - UI Configuration

- (void)configureBackgroundView {
    [self setBackgroundColorToParentColor];
}

#pragma mark - IBActions

- (IBAction)careSegementedControlValueChanged:(id)sender {
    UISegmentedControl *segementedControl = (UISegmentedControl *)sender;
    [self.tabBarController setSelectedIndex:segementedControl.selectedSegmentIndex];
}

@end
