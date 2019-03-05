

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface IpcdService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Lists the available vendor/model combinations for supported IPCD devices */
+ (PMKPromise *) listDeviceTypes;



/** Finds the IPCD device for the given vendor/model/sn combination that uniquely identies an IPCD device */
+ (PMKPromise *) findDeviceWithDeviceType:(id)deviceType withSn:(NSString *)sn;



/** Forces unregistration of an IPCD device */
+ (PMKPromise *) forceUnregisterWithProtocolAddress:(NSString *)protocolAddress;



@end
