//
//  TutorialPageViewController.m
//  i2app
//
//  Created by Arcus Team on 4/25/16.
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
#import "TutorialPageViewController.h"
#import "ArcusLabel.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ImageEffects.h"

#import "TutorialViewController.h"
#import "UIImage+ScaleSize.h"

@interface TutorialPageViewController ()

@property (weak, nonatomic) IBOutlet ArcusLabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet ArcusLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UIView *checkboxView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkboxViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToBottomConstraint;

- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)checkboxButtonPressed:(id)sender;

@end


@implementation TutorialPageViewController

const int kImageIphone5Height = 380;

+ (TutorialPageViewController *)create {
    return [[UIStoryboard storyboardWithName:@"TutorialsStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.text = self.titleText;
    self.instructionsLabel.text = self.instructionsText;
    self.imageView.image = [UIImage imageNamed:self.imageName];
    
    if (self.lastPageViewController) {
        [self.closeButton setImage:[self.closeButton.imageView.image invertColor] forState:UIControlStateNormal];
        
        
        void (^hideCheckbox)() = ^{
            self.checkboxView.hidden = YES;
            self.checkboxViewHeightConstraint.constant = 0;
        };
        
        void (^setupCheckbox)() = ^{
            [self.checkboxButton setImage:[UIImage imageNamed:@"CheckmarkDetail"] forState:UIControlStateSelected];
            [self.checkboxButton setImage:[[UIImage imageNamed:@"RoleUncheckButton"] invertColor] forState:UIControlStateNormal];
            self.checkboxButton.selected = ![self displayTutorial];
        };
        
        if (self.shouldHideShowAgain) {
            hideCheckbox();
        } else {
            if (self.tutorialType == TuturialTypeIntro) {
                hideCheckbox();
            } else {
                setupCheckbox();
            }
        }
        
        // Check the "don't show this again" checkbox by default
        self.checkboxButton.selected = YES;
        [self setDoNotShowTutorialOfType:self.checkboxButton.selected];
        
    }
    else {
        self.checkboxView.hidden = YES;
        self.checkboxViewHeightConstraint.constant = 0;
        self.closeButton.hidden = YES;
    }
    
    if (IS_IPHONE_5) {
        CGSize imageSize = self.imageView.image.size;
        if (imageSize.height > kImageIphone5Height) {
            // Resize the image
            float ratio = kImageIphone5Height / self.imageHeightConstraint.constant;
            int imageWidth = ratio * imageSize.width;
            self.imageHeightConstraint.constant = kImageIphone5Height;
            self.imageWidthConstraint.constant = imageWidth;
            
            self.imageView.image = [self.imageView.image scaleImageToFillSize:CGSizeMake(imageWidth, kImageIphone5Height)];
        }
    }
    else if (IS_IPAD) {
        self.imageToBottomConstraint.constant = ([UIScreen mainScreen].bounds.size.height - self.imageView.bounds.size.height) / 2;
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    TutorialCompletionBlock completionBlock = ((TutorialViewController *)self.parentViewController.parentViewController).completionBlock;
    if (completionBlock) {
        completionBlock();
    }
}

- (IBAction)checkboxButtonPressed:(id)sender {
    self.checkboxButton.selected = !self.checkboxButton.selected;
    [self setDoNotShowTutorialOfType:self.checkboxButton.selected];
}

- (BOOL)displayTutorial {
    switch (self.tutorialType) {
        case TuturialTypeClimate:
            return [[CorneaHolder shared] settings].displayClimateTutorial;
            
        case TuturialTypeRules:
            return [[CorneaHolder shared] settings].displayRulesTutorial;
            break;
            
        case TuturialTypeScenes:
            return [[CorneaHolder shared] settings].displayScenesTutorial;
            break;
            
        case TuturialTypeSecurity:
            return [[CorneaHolder shared] settings].displaySecurityTutorial;
            break;
            
        case TuturialTypeHistory:
            return [[CorneaHolder shared] settings].displayHistoryTutorial;
            break;
            
        default:
            return YES;
            break;
    }
}

- (void)setDoNotShowTutorialOfType:(BOOL)setToYES {
    switch (self.tutorialType) {
        case TuturialTypeClimate:
            [[[CorneaHolder shared] settings] setDoNotShowClimateTutorial:setToYES];
            break;
            
        case TuturialTypeRules:
            [[[CorneaHolder shared] settings] setDoNotShowRulesTutorial:setToYES];
            break;
            
        case TuturialTypeScenes:
            [[[CorneaHolder shared] settings] setDoNotShowScenesTutorial:setToYES];
            break;
            
        case TuturialTypeSecurity:
            [[[CorneaHolder shared] settings] setDoNotShowSecurityTutorial:setToYES];
            break;
            
        case TuturialTypeHistory:
            [[[CorneaHolder shared] settings] setDoNotShowHistoryTutorial:setToYES];
            break;
            
        default:
            break;
    }
}

@end
