

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PairingDeviceService.h"
#import <i2app-Swift.h>

@implementation PairingDeviceService
+ (NSString *)name { return @"PairingDeviceService"; }
+ (NSString *)address { return @"SERV:pairdev:"; }


+ (PMKPromise *) createMockWithProductAddress:(NSString *)productAddress {
  return [PairingDeviceServiceLegacy createMock:productAddress];

}

@end
