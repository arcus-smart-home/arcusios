

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SafetySubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSafetySubsystemTotalDevices=@"subsafety:totalDevices";

NSString *const kAttrSafetySubsystemActiveDevices=@"subsafety:activeDevices";

NSString *const kAttrSafetySubsystemIgnoredDevices=@"subsafety:ignoredDevices";

NSString *const kAttrSafetySubsystemWaterShutoffValves=@"subsafety:waterShutoffValves";

NSString *const kAttrSafetySubsystemAlarm=@"subsafety:alarm";

NSString *const kAttrSafetySubsystemTriggers=@"subsafety:triggers";

NSString *const kAttrSafetySubsystemPendingClear=@"subsafety:pendingClear";

NSString *const kAttrSafetySubsystemWarnings=@"subsafety:warnings";

NSString *const kAttrSafetySubsystemCallTreeEnabled=@"subsafety:callTreeEnabled";

NSString *const kAttrSafetySubsystemCallTree=@"subsafety:callTree";

NSString *const kAttrSafetySubsystemSensorState=@"subsafety:sensorState";

NSString *const kAttrSafetySubsystemLastAlertTime=@"subsafety:lastAlertTime";

NSString *const kAttrSafetySubsystemLastAlertCause=@"subsafety:lastAlertCause";

NSString *const kAttrSafetySubsystemLastClearTime=@"subsafety:lastClearTime";

NSString *const kAttrSafetySubsystemLastClearedBy=@"subsafety:lastClearedBy";

NSString *const kAttrSafetySubsystemAlarmSensitivitySec=@"subsafety:alarmSensitivitySec";

NSString *const kAttrSafetySubsystemAlarmSensitivityDeviceCount=@"subsafety:alarmSensitivityDeviceCount";

NSString *const kAttrSafetySubsystemQuietPeriodSec=@"subsafety:quietPeriodSec";

NSString *const kAttrSafetySubsystemSilentAlarm=@"subsafety:silentAlarm";

NSString *const kAttrSafetySubsystemWaterShutOff=@"subsafety:waterShutOff";

NSString *const kAttrSafetySubsystemSmokePreAlertDevices=@"subsafety:smokePreAlertDevices";

NSString *const kAttrSafetySubsystemSmokePreAlert=@"subsafety:smokePreAlert";

NSString *const kAttrSafetySubsystemLastSmokePreAlertTime=@"subsafety:lastSmokePreAlertTime";


NSString *const kCmdSafetySubsystemTrigger=@"subsafety:Trigger";

NSString *const kCmdSafetySubsystemClear=@"subsafety:Clear";


NSString *const kEnumSafetySubsystemAlarmREADY = @"READY";
NSString *const kEnumSafetySubsystemAlarmWARN = @"WARN";
NSString *const kEnumSafetySubsystemAlarmSOAKING = @"SOAKING";
NSString *const kEnumSafetySubsystemAlarmALERT = @"ALERT";
NSString *const kEnumSafetySubsystemAlarmCLEARING = @"CLEARING";
NSString *const kEnumSafetySubsystemSmokePreAlertREADY = @"READY";
NSString *const kEnumSafetySubsystemSmokePreAlertALERT = @"ALERT";


@implementation SafetySubsystemCapability
+ (NSString *)namespace { return @"subsafety"; }
+ (NSString *)name { return @"SafetySubsystem"; }

+ (NSArray *)getTotalDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getTotalDevices:modelObj];
  
}


+ (NSArray *)getActiveDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getActiveDevices:modelObj];
  
}


+ (NSArray *)getIgnoredDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getIgnoredDevices:modelObj];
  
}

+ (NSArray *)setIgnoredDevices:(NSArray *)ignoredDevices onModel:(SubsystemModel *)modelObj {
  [SafetySubsystemCapabilityLegacy setIgnoredDevices:ignoredDevices model:modelObj];
  
  return [SafetySubsystemCapabilityLegacy getIgnoredDevices:modelObj];
  
}


+ (NSArray *)getWaterShutoffValvesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getWaterShutoffValves:modelObj];
  
}


+ (NSString *)getAlarmFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getAlarm:modelObj];
  
}


+ (NSArray *)getTriggersFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getTriggers:modelObj];
  
}


+ (NSArray *)getPendingClearFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getPendingClear:modelObj];
  
}


+ (NSDictionary *)getWarningsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getWarnings:modelObj];
  
}


+ (BOOL)getCallTreeEnabledFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SafetySubsystemCapabilityLegacy getCallTreeEnabled:modelObj] boolValue];
  
}


+ (NSArray *)getCallTreeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getCallTree:modelObj];
  
}

+ (NSArray *)setCallTree:(NSArray *)callTree onModel:(SubsystemModel *)modelObj {
  [SafetySubsystemCapabilityLegacy setCallTree:callTree model:modelObj];
  
  return [SafetySubsystemCapabilityLegacy getCallTree:modelObj];
  
}


+ (NSDictionary *)getSensorStateFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getSensorState:modelObj];
  
}


+ (NSDate *)getLastAlertTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getLastAlertTime:modelObj];
  
}


+ (NSString *)getLastAlertCauseFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getLastAlertCause:modelObj];
  
}


+ (NSDate *)getLastClearTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getLastClearTime:modelObj];
  
}


+ (NSString *)getLastClearedByFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getLastClearedBy:modelObj];
  
}


+ (int)getAlarmSensitivitySecFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SafetySubsystemCapabilityLegacy getAlarmSensitivitySec:modelObj] intValue];
  
}


+ (int)getAlarmSensitivityDeviceCountFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SafetySubsystemCapabilityLegacy getAlarmSensitivityDeviceCount:modelObj] intValue];
  
}

+ (int)setAlarmSensitivityDeviceCount:(int)alarmSensitivityDeviceCount onModel:(SubsystemModel *)modelObj {
  [SafetySubsystemCapabilityLegacy setAlarmSensitivityDeviceCount:alarmSensitivityDeviceCount model:modelObj];
  
  return [[SafetySubsystemCapabilityLegacy getAlarmSensitivityDeviceCount:modelObj] intValue];
  
}


+ (int)getQuietPeriodSecFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SafetySubsystemCapabilityLegacy getQuietPeriodSec:modelObj] intValue];
  
}

+ (int)setQuietPeriodSec:(int)quietPeriodSec onModel:(SubsystemModel *)modelObj {
  [SafetySubsystemCapabilityLegacy setQuietPeriodSec:quietPeriodSec model:modelObj];
  
  return [[SafetySubsystemCapabilityLegacy getQuietPeriodSec:modelObj] intValue];
  
}


+ (BOOL)getSilentAlarmFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SafetySubsystemCapabilityLegacy getSilentAlarm:modelObj] boolValue];
  
}

+ (BOOL)setSilentAlarm:(BOOL)silentAlarm onModel:(SubsystemModel *)modelObj {
  [SafetySubsystemCapabilityLegacy setSilentAlarm:silentAlarm model:modelObj];
  
  return [[SafetySubsystemCapabilityLegacy getSilentAlarm:modelObj] boolValue];
  
}


+ (BOOL)getWaterShutOffFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SafetySubsystemCapabilityLegacy getWaterShutOff:modelObj] boolValue];
  
}

+ (BOOL)setWaterShutOff:(BOOL)waterShutOff onModel:(SubsystemModel *)modelObj {
  [SafetySubsystemCapabilityLegacy setWaterShutOff:waterShutOff model:modelObj];
  
  return [[SafetySubsystemCapabilityLegacy getWaterShutOff:modelObj] boolValue];
  
}


+ (NSArray *)getSmokePreAlertDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getSmokePreAlertDevices:modelObj];
  
}


+ (NSString *)getSmokePreAlertFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getSmokePreAlert:modelObj];
  
}


+ (NSDate *)getLastSmokePreAlertTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SafetySubsystemCapabilityLegacy getLastSmokePreAlertTime:modelObj];
  
}




+ (PMKPromise *) triggerWithCause:(NSString *)cause onModel:(SubsystemModel *)modelObj {
  return [SafetySubsystemCapabilityLegacy trigger:modelObj cause:cause];

}


+ (PMKPromise *) clearOnModel:(SubsystemModel *)modelObj {
  return [SafetySubsystemCapabilityLegacy clear:modelObj ];
}

@end
