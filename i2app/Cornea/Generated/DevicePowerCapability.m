

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DevicePowerCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDevicePowerSource=@"devpow:source";

NSString *const kAttrDevicePowerLinecapable=@"devpow:linecapable";

NSString *const kAttrDevicePowerBackupbatterycapable=@"devpow:backupbatterycapable";

NSString *const kAttrDevicePowerBattery=@"devpow:battery";

NSString *const kAttrDevicePowerBackupbattery=@"devpow:backupbattery";

NSString *const kAttrDevicePowerSourcechanged=@"devpow:sourcechanged";

NSString *const kAttrDevicePowerRechargeable=@"devpow:rechargeable";



NSString *const kEvtDevicePowerBackupBattery=@"devpow:BackupBattery";

NSString *const kEvtDevicePowerLinePowerRestored=@"devpow:LinePowerRestored";

NSString *const kEvtDevicePowerBatteryLow=@"devpow:BatteryLow";

NSString *const kEnumDevicePowerSourceLINE = @"LINE";
NSString *const kEnumDevicePowerSourceBATTERY = @"BATTERY";
NSString *const kEnumDevicePowerSourceBACKUPBATTERY = @"BACKUPBATTERY";


@implementation DevicePowerCapability
+ (NSString *)namespace { return @"devpow"; }
+ (NSString *)name { return @"DevicePower"; }

+ (NSString *)getSourceFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DevicePowerCapabilityLegacy getSource:modelObj];
  
}


+ (BOOL)getLinecapableFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DevicePowerCapabilityLegacy getLinecapable:modelObj] boolValue];
  
}


+ (BOOL)getBackupbatterycapableFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DevicePowerCapabilityLegacy getBackupbatterycapable:modelObj] boolValue];
  
}


+ (int)getBatteryFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DevicePowerCapabilityLegacy getBattery:modelObj] intValue];
  
}


+ (int)getBackupbatteryFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DevicePowerCapabilityLegacy getBackupbattery:modelObj] intValue];
  
}


+ (NSDate *)getSourcechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DevicePowerCapabilityLegacy getSourcechanged:modelObj];
  
}


+ (BOOL)getRechargeableFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DevicePowerCapabilityLegacy getRechargeable:modelObj] boolValue];
  
}



@end
