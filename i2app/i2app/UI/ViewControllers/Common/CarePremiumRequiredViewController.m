//
//  CarePremiumRequiredViewController.m
//  i2app
//
//  Created by Arcus Team on 2/23/16.
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
#import "CarePremiumRequiredViewController.h"

@interface CarePremiumRequiredViewController ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

//Generic premium required outlets
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewsHiddenSaveSpace;

//Care behavior-specific
@property (weak, nonatomic) IBOutlet UILabel *firstTeaserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTeaserDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTeaserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTeaserDescriptionLabel;


@end


@implementation CarePremiumRequiredViewController

#pragma mark - Creation
+ (CarePremiumRequiredViewController *)create {
    CarePremiumRequiredViewController *vc = [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - UI
- (void)setUpUI {
    [self createGradientBackground];
    [self.titleImageView setImage:[UIImage imageNamed:@"icon_unfilled_care"]];
    [self.titleImageView setTintColor:[UIColor whiteColor]];
    [self.titleLabel setText:NSLocalizedString(@"Feature Not Available on Current Plan", nil)];
    [self.subtitleLabel setText:NSLocalizedString(@"Care premium required subtitle", nil)];
    
    [self.firstTeaserNameLabel setText:NSLocalizedString(@"No activity detected", nil)];
    [self.firstTeaserDescriptionLabel setText:NSLocalizedString(@"No activity detected description", nil)];
    [self.secondTeaserNameLabel setText:NSLocalizedString(@"Curfew", nil)];
    [self.secondTeaserDescriptionLabel setText:NSLocalizedString(@"Curfew description", nil)];
}

- (void)createGradientBackground {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.view.bounds;
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:155.0/255.0 green:70.0/255.0 blue:138.0/255.0 alpha:1.0].CGColor,
                                  (__bridge id)[UIColor colorWithRed:85.0/255.0 green:116.0/255.0 blue:185.0/255.0 alpha:1.0].CGColor];
    self.gradientLayer.locations = nil;
    
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
}

#pragma mark - Dismissal
- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
