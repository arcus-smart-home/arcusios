//
//  NSString+CreditCard.m
//  i2app
//
//  Created by Arcus Team on 7/15/15.
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
#import "NSString+CreditCard.h"
#import "NSString+Validate.h"

@implementation NSString ( CreditCard )

- (NSString *)amexCardFormatString {
    NSString *output;
    switch (self.length) {
        case 0:
            output = @"";
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            output = [NSString stringWithFormat:@"%@", [self substringToIndex:self.length]];
            break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
            output = [NSString stringWithFormat:@"%@-%@", [self substringToIndex:4], [self substringFromIndex:4]];
            break;
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
            output = [NSString stringWithFormat:@"%@-%@-%@", [self substringToIndex:4], [self substringWithRange:NSMakeRange(4, 6)], [self substringFromIndex:10]];
            break;
        default:
            output = [NSString stringWithFormat:@"%@-%@-%@", [self substringToIndex:4], [self substringWithRange:NSMakeRange(4, 6)], [self substringWithRange:NSMakeRange(10,5)]];
            break;
    }
    return output;
}

- (NSString *)normalCardFormatString {
    NSString *output;
    
    switch (self.length) {
        case 0:
            output = @"";
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            output = [NSString stringWithFormat:@"%@", [self substringToIndex:self.length]];
            break;
        case 5:
        case 6:
        case 7:
        case 8:
            output = [NSString stringWithFormat:@"%@-%@", [self substringToIndex:4], [self substringFromIndex:4]];
            break;
        case 9:
        case 10:
        case 11:
        case 12:
            output = [NSString stringWithFormat:@"%@-%@-%@", [self substringToIndex:4], [self substringWithRange:NSMakeRange(4, 4)], [self substringFromIndex:8]];
            break;
        case 13:
        case 14:
        case 15:
        case 16:
            output = [NSString stringWithFormat:@"%@-%@-%@-%@", [self substringToIndex:4], [self substringWithRange:NSMakeRange(4, 4)], [self substringWithRange:NSMakeRange(8, 4)], [self substringFromIndex:12]];
            break;
        default:
            output = [NSString stringWithFormat:@"%@-%@-%@-%@", [self substringToIndex:4], [self substringWithRange:NSMakeRange(4, 4)], [self substringWithRange:NSMakeRange(8, 4)], [self substringWithRange:NSMakeRange(12, 4)]];;
            break;
    }
   
    return output;
}

- (NSString *)formattedCreditString  {
    if ( [self isPossibleAmexCard] ) {
        return [self amexCardFormatString];
    }
    
    return [self normalCardFormatString];
}

- (BOOL)isPossibleAmexCard {
    return  ([self hasPrefix:@"34"] || [self hasPrefix:@"37"]);
}

@end


@implementation NSString ( Format )

- (NSString *)stringUpperCaseFirstLetter {
    if (self.length == 0) {
        return @"";
    }
    if (self.length == 1) {
        return [self capitalizedString];
    }
    
    return  [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] capitalizedString]];
}

@end
