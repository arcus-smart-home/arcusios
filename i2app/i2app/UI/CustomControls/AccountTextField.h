//
//  AccountTextField.h
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

#import <UIKit/UIKit.h>
#import "FontData.h"
#import "ArcusFloatingLabelTextField.h"

@class ArcusFloatingLabelTextField;

typedef enum {
    AccountTextFieldTypeGeneral   = 0,
    AccountTextFieldTypeEmail     = 1,
    AccountTextFieldTypePhone     = 2,
    AccountTextFieldTypePassword  = 3,
    AccountTextFieldTypeZipCode   = 4,
    AccountTextFieldTypeCCNumber  = 7,
    AccountTextFieldTypeCVC       = 8,
    AccountTextFieldTypeHubID     = 9,
    AccountTextFieldTypeDeviceName = 10
} AccountTextFieldType;

typedef enum {
    CreditCardTypeErrorType = 0,
    CreditCardTypeUnknowType,
    CreditCardTypeAmericanExpress,
    CreditCardTypeBankcard,
    CreditCardTypeChinaUnionPay,
    CreditCardTypeDinersClubCarteBlanche,
    CreditCardTypeDinersClubEnRoute,
    CreditCardTypeDinersClubInternational,
    CreditCardTypeDinersClubUnitedStates_Canada,
    CreditCardTypeDiscoverCard,
    CreditCardTypeInterPayment,
    CreditCardTypeInstaPayment,
    CreditCardTypeJCB,
    CreditCardTypeLaser,
    CreditCardTypeMaestro,
    CreditCardTypeDankort,
    CreditCardTypeMasterCard,
    CreditCardTypeSolo,
    CreditCardTypeSwitch,
    CreditCardTypeVisa,
    CreditCardTypeUATP,
} CreditCardType;

typedef enum {
    AccountTextFieldStyleBlack   = 0,
    AccountTextFieldStyleWhite,
} AccountTextFieldStyleType;


@interface AccountTextField : ArcusFloatingLabelTextField

@property (atomic) AccountTextFieldType accountFieldType;
@property (atomic) BOOL isRequired;
@property (readonly, atomic) AccountTextFieldStyleType fieldStyle;

- (void)setAccountFieldStyle: (AccountTextFieldStyleType) type;

- (void)setupType:(AccountTextFieldType)accountFieldType;
- (void)setupType:(AccountTextFieldType)accountFieldType
       isRequired:(BOOL)required;
- (void)setupType:(AccountTextFieldType)accountFieldType
         fontType:(FontDataType)fontType
placeholderFontType:(FontDataType)placeholderFontType;
- (void)setupType:(AccountTextFieldType)accountFieldType
       isRequired:(BOOL)required
         fontType:(FontDataType)fontType
placeholderFontType:(FontDataType)placeholderFontType;

// use to validate the text before submitting the data 
- (BOOL)isValidEntry:(NSString **)errorMessageKey;


- (NSString *)getCreditCardNumber;

@end
