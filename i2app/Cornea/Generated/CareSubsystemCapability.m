

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CareSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCareSubsystemTriggeredDevices=@"subcare:triggeredDevices";

NSString *const kAttrCareSubsystemInactiveDevices=@"subcare:inactiveDevices";

NSString *const kAttrCareSubsystemCareDevices=@"subcare:careDevices";

NSString *const kAttrCareSubsystemCareCapableDevices=@"subcare:careCapableDevices";

NSString *const kAttrCareSubsystemPresenceDevices=@"subcare:presenceDevices";

NSString *const kAttrCareSubsystemBehaviors=@"subcare:behaviors";

NSString *const kAttrCareSubsystemActiveBehaviors=@"subcare:activeBehaviors";

NSString *const kAttrCareSubsystemAlarmMode=@"subcare:alarmMode";

NSString *const kAttrCareSubsystemAlarmState=@"subcare:alarmState";

NSString *const kAttrCareSubsystemLastAlertTime=@"subcare:lastAlertTime";

NSString *const kAttrCareSubsystemLastAlertCause=@"subcare:lastAlertCause";

NSString *const kAttrCareSubsystemLastAlertTriggers=@"subcare:lastAlertTriggers";

NSString *const kAttrCareSubsystemLastAcknowledgement=@"subcare:lastAcknowledgement";

NSString *const kAttrCareSubsystemLastAcknowledgementTime=@"subcare:lastAcknowledgementTime";

NSString *const kAttrCareSubsystemLastAcknowledgedBy=@"subcare:lastAcknowledgedBy";

NSString *const kAttrCareSubsystemLastClearTime=@"subcare:lastClearTime";

NSString *const kAttrCareSubsystemLastClearedBy=@"subcare:lastClearedBy";

NSString *const kAttrCareSubsystemCallTreeEnabled=@"subcare:callTreeEnabled";

NSString *const kAttrCareSubsystemCallTree=@"subcare:callTree";

NSString *const kAttrCareSubsystemSilent=@"subcare:silent";

NSString *const kAttrCareSubsystemCareDevicesPopulated=@"subcare:careDevicesPopulated";


NSString *const kCmdCareSubsystemPanic=@"subcare:Panic";

NSString *const kCmdCareSubsystemAcknowledge=@"subcare:Acknowledge";

NSString *const kCmdCareSubsystemClear=@"subcare:Clear";

NSString *const kCmdCareSubsystemListActivity=@"subcare:ListActivity";

NSString *const kCmdCareSubsystemListDetailedActivity=@"subcare:ListDetailedActivity";

NSString *const kCmdCareSubsystemListBehaviors=@"subcare:ListBehaviors";

NSString *const kCmdCareSubsystemListBehaviorTemplates=@"subcare:ListBehaviorTemplates";

NSString *const kCmdCareSubsystemAddBehavior=@"subcare:AddBehavior";

NSString *const kCmdCareSubsystemUpdateBehavior=@"subcare:UpdateBehavior";

NSString *const kCmdCareSubsystemRemoveBehavior=@"subcare:RemoveBehavior";


NSString *const kEvtCareSubsystemBehaviorAlert=@"subcare:BehaviorAlert";

NSString *const kEvtCareSubsystemBehaviorAlertCleared=@"subcare:BehaviorAlertCleared";

NSString *const kEvtCareSubsystemBehaviorAlertAcknowledged=@"subcare:BehaviorAlertAcknowledged";

NSString *const kEvtCareSubsystemBehaviorAction=@"subcare:BehaviorAction";

NSString *const kEnumCareSubsystemAlarmModeON = @"ON";
NSString *const kEnumCareSubsystemAlarmModeVISIT = @"VISIT";
NSString *const kEnumCareSubsystemAlarmStateREADY = @"READY";
NSString *const kEnumCareSubsystemAlarmStateALERT = @"ALERT";
NSString *const kEnumCareSubsystemLastAcknowledgementPENDING = @"PENDING";
NSString *const kEnumCareSubsystemLastAcknowledgementACKNOWLEDGED = @"ACKNOWLEDGED";
NSString *const kEnumCareSubsystemLastAcknowledgementFAILED = @"FAILED";


@implementation CareSubsystemCapability
+ (NSString *)namespace { return @"subcare"; }
+ (NSString *)name { return @"CareSubsystem"; }

+ (NSArray *)getTriggeredDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getTriggeredDevices:modelObj];
  
}


+ (NSArray *)getInactiveDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getInactiveDevices:modelObj];
  
}


+ (NSArray *)getCareDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getCareDevices:modelObj];
  
}

+ (NSArray *)setCareDevices:(NSArray *)careDevices onModel:(SubsystemModel *)modelObj {
  [CareSubsystemCapabilityLegacy setCareDevices:careDevices model:modelObj];
  
  return [CareSubsystemCapabilityLegacy getCareDevices:modelObj];
  
}


+ (NSArray *)getCareCapableDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getCareCapableDevices:modelObj];
  
}


+ (NSArray *)getPresenceDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getPresenceDevices:modelObj];
  
}


+ (NSArray *)getBehaviorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getBehaviors:modelObj];
  
}


+ (NSArray *)getActiveBehaviorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getActiveBehaviors:modelObj];
  
}


+ (NSString *)getAlarmModeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getAlarmMode:modelObj];
  
}

+ (NSString *)setAlarmMode:(NSString *)alarmMode onModel:(SubsystemModel *)modelObj {
  [CareSubsystemCapabilityLegacy setAlarmMode:alarmMode model:modelObj];
  
  return [CareSubsystemCapabilityLegacy getAlarmMode:modelObj];
  
}


+ (NSString *)getAlarmStateFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getAlarmState:modelObj];
  
}


+ (NSDate *)getLastAlertTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getLastAlertTime:modelObj];
  
}


+ (NSString *)getLastAlertCauseFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getLastAlertCause:modelObj];
  
}


+ (NSDictionary *)getLastAlertTriggersFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getLastAlertTriggers:modelObj];
  
}


+ (NSString *)getLastAcknowledgementFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getLastAcknowledgement:modelObj];
  
}


+ (NSDate *)getLastAcknowledgementTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getLastAcknowledgementTime:modelObj];
  
}


+ (NSString *)getLastAcknowledgedByFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getLastAcknowledgedBy:modelObj];
  
}


+ (NSDate *)getLastClearTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getLastClearTime:modelObj];
  
}


+ (NSString *)getLastClearedByFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getLastClearedBy:modelObj];
  
}


+ (BOOL)getCallTreeEnabledFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CareSubsystemCapabilityLegacy getCallTreeEnabled:modelObj] boolValue];
  
}


+ (NSArray *)getCallTreeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CareSubsystemCapabilityLegacy getCallTree:modelObj];
  
}

+ (NSArray *)setCallTree:(NSArray *)callTree onModel:(SubsystemModel *)modelObj {
  [CareSubsystemCapabilityLegacy setCallTree:callTree model:modelObj];
  
  return [CareSubsystemCapabilityLegacy getCallTree:modelObj];
  
}


+ (BOOL)getSilentFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CareSubsystemCapabilityLegacy getSilent:modelObj] boolValue];
  
}

+ (BOOL)setSilent:(BOOL)silent onModel:(SubsystemModel *)modelObj {
  [CareSubsystemCapabilityLegacy setSilent:silent model:modelObj];
  
  return [[CareSubsystemCapabilityLegacy getSilent:modelObj] boolValue];
  
}


+ (BOOL)getCareDevicesPopulatedFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CareSubsystemCapabilityLegacy getCareDevicesPopulated:modelObj] boolValue];
  
}




+ (PMKPromise *) panicOnModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy panic:modelObj ];
}


+ (PMKPromise *) acknowledgeOnModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy acknowledge:modelObj ];
}


+ (PMKPromise *) clearOnModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy clear:modelObj ];
}


+ (PMKPromise *) listActivityWithStart:(double)start withEnd:(double)end withBucket:(int)bucket withDevices:(NSArray *)devices onModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy listActivity:modelObj start:start end:end bucket:bucket devices:devices];

}


+ (PMKPromise *) listDetailedActivityWithLimit:(int)limit withToken:(NSString *)token withDevices:(NSArray *)devices onModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy listDetailedActivity:modelObj limit:limit token:token devices:devices];

}


+ (PMKPromise *) listBehaviorsOnModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy listBehaviors:modelObj ];
}


+ (PMKPromise *) listBehaviorTemplatesOnModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy listBehaviorTemplates:modelObj ];
}


+ (PMKPromise *) addBehaviorWithBehavior:(id)behavior onModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy addBehavior:modelObj behavior:behavior];

}


+ (PMKPromise *) updateBehaviorWithBehavior:(id)behavior onModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy updateBehavior:modelObj behavior:behavior];

}


+ (PMKPromise *) removeBehaviorWithId:(NSString *)id onModel:(SubsystemModel *)modelObj {
  return [CareSubsystemCapabilityLegacy removeBehavior:modelObj id:id];

}

@end
