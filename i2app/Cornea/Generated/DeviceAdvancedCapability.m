

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DeviceAdvancedCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDeviceAdvancedDrivername=@"devadv:drivername";

NSString *const kAttrDeviceAdvancedDriverversion=@"devadv:driverversion";

NSString *const kAttrDeviceAdvancedDrivercommit=@"devadv:drivercommit";

NSString *const kAttrDeviceAdvancedDriverhash=@"devadv:driverhash";

NSString *const kAttrDeviceAdvancedDriverstate=@"devadv:driverstate";

NSString *const kAttrDeviceAdvancedProtocol=@"devadv:protocol";

NSString *const kAttrDeviceAdvancedSubprotocol=@"devadv:subprotocol";

NSString *const kAttrDeviceAdvancedProtocolid=@"devadv:protocolid";

NSString *const kAttrDeviceAdvancedErrors=@"devadv:errors";

NSString *const kAttrDeviceAdvancedAdded=@"devadv:added";

NSString *const kAttrDeviceAdvancedFirmwareVersion=@"devadv:firmwareVersion";

NSString *const kAttrDeviceAdvancedHubLocal=@"devadv:hubLocal";

NSString *const kAttrDeviceAdvancedDegraded=@"devadv:degraded";

NSString *const kAttrDeviceAdvancedDegradedCode=@"devadv:degradedCode";


NSString *const kCmdDeviceAdvancedUpgradeDriver=@"devadv:UpgradeDriver";

NSString *const kCmdDeviceAdvancedGetReflexes=@"devadv:GetReflexes";

NSString *const kCmdDeviceAdvancedReconfigure=@"devadv:Reconfigure";


NSString *const kEvtDeviceAdvancedRemovedDevice=@"devadv:RemovedDevice";

NSString *const kEnumDeviceAdvancedDriverstateCREATED = @"CREATED";
NSString *const kEnumDeviceAdvancedDriverstatePROVISIONING = @"PROVISIONING";
NSString *const kEnumDeviceAdvancedDriverstateACTIVE = @"ACTIVE";
NSString *const kEnumDeviceAdvancedDriverstateUNSUPPORTED = @"UNSUPPORTED";
NSString *const kEnumDeviceAdvancedDriverstateRECOVERABLE = @"RECOVERABLE";
NSString *const kEnumDeviceAdvancedDriverstateUNRECOVERABLE = @"UNRECOVERABLE";
NSString *const kEnumDeviceAdvancedDriverstateTOMBSTONED = @"TOMBSTONED";


@implementation DeviceAdvancedCapability
+ (NSString *)namespace { return @"devadv"; }
+ (NSString *)name { return @"DeviceAdvanced"; }

+ (NSString *)getDrivernameFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getDrivername:modelObj];
  
}


+ (NSString *)getDriverversionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getDriverversion:modelObj];
  
}


+ (NSString *)getDrivercommitFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getDrivercommit:modelObj];
  
}


+ (NSString *)getDriverhashFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getDriverhash:modelObj];
  
}


+ (NSString *)getDriverstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getDriverstate:modelObj];
  
}


+ (NSString *)getProtocolFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getProtocol:modelObj];
  
}


+ (NSString *)getSubprotocolFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getSubprotocol:modelObj];
  
}


+ (NSString *)getProtocolidFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getProtocolid:modelObj];
  
}


+ (NSDictionary *)getErrorsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getErrors:modelObj];
  
}


+ (NSDate *)getAddedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getAdded:modelObj];
  
}


+ (NSString *)getFirmwareVersionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getFirmwareVersion:modelObj];
  
}


+ (BOOL)getHubLocalFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DeviceAdvancedCapabilityLegacy getHubLocal:modelObj] boolValue];
  
}


+ (BOOL)getDegradedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DeviceAdvancedCapabilityLegacy getDegraded:modelObj] boolValue];
  
}


+ (NSString *)getDegradedCodeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceAdvancedCapabilityLegacy getDegradedCode:modelObj];
  
}

+ (NSString *)setDegradedCode:(NSString *)degradedCode onModel:(DeviceModel *)modelObj {
  [DeviceAdvancedCapabilityLegacy setDegradedCode:degradedCode model:modelObj];
  
  return [DeviceAdvancedCapabilityLegacy getDegradedCode:modelObj];
  
}




+ (PMKPromise *) upgradeDriverWithDriverName:(NSString *)driverName withDriverVersion:(NSString *)driverVersion onModel:(DeviceModel *)modelObj {
  return [DeviceAdvancedCapabilityLegacy upgradeDriver:modelObj driverName:driverName driverVersion:driverVersion];

}


+ (PMKPromise *) getReflexesOnModel:(DeviceModel *)modelObj {
  return [DeviceAdvancedCapabilityLegacy getReflexes:modelObj ];
}


+ (PMKPromise *) reconfigureOnModel:(DeviceModel *)modelObj {
  return [DeviceAdvancedCapabilityLegacy reconfigure:modelObj ];
}

@end
