//
//  RuleEidtNameViewController.m
//  i2app
//
//  Created by Arcus Team on 6/25/15.
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
#import "RuleEditNameViewController.h"
#import "AccountTextField.h"
#import "UIImage+ImageEffects.h"

@interface RuleEditNameViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet UIButton *clearTextButton;
@property (nonatomic, strong) IBOutlet AccountTextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIView *underlineView;

@end

@implementation RuleEditNameViewController

#pragma mark - View LifeCycle

+ (RuleEditNameViewController *)create {
    RuleEditNameViewController *controller = [[UIStoryboard storyboardWithName:@"Rules" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([RuleEditNameViewController class])];

    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[self.navigationItem.title uppercaseString]];
    
    UIColor *textColor = nil;
    FontDataType fontType;
    if (self.editMode) {
        [self addDarkOverlay:BackgroupOverlayLightLevel];
        [self.clearTextButton setImage:[self.clearTextButton imageForState:UIControlStateNormal].invertColor forState:UIControlStateNormal];
        
        textColor = [UIColor whiteColor];
        fontType = FontDataType_Medium_18_White_NoSpace;
    }
    else {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        
        textColor = [UIColor blackColor];
        fontType = FontDataType_Medium_18_Black_NoSpace;
    }
    [self setBackgroundColorToLastNavigateColor];
    
    self.underlineView.backgroundColor = [textColor colorWithAlphaComponent:0.4f];
    self.nameTextField.textColor = textColor;
    self.nameTextField.floatingLabelTextColor = [textColor colorWithAlphaComponent:0.6f];
    self.nameTextField.floatingLabelActiveTextColor = textColor;
    self.nameTextField.separatorColor = [UIColor clearColor];
    self.nameTextField.activeSeparatorColor = [UIColor clearColor];
    
    [self.nameTextField setupType:AccountTextFieldTypeGeneral
                         fontType:fontType
              placeholderFontType:FontDataTypeAccountTextFieldPlaceholder];
    
    if (self.ruleName) {
        NSDictionary *titleAttributes = [FontData getFontWithSize:17.0f
                                                             bold:NO
                                                          kerning:0.0f
                                                            color:textColor];
        NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:self.ruleName
                                                                        attributes:titleAttributes];
        [self.nameTextField setAttributedText:titleText];
        
        [self.clearTextButton setHidden:NO];
    }
    else {
        [self.clearTextButton setHidden:YES];
    }
    
    NSDictionary *messageLimitAttributes = [FontData getFontWithSize:17.0f
                                                         bold:NO
                                                      kerning:0.0f
                                                        color:textColor];
    NSAttributedString *messageText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"36 Character Limit", nil)
                                                                    attributes:messageLimitAttributes];
    [self.messageLabel setAttributedText:messageText];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.nameTextField.isFirstResponder) {
        [self.nameTextField resignFirstResponder];
    }
    
    if (self.isMovingFromParentViewController) {
        if (self.completion) {
            self.completion(self.ruleName);
        }
    }
}

#pragma mark - IBActions

- (IBAction)clearButtonPressed:(id)sender {
    [self.nameTextField setText:@""];
    self.ruleName = @"";
}

- (IBAction)nameTextDidChange:(UITextField *)sender {
    [self.clearTextButton setHidden:(sender.text.length <= 0)];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return (textField.text.length - range.length + string.length <= 36);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    self.ruleName = textField.text;
}

@end
