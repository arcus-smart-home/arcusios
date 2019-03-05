

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "BridgeService.h"
#import <i2app-Swift.h>

@implementation BridgeService
+ (NSString *)name { return @"BridgeService"; }
+ (NSString *)address { return @"SERV:bridgesvc:"; }


+ (PMKPromise *) registerDeviceWithAttrs:(NSDictionary *)attrs {
  return [BridgeServiceLegacy registerDevice:attrs];

}


+ (PMKPromise *) removeDeviceWithId:(NSString *)id withAccountId:(NSString *)accountId withPlaceId:(NSString *)placeId {
  return [BridgeServiceLegacy removeDevice:id accountId:accountId placeId:placeId];

}

@end
