

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface BridgeService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Assigns a place to the device with the specified id provided the device is online. */
+ (PMKPromise *) registerDeviceWithAttrs:(NSDictionary *)attrs;



/** Removes the device with the specified id. */
+ (PMKPromise *) removeDeviceWithId:(NSString *)id withAccountId:(NSString *)accountId withPlaceId:(NSString *)placeId;



@end
