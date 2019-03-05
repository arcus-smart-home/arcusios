//
//  BillingViewController.m
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
#import "BillingViewController.h"
#import "AccountTextField.h"
#import "CustomPickerController.h"

#import "SuccessAccountViewController.h"
#import "PopupSelectionWindow.h"
#import "SmartyStreets.h"
#import "SmartStreetTextField.h"

#import "UIImage+ImageEffects.h"
#import "PlaceCapability.h"
#import "Capability.h"
#import "AccountCapability.h"
#import "SignUpPremiumSkipModalViewController.h"
#import <i2app-Swift.h>

@interface BillingViewController () <CustomPickerDelegate>

@property (weak, nonatomic) IBOutlet AccountTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *cvcTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *streetOneTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *streetTwoTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *cityTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *zipTextField;

@property (weak, nonatomic) IBOutlet UIButton *expMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *expYearButton;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIView *lineView2;
@property (strong, nonatomic) IBOutlet UIView *lineViewState;
@property (weak, nonatomic) IBOutlet UIButton *checkmarkButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *expirationLabel;

@property (strong, nonatomic) AccountModel *accountToWorkWith;
@property (assign, nonatomic) BillingViewConfigMode billingMode;

- (IBAction)stateButtonPressed:(id)sender;
- (IBAction)expMonthButtonPressed:(id)sender;
- (IBAction)expYearButtonPressed:(id)sender;

- (IBAction)nextButtonPressed:(id)sender;

- (void)billDisplayMessageWithError:(NSError *)error errorTitle:(NSString **)title errorMessage:(NSString **)message;

@end


@implementation BillingViewController {
    
    __weak IBOutlet NSLayoutConstraint *nextButtonToTop;
    __weak IBOutlet NSLayoutConstraint *nameToTopConstraint;
    
    BOOL        _skipButtonEnabled;
    
    PopupSelectionWindow        *_popupWindow;
}

@dynamic creditCardNumberField;

#pragma mark - Life Cycle
+ (BillingViewController *)create {
    BillingViewController *billingController = [[UIStoryboard storyboardWithName:@"CreateAccount" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([BillingViewController class])];
    billingController.billingMode = BillingViewConfigModeCreation;
    billingController.accountToWorkWith = CorneaHolder.shared.settings.currentAccount;
    return billingController;
}

+ (BillingViewController *)createInEditModeWithAccount:(AccountModel *)accountToEdit {
    BillingViewController *billingController = [[UIStoryboard storyboardWithName:@"CreateAccount" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([BillingViewController class])];
    billingController.billingMode = BillingViewConfigModeEdit;
    billingController.accountToWorkWith = accountToEdit;
    return billingController;
}

+ (BillingViewController *)createInAddAPlaceGuestMode {
    BillingViewController *billingController = [[UIStoryboard storyboardWithName:@"CreateAccount" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([BillingViewController class])];
    billingController.billingMode = BillingViewConfigModeAddAPlace;
    billingController.accountToWorkWith = CorneaHolder.shared.settings.currentAccount;
    return billingController;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = [NSLocalizedString(@"Credit Card Information", nil) uppercaseString];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.billingMode == BillingViewConfigModeEdit) {
        [self navBarWithBackButtonAndTitle:self.title];
        [self addBackButtonItemAsLeftButtonItem];
    } else {
        [self navBarWithTitle:self.title
           andRightButtonText:NSLocalizedString(@"SKIP", nil)
                 withSelector:@selector(skipPremiumTrialPressed)];
        
        if (self.navigationController.viewControllers.count > 2) {
            [self addBackButtonItemAsLeftButtonItem];
        }
    }

    if (self.billingMode == BillingViewConfigModeEdit) {
        [self addBackButtonItemAsLeftButtonItem];
    } else {
        if (self.navigationController.viewControllers.count > 2) {
            [self addBackButtonItemAsLeftButtonItem];
        }
    }

    [self setupView];
    
    _skipButtonEnabled = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:signUpPremiumToSegueIdentifier]) {
        SignUpPremiumSkipModalViewController *vc = (SignUpPremiumSkipModalViewController *) segue.destinationViewController;
        vc.skipBlock = ^{
            [self skipPremiumTrialConfirmed];
        };
        vc.startBlock = nil;
    }
}

#pragma mark - Dynamic properties
- (AccountTextField *)creditCardNumberField {
    for (AccountTextField *textField in self.textFields) {
        if (textField.accountFieldType == AccountTextFieldTypeCCNumber) {
            return textField;
        }
    }
    return nil;
}

#pragma mark - View Setup

- (void)setupView {
    _firstNameTextField.placeholder = NSLocalizedString(@"First Name", nil);
    _firstNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_firstNameTextField setupType:AccountTextFieldTypeGeneral];
    [_firstNameTextField setAccountFieldStyle:AccountTextFieldStyleBlack];
    
    
    _lastNameTextField.placeholder = NSLocalizedString(@"Last Name", nil);
    _lastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_lastNameTextField setupType:AccountTextFieldTypeGeneral];
    
    _streetOneTextField.placeholder = NSLocalizedString(@"Street Address 1", nil);
    _streetOneTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _streetOneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_streetOneTextField setupType:AccountTextFieldTypeGeneral];
    
    _streetTwoTextField.placeholder = NSLocalizedString(@"Street Address 2", nil);
    _streetTwoTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_streetTwoTextField setupType:AccountTextFieldTypeGeneral isRequired:NO];
    
    _cardNumberTextField.placeholder = NSLocalizedString(@"Card Number", nil);
    _cardNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    _cardNumberTextField.secureTextEntry = YES;
    [_cardNumberTextField setupType:AccountTextFieldTypeCCNumber];
    //[_cardNumberTextField setText:@"378282246310005"];
    [_cardNumberTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    _cardNumberTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  
    _cvcTextField.placeholder = NSLocalizedString(@"CVV", nil);
    //_cvcTextField.text = @"2232";
    [_cvcTextField setupType:AccountTextFieldTypeCVC];
    
    _cityTextField.placeholder = NSLocalizedString(@"City", nil);
    _cityTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_cityTextField setupType:AccountTextFieldTypeGeneral];
    
    _zipTextField.placeholder = NSLocalizedString(@"Zip Code", nil);
    [_zipTextField setupType:AccountTextFieldTypeZipCode];
    
    _expirationLabel.attributedText = [FontData getString:[NSLocalizedString(@"expiration", nil) uppercaseString] withFont:FontDataTypeFloatingLabelFont];
    
    
    if (self.billingMode == BillingViewConfigModeEdit) {
        [self setupViewsForAccountSettings];
        [self populateAccountInformations];
        
    } else {
        [self setupViewsForAccountCreation];
    }
    
    if (IS_IPHONE_5) {
        nameToTopConstraint.constant = 16;
    }
    
    if (IS_IPHONE_6P) {
        nextButtonToTop.constant = [[UIScreen mainScreen] bounds].size.height - 135;
    }
}

- (void)setupViewsForAccountCreation {
    _lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    _lineView2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    _lineViewState.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    
    _expMonthButton.titleLabel.attributedText = [FontData getString:[NSLocalizedString(@"Exp Mth", nil) uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholder];
    _expYearButton.titleLabel.attributedText = [FontData getString:[NSLocalizedString(@"Exp Year", nil) uppercaseString]  withFont:FontDataTypeAccountTextFieldPlaceholder];
    
    _expirationLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_stateButton setAttributedTitle:[FontData getString:[NSLocalizedString(@"State", nil) uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholder] forState:UIControlStateNormal];
    
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
}

- (void)setupViewsForAccountSettings {
    [self setBackgroundColorToParentColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [_firstNameTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_lastNameTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_streetOneTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_streetTwoTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_cardNumberTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    
    [_cvcTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_cityTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_zipTextField setAccountFieldStyle:AccountTextFieldStyleWhite];
    
    _lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    _lineView2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    
    _lineViewState.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    
    [_expMonthButton styleSet:@"MM" andButtonType:FontDataTypeAccountTextFieldWhite upperCase:YES];
    _expMonthButton.titleLabel.attributedText = [FontData getString:[NSLocalizedString(@"Exp Mth", nil) uppercaseString] withFont:FontDataTypeAccountTextFieldWhite];
    
    [_expYearButton styleSet:@"YY" andButtonType:FontDataTypeAccountTextFieldWhite upperCase:YES];
    _expYearButton.titleLabel.attributedText = [FontData getString:[NSLocalizedString(@"Exp Year", nil) uppercaseString]  withFont:FontDataTypeAccountTextFieldWhite];
    
    _expirationLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [_stateButton setAttributedTitle:[FontData getString:[NSLocalizedString(@"State", nil) uppercaseString] withFont:FontDataTypeAccountTextFieldWhite] forState:UIControlStateNormal];
    
    UIImage *dropdownImage = _stateButton.imageView.image.invertColor;
    [_stateButton setImage:dropdownImage forState:UIControlStateNormal];
    
    [_nextButton styleSet:NSLocalizedString(@"save", nil) andButtonType:FontDataTypeButtonLight upperCase:YES];
}

- (void)populateAccountInformations {
    _firstNameTextField.text = [AccountCapability getBillingFirstNameFromModel:self.accountToWorkWith];
    _lastNameTextField.text = [AccountCapability getBillingLastNameFromModel:self.accountToWorkWith];
    _streetOneTextField.text = [AccountCapability getBillingStreet1FromModel:self.accountToWorkWith];
    _streetTwoTextField.text = [AccountCapability getBillingStreet2FromModel:self.accountToWorkWith];
    
    _cityTextField.text = [AccountCapability getBillingCityFromModel:self.accountToWorkWith];
    
    [_stateButton setAttributedTitle:[FontData getString:[[AccountCapability getBillingStateFromModel:self.accountToWorkWith]
                                                          uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholderWhite] forState:UIControlStateNormal];
    
    _zipTextField.text = [AccountCapability getBillingZipFromModel:self.accountToWorkWith];
    [_cardNumberTextField setText:@""];
    _cvcTextField.text = @"";
    
}

#pragma mark - Actions
- (IBAction)stateButtonPressed:(id)sender {
    CustomPickerController *customPickerController = [CustomPickerController customPickerViewWithDataSource:[Constants usStatesAbbreviated] withPickerButton:_stateButton];
    [customPickerController setDelegate:self];
    [customPickerController setCurrentSelection:_stateButton.currentTitle];
    [self presentViewController:customPickerController animated:YES completion:nil];
}

- (IBAction)expMonthButtonPressed:(id)sender {
    CustomPickerController *customPickerController = [CustomPickerController customPickerViewWithDataSource:[Constants getMonths] withPickerButton:_expMonthButton];
    [customPickerController setDelegate:self];
    [customPickerController setCurrentSelection:_expMonthButton.currentTitle];
    [self presentViewController:customPickerController animated:YES completion:nil];
}

- (IBAction)expYearButtonPressed:(id)sender {
    CustomPickerController *customPickerController = [CustomPickerController customPickerViewWithDataSource:[Constants validCardYears] withPickerButton:_expYearButton];
    [customPickerController setDelegate:self];
    [customPickerController setCurrentSelection:_expYearButton.currentTitle];
    [self presentViewController:customPickerController animated:YES completion:nil];
}

- (IBAction)nextButtonPressed:(id)sender {
    [super validateTextFields];
}

- (void)skipPremiumTrialPressed {
    [self performSegueWithIdentifier:signUpPremiumToSegueIdentifier sender:nil];
}

- (void)skipPremiumTrialConfirmed {
    _skipButtonEnabled = YES;
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [AccountController skipPremiumTrial:self.accountToWorkWith].thenInBackground(^(NSObject *obj) {
            //Account Creation - Billing - Skip Credit Card
            [ArcusAnalytics tag:AnalyticsTags.AccountCreationBillingSkipCreditCard attributes:@{}];

            if (self.billingMode != BillingViewConfigModeAddAPlace) {
                RunOnMain(^{
                    [self hideGif];
                    SuccessAccountViewController *vc = [SuccessAccountViewController create];
                    [self.navigationController pushViewController:vc animated:YES];
                });
            } else {
                [AccountController completedAccountStep:AccountStateNewSignUpComplete
                                                      model:self.accountToWorkWith
                                           withAccountModel:self.accountToWorkWith];
                RunOnMain(^{
                    BOOL shouldShowChoosePlaceTutorial = CorneaHolder.shared.settings.displayChoosePlaceTutorial;
                    if (shouldShowChoosePlaceTutorial) {
                        [self displayChoosePlacePopup];
                    } else {
                      [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
                    };
                });
            }
            
        }).catch(^(NSError *error) {
            [self hideGif];
            
            [self displayGenericErrorMessage];
        });
    });
}

#pragma mark - override
- (BOOL)validateTextFields {
    [self.view endEditing:YES];
    
    NSString *errorMessageKey;
    if (![self isDataValid:&errorMessageKey]) {
        return NO;
    }
    return YES;
}

#pragma mark - CustomPickerDelegate
- (void)picker:(CustomPickerController *)pickerViewController didPressCloseButtonWithSelection:(NSString *)selection {
    
    if (self.billingMode) {
        [pickerViewController.pickerButton setAttributedTitle:[FontData getString:selection withFont:FontDataTypeAccountTextFieldWhite] forState:UIControlStateNormal];
    } else {
        [pickerViewController.pickerButton setAttributedTitle:[FontData getString:selection withFont:FontDataTypeAccountTextField] forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [super goToNextControl:pickerViewController.pickerButton.tag];
}

#pragma mark - Save Registration Context

- (void)saveRegistrationContext {
    switch (self.billingMode) {
        case BillingViewConfigModeEdit:
            [self saveContextAccountSettings];
            break;
            
        case BillingViewConfigModeCreation:
            [self saveContextAccountCreation];
            break;
            
        case BillingViewConfigModeAddAPlace:
            [self saveContextAccountAddAPlaceAsGuest];
            break;
    }
}

- (void)saveContextAccountCreation {
    [self createGif];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      [AccountController setBillingInfo:[self.cardNumberTextField getCreditCardNumber]
                                      month:self.expMonthButton.titleLabel.text
                                       year:self.expYearButton.titleLabel.text
                                  firstName:self.firstNameTextField.text
                                   lastName:self.lastNameTextField.text
                          verificationValue:self.cvcTextField.text
                                   address1:self.streetOneTextField.text
                                   address2:self.streetTwoTextField.text
                                       city:self.cityTextField.text
                                      state:self.stateButton.titleLabel.text
                                 postalCode:self.zipTextField.text
                                    country:@"US"
                                  vatNumber:@""
                                    placeId:[[[CorneaHolder shared] settings].currentPlace getAttribute:kAttrId]
                               accountModel:self.accountToWorkWith].then(^(NSDictionary *models) {
            [self hideGif];
            
            SuccessAccountViewController *vc = [SuccessAccountViewController create];
            [self.navigationController pushViewController:vc animated:YES];
        }).catch(^(NSError *error) {
            [self hideGif];
            NSString *title;
            NSString *message;
            [self billDisplayMessageWithError:error errorTitle:&title errorMessage:&message];
            [self displayErrorMessage:message withTitle:title];
        });
    });
}

- (void)saveContextAccountSettings {
    [self createGif];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      [AccountController updateBillingInfo:[self.cardNumberTextField getCreditCardNumber]
                                         month:self.expMonthButton.titleLabel.text
                                          year:self.expYearButton.titleLabel.text
                                     firstName:self.firstNameTextField.text
                                      lastName:self.lastNameTextField.text
                             verificationValue:self.cvcTextField.text
                                      address1:self.streetOneTextField.text
                                      address2:self.streetTwoTextField.text
                                          city:self.cityTextField.text
                                         state:self.stateButton.titleLabel.text
                                    postalCode:self.zipTextField.text
                                       country:@"US"
                                     vatNumber:@""
                                  accountModel:self.accountToWorkWith].then(^ {
            [self hideGif];

            DashboardTwoViewController *dashboardVC = self.navigationController.viewControllers[0];
            if (dashboardVC != nil && [dashboardVC isKindOfClass:[DashboardTwoViewController class]]) {
                [dashboardVC setDashboardBackgroundImageForCurrentPlace];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }).catch(^(NSError *error) {
            [self hideGif];
            
            NSString *title;
            NSString *message;
            [self billDisplayMessageWithError:error errorTitle:&title errorMessage:&message];
            [self displayErrorMessage:message withTitle:title];
        });
    });
}

- (void)saveContextAccountAddAPlaceAsGuest {
    [self createGif];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      [AccountController setBillingInfo:[self.cardNumberTextField getCreditCardNumber]
                                      month:self.expMonthButton.titleLabel.text
                                       year:self.expYearButton.titleLabel.text
                                  firstName:self.firstNameTextField.text
                                   lastName:self.lastNameTextField.text
                          verificationValue:self.cvcTextField.text
                                   address1:self.streetOneTextField.text
                                   address2:self.streetTwoTextField.text
                                       city:self.cityTextField.text
                                      state:self.stateButton.titleLabel.text
                                 postalCode:self.zipTextField.text
                                    country:@"US"
                                  vatNumber:@""
                                    placeId:[[[CorneaHolder shared] settings].currentPlace getAttribute:kAttrId]
                               accountModel:self.accountToWorkWith].thenInBackground(^(NSDictionary *models) {
            [AccountController completedAccountStep:AccountStateNewSignUpComplete
                                                  model:self.accountToWorkWith
                                       withAccountModel:self.accountToWorkWith];
            RunOnMain(^{
                [self hideGif];
                BOOL shouldShowChoosePlaceTutorial = CorneaHolder.shared.settings.displayChoosePlaceTutorial;
                if (shouldShowChoosePlaceTutorial) {
                    [self displayChoosePlacePopup];
                } else {
                   [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
                }
            });

                
            
        }).catch(^(NSError *error) {
            [self hideGif];
            NSString *title;
            NSString *message;
            [self billDisplayMessageWithError:error errorTitle:&title errorMessage:&message];
            [self displayErrorMessage:message withTitle:title];
        });
    });
}

#pragma mark Error Mesasges

- (void)billDisplayMessageWithError:(NSError *)error errorTitle:(NSString **)title errorMessage:(NSString **)message {
    *message = (NSString *)(error.userInfo[@"code"]);
#ifndef DEBUG
    if ([*message isEqualToString:@"declined_card_number"] ||
        [*message isEqualToString:@"invalid_card_number"]) {
        *title = NSLocalizedString(@"Invalid/Declined Credit Card Number", nil);
        *message = NSLocalizedString(@"Please update your card number and try again", nil);
    }
    else if ([*message isEqualToString:@"declined"]) {
        *title = NSLocalizedString(@"Declined", nil);
        *message = NSLocalizedString(@"Please update your card number and try again.", nil);
    }
    else if ([*message isEqualToString:@"taken"] ||
             [*message isEqualToString:@"simultaneous"]) {
        *title = NSLocalizedString(@"Transaction Unsuccessful", nil);
        *message = NSLocalizedString(@"Your card was not charged. Please wait 10 seconds before trying again.", nil);
    }
    else if ([*message isEqualToString:@"declined_security_code"] ||
             [*message isEqualToString:@"fraud_security_code"]) {
        *title = NSLocalizedString(@"Security Code Doesn't Match", nil);
        *message = NSLocalizedString(@"Please update the CVV and try again", nil);
    }
    else if ([*message isEqualToString:@"expired_card"]) {
        *title = NSLocalizedString(@"Expired Credit Card", nil);
        *message = NSLocalizedString(@"Please update your card and try again", nil);
    }
    else if ([*message isEqualToString:@"declined_expiration_date"]) {
        *title = NSLocalizedString(@"Invalid/Incorrect Expiration Date", nil);
        *message = NSLocalizedString(@"Please update the expiration date and try again", nil);
    }
    else if ([*message isEqualToString:@"invalid_merchant_type"] ||
             [*message isEqualToString:@"invalid_issuer"]) {
        *title = NSLocalizedString(@"Invalid Credit Card", nil) ;
        *message = NSLocalizedString(@"This card is not allowed to complete this transaction. Please try another card.", nil);
    }
    else if ([*message isEqualToString:@"card_type_not_accepted"]) {
        *title = NSLocalizedString(@"Card Type Not Accepted", nil) ;
        *message = NSLocalizedString(@"Please use a different credit card", nil);
    }
    else if ([*message isEqualToString:@"restricted_card"] ||
             [*message isEqualToString:@"restricted_card_chargeback"]) {
        *title = NSLocalizedString(@"Restricted Credit Card", nil) ;
        *message = NSLocalizedString(@"Please contact your issuing bank for details, or try another card", nil);
    }
    else if ([*message isEqualToString:@"card_not_activated"]) {
        *title = NSLocalizedString(@"Card Not Activated", nil) ;
        *message = NSLocalizedString(@"Please call your bank to activate your card and try again", nil);
    }
    else if ([*message isEqualToString:@"fraud_address"]) {
        *title = NSLocalizedString(@"Incorrect Billing Address", nil) ;
        *message = NSLocalizedString(@"Billing address doesn't match address on your account. Please fix your address or contact your bank", nil);
    }
    else if ([*message isEqualToString:@"fraud_stolen_card"] ||
             [*message isEqualToString:@"fraud_ip_address"] ||
             [*message isEqualToString:@"fraud_gateway"] ||
             [*message isEqualToString:@"fraud_advanced_verification"]) {
        
        *title = NSLocalizedString(@"Declined", nil) ;
        *message = NSLocalizedString(@"Please use a different card or contact your bank", nil);
    }
    else if ([*message isEqualToString:@"invalid_gateway_configuration"] ||
             [*message isEqualToString:@"invalid_login"] ||
             [*message isEqualToString:@"gateway_unavailable"] ||
             [*message isEqualToString:@"processor_unavailable"]  ||
             [*message isEqualToString:@"issuer_unavailable"] ||
             [*message isEqualToString:@"gateway_timeout"] ||
             [*message isEqualToString:@"gateway_error"] ||
             [*message isEqualToString:@"contact_gateway"] ||
             [*message isEqualToString:@"try_again"] ||
             [*message isEqualToString:@"ssl_error"] ||
             [*message isEqualToString:@"recurly_error"] ||
             [*message isEqualToString:@"unknown"]  ||
             [*message isEqualToString:@"api_error"]) {
        
        *title = NSLocalizedString(@"Transaction Unsuccessful", nil) ;
        *message = NSLocalizedString(@"Your card was not charged. Please contact support at 1-0", nil);
    }
    else {
        *title = NSLocalizedString(@"Oops, That's not Right", nil) ;
        *message = NSLocalizedString(@"Generic errors", nil);
    }
#else 
    *message = [NSString stringWithFormat:@"error code: %@\n description: %@", *message, error.localizedDescription];
#endif
}

#pragma mark - Helpers
- (void)displayChoosePlacePopup {
    TutorialViewController *vc = [TutorialViewController createWithType:TuturialTypeChoosePlaces shouldHideShowAgain:YES andCompletionBlock:^{
      [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
    }];
    [self presentViewController:vc animated:true completion:nil];
}

@end
