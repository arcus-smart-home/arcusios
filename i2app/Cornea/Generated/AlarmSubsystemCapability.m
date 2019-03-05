

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AlarmSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrAlarmSubsystemAlarmState=@"subalarm:alarmState";

NSString *const kAttrAlarmSubsystemSecurityMode=@"subalarm:securityMode";

NSString *const kAttrAlarmSubsystemSecurityArmTime=@"subalarm:securityArmTime";

NSString *const kAttrAlarmSubsystemLastArmedTime=@"subalarm:lastArmedTime";

NSString *const kAttrAlarmSubsystemLastArmedBy=@"subalarm:lastArmedBy";

NSString *const kAttrAlarmSubsystemLastArmedFrom=@"subalarm:lastArmedFrom";

NSString *const kAttrAlarmSubsystemLastDisarmedTime=@"subalarm:lastDisarmedTime";

NSString *const kAttrAlarmSubsystemLastDisarmedBy=@"subalarm:lastDisarmedBy";

NSString *const kAttrAlarmSubsystemLastDisarmedFrom=@"subalarm:lastDisarmedFrom";

NSString *const kAttrAlarmSubsystemActiveAlerts=@"subalarm:activeAlerts";

NSString *const kAttrAlarmSubsystemAvailableAlerts=@"subalarm:availableAlerts";

NSString *const kAttrAlarmSubsystemMonitoredAlerts=@"subalarm:monitoredAlerts";

NSString *const kAttrAlarmSubsystemCurrentIncident=@"subalarm:currentIncident";

NSString *const kAttrAlarmSubsystemCallTree=@"subalarm:callTree";

NSString *const kAttrAlarmSubsystemTestModeEnabled=@"subalarm:testModeEnabled";

NSString *const kAttrAlarmSubsystemFanShutoffSupported=@"subalarm:fanShutoffSupported";

NSString *const kAttrAlarmSubsystemFanShutoffOnSmoke=@"subalarm:fanShutoffOnSmoke";

NSString *const kAttrAlarmSubsystemFanShutoffOnCO=@"subalarm:fanShutoffOnCO";

NSString *const kAttrAlarmSubsystemRecordingSupported=@"subalarm:recordingSupported";

NSString *const kAttrAlarmSubsystemRecordOnSecurity=@"subalarm:recordOnSecurity";

NSString *const kAttrAlarmSubsystemRecordingDurationSec=@"subalarm:recordingDurationSec";

NSString *const kAttrAlarmSubsystemAlarmProvider=@"subalarm:alarmProvider";

NSString *const kAttrAlarmSubsystemRequestedAlarmProvider=@"subalarm:requestedAlarmProvider";

NSString *const kAttrAlarmSubsystemLastAlarmProviderAttempt=@"subalarm:lastAlarmProviderAttempt";

NSString *const kAttrAlarmSubsystemLastAlarmProviderError=@"subalarm:lastAlarmProviderError";


NSString *const kCmdAlarmSubsystemListIncidents=@"subalarm:ListIncidents";

NSString *const kCmdAlarmSubsystemArm=@"subalarm:Arm";

NSString *const kCmdAlarmSubsystemArmBypassed=@"subalarm:ArmBypassed";

NSString *const kCmdAlarmSubsystemDisarm=@"subalarm:Disarm";

NSString *const kCmdAlarmSubsystemPanic=@"subalarm:Panic";

NSString *const kCmdAlarmSubsystemSetProvider=@"subalarm:SetProvider";


NSString *const kEnumAlarmSubsystemAlarmStateINACTIVE = @"INACTIVE";
NSString *const kEnumAlarmSubsystemAlarmStateREADY = @"READY";
NSString *const kEnumAlarmSubsystemAlarmStatePREALERT = @"PREALERT";
NSString *const kEnumAlarmSubsystemAlarmStateALERTING = @"ALERTING";
NSString *const kEnumAlarmSubsystemAlarmStateCLEARING = @"CLEARING";
NSString *const kEnumAlarmSubsystemSecurityModeINACTIVE = @"INACTIVE";
NSString *const kEnumAlarmSubsystemSecurityModeDISARMED = @"DISARMED";
NSString *const kEnumAlarmSubsystemSecurityModeON = @"ON";
NSString *const kEnumAlarmSubsystemSecurityModePARTIAL = @"PARTIAL";
NSString *const kEnumAlarmSubsystemAlarmProviderPLATFORM = @"PLATFORM";
NSString *const kEnumAlarmSubsystemAlarmProviderHUB = @"HUB";
NSString *const kEnumAlarmSubsystemRequestedAlarmProviderPLATFORM = @"PLATFORM";
NSString *const kEnumAlarmSubsystemRequestedAlarmProviderHUB = @"HUB";


@implementation AlarmSubsystemCapability
+ (NSString *)namespace { return @"subalarm"; }
+ (NSString *)name { return @"AlarmSubsystem"; }

+ (NSString *)getAlarmStateFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getAlarmState:modelObj];
  
}


+ (NSString *)getSecurityModeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getSecurityMode:modelObj];
  
}


+ (NSDate *)getSecurityArmTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getSecurityArmTime:modelObj];
  
}


+ (NSDate *)getLastArmedTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getLastArmedTime:modelObj];
  
}


+ (NSString *)getLastArmedByFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getLastArmedBy:modelObj];
  
}


+ (NSString *)getLastArmedFromFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getLastArmedFrom:modelObj];
  
}


+ (NSDate *)getLastDisarmedTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getLastDisarmedTime:modelObj];
  
}


+ (NSString *)getLastDisarmedByFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getLastDisarmedBy:modelObj];
  
}


+ (NSString *)getLastDisarmedFromFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getLastDisarmedFrom:modelObj];
  
}


+ (NSArray *)getActiveAlertsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getActiveAlerts:modelObj];
  
}


+ (NSArray *)getAvailableAlertsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getAvailableAlerts:modelObj];
  
}


+ (NSArray *)getMonitoredAlertsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getMonitoredAlerts:modelObj];
  
}

+ (NSArray *)setMonitoredAlerts:(NSArray *)monitoredAlerts onModel:(SubsystemModel *)modelObj {
  [AlarmSubsystemCapabilityLegacy setMonitoredAlerts:monitoredAlerts model:modelObj];
  
  return [AlarmSubsystemCapabilityLegacy getMonitoredAlerts:modelObj];
  
}


+ (NSString *)getCurrentIncidentFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getCurrentIncident:modelObj];
  
}


+ (NSArray *)getCallTreeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getCallTree:modelObj];
  
}

+ (NSArray *)setCallTree:(NSArray *)callTree onModel:(SubsystemModel *)modelObj {
  [AlarmSubsystemCapabilityLegacy setCallTree:callTree model:modelObj];
  
  return [AlarmSubsystemCapabilityLegacy getCallTree:modelObj];
  
}


+ (BOOL)getTestModeEnabledFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmSubsystemCapabilityLegacy getTestModeEnabled:modelObj] boolValue];
  
}

+ (BOOL)setTestModeEnabled:(BOOL)testModeEnabled onModel:(SubsystemModel *)modelObj {
  [AlarmSubsystemCapabilityLegacy setTestModeEnabled:testModeEnabled model:modelObj];
  
  return [[AlarmSubsystemCapabilityLegacy getTestModeEnabled:modelObj] boolValue];
  
}


+ (BOOL)getFanShutoffSupportedFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmSubsystemCapabilityLegacy getFanShutoffSupported:modelObj] boolValue];
  
}


+ (BOOL)getFanShutoffOnSmokeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmSubsystemCapabilityLegacy getFanShutoffOnSmoke:modelObj] boolValue];
  
}

+ (BOOL)setFanShutoffOnSmoke:(BOOL)fanShutoffOnSmoke onModel:(SubsystemModel *)modelObj {
  [AlarmSubsystemCapabilityLegacy setFanShutoffOnSmoke:fanShutoffOnSmoke model:modelObj];
  
  return [[AlarmSubsystemCapabilityLegacy getFanShutoffOnSmoke:modelObj] boolValue];
  
}


+ (BOOL)getFanShutoffOnCOFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmSubsystemCapabilityLegacy getFanShutoffOnCO:modelObj] boolValue];
  
}

+ (BOOL)setFanShutoffOnCO:(BOOL)fanShutoffOnCO onModel:(SubsystemModel *)modelObj {
  [AlarmSubsystemCapabilityLegacy setFanShutoffOnCO:fanShutoffOnCO model:modelObj];
  
  return [[AlarmSubsystemCapabilityLegacy getFanShutoffOnCO:modelObj] boolValue];
  
}


+ (BOOL)getRecordingSupportedFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmSubsystemCapabilityLegacy getRecordingSupported:modelObj] boolValue];
  
}


+ (BOOL)getRecordOnSecurityFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmSubsystemCapabilityLegacy getRecordOnSecurity:modelObj] boolValue];
  
}

+ (BOOL)setRecordOnSecurity:(BOOL)recordOnSecurity onModel:(SubsystemModel *)modelObj {
  [AlarmSubsystemCapabilityLegacy setRecordOnSecurity:recordOnSecurity model:modelObj];
  
  return [[AlarmSubsystemCapabilityLegacy getRecordOnSecurity:modelObj] boolValue];
  
}


+ (int)getRecordingDurationSecFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmSubsystemCapabilityLegacy getRecordingDurationSec:modelObj] intValue];
  
}

+ (int)setRecordingDurationSec:(int)recordingDurationSec onModel:(SubsystemModel *)modelObj {
  [AlarmSubsystemCapabilityLegacy setRecordingDurationSec:recordingDurationSec model:modelObj];
  
  return [[AlarmSubsystemCapabilityLegacy getRecordingDurationSec:modelObj] intValue];
  
}


+ (NSString *)getAlarmProviderFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getAlarmProvider:modelObj];
  
}


+ (NSString *)getRequestedAlarmProviderFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getRequestedAlarmProvider:modelObj];
  
}


+ (NSDate *)getLastAlarmProviderAttemptFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getLastAlarmProviderAttempt:modelObj];
  
}


+ (NSString *)getLastAlarmProviderErrorFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmSubsystemCapabilityLegacy getLastAlarmProviderError:modelObj];
  
}




+ (PMKPromise *) listIncidentsOnModel:(SubsystemModel *)modelObj {
  return [AlarmSubsystemCapabilityLegacy listIncidents:modelObj ];
}


+ (PMKPromise *) armWithMode:(NSString *)mode onModel:(SubsystemModel *)modelObj {
  return [AlarmSubsystemCapabilityLegacy arm:modelObj mode:mode];

}


+ (PMKPromise *) armBypassedWithMode:(NSString *)mode onModel:(SubsystemModel *)modelObj {
  return [AlarmSubsystemCapabilityLegacy armBypassed:modelObj mode:mode];

}


+ (PMKPromise *) disarmOnModel:(SubsystemModel *)modelObj {
  return [AlarmSubsystemCapabilityLegacy disarm:modelObj ];
}


+ (PMKPromise *) panicOnModel:(SubsystemModel *)modelObj {
  return [AlarmSubsystemCapabilityLegacy panic:modelObj ];
}


+ (PMKPromise *) setProviderWithProvider:(NSString *)provider onModel:(SubsystemModel *)modelObj {
  return [AlarmSubsystemCapabilityLegacy setProvider:modelObj provider:provider];

}

@end
