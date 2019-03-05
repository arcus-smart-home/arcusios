//
//  ResetPasswordViewController.m
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
#import "ResetPasswordViewController.h"
#import "PasswordTextField.h"
#import "NotificationViewController.h"
#import "FavoriteOrderedManager.h"
#import "AccountCapability.h"
#import <i2app-Swift.h>

@interface ResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet PasswordTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet PasswordTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)resetPasswordPressed:(id)sender;

@end

@implementation ResetPasswordViewController

+ (ResetPasswordViewController *)create {
    ResetPasswordViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ResetPasswordViewController class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Password Reset", nil) uppercaseString]];
    
    _passwordTextField.attributedPlaceholder = [FontData getString:[NSLocalizedString(@"New Password", nil) uppercaseString] andString2:NSLocalizedString(@"  (min 8 characters)", nil) withCombineFont:FontDataCombineTypeAccountTextFieldPlaceholder];
    [_passwordTextField setupType:AccountTextFieldTypePassword];
    
    _confirmPasswordTextField.attributedPlaceholder = [FontData getString:[NSLocalizedString(@"Confirm Password", nil) uppercaseString] andString2:NSLocalizedString(@"  (min 8 characters)", nil) withCombineFont:FontDataCombineTypeAccountTextFieldPlaceholder];
    [_confirmPasswordTextField setupType:AccountTextFieldTypePassword];
    _passwordTextField.secureTextEntry = YES;
    
    [_submitButton styleSet:NSLocalizedString(NSLocalizedString(@"Submit", nil), nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
  
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _confirmPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}

#pragma mark - Data Validation

- (BOOL)isDataValid:(NSString **)errorMessageKey {
    [self configurePasswordTextFieldForValidation];
    
    return [super isDataValid:errorMessageKey];
}

- (void)configurePasswordTextFieldForValidation {
    self.passwordTextField.confirmationString = self.confirmPasswordTextField.text;
    self.confirmPasswordTextField.confirmationString = self.passwordTextField.text;
    if (self.email) {
        NSArray *components = [self.email componentsSeparatedByString:@"@"];
        if (components.count > 0) {
            self.passwordTextField.restrictedValues = @[components[0]];
        }
    }
}

#pragma mark - Save Registration Context
- (void)saveRegistrationContext {
  NSString *password = self.passwordTextField.text;

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    [AccountController resetPassword:self.email
                              resetToken:self.resetCode
                                password:password].then(^(NSObject *obj) {
      [AccountController loginUser:self.email
                              password:self.passwordTextField.text
                            completion:^(BOOL success, NSError * _Nullable error) {
                              if (error != nil) {
                                // Error here is from different calls to server not just login
                                // There is case when we successfully login but fail to get model for person
                                // Get person failed because we are in the middle of accoutn creation.
                                if ([[[error userInfo] objectForKey:@"Reason"] isEqualToString:@"Login Error"])  {
                                  [self displayErrorMessage:error.localizedDescription withTitle:@"Login Error"];
                                  self.submitButton.enabled = YES;
                                  return;
                                }
                              }
                            }];
    }).catch(^(NSError *error) {
      if (error.code == 104) {
        [self displayErrorMessage:@"Unable to locate record for person" withTitle:@"Error"];
      }
    });
  });
}

- (IBAction)resetPasswordPressed:(id)sender {
    [self validateTextFields];
}

@end
