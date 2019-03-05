//
//  AccountTextField.m
//  i2app
//
//  Created by Arcus Team on 4/8/15.
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
#import "AccountTextField.h"
#import "NSString+Validate.h"
#import "NSString+CreditCard.h"

#import "UIView+Subviews.h"
#import "BillingViewController.h"

@interface AccountTextField ()

- (CreditCardType)getCreditCardType:(NSString *)creditCardNumber;

@end

@implementation AccountTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"field name:%@ text:%@", self.placeholder, self.text];
}

- (void)setupType:(AccountTextFieldType)accountFieldType {
    // isRequired defaults to "YES"
    
    if (_fieldStyle == AccountTextFieldStyleWhite) {
        [self setupType:accountFieldType
             isRequired:YES
               fontType:FontDataTypeAccountTextFieldWhite
    placeholderFontType:FontDataTypeAccountTextFieldPlaceholderWhite];
    }
    else {
        [self setupType:accountFieldType
             isRequired:YES
               fontType:FontDataTypeAccountTextField
    placeholderFontType:FontDataTypeAccountTextFieldPlaceholder];
    }
}

- (void)setupType:(AccountTextFieldType)accountFieldType fontType:(FontDataType)fontType placeholderFontType:(FontDataType)placeholderFontType {
    
    [self setupType:accountFieldType isRequired:YES fontType:fontType placeholderFontType:placeholderFontType];
}

- (void)setupType:(AccountTextFieldType)accountFieldType isRequired:(BOOL)required {
    _accountFieldType = accountFieldType;
    _isRequired = required;
    
    switch (_fieldStyle) {
        case AccountTextFieldStyleWhite:
            self.attributedText = [FontData getString:self.text  withFont:FontDataTypeAccountTextFieldWhite];
            
            [self setFont:[FontData getFont:FontDataTypeAccountTextFieldWhite][NSFontAttributeName]];
            [self setTextColor:[UIColor whiteColor]];
            [self setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3f]];
            [self setActivatedFontAttributed:[FontData getFont:FontDataTypeAccountTextFieldPlaceholderWhite]];
            [self setActiveSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3f]];
            [self setFloatingLabelTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
            [self setFloatingLabelActiveTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
            
            break;
        case AccountTextFieldStyleBlack:
        default:
            self.attributedText = [FontData getString:self.text  withFont:FontDataTypeAccountTextField];
            [self setTextColor:[UIColor blackColor]];
            break;
    }

    if (accountFieldType != AccountTextFieldTypePassword) {
        switch (_fieldStyle) {
            case AccountTextFieldStyleWhite:
                self.attributedPlaceholder = [FontData getString:[self.placeholder uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholderWhite];
                [self setFont:[FontData getFont:FontDataTypeAccountTextFieldWhite][NSFontAttributeName]];
                break;
            case AccountTextFieldStyleBlack:
            default:
                self.attributedPlaceholder = [FontData getString:[self.placeholder uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholder];
                break;
        }
    }
}

- (void)setupType:(AccountTextFieldType)accountFieldType isRequired:(BOOL)required
         fontType:(FontDataType)fontType placeholderFontType:(FontDataType)placeholderFontType {
    _accountFieldType = accountFieldType;
    _isRequired = required;
    
    // Set textField attributes
    
    self.attributedText = [FontData getString:self.text  withFont:fontType];
    if (accountFieldType != AccountTextFieldTypePassword) {
        self.attributedPlaceholder = [FontData getString:[self.placeholder uppercaseString] withFont:placeholderFontType];
    }
}

- (void)setAccountFieldStyle: (AccountTextFieldStyleType) type {
    _fieldStyle = type;
    [self setupType:_accountFieldType isRequired:_isRequired];
}

- (BOOL)isValidEntry:(NSString **)errorMessageKey {
    
    // if an entry is required: check if it is empty
    if (self.isRequired && self.text.length == 0) {
        *errorMessageKey = @"Missing Information";
        return NO;
    }
    if (!_isRequired && self.text.length == 0) {
        return YES;
    }

    BOOL isValid = YES;
    *errorMessageKey = nil;
    
    switch (self.accountFieldType) {
        case AccountTextFieldTypeEmail:
        {
            NSArray *array = [self.text componentsSeparatedByString:@"!"];
            if (array.count == 1) {
                isValid = [self.text isValidEmail];
            }
            else {
                // email address contains the IP address for the platform
                isValid = [array[1] isValidEmail];
            }
            
            if (isValid) {
                NSRange whiteSpaceRange = [self.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
                if (whiteSpaceRange.location != NSNotFound) {
                    isValid = NO;
                }
            }
            
            if (!isValid) {
                *errorMessageKey = @"Invalid Email";
            }
        }
            break;
            
        case AccountTextFieldTypePhone:
            isValid = [self.text isValidPhoneNumber];
            
            if (!isValid) {
                *errorMessageKey = @"Phone invalid";
            }
            break;
            
        case AccountTextFieldTypeZipCode:
            isValid = [self.text isValidZipCode];
            
            if (!isValid) {
                *errorMessageKey = @"Zip code invalid";
            }
            break;
            
        case AccountTextFieldTypeCCNumber:
        {
            CreditCardType creditCardType = [self getCreditCardType:[self getCreditCardNumber]];
            if (creditCardType == CreditCardTypeUnknowType || creditCardType == CreditCardTypeErrorType) {
                isValid = NO;
                *errorMessageKey = @"Credit card invalid";
            }
        }
            break;
            
        case AccountTextFieldTypeCVC:
        {
            // We need to get the account # to determine if the CVC is valid
            BillingViewController *vc = (BillingViewController *)[self getParentViewController];
            if (![vc isKindOfClass:[BillingViewController class]] ||
                !vc.creditCardNumberField ||
                vc.creditCardNumberField.text.length == 0) {
                isValid = NO;
                *errorMessageKey = @"CVC invalid";
            }
            else {
                CreditCardType creditCardType = [self getCreditCardType:[vc.creditCardNumberField getCreditCardNumber]];
                if (creditCardType == CreditCardTypeAmericanExpress) {
                    isValid = [self.text isValidAmexCVV];
                }
                else {
                    isValid = [self.text isValidNonAmexCVV];
                }
                
                if (!isValid) {
                    *errorMessageKey = @"CVC invalid";
                }
            }
        }
            break;

        case AccountTextFieldTypeHubID:
            isValid = [self.text isValidHubID];
            
            if (!isValid) {
                *errorMessageKey = @"Hub ID invalid";
            }
            break;
            
        case AccountTextFieldTypeDeviceName:
            isValid = [self.text isValidDeviceName];
            
            if (!isValid) {
                *errorMessageKey = @"Device Name invalid";
            }
            break;


        default:
            break;
    }
    return isValid;
}

- (IBAction)valueChanged:(id)sender {
    if (self.accountFieldType != AccountTextFieldTypeCCNumber) {
        return;
    }
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *currentRange = [self selectedTextRange];
    UITextPosition *selectionStart = currentRange.start;
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];

    NSString *formatStr = [self getCreditCardNumber];
    NSString *displayStr = [formatStr formattedCreditString];
    
    if (![self.text isEqualToString:displayStr]) {
        self.text = displayStr;
        
        //set current cursor to current if we edit the textfield
        if (location < displayStr.length - [self numberOfHiphenInString:displayStr]) {
            
            [self setSelectedTextRange:currentRange];
        }
    }
}

- (int)numberOfHiphenInString:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@"-"];
    return (int)components.count - 1;
}


- (NSString *)getCreditCardNumber {
    if (self.accountFieldType == AccountTextFieldTypeCCNumber)
        return [self.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    else
        return self.text;
}

- (CreditCardType)getCreditCardType:(NSString *)creditCardNumber {
    //https://en.wikipedia.org/wiki/Bank_card_number#Issuer_identification_number_.28IIN.29
    
    if ([creditCardNumber hasPrefix:@"34"] || [creditCardNumber hasPrefix:@"37"]) {
        if (![creditCardNumber isValidAmexCreditCardNumber]) {
            return CreditCardTypeErrorType;
        }
        return CreditCardTypeAmericanExpress;
    }

    if ([creditCardNumber hasPrefix:@"62"]) {
        return CreditCardTypeChinaUnionPay;
    }
    if ([creditCardNumber hasPrefix:@"2014"] || [creditCardNumber hasPrefix:@"2149"] ) {
        return CreditCardTypeDinersClubEnRoute;
    }
    if ([creditCardNumber hasPrefix:@"54"] || [creditCardNumber hasPrefix:@"55"] ) {
        return CreditCardTypeDinersClubUnitedStates_Canada;
    }
    if ([creditCardNumber hasPrefix:@"636"]) {
        return CreditCardTypeInterPayment;
    }
    if ([creditCardNumber hasPrefix:@"6304"] || [creditCardNumber hasPrefix:@"6706"] || [creditCardNumber hasPrefix:@"6771"] || [creditCardNumber hasPrefix:@"6709"]) {
        return CreditCardTypeLaser;
    }
    if ([creditCardNumber hasPrefix:@"5019"]) {
        return CreditCardTypeDankort;
    }
    if ([creditCardNumber hasPrefix:@"51"] || [creditCardNumber hasPrefix:@"52"] ||
        [creditCardNumber hasPrefix:@"53"] || [creditCardNumber hasPrefix:@"54"] ||
        [creditCardNumber hasPrefix:@"55"]) {
        return CreditCardTypeMasterCard;
    }
    if ([creditCardNumber hasPrefix:@"6334"] || [creditCardNumber hasPrefix:@"6767"]) {
        return CreditCardTypeSolo;
    }
    if ([creditCardNumber hasPrefix:@"4903"] || [creditCardNumber hasPrefix:@"4905"] || [creditCardNumber hasPrefix:@"4911"] ||
        [creditCardNumber hasPrefix:@"4936"] || [creditCardNumber hasPrefix:@"564182"] || [creditCardNumber hasPrefix:@"633110"] ||
        [creditCardNumber hasPrefix:@"6333"] || [creditCardNumber hasPrefix:@"6759"]) {
        return CreditCardTypeSwitch;
    }
    if ([creditCardNumber hasPrefix:@"4"]) {
        return CreditCardTypeVisa;
    }
    if ([creditCardNumber hasPrefix:@"1"]) {
        return CreditCardTypeUATP;
    }
    
    if ([creditCardNumber hasPrefix:@"5610"]) {
        return CreditCardTypeBankcard;
    }
    if ([creditCardNumber hasPrefix:@"309"] || [creditCardNumber hasPrefix:@"36"]) {
        return CreditCardTypeDinersClubInternational;
    }
    if ([creditCardNumber hasPrefix:@"6011"] || [creditCardNumber hasPrefix:@"65"]) {
        return CreditCardTypeDiscoverCard;
    }
    
    NSInteger prefix6Digital = [[creditCardNumber substringWithRange:NSMakeRange(0, 6)] integerValue];
    if (prefix6Digital >= 560221 && prefix6Digital <= 560225) {
        return CreditCardTypeBankcard;
    }
    
    NSInteger prefix3Digital = [[creditCardNumber substringWithRange:NSMakeRange(0, 3)] integerValue];
    if (prefix3Digital >= 300 && prefix3Digital <= 305) {
        return CreditCardTypeDinersClubCarteBlanche;
    }
    
    NSInteger prefix2Digital = [[creditCardNumber substringWithRange:NSMakeRange(0, 2)] integerValue];
    if (prefix2Digital >= 38 && prefix2Digital <= 39) {
        return CreditCardTypeDinersClubInternational;
    }
    if (prefix6Digital >= 622126 && prefix6Digital <= 622925) {
        return CreditCardTypeDiscoverCard;
    }
    if (prefix3Digital >= 644 && prefix3Digital <= 649) {
        return CreditCardTypeDiscoverCard;
    }
    if (prefix3Digital >= 637 && prefix3Digital <= 639) {
        return CreditCardTypeInstaPayment;
    }

    NSInteger prefix4Digital = [[creditCardNumber substringWithRange:NSMakeRange(0, 4)] integerValue];
    if (prefix4Digital >= 3528 && prefix4Digital <= 3589) {
        return CreditCardTypeJCB;
    }
    if (prefix6Digital >= 500000 && prefix6Digital <= 509999) {
        return CreditCardTypeMaestro;
    }
    if (prefix6Digital >= 560000 && prefix6Digital <= 569999) {
        return CreditCardTypeMaestro;
    }
    
    return  CreditCardTypeUnknowType;
}

@end





