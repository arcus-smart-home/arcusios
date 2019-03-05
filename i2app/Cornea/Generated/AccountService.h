

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface AccountService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Creates an initial account, which includes the billing account, account owning person, default place, login credentials and default authorization grants */
+ (PMKPromise *) createAccountWithEmail:(NSString *)email withPassword:(NSString *)password withOptin:(NSString *)optin withIsPublic:(NSString *)isPublic withPerson:(id)person withPlace:(id)place;



@end
