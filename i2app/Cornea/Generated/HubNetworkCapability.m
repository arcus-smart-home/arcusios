

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubNetworkCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubNetworkType=@"hubnet:type";

NSString *const kAttrHubNetworkUptime=@"hubnet:uptime";

NSString *const kAttrHubNetworkIp=@"hubnet:ip";

NSString *const kAttrHubNetworkExternalip=@"hubnet:externalip";

NSString *const kAttrHubNetworkNetmask=@"hubnet:netmask";

NSString *const kAttrHubNetworkGateway=@"hubnet:gateway";

NSString *const kAttrHubNetworkDns=@"hubnet:dns";

NSString *const kAttrHubNetworkInterfaces=@"hubnet:interfaces";


NSString *const kCmdHubNetworkGetRoutingTable=@"hubnet:GetRoutingTable";


NSString *const kEnumHubNetworkTypeETH = @"ETH";
NSString *const kEnumHubNetworkType3G = @"3G";
NSString *const kEnumHubNetworkTypeWIFI = @"WIFI";


@implementation HubNetworkCapability
+ (NSString *)namespace { return @"hubnet"; }
+ (NSString *)name { return @"HubNetwork"; }

+ (NSString *)getTypeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubNetworkCapabilityLegacy getType:modelObj];
  
}


+ (long)getUptimeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubNetworkCapabilityLegacy getUptime:modelObj] longValue];
  
}


+ (NSString *)getIpFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubNetworkCapabilityLegacy getIp:modelObj];
  
}


+ (NSString *)getExternalipFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubNetworkCapabilityLegacy getExternalip:modelObj];
  
}


+ (NSString *)getNetmaskFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubNetworkCapabilityLegacy getNetmask:modelObj];
  
}


+ (NSString *)getGatewayFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubNetworkCapabilityLegacy getGateway:modelObj];
  
}


+ (NSString *)getDnsFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubNetworkCapabilityLegacy getDns:modelObj];
  
}


+ (NSArray *)getInterfacesFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubNetworkCapabilityLegacy getInterfaces:modelObj];
  
}




+ (PMKPromise *) getRoutingTableOnModel:(HubModel *)modelObj {
  return [HubNetworkCapabilityLegacy getRoutingTable:modelObj ];
}

@end
