//
//  PasswordTextField.m
//  i2app
//
//  Created by Arcus Team on 8/6/15.
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
#import "PasswordTextField.h"
#import "NSString+Validate.h"

@implementation PasswordTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)isValidEntry:(NSString **)errorMessageKey {
    BOOL isValid = YES;
    
    if (self.restrictedValues) {
        for (NSString *value in self.restrictedValues) {
            isValid = ![self.text containsString:value];
            if (!isValid) {
                *errorMessageKey = @"Password cannot contain email.";
                break;
            }
        }
    }
    
    if (isValid && self.confirmationString) {
        isValid = [self.text isEqualToString:self.confirmationString];
        if (!isValid) {
            *errorMessageKey = @"Passwords do not match.";
        }
    }

    if (isValid) {
        isValid = [self.text isValidPassword];
        if (!isValid) {
            *errorMessageKey = @"Invalid Password";
        }
    }
   
    return isValid;
}

@end
