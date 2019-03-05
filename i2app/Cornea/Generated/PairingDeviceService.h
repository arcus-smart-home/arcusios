

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface PairingDeviceService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** A request to create a mock pairing device. */
+ (PMKPromise *) createMockWithProductAddress:(NSString *)productAddress;



@end
