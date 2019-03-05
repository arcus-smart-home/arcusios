

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubZigbeeCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubZigbeePanid=@"hubzigbee:panid";

NSString *const kAttrHubZigbeeExtid=@"hubzigbee:extid";

NSString *const kAttrHubZigbeeChannel=@"hubzigbee:channel";

NSString *const kAttrHubZigbeePower=@"hubzigbee:power";

NSString *const kAttrHubZigbeePowermode=@"hubzigbee:powermode";

NSString *const kAttrHubZigbeeProfile=@"hubzigbee:profile";

NSString *const kAttrHubZigbeeSecurity=@"hubzigbee:security";

NSString *const kAttrHubZigbeeSupportednwks=@"hubzigbee:supportednwks";

NSString *const kAttrHubZigbeeJoining=@"hubzigbee:joining";

NSString *const kAttrHubZigbeeUpdateid=@"hubzigbee:updateid";

NSString *const kAttrHubZigbeeEui64=@"hubzigbee:eui64";

NSString *const kAttrHubZigbeeTceui64=@"hubzigbee:tceui64";

NSString *const kAttrHubZigbeeUptime=@"hubzigbee:uptime";

NSString *const kAttrHubZigbeeVersion=@"hubzigbee:version";

NSString *const kAttrHubZigbeeManufacturer=@"hubzigbee:manufacturer";

NSString *const kAttrHubZigbeeState=@"hubzigbee:state";

NSString *const kAttrHubZigbeePendingPairing=@"hubzigbee:pendingPairing";


NSString *const kCmdHubZigbeeReset=@"hubzigbee:Reset";

NSString *const kCmdHubZigbeeScan=@"hubzigbee:Scan";

NSString *const kCmdHubZigbeeGetConfig=@"hubzigbee:GetConfig";

NSString *const kCmdHubZigbeeGetStats=@"hubzigbee:GetStats";

NSString *const kCmdHubZigbeeGetNodeDesc=@"hubzigbee:GetNodeDesc";

NSString *const kCmdHubZigbeeGetActiveEp=@"hubzigbee:GetActiveEp";

NSString *const kCmdHubZigbeeGetSimpleDesc=@"hubzigbee:GetSimpleDesc";

NSString *const kCmdHubZigbeeGetPowerDesc=@"hubzigbee:GetPowerDesc";

NSString *const kCmdHubZigbeeIdentify=@"hubzigbee:Identify";

NSString *const kCmdHubZigbeeRemove=@"hubzigbee:Remove";

NSString *const kCmdHubZigbeeFactoryReset=@"hubzigbee:FactoryReset";

NSString *const kCmdHubZigbeeFormNetwork=@"hubzigbee:FormNetwork";

NSString *const kCmdHubZigbeeFixMigration=@"hubzigbee:FixMigration";

NSString *const kCmdHubZigbeeNetworkInformation=@"hubzigbee:NetworkInformation";

NSString *const kCmdHubZigbeePairingLinkKey=@"hubzigbee:PairingLinkKey";

NSString *const kCmdHubZigbeePairingInstallCode=@"hubzigbee:PairingInstallCode";


NSString *const kEnumHubZigbeePowermodeDEFAULT = @"DEFAULT";
NSString *const kEnumHubZigbeePowermodeBOOST = @"BOOST";
NSString *const kEnumHubZigbeePowermodeALTERNATE = @"ALTERNATE";
NSString *const kEnumHubZigbeePowermodeBOOST_AND_ALTERNATE = @"BOOST_AND_ALTERNATE";
NSString *const kEnumHubZigbeeStateUP = @"UP";
NSString *const kEnumHubZigbeeStateDOWN = @"DOWN";
NSString *const kEnumHubZigbeeStateJOIN_FAILED = @"JOIN_FAILED";
NSString *const kEnumHubZigbeeStateMOVE_FAILED = @"MOVE_FAILED";


@implementation HubZigbeeCapability
+ (NSString *)namespace { return @"hubzigbee"; }
+ (NSString *)name { return @"HubZigbee"; }

+ (int)getPanidFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getPanid:modelObj] intValue];
  
}


+ (long)getExtidFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getExtid:modelObj] longValue];
  
}


+ (int)getChannelFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getChannel:modelObj] intValue];
  
}


+ (int)getPowerFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getPower:modelObj] intValue];
  
}


+ (NSString *)getPowermodeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZigbeeCapabilityLegacy getPowermode:modelObj];
  
}


+ (int)getProfileFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getProfile:modelObj] intValue];
  
}


+ (int)getSecurityFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getSecurity:modelObj] intValue];
  
}


+ (int)getSupportednwksFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getSupportednwks:modelObj] intValue];
  
}


+ (BOOL)getJoiningFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getJoining:modelObj] boolValue];
  
}


+ (int)getUpdateidFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getUpdateid:modelObj] intValue];
  
}


+ (long)getEui64FromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getEui64:modelObj] longValue];
  
}


+ (long)getTceui64FromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getTceui64:modelObj] longValue];
  
}


+ (long)getUptimeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getUptime:modelObj] longValue];
  
}


+ (NSString *)getVersionFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZigbeeCapabilityLegacy getVersion:modelObj];
  
}


+ (int)getManufacturerFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubZigbeeCapabilityLegacy getManufacturer:modelObj] intValue];
  
}


+ (NSString *)getStateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZigbeeCapabilityLegacy getState:modelObj];
  
}


+ (NSArray *)getPendingPairingFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubZigbeeCapabilityLegacy getPendingPairing:modelObj];
  
}




+ (PMKPromise *) resetWithType:(NSString *)type onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy reset:modelObj type:type];

}


+ (PMKPromise *) scanOnModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy scan:modelObj ];
}


+ (PMKPromise *) getConfigOnModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy getConfig:modelObj ];
}


+ (PMKPromise *) getStatsOnModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy getStats:modelObj ];
}


+ (PMKPromise *) getNodeDescWithNwk:(int)nwk onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy getNodeDesc:modelObj nwk:nwk];

}


+ (PMKPromise *) getActiveEpWithNwk:(int)nwk onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy getActiveEp:modelObj nwk:nwk];

}


+ (PMKPromise *) getSimpleDescWithNwk:(int)nwk withEp:(int)ep onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy getSimpleDesc:modelObj nwk:nwk ep:ep];

}


+ (PMKPromise *) getPowerDescWithNwk:(int)nwk onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy getPowerDesc:modelObj nwk:nwk];

}


+ (PMKPromise *) identifyWithEui64:(long)eui64 withDuration:(int)duration onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy identify:modelObj eui64:eui64 duration:duration];

}


+ (PMKPromise *) removeWithEui64:(long)eui64 onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy remove:modelObj eui64:eui64];

}


+ (PMKPromise *) factoryResetOnModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy factoryReset:modelObj ];
}


+ (PMKPromise *) formNetworkWithEui64:(long)eui64 withPanId:(int)panId withExtPanId:(long)extPanId withChannel:(int)channel withNwkkey:(NSString *)nwkkey withNwkfc:(long)nwkfc withApsfc:(long)apsfc withUpdateid:(int)updateid onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy formNetwork:modelObj eui64:eui64 panId:panId extPanId:extPanId channel:channel nwkkey:nwkkey nwkfc:nwkfc apsfc:apsfc updateid:updateid];

}


+ (PMKPromise *) fixMigrationOnModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy fixMigration:modelObj ];
}


+ (PMKPromise *) networkInformationOnModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy networkInformation:modelObj ];
}


+ (PMKPromise *) pairingLinkKeyWithEuid:(NSString *)euid withLinkkey:(NSString *)linkkey withTimeout:(long)timeout onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy pairingLinkKey:modelObj euid:euid linkkey:linkkey timeout:timeout];

}


+ (PMKPromise *) pairingInstallCodeWithEuid:(NSString *)euid withInstallcode:(NSString *)installcode withTimeout:(long)timeout onModel:(HubModel *)modelObj {
  return [HubZigbeeCapabilityLegacy pairingInstallCode:modelObj euid:euid installcode:installcode timeout:timeout];

}

@end
