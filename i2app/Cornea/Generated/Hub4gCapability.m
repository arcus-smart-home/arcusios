

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "Hub4gCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHub4gPresent=@"hub4g:present";

NSString *const kAttrHub4gSimPresent=@"hub4g:simPresent";

NSString *const kAttrHub4gSimProvisioned=@"hub4g:simProvisioned";

NSString *const kAttrHub4gSimDisabled=@"hub4g:simDisabled";

NSString *const kAttrHub4gSimDisabledDate=@"hub4g:simDisabledDate";

NSString *const kAttrHub4gConnectionState=@"hub4g:connectionState";

NSString *const kAttrHub4gVendor=@"hub4g:vendor";

NSString *const kAttrHub4gModel=@"hub4g:model";

NSString *const kAttrHub4gSerialNumber=@"hub4g:serialNumber";

NSString *const kAttrHub4gImei=@"hub4g:imei";

NSString *const kAttrHub4gImsi=@"hub4g:imsi";

NSString *const kAttrHub4gIccid=@"hub4g:iccid";

NSString *const kAttrHub4gPhoneNumber=@"hub4g:phoneNumber";

NSString *const kAttrHub4gMode=@"hub4g:mode";

NSString *const kAttrHub4gSignalBars=@"hub4g:signalBars";

NSString *const kAttrHub4gConnectionStatus=@"hub4g:connectionStatus";


NSString *const kCmdHub4gGetInfo=@"hub4g:GetInfo";

NSString *const kCmdHub4gResetStatistics=@"hub4g:ResetStatistics";

NSString *const kCmdHub4gGetStatistics=@"hub4g:GetStatistics";


NSString *const kEnumHub4gConnectionStateCONNECTING = @"CONNECTING";
NSString *const kEnumHub4gConnectionStateCONNECTED = @"CONNECTED";
NSString *const kEnumHub4gConnectionStateDISCONNECTING = @"DISCONNECTING";
NSString *const kEnumHub4gConnectionStateDISCONNECTED = @"DISCONNECTED";


@implementation Hub4gCapability
+ (NSString *)namespace { return @"hub4g"; }
+ (NSString *)name { return @"Hub4g"; }

+ (BOOL)getPresentFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[Hub4gCapabilityLegacy getPresent:modelObj] boolValue];
  
}


+ (BOOL)getSimPresentFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[Hub4gCapabilityLegacy getSimPresent:modelObj] boolValue];
  
}


+ (BOOL)getSimProvisionedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[Hub4gCapabilityLegacy getSimProvisioned:modelObj] boolValue];
  
}


+ (BOOL)getSimDisabledFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[Hub4gCapabilityLegacy getSimDisabled:modelObj] boolValue];
  
}


+ (NSDate *)getSimDisabledDateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getSimDisabledDate:modelObj];
  
}


+ (NSString *)getConnectionStateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getConnectionState:modelObj];
  
}


+ (NSString *)getVendorFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getVendor:modelObj];
  
}


+ (NSString *)getModelFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getModel:modelObj];
  
}


+ (NSString *)getSerialNumberFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getSerialNumber:modelObj];
  
}


+ (NSString *)getImeiFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getImei:modelObj];
  
}


+ (NSString *)getImsiFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getImsi:modelObj];
  
}


+ (NSString *)getIccidFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getIccid:modelObj];
  
}


+ (NSString *)getPhoneNumberFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getPhoneNumber:modelObj];
  
}


+ (NSString *)getModeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getMode:modelObj];
  
}


+ (int)getSignalBarsFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[Hub4gCapabilityLegacy getSignalBars:modelObj] intValue];
  
}


+ (NSString *)getConnectionStatusFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Hub4gCapabilityLegacy getConnectionStatus:modelObj];
  
}




+ (PMKPromise *) getInfoOnModel:(HubModel *)modelObj {
  return [Hub4gCapabilityLegacy getInfo:modelObj ];
}


+ (PMKPromise *) resetStatisticsOnModel:(HubModel *)modelObj {
  return [Hub4gCapabilityLegacy resetStatistics:modelObj ];
}


+ (PMKPromise *) getStatisticsOnModel:(HubModel *)modelObj {
  return [Hub4gCapabilityLegacy getStatistics:modelObj ];
}

@end
