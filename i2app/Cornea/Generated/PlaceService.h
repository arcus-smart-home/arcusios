

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface PlaceService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Creates an initial account, which includes the billing account, account owning person, default place, login credentials and default authorization grants */
+ (PMKPromise *) listTimezones;



/** Validates the place&#x27;s address. Usually when the address is invalid a set of suggestions may be used to prompt the user with alternatives. */
+ (PMKPromise *) validateAddressWithPlaceId:(NSString *)placeId withStreetAddress:(id)streetAddress;



@end
