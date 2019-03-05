//
//  NSString+Validate.m
//  i2app
//
//  Created by Arcus Team on 4/6/15.
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
#import "NSString+Validate.h"

@interface NSString (ValidatePrivate)

- (NSString *)cleanStringOfAllNonNumericCharacters;

@end

@implementation NSString (Validate)

- (BOOL)isValidEmail {
    NSString *emailAddress = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *filterEmailString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterEmailString];
    return [emailTest evaluateWithObject:emailAddress];
}


- (BOOL)isValidPhoneNumber {
    
    NSString *cleanedString = [self cleanStringOfAllNonNumericCharacters];
    
    // containing only numbers 0 through 9 with a length between and including 10 and 20
    NSString *filterString = @"^[0-9]{10,20}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterString];
    return [phoneTest evaluateWithObject:cleanedString];
}

- (BOOL)isValidPassword {
    
    // containing minimum 8 and max 32 characters, at least 1 numeric and 1 alphabet character present
    NSString *filterPasswordString = @"(?=^.{8,}$)(?=.*[a-zA-Z])(?=.*[0-9])(?!.*[:space:]).*$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterPasswordString];
    return [passwordTest evaluateWithObject:self];
    
}

- (BOOL)isValidZipCode {
    // zip code validation for US only
    NSString *filterZipString = @"(^[0-9]{5}(-[0-9]{4})?$)";
    NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterZipString];
    return [zipTest evaluateWithObject:self];
    
}

- (BOOL)isValidAmexCreditCardNumber {
    NSString *filterCreditCardString = @"(^[0-9]{15})?$";
    NSPredicate *creditCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterCreditCardString];
    return [creditCardTest evaluateWithObject:self];
}

- (BOOL)isValidAmexCVV {
    //containing 4 numeric characters
    NSString *filterCvcString = @"(^[0-9]{4}?$)";
    NSPredicate *cvcTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterCvcString];
    return [cvcTest evaluateWithObject:self];
}

- (BOOL)isValidNonAmexCVV {
    //containing 3 numeric characters
    NSString *filterCvcString = @"(^[0-9]{3}?$)";
    NSPredicate *cvcTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterCvcString];
    return [cvcTest evaluateWithObject:self];
}

- (BOOL)isValidHubID {
    
    NSString *filterHubIDString = @"(^[a-zA-Z]{3}-[0-9]{4}?$)";
    NSPredicate *hubIDTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterHubIDString];
    return [hubIDTest evaluateWithObject:self];

}

- (BOOL)isValidDeviceName {

    return (self.length > 0);
}


- (NSString *)cleanStringOfAllNonNumericCharacters {
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
}

@end
