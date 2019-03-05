

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface DeviceService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** A request to synchronize the hub local reflexes with device services */
+ (PMKPromise *) syncDevicesWithAccountId:(NSString *)accountId withPlaceId:(NSString *)placeId withReflexVersion:(int)reflexVersion withDevices:(NSString *)devices;



@end
