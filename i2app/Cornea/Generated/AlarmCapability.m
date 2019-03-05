

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AlarmCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrAlarmAlertState=@"alarm:alertState";

NSString *const kAttrAlarmDevices=@"alarm:devices";

NSString *const kAttrAlarmExcludedDevices=@"alarm:excludedDevices";

NSString *const kAttrAlarmActiveDevices=@"alarm:activeDevices";

NSString *const kAttrAlarmOfflineDevices=@"alarm:offlineDevices";

NSString *const kAttrAlarmTriggeredDevices=@"alarm:triggeredDevices";

NSString *const kAttrAlarmTriggers=@"alarm:triggers";

NSString *const kAttrAlarmMonitored=@"alarm:monitored";

NSString *const kAttrAlarmSilent=@"alarm:silent";



NSString *const kEnumAlarmAlertStateINACTIVE = @"INACTIVE";
NSString *const kEnumAlarmAlertStateDISARMED = @"DISARMED";
NSString *const kEnumAlarmAlertStateARMING = @"ARMING";
NSString *const kEnumAlarmAlertStateREADY = @"READY";
NSString *const kEnumAlarmAlertStatePREALERT = @"PREALERT";
NSString *const kEnumAlarmAlertStateALERT = @"ALERT";
NSString *const kEnumAlarmAlertStateCLEARING = @"CLEARING";


@implementation AlarmCapability
+ (NSString *)namespace { return @"alarm"; }
+ (NSString *)name { return @"Alarm"; }

+ (NSString *)getAlertStateFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmCapabilityLegacy getAlertState:modelObj];
  
}


+ (NSArray *)getDevicesFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmCapabilityLegacy getDevices:modelObj];
  
}


+ (NSArray *)getExcludedDevicesFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmCapabilityLegacy getExcludedDevices:modelObj];
  
}


+ (NSArray *)getActiveDevicesFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmCapabilityLegacy getActiveDevices:modelObj];
  
}


+ (NSArray *)getOfflineDevicesFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmCapabilityLegacy getOfflineDevices:modelObj];
  
}


+ (NSArray *)getTriggeredDevicesFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmCapabilityLegacy getTriggeredDevices:modelObj];
  
}


+ (NSArray *)getTriggersFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmCapabilityLegacy getTriggers:modelObj];
  
}


+ (BOOL)getMonitoredFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmCapabilityLegacy getMonitored:modelObj] boolValue];
  
}


+ (BOOL)getSilentFromModel:(AlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmCapabilityLegacy getSilent:modelObj] boolValue];
  
}

+ (BOOL)setSilent:(BOOL)silent onModel:(AlarmModel *)modelObj {
  [AlarmCapabilityLegacy setSilent:silent model:modelObj];
  
  return [[AlarmCapabilityLegacy getSilent:modelObj] boolValue];
  
}



@end
