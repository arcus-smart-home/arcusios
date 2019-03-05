

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubConnectionCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubConnectionState=@"hubconn:state";

NSString *const kAttrHubConnectionLastchange=@"hubconn:lastchange";

NSString *const kAttrHubConnectionConnQuality=@"hubconn:connQuality";

NSString *const kAttrHubConnectionPingTime=@"hubconn:pingTime";

NSString *const kAttrHubConnectionPingResponse=@"hubconn:pingResponse";



NSString *const kEnumHubConnectionStateONLINE = @"ONLINE";
NSString *const kEnumHubConnectionStateHANDSHAKE = @"HANDSHAKE";
NSString *const kEnumHubConnectionStateOFFLINE = @"OFFLINE";


@implementation HubConnectionCapability
+ (NSString *)namespace { return @"hubconn"; }
+ (NSString *)name { return @"HubConnection"; }

+ (NSString *)getStateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubConnectionCapabilityLegacy getState:modelObj];
  
}


+ (NSDate *)getLastchangeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubConnectionCapabilityLegacy getLastchange:modelObj];
  
}


+ (int)getConnQualityFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubConnectionCapabilityLegacy getConnQuality:modelObj] intValue];
  
}


+ (int)getPingTimeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubConnectionCapabilityLegacy getPingTime:modelObj] intValue];
  
}


+ (int)getPingResponseFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubConnectionCapabilityLegacy getPingResponse:modelObj] intValue];
  
}



@end
