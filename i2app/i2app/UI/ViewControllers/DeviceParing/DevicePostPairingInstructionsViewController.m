//
//  DevicePostPairingInstructionsViewController.m
//  i2app
//
//  Created by Arcus Team on 4/6/16.
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
#import "DevicePostPairingInstructionsViewController.h"
#import "PairingStep.h"

@interface DevicePostPairingInstructionsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation DevicePostPairingInstructionsViewController

#pragma mark - View LifeCycle 

+ (instancetype)create {
    UIStoryboard *devicePairingStoryboard = [UIStoryboard storyboardWithName:@"PairDevice"
                                                                      bundle:nil];
    return [devicePairingStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

+ (instancetype)createWithDeviceStep:(PairingStep *)step {
    UIStoryboard *devicePairingStoryboard = [UIStoryboard storyboardWithName:@"PairDevice"
                                                                      bundle:nil];
    DevicePostPairingInstructionsViewController *viewController = [devicePairingStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];

    if (step) {
        [viewController setDeviceStep:step];
    }
    
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.nextButton styleSet:@"Next" andButtonType:FontDataTypeButtonDark upperCase:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController) {
        [self configureNavigationBar];
        [self configureViewBackground];
        [self configureInstructionLabels];
    }
}

#pragma mark - UI Configuration

- (void)configureNavigationBar {
    if (self.step.title) {
        [self navBarWithBackButtonAndTitle:self.step.title];
    }
}

- (void)configureViewBackground {
    [self setBackgroundColorToParentColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
}

- (void)configureInstructionLabels {
    if (self.step.instructionTitle) {
        self.titleLabel.text = self.step.instructionTitle;
    }
    
    if (self.step.instructionText) {
        self.instructionsLabel.text = self.step.instructionText;
    }
}

@end
