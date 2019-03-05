//
//  CareNoDeviceViewController.m
//  i2app
//
//  Created by Arcus Team on 3/8/16.
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
#import "CareNoDeviceViewController.h"
#import <i2app-Swift.h>

@interface CareNoDeviceViewController ()
@property (weak, nonatomic) IBOutlet UITextView *careMessageTextView;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@end

@implementation CareNoDeviceViewController

#pragma mark - View LifeCycle

+ (CareNoDeviceViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CareLearnMore" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareNoDeviceViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Care", nil)];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [[self careMessageTextView] setText:NSLocalizedString(@"Care Learn More text", nil)];
    
    [[self careMessageTextView] setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15.0]];
    [[self careMessageTextView] setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    
    [self customizeLearnMoreButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeLearnMoreButton {
    [_contactButton styleSet:@"Shop Care Devices" andFontData:[FontData createFontData:FontTypeMedium size:11 blackColor:NO space:YES] upperCase:YES];
    _contactButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _contactButton.layer.borderWidth = 1.0f;
    _contactButton.layer.cornerRadius = 4.0f;
    
    [_contactButton addTarget:self action:@selector(pressedContactButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressedContactButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL ProductsCare]];
}

@end
