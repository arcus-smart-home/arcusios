

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AlarmIncidentCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrAlarmIncidentPlaceId=@"incident:placeId";

NSString *const kAttrAlarmIncidentStartTime=@"incident:startTime";

NSString *const kAttrAlarmIncidentPrealertEndtime=@"incident:prealertEndtime";

NSString *const kAttrAlarmIncidentEndTime=@"incident:endTime";

NSString *const kAttrAlarmIncidentAlertState=@"incident:alertState";

NSString *const kAttrAlarmIncidentConfirmed=@"incident:confirmed";

NSString *const kAttrAlarmIncidentMonitoringState=@"incident:monitoringState";

NSString *const kAttrAlarmIncidentPlatformState=@"incident:platformState";

NSString *const kAttrAlarmIncidentHubState=@"incident:hubState";

NSString *const kAttrAlarmIncidentAlert=@"incident:alert";

NSString *const kAttrAlarmIncidentAdditionalAlerts=@"incident:additionalAlerts";

NSString *const kAttrAlarmIncidentTracker=@"incident:tracker";

NSString *const kAttrAlarmIncidentCancelled=@"incident:cancelled";

NSString *const kAttrAlarmIncidentCancelledBy=@"incident:cancelledBy";

NSString *const kAttrAlarmIncidentMonitored=@"incident:monitored";


NSString *const kCmdAlarmIncidentVerify=@"incident:Verify";

NSString *const kCmdAlarmIncidentCancel=@"incident:Cancel";

NSString *const kCmdAlarmIncidentListHistoryEntries=@"incident:ListHistoryEntries";


NSString *const kEvtAlarmIncidentCOAlert=@"incident:COAlert";

NSString *const kEvtAlarmIncidentPanicAlert=@"incident:PanicAlert";

NSString *const kEvtAlarmIncidentSecurityAlert=@"incident:SecurityAlert";

NSString *const kEvtAlarmIncidentSmokeAlert=@"incident:SmokeAlert";

NSString *const kEvtAlarmIncidentWaterAlert=@"incident:WaterAlert";

NSString *const kEvtAlarmIncidentHistoryAdded=@"incident:HistoryAdded";

NSString *const kEvtAlarmIncidentCompleted=@"incident:Completed";

NSString *const kEnumAlarmIncidentAlertStatePREALERT = @"PREALERT";
NSString *const kEnumAlarmIncidentAlertStateALERT = @"ALERT";
NSString *const kEnumAlarmIncidentAlertStateCANCELLING = @"CANCELLING";
NSString *const kEnumAlarmIncidentAlertStateCOMPLETE = @"COMPLETE";
NSString *const kEnumAlarmIncidentMonitoringStateNONE = @"NONE";
NSString *const kEnumAlarmIncidentMonitoringStatePENDING = @"PENDING";
NSString *const kEnumAlarmIncidentMonitoringStateDISPATCHING = @"DISPATCHING";
NSString *const kEnumAlarmIncidentMonitoringStateDISPATCHED = @"DISPATCHED";
NSString *const kEnumAlarmIncidentMonitoringStateREFUSED = @"REFUSED";
NSString *const kEnumAlarmIncidentMonitoringStateCANCELLED = @"CANCELLED";
NSString *const kEnumAlarmIncidentMonitoringStateFAILED = @"FAILED";
NSString *const kEnumAlarmIncidentPlatformStatePREALERT = @"PREALERT";
NSString *const kEnumAlarmIncidentPlatformStateALERT = @"ALERT";
NSString *const kEnumAlarmIncidentPlatformStateCANCELLING = @"CANCELLING";
NSString *const kEnumAlarmIncidentPlatformStateCOMPLETE = @"COMPLETE";
NSString *const kEnumAlarmIncidentHubStatePREALERT = @"PREALERT";
NSString *const kEnumAlarmIncidentHubStateALERT = @"ALERT";
NSString *const kEnumAlarmIncidentHubStateCANCELLING = @"CANCELLING";
NSString *const kEnumAlarmIncidentHubStateCOMPLETE = @"COMPLETE";
NSString *const kEnumAlarmIncidentAlertSECURITY = @"SECURITY";
NSString *const kEnumAlarmIncidentAlertPANIC = @"PANIC";
NSString *const kEnumAlarmIncidentAlertSMOKE = @"SMOKE";
NSString *const kEnumAlarmIncidentAlertCO = @"CO";
NSString *const kEnumAlarmIncidentAlertWATER = @"WATER";
NSString *const kEnumAlarmIncidentAlertCARE = @"CARE";
NSString *const kEnumAlarmIncidentAlertWEATHER = @"WEATHER";


@implementation AlarmIncidentCapability
+ (NSString *)namespace { return @"incident"; }
+ (NSString *)name { return @"AlarmIncident"; }

+ (NSString *)getPlaceIdFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getPlaceId:modelObj];
  
}


+ (NSDate *)getStartTimeFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getStartTime:modelObj];
  
}


+ (NSDate *)getPrealertEndtimeFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getPrealertEndtime:modelObj];
  
}


+ (NSDate *)getEndTimeFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getEndTime:modelObj];
  
}


+ (NSString *)getAlertStateFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getAlertState:modelObj];
  
}


+ (BOOL)getConfirmedFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmIncidentCapabilityLegacy getConfirmed:modelObj] boolValue];
  
}


+ (NSString *)getMonitoringStateFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getMonitoringState:modelObj];
  
}


+ (NSString *)getPlatformStateFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getPlatformState:modelObj];
  
}


+ (NSString *)getHubStateFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getHubState:modelObj];
  
}


+ (NSString *)getAlertFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getAlert:modelObj];
  
}


+ (NSArray *)getAdditionalAlertsFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getAdditionalAlerts:modelObj];
  
}


+ (NSArray *)getTrackerFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getTracker:modelObj];
  
}


+ (BOOL)getCancelledFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmIncidentCapabilityLegacy getCancelled:modelObj] boolValue];
  
}


+ (NSString *)getCancelledByFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlarmIncidentCapabilityLegacy getCancelledBy:modelObj];
  
}


+ (BOOL)getMonitoredFromModel:(AlarmIncidentModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlarmIncidentCapabilityLegacy getMonitored:modelObj] boolValue];
  
}




+ (PMKPromise *) verifyOnModel:(AlarmIncidentModel *)modelObj {
  return [AlarmIncidentCapabilityLegacy verify:modelObj ];
}


+ (PMKPromise *) cancelOnModel:(AlarmIncidentModel *)modelObj {
  return [AlarmIncidentCapabilityLegacy cancel:modelObj ];
}


+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(AlarmIncidentModel *)modelObj {
  return [AlarmIncidentCapabilityLegacy listHistoryEntries:modelObj limit:limit token:token];

}

@end
