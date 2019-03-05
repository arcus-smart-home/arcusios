//
//  SceneNameEditingViewController.m
//  i2app
//
//  Created by Arcus Team on 10/27/15.
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
#import "SceneNameEditingViewController.h"
#import "AccountTextField.h"
#import "UIImage+ImageEffects.h"
#import "SceneManager.h"

@interface SceneNameEditingViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *clearTextButton;
@property (weak, nonatomic) IBOutlet AccountTextField *nameField;
@property (weak, nonatomic) IBOutlet UIView *underlineView;

@end

@implementation SceneNameEditingViewController

+ (SceneNameEditingViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Scenes" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[@"Edit Name" uppercaseString]];
    [self setBackgroundColorToLastNavigateColor];
    
    UIColor *textColor = nil;
    FontDataType fontType;
    if ([SceneManager sharedInstance].isNewScene) {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        
        textColor = [UIColor blackColor];
        fontType = FontDataType_Medium_18_Black_NoSpace;
        [_saveButton styleSet:@"Save" andButtonType:FontDataTypeButtonDark upperCase:YES];
    }
    else {
        [self addDarkOverlay:BackgroupOverlayLightLevel];
        [self.clearTextButton setImage:[self.clearTextButton imageForState:UIControlStateNormal].invertColor forState:UIControlStateNormal];
        
        textColor = [UIColor whiteColor];
        fontType = FontDataType_Medium_18_White_NoSpace;
        [_saveButton styleSet:@"Save" andButtonType:FontDataTypeButtonLight upperCase:YES];
    }
    self.underlineView.backgroundColor = [textColor colorWithAlphaComponent:0.4f];
    self.nameField.delegate = self;
    self.nameField.textColor = textColor;
    self.nameField.floatingLabelTextColor = [textColor colorWithAlphaComponent:0.6f];
    self.nameField.floatingLabelActiveTextColor = textColor;
    self.nameField.separatorColor = [UIColor clearColor];
    self.nameField.activeSeparatorColor = [UIColor clearColor];
    self.nameField.attributedPlaceholder = [[FontData createFontData:FontTypeDemiBold size:16 blackColor:[SceneManager sharedInstance].isNewScene space:YES alpha:YES] getFontAttributed:@"SCENE NAME"];
    
    [self.nameField setupType:AccountTextFieldTypeGeneral fontType:fontType placeholderFontType:FontDataTypeAccountTextFieldPlaceholder];
    
    if (self.sceneName) {
        NSDictionary *titleAttributes = [FontData getFontWithSize:17.0f bold:NO kerning:0.0f color:textColor];
        NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:[SceneManager sharedInstance].currentSceneTitle attributes:titleAttributes];
        [self.nameField setAttributedText:titleText];
        
        [self.clearTextButton setHidden:NO];
    }
    else {
        [self.clearTextButton setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    if (self.isMovingFromParentViewController) {
        if (self.completion) {
            self.completion(self.nameField.text);
        }
    }
}

- (IBAction)clearButtonPressed:(id)sender {
    [_nameField setText:@""];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (self.completion) {
        self.completion(self.nameField.text);
    }
    
    return NO;
}

@end
