//
//  CareLearnMoreViewController.m
//  i2app
//
//  Created by Arcus Team on 2/26/16.
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
#import "CareLearnMoreViewController.h"

@interface CareLearnMoreViewController ()
//@property (nonatomic, weak) IBOutlet UISegmentedControl *careSegementedControl;
@property (weak, nonatomic) IBOutlet UITextView *careMessageTextView;
@property (weak, nonatomic) IBOutlet UITextView *carePremiumTextView;
@end

@implementation CareLearnMoreViewController

BOOL _CareLearnFromDashboardCell;

#pragma mark - View LifeCycle

+ (CareLearnMoreViewController *)create {
    _CareLearnFromDashboardCell = YES;
    return [[UIStoryboard storyboardWithName:@"CareLearnMore" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareLearnMoreViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Care", nil)];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [[self careMessageTextView] setText:NSLocalizedString(@"Care Learn More text", nil)];
    [[self carePremiumTextView] setText:NSLocalizedString(@"Care Learn More Premium text", nil)];
    
    [[self careMessageTextView] setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]];
    [[self careMessageTextView] setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]];
    [[self carePremiumTextView] setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]];
    [[self carePremiumTextView] setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]];
    
    if(_CareLearnFromDashboardCell == YES) {
        [[self careSegementedControl] setHidden:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(_CareLearnFromDashboardCell == YES) {
        [[self careSegementedControl] setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
