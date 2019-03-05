//
//  CareAddBehaviorInstructionViewController.m
//  i2app
//
//  Created by Arcus Team on 2/28/16.
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
#import "CareAddBehaviorInstructionViewController.h"

@interface CareAddBehaviorInstructionViewController ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *showAgainLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic) BOOL hasAcknowledgedBehaviorInfo;

@end

@implementation CareAddBehaviorInstructionViewController

NSString *const kHasAcknowledBehaviorInfoKey = @"hasAcknowledgedBehaviorInfoKey";

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageLabel.text = NSLocalizedString(@"Care behavior info message", nil);
    self.showAgainLabel.text = NSLocalizedString(@"Don't show this again", nil);
    self.checkButton.selected = YES;

    [self addGradientBackground];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UI
- (void)addGradientBackground {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.view.bounds;
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:85.0/255.0 green:116.0/255.0 blue:185.0/255.0 alpha:1.0].CGColor,
                                  (__bridge id)[UIColor colorWithRed:85.0/255.0 green:36.0/255.0 blue:114.0/255.0 alpha:1.0].CGColor];
    self.gradientLayer.locations = nil;
    
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
}

#pragma mark - IBActions
- (IBAction)closeButtonTapped:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.checkButton forKey:kHasAcknowledBehaviorInfoKey];
    
    [self dismissViewControllerAnimated:YES completion: ^{
        if (self.dismissalCompletion) {
            self.dismissalCompletion();
        }
    }];
}

- (IBAction)checkMarkTapped:(id)sender {
    self.checkButton.selected = !self.checkButton.selected;
}

@end
