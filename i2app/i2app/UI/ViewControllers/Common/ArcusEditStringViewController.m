//
//  ArcusEditStringViewController.m
//  i2app
//
//  Created by Arcus Team on 2/16/16.
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
#import "ArcusEditStringViewController.h"
#import "AccountTextField.h"
#import "UIImage+ImageEffects.h"

@interface ArcusEditStringViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet UIButton *clearTextButton;
@property (nonatomic, strong) IBOutlet AccountTextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIView *underlineView;

@end

@implementation ArcusEditStringViewController

#pragma mark - Creation
+ (ArcusEditStringViewController *)createWithPlaceholderText:(NSString *)placeholder currentValue:(NSString *)currentValue isEditMode:(BOOL)isEditMode {
    ArcusEditStringViewController *vc = [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ArcusEditStringViewController class])];
    vc.placeholderText = placeholder;
    vc.itemName = currentValue;
    vc.isEditMode = isEditMode;
    return vc;
}

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.navBarText];
    [self setBackgroundColorToLastNavigateColor];
    
    if (self.placeholderText) {
        self.nameTextField.placeholder = self.placeholderText;
    }
    
    if (self.itemName) {
        [self.nameTextField setText:self.itemName];
    } else {
        [self.clearTextButton setHidden:YES];
    }
    
    if (self.messageText) {
        [self.messageLabel setText:self.messageText];
    }
    
    [self configureUIForEditingMode:self.isEditMode];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.nameTextField.isFirstResponder) {
        [self.nameTextField resignFirstResponder];
    }
    
    if (self.isMovingFromParentViewController) {
        if (self.completion) {
            self.completion(self.itemName);
        }
    }
}

#pragma mark - IBActions

- (IBAction)clearButtonPressed:(id)sender {
    [self.nameTextField setText:@""];
    self.itemName = @"";
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
    
    self.itemName = textField.text;
}

#pragma mark - UI config
- (void)configureUIForEditingMode:(BOOL)isEditingMode {
    UIColor *textColor = nil;
    FontDataType fontType;
    
    if (isEditingMode) {
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
    
    self.underlineView.backgroundColor = [textColor colorWithAlphaComponent:0.4f];
    self.nameTextField.textColor = textColor;
    self.nameTextField.floatingLabelTextColor = [textColor colorWithAlphaComponent:0.6f];
    self.nameTextField.floatingLabelActiveTextColor = textColor;
    self.nameTextField.separatorColor = [UIColor clearColor];
    self.nameTextField.activeSeparatorColor = [UIColor clearColor];
    
    [self.nameTextField setupType:AccountTextFieldTypeGeneral
                         fontType:fontType
              placeholderFontType:FontDataTypeAccountTextFieldPlaceholder];
    
    self.messageLabel.textColor = textColor;
}

@end

