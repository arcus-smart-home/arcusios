//
//  CreateFavoriteLandingViewController.m
//  i2app
//
//  Created by Arcus Team on 5/5/15.
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
#import "CreateFavoriteLandingViewController.h"
#import "ChooseDeviceViewController.h"
#import "DevicePairingWizard.h"
#import "AddViewController.h"

@interface CreateFavoriteLandingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *mainText;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)skipPressed:(id)sender;
@end

@implementation CreateFavoriteLandingViewController

#pragma mark - Life Cycle

+ (CreateFavoriteLandingViewController *)create {
    CreateFavoriteLandingViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CreateFavoriteLandingViewController class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[DevicePairingManager sharedInstance] resetAllPairingStates];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenHubScreen"];

    [self navBarWithCloseButtonAndTitle:NSLocalizedString(@"Add a Hub", nil)];
    _mainText.textAlignment = NSTextAlignmentCenter;
    _mainText.attributedText = [FontData getString:NSLocalizedString(@"The hub is the heart of the\nArcus Smart Home System,\nso let's set that up first.", nil) withFont:FontDataTypeAccountMainText];
    [self setBackgroundColorToDashboardColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    _skipButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _skipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_skipButton setAttributedTitle:[FontData getString:NSLocalizedString(@"Using Arcus without a hub?\nSkip this Step.", nil) withFont:FontDataTypeAccountSubTextWithOpacity] forState:UIControlStateNormal];
}

- (IBAction)nextButtonPressed:(id)sender {
    [DevicePairingWizard createHubPairingSteps:YES];
}

- (IBAction)skipPressed:(id)sender {
    AddViewController *vc = [AddViewController create];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
