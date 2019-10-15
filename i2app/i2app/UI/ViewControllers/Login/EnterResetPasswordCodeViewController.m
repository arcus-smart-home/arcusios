//
//  EnterResetPasswordCodeViewController.m
//  i2app
//
//  Created by Arcus Team on 7/27/15.
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
#import "EnterResetPasswordCodeViewController.h"
#import "ResetPasswordViewController.h"
#import "AccountTextField.h"
#import "NSString+Validate.h"
#import <i2app-Swift.h>

@interface EnterResetPasswordCodeViewController ()

@property (weak, nonatomic) IBOutlet AccountTextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;
@property (weak, nonatomic) IBOutlet UILabel *mainText;
@property (weak, nonatomic) IBOutlet UIButton *callingButton;
@property (weak, nonatomic) IBOutlet AccountTextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailAddressHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeTextFieldTopConstraint;

@property (nonatomic, strong) NSString *email;

@property (atomic, assign) BOOL emailINeeded;
@end


@implementation EnterResetPasswordCodeViewController

#pragma mark - Life Cycle
+ (EnterResetPasswordCodeViewController *)createWithEmail:(NSString *)email {
    EnterResetPasswordCodeViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([EnterResetPasswordCodeViewController class])];
    
    if (email.length > 0) {
        vc.email = email;
        vc.emailINeeded = NO;
    }
    else {
        vc.emailINeeded = YES;
    }
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Forgot Password", nil) uppercaseString]];
    
    [self setBackgroundColorToParentColor];
    
    _codeTextField.placeholder = [NSLocalizedString(@"Enter Code", nil) uppercaseString];
    [_codeTextField setupType:AccountTextFieldTypeGeneral];

    _emailAddressTextField.placeholder = [NSLocalizedString(@"Enter Email Address", nil) uppercaseString];
    [_emailAddressTextField setupType:AccountTextFieldTypeEmail];

    [_sendEmailButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    _mainText.attributedText = [FontData getString:NSLocalizedString(@"Check your inbox.", nil) withFont:FontDataTypeAccountMainText];
    
    _callingButton.layer.borderWidth = 1.0f;
    _callingButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f].CGColor;
    _callingButton.layer.cornerRadius = 6.0f;
    
    if (!self.emailINeeded) {
        // The email address is already available. No need to provide an email address field
        self.emailAddressHeightConstraint.constant = 0;
        self.codeTextFieldTopConstraint.constant = 10;
        self.textFields = @[self.codeTextField];
    }
}

- (IBAction)onClickCallingButton:(id)sender {
    // This will need to be addressed if support is added.
//    NSString *phNo = @"+18554694747";
//    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
//
//    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//        [[UIApplication sharedApplication] openURL:phoneUrl];
//    }
}

- (IBAction)submitPressed:(id)sender {
    [self validateTextFields];

    //Tag Forgot Password - Code Entered:
    [ArcusAnalytics tag:AnalyticsTags.ForgotPassword attributes:@{ AnalyticsTags.SelectedStep : AnalyticsTags.ForgotPasswordCodeEntered }];
}

- (void)saveRegistrationContext {
    ResetPasswordViewController *vc = [ResetPasswordViewController create];
    vc.resetCode = _codeTextField.text;
    if (self.emailINeeded) {
        self.email = self.emailAddressTextField.text;
    }
    
    vc.email = self.email;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
