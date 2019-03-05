//
//  PlaceEditAddressViewController.m
//  i2app
//
//  Created by Arcus Team on 8/20/15.
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
#import "PlaceEditAddressViewController.h"
#import "AccountTextField.h"
#import "CustomPickerController.h"

#import "PlaceCapability.h"
#import "ArcusBaseHomeInfoViewController.h"

#import "SmartyStreets.h"
#import "SmartStreetTextField.h"
#import "SmartStreetValidationViewController.h"

#define kZipCodeMaxLength 6

@interface PlaceEditAddressViewController () <CustomPickerDelegate>

@property (weak, nonatomic) IBOutlet AccountTextField *homeNameTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *addressOneTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *addressTwoTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *cityTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *zipTextField;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIButton *residenceButton;

@end

@implementation PlaceEditAddressViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"Edit Address", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navBarWithBackButtonAndTitle:self.title];
    [self navBarWithTitle:self.title andRightButtonText:@"Save" withSelector:@selector(save:)];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];

    [self setupView];
}


- (void)setupView {
    PlaceModel *currentPlace = [[CorneaHolder shared] settings].currentPlace;
    
    _homeNameTextField.placeholder = NSLocalizedString(@"Home", nil);
    _homeNameTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [_homeNameTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_homeNameTextField setupType:AccountTextFieldTypeGeneral];
    [_homeNameTextField setText:[PlaceCapability getNameFromModel:currentPlace]];
    
    _addressOneTextField.placeholder = NSLocalizedString(@"Address Line 1", nil);
    _addressOneTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _addressOneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_addressOneTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_addressOneTextField setupType:AccountTextFieldTypeGeneral];
    [_addressOneTextField setText:[PlaceCapability getStreetAddress1FromModel:currentPlace]];
    
    _addressTwoTextField.placeholder = NSLocalizedString(@"Address Line 2", nil);
    _addressTwoTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_addressTwoTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_addressTwoTextField setupType:AccountTextFieldTypeGeneral isRequired:NO];
    [_addressTwoTextField setText:[PlaceCapability getStreetAddress2FromModel:currentPlace]];
    
    _cityTextField.placeholder = NSLocalizedString(@"City", nil);
    _cityTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_cityTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_cityTextField setupType:AccountTextFieldTypeGeneral];
    [_cityTextField setText:[PlaceCapability getCityFromModel:currentPlace]];
    
    _zipTextField.placeholder = NSLocalizedString(@"Zip", nil);
    [_zipTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_zipTextField setupType:AccountTextFieldTypeZipCode isRequired:YES];
    [_zipTextField setText:[PlaceCapability getZipCodeFromModel:currentPlace]];
    
    [_stateButton setAttributedTitle:[FontData getString:[PlaceCapability getStateFromModel:currentPlace] withFont:FontDataTypeAccountTextFieldWhite] forState:UIControlStateNormal];
    [_stateButton addTarget:self action:@selector(stateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_residenceButton setAttributedTitle:[FontData getString:[@"Primary residence" uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholderWhite] forState:UIControlStateNormal];
    
    //hide residence button till implemented
    [_residenceButton setHidden:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range  replacementString:(NSString *)string {
    if ( textField != _zipTextField) {
        return YES;
    }
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return (newText.length <= kZipCodeMaxLength);
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

- (void)submitToPlatform {
    PlaceModel *placeModel = [[CorneaHolder shared] settings].currentPlace;
    
    [PlaceCapability setName:_homeNameTextField.text onModel:placeModel];
    [PlaceCapability setStreetAddress1:_addressOneTextField.text onModel:placeModel];
    [PlaceCapability setStreetAddress2:(_addressTwoTextField.text.length > 0 ? _addressTwoTextField.text : @"") onModel:placeModel];
    [PlaceCapability setCity:_cityTextField.text onModel:placeModel];
    [PlaceCapability setState:_stateButton.titleLabel.text onModel:placeModel];
    [PlaceCapability setZipCode:_zipTextField.text onModel:placeModel];
    [placeModel commit].thenInBackground(^(ClientEvent *event) {
        [placeModel refresh];
    }).then(^(NSDictionary *dict) {
        [self.navigationController popViewControllerAnimated:YES];
    }).catch(^(NSError *error) {
        
    });
}

- (void)save:(id)sender {
    NSString *errorMessageKey;
    if ([super isDataValid:&errorMessageKey]) {
        
        NSString *addressToDisplay = [ArcusBaseHomeInfoViewController prettyPrintAddressWithStreetAddress1:self.addressOneTextField.text
                                                                                           streetAddress2:self.addressTwoTextField.text
                                                                                                     city:self.cityTextField.text
                                                                                                    state:self.stateButton.titleLabel.text
                                                                                                   andZip:self.zipTextField.text];
        NSString *street = _addressOneTextField.text;
        if (_addressTwoTextField.text.length > 0) {
            street = [street stringByAppendingFormat:@" %@",_addressTwoTextField.text];
        }
        [SmartStreetValidationViewController validateStreet:street city:_cityTextField.text state:_stateButton.titleLabel.text zip:_zipTextField.text addressToDisplayOnError:addressToDisplay owner:self completeHandle:^(BOOL isValid) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                        [self submitToPlatform];
            });
        }];
    }
}

#pragma mark - CustomPickerDelegate
- (void)picker:(CustomPickerController *)pickerViewController didPressCloseButtonWithSelection:(NSString *)selection {
    [pickerViewController.pickerButton setAttributedTitle:[FontData getString:selection withFont:FontDataTypeAccountTextFieldWhite] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
