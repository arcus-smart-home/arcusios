

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IpInfoCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrIpInfoIp=@"ipinfo:ip";

NSString *const kAttrIpInfoMac=@"ipinfo:mac";

NSString *const kAttrIpInfoNetmask=@"ipinfo:netmask";

NSString *const kAttrIpInfoGateway=@"ipinfo:gateway";





@implementation IpInfoCapability
+ (NSString *)namespace { return @"ipinfo"; }
+ (NSString *)name { return @"IpInfo"; }

+ (NSString *)getIpFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IpInfoCapabilityLegacy getIp:modelObj];
  
}


+ (NSString *)getMacFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IpInfoCapabilityLegacy getMac:modelObj];
  
}


+ (NSString *)getNetmaskFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IpInfoCapabilityLegacy getNetmask:modelObj];
  
}


+ (NSString *)getGatewayFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IpInfoCapabilityLegacy getGateway:modelObj];
  
}



@end
