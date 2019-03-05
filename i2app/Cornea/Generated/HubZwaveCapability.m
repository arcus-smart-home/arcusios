

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubZwaveCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubZwaveHardware=@"hubzwave:hardware";

NSString *const kAttrHubZwaveFirmware=@"hubzwave:firmware";

NSString *const kAttrHubZwaveProtocol=@"hubzwave:protocol";

NSString *const kAttrHubZwaveHomeId=@"hubzwave:homeId";

NSString *const kAttrHubZwaveNumDevices=@"hubzwave:numDevices";

NSString *const kAttrHubZwaveIsSecondary=@"hubzwave:isSecondary";

NSString *const kAttrHubZwaveIsOnOtherNetwork=@"hubzwave:isOnOtherNetwork";

NSString *const kAttrHubZwaveIsSUC=@"hubzwave:isSUC";

NSString *const kAttrHubZwaveState=@"hubzwave:state";

NSString *const kAttrHubZwaveUptime=@"hubzwave:uptime";

NSString *const kAttrHubZwaveHealInProgress=@"hubzwave:healInProgress";

NSString *const kAttrHubZwaveHealLastStart=@"hubzwave:healLastStart";

NSString *const kAttrHubZwaveHealLastFinish=@"hubzwave:healLastFinish";

NSString *const kAttrHubZwaveHealFinishReason=@"hubzwave:healFinishReason";

NSString *const kAttrHubZwaveHealTotal=@"hubzwave:healTotal";

NSString *const kAttrHubZwaveHealCompleted=@"hubzwave:healCompleted";

NSString *const kAttrHubZwaveHealSuccessful=@"hubzwave:healSuccessful";

NSString *const kAttrHubZwaveHealBlockingControl=@"hubzwave:healBlockingControl";

NSString *const kAttrHubZwaveHealEstimatedFinish=@"hubzwave:healEstimatedFinish";

NSString *const kAttrHubZwaveHealPercent=@"hubzwave:healPercent";

NSString *const kAttrHubZwaveHealNextScheduled=@"hubzwave:healNextScheduled";

NSString *const kAttrHubZwaveHealRecommended=@"hubzwave:healRecommended";


NSString *const kCmdHubZwaveFactoryReset=@"hubzwave:FactoryReset";

NSString *const kCmdHubZwaveReset=@"hubzwave:Reset";

NSString *const kCmdHubZwaveForcePrimary=@"hubzwave:ForcePrimary";

NSString *const kCmdHubZwaveForceSecondary=@"hubzwave:ForceSecondary";

NSString *const kCmdHubZwaveNetworkInformation=@"hubzwave:NetworkInformation";

NSString *const kCmdHubZwaveHeal=@"hubzwave:Heal";

NSString *const kCmdHubZwaveCancelHeal=@"hubzwave:CancelHeal";

NSString *const kCmdHubZwaveRemoveZombie=@"hubzwave:RemoveZombie";

NSString *const kCmdHubZwaveAssociate=@"hubzwave:Associate";

NSString *const kCmdHubZwaveAssignReturnRoutes=@"hubzwave:AssignReturnRoutes";


NSString *const kEvtHubZwaveHealComplete=@"hubzwave:HealComplete";

NSString *const kEnumHubZwaveStateINIT = @"INIT";
NSString *const kEnumHubZwaveStateNORMAL = @"NORMAL";
NSString *const kEnumHubZwaveStatePAIRING = @"PAIRING";
NSString *const kEnumHubZwaveStateUNPAIRING = @"UNPAIRING";
NSString *const kEnumHubZwaveHealFinishReasonSUCCESS = @"SUCCESS";
NSString *const kEnumHubZwaveHealFinishReasonCANCEL = @"CANCEL";
NSString *const kEnumHubZwaveHealFinishReasonTERMINATED = @"TERMINATED";


@implementation HubZwaveCapability
+ (NSString *)namespace { return @"hubzwave"; }
+ (NSString *)name { return @"HubZwave"; }

+ (NSString *)getHardwareFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getHardware:modelObj];
  
}


+ (NSString *)getFirmwareFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getFirmware:modelObj];
  
}


+ (NSString *)getProtocolFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getProtocol:modelObj];
  
}


+ (NSString *)getHomeIdFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getHomeId:modelObj];
  
}


+ (int)getNumDevicesFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getNumDevices:modelObj] intValue];
  
}


+ (BOOL)getIsSecondaryFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getIsSecondary:modelObj] boolValue];
  
}


+ (BOOL)getIsOnOtherNetworkFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getIsOnOtherNetwork:modelObj] boolValue];
  
}


+ (BOOL)getIsSUCFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getIsSUC:modelObj] boolValue];
  
}


+ (NSString *)getStateFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getState:modelObj];
  
}


+ (long)getUptimeFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getUptime:modelObj] longValue];
  
}


+ (BOOL)getHealInProgressFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getHealInProgress:modelObj] boolValue];
  
}


+ (NSDate *)getHealLastStartFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getHealLastStart:modelObj];
  
}


+ (NSDate *)getHealLastFinishFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getHealLastFinish:modelObj];
  
}


+ (NSString *)getHealFinishReasonFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getHealFinishReason:modelObj];
  
}


+ (int)getHealTotalFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getHealTotal:modelObj] intValue];
  
}


+ (int)getHealCompletedFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getHealCompleted:modelObj] intValue];
  
}


+ (int)getHealSuccessfulFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getHealSuccessful:modelObj] intValue];
  
}


+ (BOOL)getHealBlockingControlFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getHealBlockingControl:modelObj] boolValue];
  
}


+ (NSDate *)getHealEstimatedFinishFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getHealEstimatedFinish:modelObj];
  
}


+ (double)getHealPercentFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getHealPercent:modelObj] doubleValue];
  
}


+ (NSDate *)getHealNextScheduledFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZwaveCapabilityLegacy getHealNextScheduled:modelObj];
  
}


+ (BOOL)getHealRecommendedFromModel:(HubZwaveModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZwaveCapabilityLegacy getHealRecommended:modelObj] boolValue];
  
}

+ (BOOL)setHealRecommended:(BOOL)healRecommended onModel:(HubZwaveModel *)modelObj {
  [HubZwaveCapabilityLegacy setHealRecommended:healRecommended model:modelObj];
  
  return [[HubZwaveCapabilityLegacy getHealRecommended:modelObj] boolValue];
  
}




+ (PMKPromise *) factoryResetOnModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy factoryReset:modelObj ];
}


+ (PMKPromise *) resetWithType:(NSString *)type onModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy reset:modelObj type:type];

}


+ (PMKPromise *) forcePrimaryOnModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy forcePrimary:modelObj ];
}


+ (PMKPromise *) forceSecondaryOnModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy forceSecondary:modelObj ];
}


+ (PMKPromise *) networkInformationOnModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy networkInformation:modelObj ];
}


+ (PMKPromise *) healWithBlock:(BOOL)block withTime:(double)time onModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy heal:modelObj block:block time:time];

}


+ (PMKPromise *) cancelHealOnModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy cancelHeal:modelObj ];
}


+ (PMKPromise *) removeZombieWithNode:(int)node onModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy removeZombie:modelObj node:node];

}


+ (PMKPromise *) associateWithNode:(int)node withGroups:(NSArray *)groups onModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy associate:modelObj node:node groups:groups];

}


+ (PMKPromise *) assignReturnRoutesWithNode:(int)node onModel:(HubZwaveModel *)modelObj {
  return [HubZwaveCapabilityLegacy assignReturnRoutes:modelObj node:node];

}

@end
