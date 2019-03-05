

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IpcdService.h"
#import <i2app-Swift.h>

@implementation IpcdService
+ (NSString *)name { return @"IpcdService"; }
+ (NSString *)address { return @"SERV:ipcd:"; }


+ (PMKPromise *) listDeviceTypes {
  return [IpcdServiceLegacy listDeviceTypes];
}


+ (PMKPromise *) findDeviceWithDeviceType:(id)deviceType withSn:(NSString *)sn {
  return [IpcdServiceLegacy findDevice:deviceType sn:sn];

}


+ (PMKPromise *) forceUnregisterWithProtocolAddress:(NSString *)protocolAddress {
  return [IpcdServiceLegacy forceUnregister:protocolAddress];

}

@end
