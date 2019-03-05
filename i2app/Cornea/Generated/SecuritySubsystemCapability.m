

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SecuritySubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSecuritySubsystemSecurityDevices=@"subsecurity:securityDevices";

NSString *const kAttrSecuritySubsystemTriggeredDevices=@"subsecurity:triggeredDevices";

NSString *const kAttrSecuritySubsystemReadyDevices=@"subsecurity:readyDevices";

NSString *const kAttrSecuritySubsystemArmedDevices=@"subsecurity:armedDevices";

NSString *const kAttrSecuritySubsystemBypassedDevices=@"subsecurity:bypassedDevices";

NSString *const kAttrSecuritySubsystemOfflineDevices=@"subsecurity:offlineDevices";

NSString *const kAttrSecuritySubsystemKeypads=@"subsecurity:keypads";

NSString *const kAttrSecuritySubsystemAlarmState=@"subsecurity:alarmState";

NSString *const kAttrSecuritySubsystemAlarmMode=@"subsecurity:alarmMode";

NSString *const kAttrSecuritySubsystemLastAlertTime=@"subsecurity:lastAlertTime";

NSString *const kAttrSecuritySubsystemLastAlertCause=@"subsecurity:lastAlertCause";

NSString *const kAttrSecuritySubsystemCurrentAlertTriggers=@"subsecurity:currentAlertTriggers";

NSString *const kAttrSecuritySubsystemCurrentAlertCause=@"subsecurity:currentAlertCause";

NSString *const kAttrSecuritySubsystemLastAlertTriggers=@"subsecurity:lastAlertTriggers";

NSString *const kAttrSecuritySubsystemLastAcknowledgement=@"subsecurity:lastAcknowledgement";

NSString *const kAttrSecuritySubsystemLastAcknowledgementTime=@"subsecurity:lastAcknowledgementTime";

NSString *const kAttrSecuritySubsystemLastAcknowledgedBy=@"subsecurity:lastAcknowledgedBy";

NSString *const kAttrSecuritySubsystemLastArmedTime=@"subsecurity:lastArmedTime";

NSString *const kAttrSecuritySubsystemLastArmedBy=@"subsecurity:lastArmedBy";

NSString *const kAttrSecuritySubsystemLastDisarmedTime=@"subsecurity:lastDisarmedTime";

NSString *const kAttrSecuritySubsystemLastDisarmedBy=@"subsecurity:lastDisarmedBy";

NSString *const kAttrSecuritySubsystemCallTreeEnabled=@"subsecurity:callTreeEnabled";

NSString *const kAttrSecuritySubsystemCallTree=@"subsecurity:callTree";

NSString *const kAttrSecuritySubsystemKeypadArmBypassedTimeOutSec=@"subsecurity:keypadArmBypassedTimeOutSec";

NSString *const kAttrSecuritySubsystemBlacklistedSecurityDevices=@"subsecurity:blacklistedSecurityDevices";


NSString *const kCmdSecuritySubsystemPanic=@"subsecurity:Panic";

NSString *const kCmdSecuritySubsystemArm=@"subsecurity:Arm";

NSString *const kCmdSecuritySubsystemArmBypassed=@"subsecurity:ArmBypassed";

NSString *const kCmdSecuritySubsystemAcknowledge=@"subsecurity:Acknowledge";

NSString *const kCmdSecuritySubsystemDisarm=@"subsecurity:Disarm";


NSString *const kEvtSecuritySubsystemArmed=@"subsecurity:Armed";

NSString *const kEvtSecuritySubsystemAlert=@"subsecurity:Alert";

NSString *const kEvtSecuritySubsystemDisarmed=@"subsecurity:Disarmed";

NSString *const kEnumSecuritySubsystemAlarmStateDISARMED = @"DISARMED";
NSString *const kEnumSecuritySubsystemAlarmStateARMING = @"ARMING";
NSString *const kEnumSecuritySubsystemAlarmStateARMED = @"ARMED";
NSString *const kEnumSecuritySubsystemAlarmStateALERT = @"ALERT";
NSString *const kEnumSecuritySubsystemAlarmStateCLEARING = @"CLEARING";
NSString *const kEnumSecuritySubsystemAlarmStateSOAKING = @"SOAKING";
NSString *const kEnumSecuritySubsystemAlarmModeOFF = @"OFF";
NSString *const kEnumSecuritySubsystemAlarmModeON = @"ON";
NSString *const kEnumSecuritySubsystemAlarmModePARTIAL = @"PARTIAL";
NSString *const kEnumSecuritySubsystemCurrentAlertCauseALARM = @"ALARM";
NSString *const kEnumSecuritySubsystemCurrentAlertCausePANIC = @"PANIC";
NSString *const kEnumSecuritySubsystemCurrentAlertCauseNONE = @"NONE";
NSString *const kEnumSecuritySubsystemLastAcknowledgementNEVER = @"NEVER";
NSString *const kEnumSecuritySubsystemLastAcknowledgementPENDING = @"PENDING";
NSString *const kEnumSecuritySubsystemLastAcknowledgementACKNOWLEDGED = @"ACKNOWLEDGED";
NSString *const kEnumSecuritySubsystemLastAcknowledgementFAILED = @"FAILED";


@implementation SecuritySubsystemCapability
+ (NSString *)namespace { return @"subsecurity"; }
+ (NSString *)name { return @"SecuritySubsystem"; }

+ (NSArray *)getSecurityDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getSecurityDevices:modelObj];
  
}


+ (NSArray *)getTriggeredDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getTriggeredDevices:modelObj];
  
}


+ (NSArray *)getReadyDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getReadyDevices:modelObj];
  
}


+ (NSArray *)getArmedDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getArmedDevices:modelObj];
  
}


+ (NSArray *)getBypassedDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getBypassedDevices:modelObj];
  
}


+ (NSArray *)getOfflineDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getOfflineDevices:modelObj];
  
}


+ (NSArray *)getKeypadsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getKeypads:modelObj];
  
}


+ (NSString *)getAlarmStateFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getAlarmState:modelObj];
  
}


+ (NSString *)getAlarmModeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getAlarmMode:modelObj];
  
}


+ (NSDate *)getLastAlertTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastAlertTime:modelObj];
  
}


+ (NSString *)getLastAlertCauseFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastAlertCause:modelObj];
  
}


+ (NSDictionary *)getCurrentAlertTriggersFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getCurrentAlertTriggers:modelObj];
  
}


+ (NSString *)getCurrentAlertCauseFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getCurrentAlertCause:modelObj];
  
}


+ (NSDictionary *)getLastAlertTriggersFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastAlertTriggers:modelObj];
  
}


+ (NSString *)getLastAcknowledgementFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastAcknowledgement:modelObj];
  
}


+ (NSDate *)getLastAcknowledgementTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastAcknowledgementTime:modelObj];
  
}


+ (NSString *)getLastAcknowledgedByFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastAcknowledgedBy:modelObj];
  
}


+ (NSDate *)getLastArmedTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastArmedTime:modelObj];
  
}


+ (NSString *)getLastArmedByFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastArmedBy:modelObj];
  
}


+ (NSDate *)getLastDisarmedTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastDisarmedTime:modelObj];
  
}


+ (NSString *)getLastDisarmedByFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getLastDisarmedBy:modelObj];
  
}


+ (BOOL)getCallTreeEnabledFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SecuritySubsystemCapabilityLegacy getCallTreeEnabled:modelObj] boolValue];
  
}


+ (NSArray *)getCallTreeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getCallTree:modelObj];
  
}

+ (NSArray *)setCallTree:(NSArray *)callTree onModel:(SubsystemModel *)modelObj {
  [SecuritySubsystemCapabilityLegacy setCallTree:callTree model:modelObj];
  
  return [SecuritySubsystemCapabilityLegacy getCallTree:modelObj];
  
}


+ (int)getKeypadArmBypassedTimeOutSecFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SecuritySubsystemCapabilityLegacy getKeypadArmBypassedTimeOutSec:modelObj] intValue];
  
}

+ (int)setKeypadArmBypassedTimeOutSec:(int)keypadArmBypassedTimeOutSec onModel:(SubsystemModel *)modelObj {
  [SecuritySubsystemCapabilityLegacy setKeypadArmBypassedTimeOutSec:keypadArmBypassedTimeOutSec model:modelObj];
  
  return [[SecuritySubsystemCapabilityLegacy getKeypadArmBypassedTimeOutSec:modelObj] intValue];
  
}


+ (NSArray *)getBlacklistedSecurityDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SecuritySubsystemCapabilityLegacy getBlacklistedSecurityDevices:modelObj];
  
}




+ (PMKPromise *) panicWithSilent:(BOOL)silent onModel:(SubsystemModel *)modelObj {
  return [SecuritySubsystemCapabilityLegacy panic:modelObj silent:silent];

}


+ (PMKPromise *) armWithMode:(NSString *)mode onModel:(SubsystemModel *)modelObj {
  return [SecuritySubsystemCapabilityLegacy arm:modelObj mode:mode];

}


+ (PMKPromise *) armBypassedWithMode:(NSString *)mode onModel:(SubsystemModel *)modelObj {
  return [SecuritySubsystemCapabilityLegacy armBypassed:modelObj mode:mode];

}


+ (PMKPromise *) acknowledgeOnModel:(SubsystemModel *)modelObj {
  return [SecuritySubsystemCapabilityLegacy acknowledge:modelObj ];
}


+ (PMKPromise *) disarmOnModel:(SubsystemModel *)modelObj {
  return [SecuritySubsystemCapabilityLegacy disarm:modelObj ];
}

@end
