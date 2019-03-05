

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "I18NService.h"
#import <i2app-Swift.h>

@implementation I18NService
+ (NSString *)name { return @"I18NService"; }
+ (NSString *)address { return @"SERV:i18n:"; }


+ (PMKPromise *) loadLocalizedStringsWithBundleNames:(NSArray *)bundleNames withLocale:(NSString *)locale {
  return [I18NServiceLegacy loadLocalizedStrings:bundleNames locale:locale];

}

@end
