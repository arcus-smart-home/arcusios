//
//  ChangePasswordViewController.m
//  i2app
//
//  Created by Arcus Team on 8/12/15.
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
#import "ChangePasswordViewController.h"


#import "PersonCapability.h"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) IBOutletCollection(PasswordTextField) NSArray *passwordTextFields;
@property (nonatomic, weak) IBOutlet PasswordTextField *currentPassword;
@property (nonatomic, weak) IBOutlet PasswordTextField *updatedPassword;
@property (nonatomic, weak) IBOutlet PasswordTextField *confirmPassword;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) PersonModel *currentPerson;
@property (nonatomic, strong) NSArray *restrictedValues;

@end

@implementation ChangePasswordViewController

#pragma mark - View LifeCycle

+ (ChangePasswordViewController *)create {
    ChangePasswordViewController *viewController = [[UIStoryboard storyboardWithName:@"AccountSettings"
                                                                              bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ChangePasswordViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];

    [self setBackgroundColorToParentColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];

    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[FontData getFont:FontDataTypeNavBar]
                                                          forState:UIControlStateNormal];
    
    [self.saveButton styleSet:NSLocalizedString(@"Save", nil)
                andButtonType:FontDataTypeButtonLight
                    upperCase:YES];
    
    [self configureTextFields];
  
    self.confirmPassword.secureTextEntry = YES;
    self.currentPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    self.updatedPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    self.confirmPassword.autocorrectionType = UITextAutocorrectionTypeNo;
}

#pragma mark - UI Configuration

- (void)configureTextFields {
    for (PasswordTextField *textField in self.passwordTextFields) {
        textField.text = Constants.kPasswordPlaceholder;
        textField.textColor = [UIColor whiteColor];
        textField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        textField.floatingLabelActiveTextColor = [UIColor whiteColor];
        textField.activeSeparatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        textField.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        [textField setupType:AccountTextFieldTypePassword
                    fontType:FontDataTypeSettingsSubText
         placeholderFontType:FontDataTypeSettingsSubText];
        
        textField.restrictedValues = self.restrictedValues;
    }
}

#pragma mark - Setters & Getters

- (PersonModel *)currentPerson {
    return [[[CorneaHolder shared] settings] currentPerson];
}

- (NSArray *)restrictedValues {
    if (!_restrictedValues) {
        NSString *emailAddress = [PersonCapability getEmailFromModel:self.currentPerson];
        _restrictedValues = @[[emailAddress componentsSeparatedByString:@"@"][0]];
    }
    return _restrictedValues;
}

#pragma mark - IBActions
- (IBAction)saveButtonPressed:(id)sender {
    self.updatedPassword.confirmationString = self.confirmPassword.text;
    self.confirmPassword.confirmationString = self.updatedPassword.text;
    self.currentPassword.confirmationString = self.currentPassword.text;

    NSString *errorMessage = nil;

    if ([self isDataValid:&errorMessage]) {
        // Update Password
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
          [AccountController changePassword:[PersonCapability getEmailFromModel:[[CorneaHolder shared] settings].currentPerson]
                                currentPassword:self.currentPassword.confirmationString
                                    newPassword:self.updatedPassword.confirmationString].then(^(PersonServiceChangePasswordResponse *response) {
            BOOL success = response.attributes[@"success"];
            if (success) {
              [self.navigationController popViewControllerAnimated:YES];
            }
            else {
              [self displayErrorMessage:NSLocalizedStringFromTable(@"Password could not be changed", @"ErrorMessages", nil)];
            }
          }).catch(^(NSError *error) {
            [self displayErrorMessage:NSLocalizedStringFromTable(@"Password could not be changed", @"ErrorMessages", nil)];
          });
        });
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@"************"]) {
        textField.text = nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:text];
    BOOL isPressedBackspaceAfterSingleSpaceSymbol = [text isEqualToString:@""] && [resultString isEqualToString:@""] && range.location == 0 && range.length == 1;
    if (isPressedBackspaceAfterSingleSpaceSymbol) {
        
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Used to override BaseTextViewController UITextFieldDelegate to prevent view resizing.
}


@end
