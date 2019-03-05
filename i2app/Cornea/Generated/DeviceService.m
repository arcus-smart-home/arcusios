

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DeviceService.h"
#import <i2app-Swift.h>

@implementation DeviceService
+ (NSString *)name { return @"DeviceService"; }
+ (NSString *)address { return @"SERV:dev:"; }


+ (PMKPromise *) syncDevicesWithAccountId:(NSString *)accountId withPlaceId:(NSString *)placeId withReflexVersion:(int)reflexVersion withDevices:(NSString *)devices {
  return [DeviceServiceLegacy syncDevices:accountId placeId:placeId reflexVersion:reflexVersion devices:devices];

}

@end
