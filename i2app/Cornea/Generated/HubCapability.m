

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubId=@"hub:id";

NSString *const kAttrHubAccount=@"hub:account";

NSString *const kAttrHubPlace=@"hub:place";

NSString *const kAttrHubName=@"hub:name";

NSString *const kAttrHubImage=@"hub:image";

NSString *const kAttrHubVendor=@"hub:vendor";

NSString *const kAttrHubModel=@"hub:model";

NSString *const kAttrHubState=@"hub:state";

NSString *const kAttrHubRegistrationState=@"hub:registrationState";

NSString *const kAttrHubTime=@"hub:time";

NSString *const kAttrHubTz=@"hub:tz";


NSString *const kCmdHubPairingRequest=@"hub:PairingRequest";

NSString *const kCmdHubUnpairingRequest=@"hub:UnpairingRequest";

NSString *const kCmdHubListHubs=@"hub:ListHubs";

NSString *const kCmdHubResetLogLevels=@"hub:ResetLogLevels";

NSString *const kCmdHubSetLogLevel=@"hub:SetLogLevel";

NSString *const kCmdHubGetLogs=@"hub:GetLogs";

NSString *const kCmdHubStreamLogs=@"hub:StreamLogs";

NSString *const kCmdHubGetConfig=@"hub:GetConfig";

NSString *const kCmdHubSetConfig=@"hub:SetConfig";

NSString *const kCmdHubDelete=@"hub:Delete";


NSString *const kEvtHubHubConnected=@"hub:HubConnected";

NSString *const kEvtHubHubDisconnected=@"hub:HubDisconnected";

NSString *const kEvtHubDeviceFound=@"hub:DeviceFound";

NSString *const kEnumHubStateNORMAL = @"NORMAL";
NSString *const kEnumHubStatePAIRING = @"PAIRING";
NSString *const kEnumHubStateUNPAIRING = @"UNPAIRING";
NSString *const kEnumHubStateDOWN = @"DOWN";
NSString *const kEnumHubRegistrationStateREGISTERED = @"REGISTERED";
NSString *const kEnumHubRegistrationStateUNREGISTERED = @"UNREGISTERED";
NSString *const kEnumHubRegistrationStateORPHANED = @"ORPHANED";


@implementation HubCapability
+ (NSString *)namespace { return @"hub"; }
+ (NSString *)name { return @"Hub"; }

+ (NSString *)getIdFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getId:modelObj];
  
}


+ (NSString *)getAccountFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getAccount:modelObj];
  
}


+ (NSString *)getPlaceFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getPlace:modelObj];
  
}


+ (NSString *)getNameFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getName:modelObj];
  
}

+ (NSString *)setName:(NSString *)name onModel:(HubModel *)modelObj {
  [HubCapabilityLegacy setName:name model:modelObj];
  
  return [HubCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getImageFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getImage:modelObj];
  
}

+ (NSString *)setImage:(NSString *)image onModel:(HubModel *)modelObj {
  [HubCapabilityLegacy setImage:image model:modelObj];
  
  return [HubCapabilityLegacy getImage:modelObj];
  
}


+ (NSString *)getVendorFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getVendor:modelObj];
  
}


+ (NSString *)getModelFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getModel:modelObj];
  
}


+ (NSString *)getStateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getState:modelObj];
  
}


+ (NSString *)getRegistrationStateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getRegistrationState:modelObj];
  
}


+ (long)getTimeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubCapabilityLegacy getTime:modelObj] longValue];
  
}


+ (NSString *)getTzFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubCapabilityLegacy getTz:modelObj];
  
}

+ (NSString *)setTz:(NSString *)tz onModel:(HubModel *)modelObj {
  [HubCapabilityLegacy setTz:tz model:modelObj];
  
  return [HubCapabilityLegacy getTz:modelObj];
  
}




+ (PMKPromise *) pairingRequestWithActionType:(NSString *)actionType withTimeout:(long)timeout onModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy pairingRequest:modelObj actionType:actionType timeout:timeout];

}


+ (PMKPromise *) unpairingRequestWithActionType:(NSString *)actionType withTimeout:(long)timeout withProtocol:(NSString *)protocol withProtocolId:(NSString *)protocolId withForce:(BOOL)force onModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy unpairingRequest:modelObj actionType:actionType timeout:timeout hubProtocol:protocol protocolId:protocolId force:force];

}


+ (PMKPromise *) listHubsOnModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy listHubs:modelObj ];
}


+ (PMKPromise *) resetLogLevelsOnModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy resetLogLevels:modelObj ];
}


+ (PMKPromise *) setLogLevelWithLevel:(NSString *)level withScope:(NSString *)scope onModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy setLogLevel:modelObj level:level scope:scope];

}


+ (PMKPromise *) getLogsOnModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy getLogs:modelObj ];
}


+ (PMKPromise *) streamLogsWithDuration:(long)duration withSeverity:(NSString *)severity onModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy streamLogs:modelObj duration:duration severity:severity];

}


+ (PMKPromise *) getConfigWithDefaults:(BOOL)defaults withMatching:(NSString *)matching onModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy getConfig:modelObj defaults:defaults matching:matching];

}


+ (PMKPromise *) setConfigWithConfig:(NSDictionary *)config onModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy setConfig:modelObj config:config];

}


+ (PMKPromise *) deleteOnModel:(HubModel *)modelObj {
  return [HubCapabilityLegacy delete:modelObj ];
}

@end
