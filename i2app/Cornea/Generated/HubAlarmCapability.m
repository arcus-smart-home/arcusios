

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubAlarmCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubAlarmState=@"hubalarm:state";

NSString *const kAttrHubAlarmAlarmState=@"hubalarm:alarmState";

NSString *const kAttrHubAlarmSecurityMode=@"hubalarm:securityMode";

NSString *const kAttrHubAlarmSecurityArmTime=@"hubalarm:securityArmTime";

NSString *const kAttrHubAlarmLastArmedTime=@"hubalarm:lastArmedTime";

NSString *const kAttrHubAlarmLastArmedBy=@"hubalarm:lastArmedBy";

NSString *const kAttrHubAlarmLastArmedFrom=@"hubalarm:lastArmedFrom";

NSString *const kAttrHubAlarmLastDisarmedTime=@"hubalarm:lastDisarmedTime";

NSString *const kAttrHubAlarmLastDisarmedBy=@"hubalarm:lastDisarmedBy";

NSString *const kAttrHubAlarmLastDisarmedFrom=@"hubalarm:lastDisarmedFrom";

NSString *const kAttrHubAlarmActiveAlerts=@"hubalarm:activeAlerts";

NSString *const kAttrHubAlarmAvailableAlerts=@"hubalarm:availableAlerts";

NSString *const kAttrHubAlarmCurrentIncident=@"hubalarm:currentIncident";

NSString *const kAttrHubAlarmReconnectReport=@"hubalarm:reconnectReport";

NSString *const kAttrHubAlarmSecurityAlertState=@"hubalarm:securityAlertState";

NSString *const kAttrHubAlarmSecurityDevices=@"hubalarm:securityDevices";

NSString *const kAttrHubAlarmSecurityExcludedDevices=@"hubalarm:securityExcludedDevices";

NSString *const kAttrHubAlarmSecurityActiveDevices=@"hubalarm:securityActiveDevices";

NSString *const kAttrHubAlarmSecurityCurrentActive=@"hubalarm:securityCurrentActive";

NSString *const kAttrHubAlarmSecurityOfflineDevices=@"hubalarm:securityOfflineDevices";

NSString *const kAttrHubAlarmSecurityTriggeredDevices=@"hubalarm:securityTriggeredDevices";

NSString *const kAttrHubAlarmSecurityTriggers=@"hubalarm:securityTriggers";

NSString *const kAttrHubAlarmSecurityPreAlertEndTime=@"hubalarm:securityPreAlertEndTime";

NSString *const kAttrHubAlarmSecuritySilent=@"hubalarm:securitySilent";

NSString *const kAttrHubAlarmSecurityEntranceDelay=@"hubalarm:securityEntranceDelay";

NSString *const kAttrHubAlarmSecuritySensitivity=@"hubalarm:securitySensitivity";

NSString *const kAttrHubAlarmPanicAlertState=@"hubalarm:panicAlertState";

NSString *const kAttrHubAlarmPanicActiveDevices=@"hubalarm:panicActiveDevices";

NSString *const kAttrHubAlarmPanicOfflineDevices=@"hubalarm:panicOfflineDevices";

NSString *const kAttrHubAlarmPanicTriggeredDevices=@"hubalarm:panicTriggeredDevices";

NSString *const kAttrHubAlarmPanicTriggers=@"hubalarm:panicTriggers";

NSString *const kAttrHubAlarmPanicSilent=@"hubalarm:panicSilent";

NSString *const kAttrHubAlarmSmokeAlertState=@"hubalarm:smokeAlertState";

NSString *const kAttrHubAlarmSmokeActiveDevices=@"hubalarm:smokeActiveDevices";

NSString *const kAttrHubAlarmSmokeOfflineDevices=@"hubalarm:smokeOfflineDevices";

NSString *const kAttrHubAlarmSmokeTriggeredDevices=@"hubalarm:smokeTriggeredDevices";

NSString *const kAttrHubAlarmSmokeTriggers=@"hubalarm:smokeTriggers";

NSString *const kAttrHubAlarmSmokeSilent=@"hubalarm:smokeSilent";

NSString *const kAttrHubAlarmCoAlertState=@"hubalarm:coAlertState";

NSString *const kAttrHubAlarmCoActiveDevices=@"hubalarm:coActiveDevices";

NSString *const kAttrHubAlarmCoOfflineDevices=@"hubalarm:coOfflineDevices";

NSString *const kAttrHubAlarmCoTriggeredDevices=@"hubalarm:coTriggeredDevices";

NSString *const kAttrHubAlarmCoTriggers=@"hubalarm:coTriggers";

NSString *const kAttrHubAlarmCoSilent=@"hubalarm:coSilent";

NSString *const kAttrHubAlarmWaterAlertState=@"hubalarm:waterAlertState";

NSString *const kAttrHubAlarmWaterActiveDevices=@"hubalarm:waterActiveDevices";

NSString *const kAttrHubAlarmWaterOfflineDevices=@"hubalarm:waterOfflineDevices";

NSString *const kAttrHubAlarmWaterTriggeredDevices=@"hubalarm:waterTriggeredDevices";

NSString *const kAttrHubAlarmWaterTriggers=@"hubalarm:waterTriggers";

NSString *const kAttrHubAlarmWaterSilent=@"hubalarm:waterSilent";


NSString *const kCmdHubAlarmActivate=@"hubalarm:Activate";

NSString *const kCmdHubAlarmSuspend=@"hubalarm:Suspend";

NSString *const kCmdHubAlarmArm=@"hubalarm:Arm";

NSString *const kCmdHubAlarmDisarm=@"hubalarm:Disarm";

NSString *const kCmdHubAlarmPanic=@"hubalarm:Panic";

NSString *const kCmdHubAlarmClearIncident=@"hubalarm:ClearIncident";


NSString *const kEvtHubAlarmVerified=@"hubalarm:Verified";

NSString *const kEnumHubAlarmStateSUSPENDED = @"SUSPENDED";
NSString *const kEnumHubAlarmStateACTIVE = @"ACTIVE";
NSString *const kEnumHubAlarmAlarmStateINACTIVE = @"INACTIVE";
NSString *const kEnumHubAlarmAlarmStateREADY = @"READY";
NSString *const kEnumHubAlarmAlarmStatePREALERT = @"PREALERT";
NSString *const kEnumHubAlarmAlarmStateALERTING = @"ALERTING";
NSString *const kEnumHubAlarmAlarmStateCLEARING = @"CLEARING";
NSString *const kEnumHubAlarmSecurityModeINACTIVE = @"INACTIVE";
NSString *const kEnumHubAlarmSecurityModeDISARMED = @"DISARMED";
NSString *const kEnumHubAlarmSecurityModeON = @"ON";
NSString *const kEnumHubAlarmSecurityModePARTIAL = @"PARTIAL";
NSString *const kEnumHubAlarmSecurityAlertStateINACTIVE = @"INACTIVE";
NSString *const kEnumHubAlarmSecurityAlertStatePENDING_CLEAR = @"PENDING_CLEAR";
NSString *const kEnumHubAlarmSecurityAlertStateDISARMED = @"DISARMED";
NSString *const kEnumHubAlarmSecurityAlertStateARMING = @"ARMING";
NSString *const kEnumHubAlarmSecurityAlertStateREADY = @"READY";
NSString *const kEnumHubAlarmSecurityAlertStatePREALERT = @"PREALERT";
NSString *const kEnumHubAlarmSecurityAlertStateALERT = @"ALERT";
NSString *const kEnumHubAlarmSecurityAlertStateCLEARING = @"CLEARING";
NSString *const kEnumHubAlarmPanicAlertStateINACTIVE = @"INACTIVE";
NSString *const kEnumHubAlarmPanicAlertStatePENDING_CLEAR = @"PENDING_CLEAR";
NSString *const kEnumHubAlarmPanicAlertStateDISARMED = @"DISARMED";
NSString *const kEnumHubAlarmPanicAlertStateARMING = @"ARMING";
NSString *const kEnumHubAlarmPanicAlertStateREADY = @"READY";
NSString *const kEnumHubAlarmPanicAlertStatePREALERT = @"PREALERT";
NSString *const kEnumHubAlarmPanicAlertStateALERT = @"ALERT";
NSString *const kEnumHubAlarmPanicAlertStateCLEARING = @"CLEARING";
NSString *const kEnumHubAlarmSmokeAlertStateINACTIVE = @"INACTIVE";
NSString *const kEnumHubAlarmSmokeAlertStatePENDING_CLEAR = @"PENDING_CLEAR";
NSString *const kEnumHubAlarmSmokeAlertStateDISARMED = @"DISARMED";
NSString *const kEnumHubAlarmSmokeAlertStateARMING = @"ARMING";
NSString *const kEnumHubAlarmSmokeAlertStateREADY = @"READY";
NSString *const kEnumHubAlarmSmokeAlertStatePREALERT = @"PREALERT";
NSString *const kEnumHubAlarmSmokeAlertStateALERT = @"ALERT";
NSString *const kEnumHubAlarmSmokeAlertStateCLEARING = @"CLEARING";
NSString *const kEnumHubAlarmCoAlertStateINACTIVE = @"INACTIVE";
NSString *const kEnumHubAlarmCoAlertStatePENDING_CLEAR = @"PENDING_CLEAR";
NSString *const kEnumHubAlarmCoAlertStateDISARMED = @"DISARMED";
NSString *const kEnumHubAlarmCoAlertStateARMING = @"ARMING";
NSString *const kEnumHubAlarmCoAlertStateREADY = @"READY";
NSString *const kEnumHubAlarmCoAlertStatePREALERT = @"PREALERT";
NSString *const kEnumHubAlarmCoAlertStateALERT = @"ALERT";
NSString *const kEnumHubAlarmCoAlertStateCLEARING = @"CLEARING";
NSString *const kEnumHubAlarmWaterAlertStateINACTIVE = @"INACTIVE";
NSString *const kEnumHubAlarmWaterAlertStatePENDING_CLEAR = @"PENDING_CLEAR";
NSString *const kEnumHubAlarmWaterAlertStateDISARMED = @"DISARMED";
NSString *const kEnumHubAlarmWaterAlertStateARMING = @"ARMING";
NSString *const kEnumHubAlarmWaterAlertStateREADY = @"READY";
NSString *const kEnumHubAlarmWaterAlertStatePREALERT = @"PREALERT";
NSString *const kEnumHubAlarmWaterAlertStateALERT = @"ALERT";
NSString *const kEnumHubAlarmWaterAlertStateCLEARING = @"CLEARING";


@implementation HubAlarmCapability
+ (NSString *)namespace { return @"hubalarm"; }
+ (NSString *)name { return @"HubAlarm"; }

+ (NSString *)getStateFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getState:modelObj];
  
}


+ (NSString *)getAlarmStateFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getAlarmState:modelObj];
  
}


+ (NSString *)getSecurityModeFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityMode:modelObj];
  
}


+ (NSDate *)getSecurityArmTimeFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityArmTime:modelObj];
  
}


+ (NSDate *)getLastArmedTimeFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getLastArmedTime:modelObj];
  
}


+ (NSString *)getLastArmedByFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getLastArmedBy:modelObj];
  
}


+ (NSString *)getLastArmedFromFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getLastArmedFrom:modelObj];
  
}


+ (NSDate *)getLastDisarmedTimeFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getLastDisarmedTime:modelObj];
  
}


+ (NSString *)getLastDisarmedByFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getLastDisarmedBy:modelObj];
  
}


+ (NSString *)getLastDisarmedFromFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getLastDisarmedFrom:modelObj];
  
}


+ (NSArray *)getActiveAlertsFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getActiveAlerts:modelObj];
  
}


+ (NSArray *)getAvailableAlertsFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getAvailableAlerts:modelObj];
  
}


+ (NSString *)getCurrentIncidentFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getCurrentIncident:modelObj];
  
}


+ (BOOL)getReconnectReportFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAlarmCapabilityLegacy getReconnectReport:modelObj] boolValue];
  
}


+ (NSString *)getSecurityAlertStateFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityAlertState:modelObj];
  
}


+ (NSArray *)getSecurityDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityDevices:modelObj];
  
}


+ (NSArray *)getSecurityExcludedDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityExcludedDevices:modelObj];
  
}


+ (NSArray *)getSecurityActiveDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityActiveDevices:modelObj];
  
}


+ (NSArray *)getSecurityCurrentActiveFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityCurrentActive:modelObj];
  
}


+ (NSArray *)getSecurityOfflineDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityOfflineDevices:modelObj];
  
}


+ (NSArray *)getSecurityTriggeredDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityTriggeredDevices:modelObj];
  
}


+ (NSArray *)getSecurityTriggersFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityTriggers:modelObj];
  
}


+ (NSDate *)getSecurityPreAlertEndTimeFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSecurityPreAlertEndTime:modelObj];
  
}


+ (BOOL)getSecuritySilentFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAlarmCapabilityLegacy getSecuritySilent:modelObj] boolValue];
  
}


+ (int)getSecurityEntranceDelayFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAlarmCapabilityLegacy getSecurityEntranceDelay:modelObj] intValue];
  
}


+ (int)getSecuritySensitivityFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAlarmCapabilityLegacy getSecuritySensitivity:modelObj] intValue];
  
}


+ (NSString *)getPanicAlertStateFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getPanicAlertState:modelObj];
  
}


+ (NSArray *)getPanicActiveDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getPanicActiveDevices:modelObj];
  
}


+ (NSArray *)getPanicOfflineDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getPanicOfflineDevices:modelObj];
  
}


+ (NSArray *)getPanicTriggeredDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getPanicTriggeredDevices:modelObj];
  
}


+ (NSArray *)getPanicTriggersFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getPanicTriggers:modelObj];
  
}


+ (BOOL)getPanicSilentFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAlarmCapabilityLegacy getPanicSilent:modelObj] boolValue];
  
}

+ (BOOL)setPanicSilent:(BOOL)panicSilent onModel:(HubAlarmModel *)modelObj {
  [HubAlarmCapabilityLegacy setPanicSilent:panicSilent model:modelObj];
  
  return [[HubAlarmCapabilityLegacy getPanicSilent:modelObj] boolValue];
  
}


+ (NSString *)getSmokeAlertStateFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSmokeAlertState:modelObj];
  
}


+ (NSArray *)getSmokeActiveDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSmokeActiveDevices:modelObj];
  
}


+ (NSArray *)getSmokeOfflineDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSmokeOfflineDevices:modelObj];
  
}


+ (NSArray *)getSmokeTriggeredDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSmokeTriggeredDevices:modelObj];
  
}


+ (NSArray *)getSmokeTriggersFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getSmokeTriggers:modelObj];
  
}


+ (BOOL)getSmokeSilentFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAlarmCapabilityLegacy getSmokeSilent:modelObj] boolValue];
  
}

+ (BOOL)setSmokeSilent:(BOOL)smokeSilent onModel:(HubAlarmModel *)modelObj {
  [HubAlarmCapabilityLegacy setSmokeSilent:smokeSilent model:modelObj];
  
  return [[HubAlarmCapabilityLegacy getSmokeSilent:modelObj] boolValue];
  
}


+ (NSString *)getCoAlertStateFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getCoAlertState:modelObj];
  
}


+ (NSArray *)getCoActiveDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getCoActiveDevices:modelObj];
  
}


+ (NSArray *)getCoOfflineDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getCoOfflineDevices:modelObj];
  
}


+ (NSArray *)getCoTriggeredDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getCoTriggeredDevices:modelObj];
  
}


+ (NSArray *)getCoTriggersFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getCoTriggers:modelObj];
  
}


+ (BOOL)getCoSilentFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAlarmCapabilityLegacy getCoSilent:modelObj] boolValue];
  
}

+ (BOOL)setCoSilent:(BOOL)coSilent onModel:(HubAlarmModel *)modelObj {
  [HubAlarmCapabilityLegacy setCoSilent:coSilent model:modelObj];
  
  return [[HubAlarmCapabilityLegacy getCoSilent:modelObj] boolValue];
  
}


+ (NSString *)getWaterAlertStateFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getWaterAlertState:modelObj];
  
}


+ (NSArray *)getWaterActiveDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getWaterActiveDevices:modelObj];
  
}


+ (NSArray *)getWaterOfflineDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getWaterOfflineDevices:modelObj];
  
}


+ (NSArray *)getWaterTriggeredDevicesFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getWaterTriggeredDevices:modelObj];
  
}


+ (NSArray *)getWaterTriggersFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAlarmCapabilityLegacy getWaterTriggers:modelObj];
  
}


+ (BOOL)getWaterSilentFromModel:(HubAlarmModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAlarmCapabilityLegacy getWaterSilent:modelObj] boolValue];
  
}

+ (BOOL)setWaterSilent:(BOOL)waterSilent onModel:(HubAlarmModel *)modelObj {
  [HubAlarmCapabilityLegacy setWaterSilent:waterSilent model:modelObj];
  
  return [[HubAlarmCapabilityLegacy getWaterSilent:modelObj] boolValue];
  
}




+ (PMKPromise *) activateOnModel:(HubAlarmModel *)modelObj {
  return [HubAlarmCapabilityLegacy activate:modelObj ];
}


+ (PMKPromise *) suspendOnModel:(HubAlarmModel *)modelObj {
  return [HubAlarmCapabilityLegacy suspend:modelObj ];
}


+ (PMKPromise *) armWithMode:(NSString *)mode withBypassed:(BOOL)bypassed withEntranceDelaySecs:(int)entranceDelaySecs withExitDelaySecs:(int)exitDelaySecs withAlarmSensitivityDeviceCount:(int)alarmSensitivityDeviceCount withSilent:(BOOL)silent withSoundsEnabled:(BOOL)soundsEnabled withActiveDevices:(NSArray *)activeDevices withArmedBy:(NSString *)armedBy withArmedFrom:(NSString *)armedFrom onModel:(HubAlarmModel *)modelObj {
  return [HubAlarmCapabilityLegacy arm:modelObj mode:mode bypassed:bypassed entranceDelaySecs:entranceDelaySecs exitDelaySecs:exitDelaySecs alarmSensitivityDeviceCount:alarmSensitivityDeviceCount silent:silent soundsEnabled:soundsEnabled activeDevices:activeDevices armedBy:armedBy armedFrom:armedFrom];

}


+ (PMKPromise *) disarmWithDisarmedBy:(NSString *)disarmedBy withDisarmedFrom:(NSString *)disarmedFrom onModel:(HubAlarmModel *)modelObj {
  return [HubAlarmCapabilityLegacy disarm:modelObj disarmedBy:disarmedBy disarmedFrom:disarmedFrom];

}


+ (PMKPromise *) panicWithSource:(NSString *)source withEvent:(NSString *)event onModel:(HubAlarmModel *)modelObj {
  return [HubAlarmCapabilityLegacy panic:modelObj source:source event:event];

}


+ (PMKPromise *) clearIncidentOnModel:(HubAlarmModel *)modelObj {
  return [HubAlarmCapabilityLegacy clearIncident:modelObj ];
}

@end
