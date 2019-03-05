

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AccountService.h"
#import <i2app-Swift.h>

@implementation AccountService
+ (NSString *)name { return @"AccountService"; }
+ (NSString *)address { return @"SERV:account:"; }


+ (PMKPromise *) createAccountWithEmail:(NSString *)email withPassword:(NSString *)password withOptin:(NSString *)optin withIsPublic:(NSString *)isPublic withPerson:(id)person withPlace:(id)place {
  return [AccountServiceLegacy createAccount:email password:password optin:optin isPublic:isPublic person:person place:place];

}

@end
