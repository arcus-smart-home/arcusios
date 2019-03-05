

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface I18NService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Loads localized keys from the server */
+ (PMKPromise *) loadLocalizedStringsWithBundleNames:(NSArray *)bundleNames withLocale:(NSString *)locale;



@end
