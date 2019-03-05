//
//  NSString+Formatting.m
//  Pods
//
//  Created by Arcus Team on 4/30/15.
//
//

#import <i2app-Swift.h>
#import "NSString+Formatting.h"

@implementation NSString (Formatting)

+ (NSString *)getSafeString:(NSString *)inputStr {
    return inputStr.length > 0 ? inputStr : @"";
}

- (NSString *)stringWithSentenceCapitalization {
    NSString *firstCharacterInString = [[self substringToIndex:1] capitalizedString];
    NSString *sentenceString = [self lowercaseString];
    sentenceString = [sentenceString stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                             withString:firstCharacterInString];

    return sentenceString;
}
@end
