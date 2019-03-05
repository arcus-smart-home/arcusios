//
//  PromoViewController.m
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
#import "PromoViewController.h"
#import "BillingViewController.h"

#import <i2app-Swift.h>

@interface PromoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mainText;
@property (weak, nonatomic) IBOutlet UILabel *controlText;
@property (weak, nonatomic) IBOutlet UILabel *rulesText;
@property (weak, nonatomic) IBOutlet UILabel *favoritesText;
@property (weak, nonatomic) IBOutlet UILabel *bottomText;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation PromoViewController {
    
    __weak IBOutlet NSLayoutConstraint *bottomTextConstraint;
    __weak IBOutlet NSLayoutConstraint *topIconToTopTextConstraint;
}

+ (PromoViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CreateAccount" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Premium Plan", nil) uppercaseString]];
    [self setBackgroundColorToParentColor];
    
//    _mainText.attributedText = [FontData getString:NSLocalizedString(@"We think you'll love the Premium Plan. Try it free for two months!*", nil) withFont:FontDataTypeAccountTitle];
  
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    //add white overlay
    [self addWhiteOverlay:BackgroupOverlayLightLevel];
    
    bottomTextConstraint.constant = IS_IPHONE_5 ? 2 : 27;
}

- (IBAction)pressedNextButton:(id)sender {
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [AccountController completedAccountStep:AccountStateNewSignUpPremiumPlan
                                              model:(Model *)[[CorneaHolder shared] settings].currentAccount
                                   withAccountModel:[[CorneaHolder shared] settings].currentAccount].then(^(NSDictionary *dict) {
            [self hideGif];
            BillingViewController *vc = self.isAddAPlaceGuestMode ? [BillingViewController createInAddAPlaceGuestMode] : [BillingViewController create];
            [self.navigationController pushViewController:vc animated:YES];
        }).catch(^ {
            [self hideGif];
        });
    });
}


@end
