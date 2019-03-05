//
//  HomeInfoViewController.m
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
#import "ArcusBaseHomeInfoViewController.h"
#import "ArcusBaseHomeInfoViewController+Private.h"

#import "ImagePicker.h"
#import "PinCodeEntryViewController.h"
#import "BuildConfigure.h"
#import "PlaceCapability.h"

@interface ArcusBaseHomeInfoViewController ()<UITableViewDelegate, CustomPickerDelegate>

@end

@implementation ArcusBaseHomeInfoViewController

#pragma mark - Utility
+ (NSString *)prettyPrintAddressWithStreetAddress1:(NSString *)streetAdd1 streetAddress2:(NSString *)streetAdd2 city:(NSString *)city state:(NSString *)state andZip:(NSString *)zip {
    NSString *addressToDisplayOnError = streetAdd1;
    if (streetAdd2.length > 0) {
        addressToDisplayOnError = [addressToDisplayOnError stringByAppendingFormat:@"\n%@", streetAdd2];
    }
    addressToDisplayOnError = [addressToDisplayOnError stringByAppendingFormat:@"\n%@, %@ %@", city, state, zip];
    return addressToDisplayOnError;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"About Your Home", nil) uppercaseString]];
    [self setupView];
}

#pragma mark - View Setup
- (void)setupView {
    
    // Platform doesn't support primary residence, so we need to hide it until supported
    if (YES) {
        self.residenceButton.hidden = YES;
        self.nextButtonToPrimaryResidenceTopConstraint.priority = CONSTRAINT_PRIORITY_HIDE_PRIMARY_RESIDENCE;
    }
    
    _homeNameTextField.placeholder = NSLocalizedString(@"Name", nil);
    [_homeNameTextField setupType:AccountTextFieldTypeGeneral];
    
    _addressOneTextField.placeholder = NSLocalizedString(@"Address Line 1", nil);
    [_addressOneTextField setupType:AccountTextFieldTypeGeneral];
    
    _addressTwoTextField.placeholder = NSLocalizedString(@"Address Line 2", nil);
    [_addressTwoTextField setupType:AccountTextFieldTypeGeneral isRequired:NO];
    
    _cityTextField.placeholder = NSLocalizedString(@"City", nil);
    [_cityTextField setupType:AccountTextFieldTypeGeneral];
    
    
    _zipTextField.placeholder = NSLocalizedString(@"Zip Code", nil);
    [_zipTextField setupType:AccountTextFieldTypeZipCode isRequired:YES];
    
    _lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    
    [_stateButton setAttributedTitle:[FontData getString:[NSLocalizedString(@"State", nil) uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholder] forState:UIControlStateNormal];
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    [_residenceButton setAttributedTitle:[FontData getString:[@"Primary residence" uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholder] forState:UIControlStateNormal];
}


#pragma mark - Actions
- (IBAction)stateButtonPressed:(id)sender {
    CustomPickerController *customPickerController = [CustomPickerController customPickerViewWithDataSource:[Constants usStatesAbbreviated]
                                                                                          displayDataSource:[Constants usStates]
                                                                                           withPickerButton:_stateButton];
    [customPickerController setDelegate:self];
    
    [customPickerController setCurrentSelection:_stateButton.currentTitle];
    [self presentViewController:customPickerController animated:YES completion:nil];
}

- (IBAction)residenceButtonPressed:(id)sender {
    NSArray *arr = @[@"Yes",@"No"];
    CustomPickerController *customPickerController = [CustomPickerController customPickerViewWithDataSource:arr withPickerButton:_residenceButton];
    [customPickerController setDelegate:self];
    [self presentViewController:customPickerController animated:YES completion:nil];
}

- (IBAction)photoButtonPressed:(id)sender {
}

- (IBAction)nextButtonPressed:(id)sender {
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range  replacementString:(NSString *)string {
    if ( textField != _zipTextField) {
        return YES;
    }
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return (newText.length <= ZIP_CODE_MAX_LENGTH);
}

#pragma mark - CustomPickerDelegate
- (void)picker:(CustomPickerController *)pickerViewController didPressCloseButtonWithSelection:(NSString *)selection {
    [pickerViewController.pickerButton setAttributedTitle:[FontData getString:selection withFont:FontDataTypeAccountTextField] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [super goToNextControl:pickerViewController.pickerButton.tag];
}

#pragma mark - Private utility
- (NSString *)extractPrettyAddressFromTextFields {
    return[ArcusBaseHomeInfoViewController prettyPrintAddressWithStreetAddress1:self.addressOneTextField.text
                                                                                       streetAddress2:self.addressTwoTextField.text
                                                                                                 city:self.cityTextField.text
                                                                                                state:self.stateButton.titleLabel.text
                                                                                               andZip:self.zipTextField.text];
}

@end

