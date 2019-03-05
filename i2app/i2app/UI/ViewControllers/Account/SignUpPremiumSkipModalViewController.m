//
//  SignUpPremiumSkipModalViewController.m
//  i2app
//
//  Created by Arcus Team on 4/19/16.
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
#import "SignUpPremiumSkipModalViewController.h"
#import "UIImage+ImageEffects.h"

@interface SignUpPremiumSkipModalViewController ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelsToBeLocalized;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewsToTint;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation SignUpPremiumSkipModalViewController

NSString *const signUpPremiumToSegueIdentifier = @"premiumSkipSegue";

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UILabel *label in self.labelsToBeLocalized) {
        label.text = NSLocalizedString(label.text, nil);
    }
    
    for (UIImageView *imageView in self.imageViewsToTint) {
        if (imageView.tag == 1) {
            [imageView setImage: [imageView.image invertColor]];
        }
    }
    
    [self.skipButton styleSet:NSLocalizedString(self.skipButton.titleLabel.text, nil).uppercaseString andButtonType:FontDataTypeButtonDark];
    [self.startButton styleSet:NSLocalizedString(self.startButton.titleLabel.text, nil).uppercaseString andButtonType:FontDataTypeButtonDark];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - IBActions
- (IBAction)didPressSkipButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.skipBlock) {
            self.skipBlock();
        }
    }];
}

- (IBAction)didPressStartButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.startBlock) {
            self.startBlock();
        }
    }];
}

- (IBAction)didPressCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
