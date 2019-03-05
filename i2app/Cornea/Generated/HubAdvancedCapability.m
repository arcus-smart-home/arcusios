

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubAdvancedCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubAdvancedMac=@"hubadv:mac";

NSString *const kAttrHubAdvancedHardwarever=@"hubadv:hardwarever";

NSString *const kAttrHubAdvancedOsver=@"hubadv:osver";

NSString *const kAttrHubAdvancedAgentver=@"hubadv:agentver";

NSString *const kAttrHubAdvancedSerialNum=@"hubadv:serialNum";

NSString *const kAttrHubAdvancedMfgInfo=@"hubadv:mfgInfo";

NSString *const kAttrHubAdvancedBootloaderVer=@"hubadv:bootloaderVer";

NSString *const kAttrHubAdvancedFirmwareGroup=@"hubadv:firmwareGroup";

NSString *const kAttrHubAdvancedLastReset=@"hubadv:lastReset";

NSString *const kAttrHubAdvancedLastDeviceAddRemove=@"hubadv:lastDeviceAddRemove";

NSString *const kAttrHubAdvancedLastRestartReason=@"hubadv:lastRestartReason";

NSString *const kAttrHubAdvancedLastRestartTime=@"hubadv:lastRestartTime";

NSString *const kAttrHubAdvancedLastFailedWatchdogChecksTime=@"hubadv:lastFailedWatchdogChecksTime";

NSString *const kAttrHubAdvancedLastFailedWatchdogChecks=@"hubadv:lastFailedWatchdogChecks";

NSString *const kAttrHubAdvancedLastDbCheck=@"hubadv:lastDbCheck";

NSString *const kAttrHubAdvancedLastDbCheckResults=@"hubadv:lastDbCheckResults";

NSString *const kAttrHubAdvancedMigrationDualEui64=@"hubadv:migrationDualEui64";

NSString *const kAttrHubAdvancedMigrationDualEui64Fixed=@"hubadv:migrationDualEui64Fixed";

NSString *const kAttrHubAdvancedMfgBatchNumber=@"hubadv:mfgBatchNumber";

NSString *const kAttrHubAdvancedMfgDate=@"hubadv:mfgDate";

NSString *const kAttrHubAdvancedMfgFactoryID=@"hubadv:mfgFactoryID";

NSString *const kAttrHubAdvancedHwFlashSize=@"hubadv:hwFlashSize";


NSString *const kCmdHubAdvancedRestart=@"hubadv:Restart";

NSString *const kCmdHubAdvancedReboot=@"hubadv:Reboot";

NSString *const kCmdHubAdvancedFirmwareUpdate=@"hubadv:FirmwareUpdate";

NSString *const kCmdHubAdvancedFactoryReset=@"hubadv:FactoryReset";

NSString *const kCmdHubAdvancedGetKnownDevices=@"hubadv:GetKnownDevices";

NSString *const kCmdHubAdvancedGetDeviceInfo=@"hubadv:GetDeviceInfo";


NSString *const kEvtHubAdvancedFirmwareUpgradeProcess=@"hubadv:FirmwareUpgradeProcess";

NSString *const kEvtHubAdvancedDeregister=@"hubadv:Deregister";

NSString *const kEvtHubAdvancedStartUploadingCameraPreviews=@"hubadv:StartUploadingCameraPreviews";

NSString *const kEvtHubAdvancedStopUploadingCameraPreviews=@"hubadv:StopUploadingCameraPreviews";

NSString *const kEvtHubAdvancedUnpairedDeviceRemoved=@"hubadv:UnpairedDeviceRemoved";

NSString *const kEvtHubAdvancedAttention=@"hubadv:Attention";

NSString *const kEnumHubAdvancedLastRestartReasonUNKNOWN = @"UNKNOWN";
NSString *const kEnumHubAdvancedLastRestartReasonFIRMWARE_UPDATE = @"FIRMWARE_UPDATE";
NSString *const kEnumHubAdvancedLastRestartReasonREQUESTED = @"REQUESTED";
NSString *const kEnumHubAdvancedLastRestartReasonSOFT_RESET = @"SOFT_RESET";
NSString *const kEnumHubAdvancedLastRestartReasonFACTORY_RESET = @"FACTORY_RESET";
NSString *const kEnumHubAdvancedLastRestartReasonGATEWAY_FAILURE = @"GATEWAY_FAILURE";
NSString *const kEnumHubAdvancedLastRestartReasonMIGRATION = @"MIGRATION";
NSString *const kEnumHubAdvancedLastRestartReasonBACKUP_RESTORE = @"BACKUP_RESTORE";
NSString *const kEnumHubAdvancedLastRestartReasonWATCHDOG = @"WATCHDOG";


@implementation HubAdvancedCapability
+ (NSString *)namespace { return @"hubadv"; }
+ (NSString *)name { return @"HubAdvanced"; }

+ (NSString *)getMacFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getMac:modelObj];
  
}


+ (NSString *)getHardwareverFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getHardwarever:modelObj];
  
}


+ (NSString *)getOsverFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getOsver:modelObj];
  
}


+ (NSString *)getAgentverFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getAgentver:modelObj];
  
}


+ (NSString *)getSerialNumFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getSerialNum:modelObj];
  
}


+ (NSString *)getMfgInfoFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getMfgInfo:modelObj];
  
}


+ (NSString *)getBootloaderVerFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getBootloaderVer:modelObj];
  
}


+ (NSString *)getFirmwareGroupFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getFirmwareGroup:modelObj];
  
}


+ (NSString *)getLastResetFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getLastReset:modelObj];
  
}


+ (NSString *)getLastDeviceAddRemoveFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getLastDeviceAddRemove:modelObj];
  
}


+ (NSString *)getLastRestartReasonFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getLastRestartReason:modelObj];
  
}


+ (NSDate *)getLastRestartTimeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getLastRestartTime:modelObj];
  
}


+ (NSDate *)getLastFailedWatchdogChecksTimeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getLastFailedWatchdogChecksTime:modelObj];
  
}


+ (NSArray *)getLastFailedWatchdogChecksFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getLastFailedWatchdogChecks:modelObj];
  
}


+ (NSDate *)getLastDbCheckFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getLastDbCheck:modelObj];
  
}


+ (NSString *)getLastDbCheckResultsFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getLastDbCheckResults:modelObj];
  
}


+ (BOOL)getMigrationDualEui64FromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAdvancedCapabilityLegacy getMigrationDualEui64:modelObj] boolValue];
  
}


+ (BOOL)getMigrationDualEui64FixedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAdvancedCapabilityLegacy getMigrationDualEui64Fixed:modelObj] boolValue];
  
}


+ (NSString *)getMfgBatchNumberFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getMfgBatchNumber:modelObj];
  
}


+ (NSDate *)getMfgDateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAdvancedCapabilityLegacy getMfgDate:modelObj];
  
}


+ (int)getMfgFactoryIDFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAdvancedCapabilityLegacy getMfgFactoryID:modelObj] intValue];
  
}


+ (long)getHwFlashSizeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAdvancedCapabilityLegacy getHwFlashSize:modelObj] longValue];
  
}




+ (PMKPromise *) restartOnModel:(HubModel *)modelObj {
  return [HubAdvancedCapabilityLegacy restart:modelObj ];
}


+ (PMKPromise *) rebootOnModel:(HubModel *)modelObj {
  return [HubAdvancedCapabilityLegacy reboot:modelObj ];
}


+ (PMKPromise *) firmwareUpdateWithUrl:(NSString *)url withPriority:(NSString *)priority withType:(NSString *)type withShowLed:(BOOL)showLed onModel:(HubModel *)modelObj {
  return [HubAdvancedCapabilityLegacy firmwareUpdate:modelObj url:url priority:priority type:type showLed:showLed];

}


+ (PMKPromise *) factoryResetOnModel:(HubModel *)modelObj {
  return [HubAdvancedCapabilityLegacy factoryReset:modelObj ];
}


+ (PMKPromise *) getKnownDevicesWithProtocols:(NSArray *)protocols onModel:(HubModel *)modelObj {
  return [HubAdvancedCapabilityLegacy getKnownDevices:modelObj protocols:protocols];

}


+ (PMKPromise *) getDeviceInfoWithProtocolAddress:(NSString *)protocolAddress onModel:(HubModel *)modelObj {
  return [HubAdvancedCapabilityLegacy getDeviceInfo:modelObj protocolAddress:protocolAddress];

}

@end
