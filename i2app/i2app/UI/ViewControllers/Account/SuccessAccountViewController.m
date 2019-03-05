//
//  SuccessAccountViewController.m
//  i2app
//
//  Created by Arcus Team on 4/7/15.
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
#import "SuccessAccountViewController.h"
#import "DevicePairingWizard.h"

#import "PersonCapability.h"
#import "PlaceCapability.h"
#import "AccountCapability.h"

#import <i2app-Swift.h>

@interface SuccessAccountViewController ()

@property (weak, nonatomic) IBOutlet AddPlaceCongratsView *congratsGuestView;
@property (weak, nonatomic) IBOutlet UIView *congratsCreationView;
@property (weak, nonatomic) IBOutlet UILabel *mainText;
@property (weak, nonatomic) IBOutlet UILabel *subText;
@property (weak, nonatomic) IBOutlet UILabel *alarmText;
@property (weak, nonatomic) IBOutlet UILabel *thermostatText;
@property (weak, nonatomic) IBOutlet UILabel *lightsText;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonPressed:(id)sender;

@end

@implementation SuccessAccountViewController {

}

#pragma mark - Life Cycle
+ (SuccessAccountViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CreateAccount" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SuccessAccountViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Tag when a user completes signup successfully
    [ArcusAnalytics tag:AnalyticsTags.AccountCreationSignUpComplete attributes:@{}];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"accountJustCreated"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self navBarWithCloseButtonAndTitle:NSLocalizedString(@"Congrats", nil)];
    [self setBackgroundColorToParentColor];

    // Check if the user already has an account and is in Add Arcus to Your Home
    NSUInteger placesWithPin = [[PersonCapability getPlacesWithPinFromModel:[[CorneaHolder shared] settings].currentPerson] count];
    if (placesWithPin > 1) {
      NSString *title = NSLocalizedString(@"You've successfully added %@ to your account.", comment: "");
      NSString *placeName = [PlaceCapability getNameFromModel:[[CorneaHolder shared] settings].currentPlace];

      self.congratsGuestView.titleText.text = [NSString stringWithFormat:title, placeName];
      self.congratsGuestView.hidden = NO;
      self.congratsCreationView.hidden = YES;
    } else {
      self.congratsGuestView.hidden = YES;
      self.congratsCreationView.hidden = NO;
    }

    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [AccountController completedAccountStep:AccountStateNewSignUpComplete
                                              model:CorneaHolder.shared.settings.currentAccount
                                   withAccountModel:CorneaHolder.shared.settings.currentAccount];
    });
}

#pragma mark - Close
- (void)close:(id)sender {
    [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
}

- (IBAction)nextButtonPressed:(id)sender {
    [self close:sender];
}

@end
