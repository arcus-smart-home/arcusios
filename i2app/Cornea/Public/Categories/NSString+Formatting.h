//
//  NSString+Formatting.h
//  Pods
//
//  Created by Arcus Team on 4/30/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Formatting)

+ (NSString *)getSafeString:(NSString *)inputStr;
- (NSString *)stringWithSentenceCapitalization;

@end
