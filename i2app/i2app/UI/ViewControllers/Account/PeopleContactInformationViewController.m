//
//  PeopleContactInformationViewController.m
//  i2app
//
//  Created by Arcus Team on 9/28/15.
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
#import "PeopleContactInformationViewController.h"



#import "PersonCapability.h"
#import "PlaceCapability.h"
#import "PeopleModelManager.h"
#import "AccountTextField.h"
#import "UIView+FirstResponder.h"

@interface PeopleContactInformationViewController ()

@property (strong, nonatomic) PeopleModelManager *manager;
@property (weak, nonatomic) IBOutlet AccountTextField *firstNameText;
@property (weak, nonatomic) IBOutlet AccountTextField *lastNameText;
@property (weak, nonatomic) IBOutlet AccountTextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet AccountTextField *emailText;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutletCollection(AccountTextField) NSArray *contactInfoFields;

@property (nonatomic, assign) BOOL isEditing;

@end

@implementation PeopleContactInformationViewController

#pragma mark - View LifeCycle

+ (PeopleContactInformationViewController *)create:(PeopleModelManager *)manager {
    PeopleContactInformationViewController *vc = [[UIStoryboard storyboardWithName:@"PeopleSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.manager = manager;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = @"Contact information";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self navBarWithTitle:self.title
       andRightButtonText:NSLocalizedString(@"edit", nil)
             withSelector:@selector(onClickSave:)
           selectorTarget:self];
    
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self addBackButtonItemAsLeftButtonItem];
    
    [self configureContactInfoTextFields];
    
    PersonModel *currectPerson = [_manager getCurrent];
    _firstNameText.text = [PersonCapability getFirstNameFromModel:currectPerson];
    _lastNameText.text = [PersonCapability getLastNameFromModel:currectPerson];
    _phoneNumberText.text = [PersonCapability getMobileNumberFromModel:currectPerson];
    _emailText.text = [PersonCapability getEmailFromModel:currectPerson];
    
}

#pragma mark - UI Configuration

- (void)configureContactInfoTextFields {
    for (AccountTextField *textField in self.contactInfoFields) {
        textField.textColor = [UIColor whiteColor];
        textField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
        textField.floatingLabelActiveTextColor = [UIColor whiteColor];
        textField.activeSeparatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        textField.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        textField.userInteractionEnabled = NO;
        
        FontDataType fontType = FontDataTypeSettingsTextField;
        FontDataType placeholderType = FontDataTypeSettingsTextFieldPlaceholder;
        if (textField == self.firstNameText || textField == self.lastNameText) {
            [textField setupType:AccountTextFieldTypeGeneral
                        fontType:fontType
             placeholderFontType:placeholderType];
        }
        else if (textField == self.phoneNumberText) {
            [textField setupType:AccountTextFieldTypePhone
                      isRequired:NO
                        fontType:fontType
             placeholderFontType:placeholderType];
        }
        else if (textField == self.emailText) {
            [textField setupType:AccountTextFieldTypeEmail
                      isRequired:NO
                        fontType:fontType
             placeholderFontType:placeholderType];
        }
    }
}

#pragma mark - IBActions

- (void)onClickSave:(id)sender {
    if (self.isEditing) {
        [self.view.firstResponder resignFirstResponder];
        if (![self updateCurrentPerson]) {
            return;
        }
    }
    
    self.isEditing = !self.isEditing;
    for (AccountTextField *textField in [self getAllSubviews:self.view]) {
        if ([textField isKindOfClass:[AccountTextField class]]) {
            textField.userInteractionEnabled = self.isEditing;
        }
    }
    [self navBarWithTitle:self.title andRightButtonText:self.isEditing ? NSLocalizedString(@"DONE", @"") : NSLocalizedString(@"EDIT", @"") withSelector:@selector(onClickSave:) selectorTarget:self];
    
}

#pragma mark - Save Method

- (BOOL)updateCurrentPerson {
    NSString *errorMessage = @"";
    
    BOOL success = [self isDataValid:&errorMessage];
    if (success) {
        __block PersonModel *currectPerson = [_manager getCurrent];
        
        [PersonCapability setFirstName:_firstNameText.text
                               onModel:currectPerson];
        [PersonCapability setLastName:_lastNameText.text
                              onModel:currectPerson];
        [PersonCapability setMobileNumber:_phoneNumberText.text
                                  onModel:currectPerson];
        [PersonCapability setEmail:_emailText.text
                           onModel:currectPerson];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [currectPerson commit];
        });
    }
    else {
        [self displayErrorMessage:errorMessage withTitle:@"Error"];
    }
    return success;
}


@end
