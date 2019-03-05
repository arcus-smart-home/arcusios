//
//  LocalizedStringsController.m
//  Pods
//
//  Created by Arcus Team on 5/6/15.
//
//

#import <i2app-Swift.h>
#import "LocalizedStringsController.h"
#import "I18NService.h"
#import "PromiseKit/Promise.h"
#import "NSString+Formatting.h"

@implementation LocalizedStringsController

+ (PMKPromise *)getSecurityQuestions {
    
    return [I18NService loadLocalizedStringsWithBundleNames:@[@"security_question"] withLocale:@"en_US"].thenInBackground(^(I18NServiceLoadLocalizedStringsResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *attribs = [response getLocalizedStrings];
            if (attribs.count > 0) {
                NSMutableDictionary *secQuestions = [[NSMutableDictionary alloc] initWithCapacity:attribs.count];
                // Security Question key = "security_question:question1".
                // Strip out the "security_question:" portion of the key
                for (int i = 0; i < attribs.count; i++) {
                    NSString *key = [NSString getSafeString:attribs.allKeys[i]];
                    NSArray *components = [key componentsSeparatedByString:@":"];
                    if (components.count > 1) {
                        key = components[1];
                        NSString *value = attribs.allValues[i];
                        [secQuestions setObject:value forKey:key];
                    }
                }
                fulfill(secQuestions);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"Arcus" code:201 userInfo:@{NSLocalizedDescriptionKey : @"Security Questions are not available"}];
                reject(error);
            }
        }];
    });
}

@end
