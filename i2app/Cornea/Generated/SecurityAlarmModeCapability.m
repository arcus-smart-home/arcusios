

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SecurityAlarmModeCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSecurityAlarmModeDevices=@"subsecuritymode:devices";

NSString *const kAttrSecurityAlarmModeEntranceDelaySec=@"subsecuritymode:entranceDelaySec";

NSString *const kAttrSecurityAlarmModeExitDelaySec=@"subsecuritymode:exitDelaySec";

NSString *const kAttrSecurityAlarmModeAlarmSensitivityDeviceCount=@"subsecuritymode:alarmSensitivityDeviceCount";

NSString *const kAttrSecurityAlarmModeSilent=@"subsecuritymode:silent";

NSString *const kAttrSecurityAlarmModeSoundsEnabled=@"subsecuritymode:soundsEnabled";

NSString *const kAttrSecurityAlarmModeMotionSensorCount=@"subsecuritymode:motionSensorCount";





@implementation SecurityAlarmModeCapability
+ (NSString *)namespace { return @"subsecuritymode"; }
+ (NSString *)name { return @"SecurityAlarmMode"; }

+ (NSArray *)getDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecurityAlarmModeCapabilityLegacy getDevices:modelObj];
  
}

+ (NSArray *)setDevices:(NSArray *)devices onModel:(SubsystemModel *)modelObj {
  [SecurityAlarmModeCapabilityLegacy setDevices:devices model:modelObj];
  
  return [SecurityAlarmModeCapabilityLegacy getDevices:modelObj];
  
}


+ (int)getEntranceDelaySecFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SecurityAlarmModeCapabilityLegacy getEntranceDelaySec:modelObj] intValue];
  
}

+ (int)setEntranceDelaySec:(int)entranceDelaySec onModel:(SubsystemModel *)modelObj {
  [SecurityAlarmModeCapabilityLegacy setEntranceDelaySec:entranceDelaySec model:modelObj];
  
  return [[SecurityAlarmModeCapabilityLegacy getEntranceDelaySec:modelObj] intValue];
  
}


+ (int)getExitDelaySecFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SecurityAlarmModeCapabilityLegacy getExitDelaySec:modelObj] intValue];
  
}

+ (int)setExitDelaySec:(int)exitDelaySec onModel:(SubsystemModel *)modelObj {
  [SecurityAlarmModeCapabilityLegacy setExitDelaySec:exitDelaySec model:modelObj];
  
  return [[SecurityAlarmModeCapabilityLegacy getExitDelaySec:modelObj] intValue];
  
}


+ (int)getAlarmSensitivityDeviceCountFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SecurityAlarmModeCapabilityLegacy getAlarmSensitivityDeviceCount:modelObj] intValue];
  
}

+ (int)setAlarmSensitivityDeviceCount:(int)alarmSensitivityDeviceCount onModel:(SubsystemModel *)modelObj {
  [SecurityAlarmModeCapabilityLegacy setAlarmSensitivityDeviceCount:alarmSensitivityDeviceCount model:modelObj];
  
  return [[SecurityAlarmModeCapabilityLegacy getAlarmSensitivityDeviceCount:modelObj] intValue];
  
}


+ (BOOL)getSilentFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SecurityAlarmModeCapabilityLegacy getSilent:modelObj] boolValue];
  
}

+ (BOOL)setSilent:(BOOL)silent onModel:(SubsystemModel *)modelObj {
  [SecurityAlarmModeCapabilityLegacy setSilent:silent model:modelObj];
  
  return [[SecurityAlarmModeCapabilityLegacy getSilent:modelObj] boolValue];
  
}


+ (BOOL)getSoundsEnabledFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SecurityAlarmModeCapabilityLegacy getSoundsEnabled:modelObj] boolValue];
  
}

+ (BOOL)setSoundsEnabled:(BOOL)soundsEnabled onModel:(SubsystemModel *)modelObj {
  [SecurityAlarmModeCapabilityLegacy setSoundsEnabled:soundsEnabled model:modelObj];
  
  return [[SecurityAlarmModeCapabilityLegacy getSoundsEnabled:modelObj] boolValue];
  
}


+ (int)getMotionSensorCountFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SecurityAlarmModeCapabilityLegacy getMotionSensorCount:modelObj] intValue];
  
}

+ (int)setMotionSensorCount:(int)motionSensorCount onModel:(SubsystemModel *)modelObj {
  [SecurityAlarmModeCapabilityLegacy setMotionSensorCount:motionSensorCount model:modelObj];
  
  return [[SecurityAlarmModeCapabilityLegacy getMotionSensorCount:modelObj] intValue];
  
}



@end
