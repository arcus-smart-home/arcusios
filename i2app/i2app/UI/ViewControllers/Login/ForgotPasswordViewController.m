//
//  ForgotPasswordViewController.m
//  i2app
//
//  Created by Arcus Team on 4/6/15.
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
#import "ForgotPasswordViewController.h"
#import "EnterResetPasswordCodeViewController.h"
#import "AccountTextField.h"
#import "NSString+Validate.h"
#import <i2app-Swift.h>
#import "PopupSelectionButtonsView.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet AccountTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;
@property (weak, nonatomic) IBOutlet UILabel *mainText;
@property (weak, nonatomic) IBOutlet UILabel *subText;

- (IBAction)alreadyHaveACodePressed:(id)sender;

@end


@implementation ForgotPasswordViewController {
    PopupSelectionWindow *_popupWindow;
}

#pragma mark - Life Cycle
+ (ForgotPasswordViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ForgotPasswordViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Tag Forgot Password - Started:
    [ArcusAnalytics tag:AnalyticsTags.ForgotPassword attributes:@{ AnalyticsTags.SelectedStep : AnalyticsTags.ForgotPasswordStepStarted }];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Forgot Password", nil) uppercaseString]];
    
    [self setBackgroundColorToParentColor];
    
    _emailTextField.placeholder = NSLocalizedString(@"Email Address", nil);
    [_emailTextField setupType:AccountTextFieldTypeEmail];
    [_sendEmailButton styleSet:@"send email" andButtonType:FontDataTypeButtonDark upperCase:YES];
    _mainText.attributedText = [FontData getString:NSLocalizedString(@"Forgot your password?\nNo big deal.", nil) withFont:FontDataTypeAccountMainText];
    _subText.attributedText = [FontData getString:NSLocalizedString(@"Enter your email address and\n we'll send instructions on how to reset it.\nBut hurry - the link will expire in 30 minutes.", nil) withFont:FontDataTypeAccountSubTextWithOpacity];
}

- (IBAction)submitPressed:(id)sender {

    [self validateTextFields];
    
    //Tag Forgot Password
    [ArcusAnalytics tag:AnalyticsTags.ForgotPassword attributes:@{ AnalyticsTags.SelectedStep : AnalyticsTags.ForgotPasswordStepEmailSent }];
}


- (BOOL)isDataValid:(NSString **)errorMessageKey {
    BOOL isValid = YES;
    for (AccountTextField *textField in self.textFields) {
        if (![textField isValidEntry:errorMessageKey]) {
            textField.animateEvenIfNotFirstResponder = YES;
            [self shakeAnimation:textField];
            textField.textColor = pinkAlertColor;
            isValid = NO;

            PopupSelectionButtonsView *popup = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"EMAIL ERROR", nil) subtitle:NSLocalizedString(@"This is not a valid email address.\nPlease try again.", nil) button:nil];
            _popupWindow = [PopupSelectionWindow popup:self.view
                                               subview:popup
                                                 owner:self
                                         closeSelector:nil
                                                 style:PopupWindowStyleCautionWindow];
}
    }
    return isValid;
}

- (void)saveRegistrationContext {
  _sendEmailButton.enabled = NO;
  NSString *emailAddress = [self.emailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    [AccountController sendPasswordReset:emailAddress].then(^(NSObject *obj) {
      _sendEmailButton.enabled = YES;
      dispatch_async(dispatch_get_main_queue(), ^{
        [self goToEnterResetPasswordCodeViewController];
      });
    }).catch(^(NSError *error) {
      _sendEmailButton.enabled = YES;
      [self displayErrorMessage:error.localizedDescription];
    });
  });
}

- (IBAction)alreadyHaveACodePressed:(id)sender {
    [self goToEnterResetPasswordCodeViewController];
}

- (void)goToEnterResetPasswordCodeViewController {
    EnterResetPasswordCodeViewController *vc = [EnterResetPasswordCodeViewController createWithEmail:_emailTextField.text];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
