

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class AlarmIncidentModel;

















/** The place this incident occurred at */
extern NSString *const kAttrAlarmIncidentPlaceId;

/** Platform-owned start time of the incident */
extern NSString *const kAttrAlarmIncidentStartTime;

/** The time that the prealert will complete. */
extern NSString *const kAttrAlarmIncidentPrealertEndtime;

/** The time the incident ended, won&#x27;t be set for the currently active incident */
extern NSString *const kAttrAlarmIncidentEndTime;

/** The current alert state of the incident.  This may begin in PREALERT for a security alarm grace period, then go to ALERT, transition to CANCELLING when the user requests that it be cancelled, and finally to COMPLETE when it is no longer active. */
extern NSString *const kAttrAlarmIncidentAlertState;

/** True if the incident has been confirmed */
extern NSString *const kAttrAlarmIncidentConfirmed;

/** An enum of the current monitoring state: NONE - If the alerts are not monitored PENDING - If the alert is monitored but we have not contacted the monitoring station yet DISPATCHING - If we have contacted the monitoring station but the authorities have not been contacted yet DISPATCHED - If the authorities have been contacted REFUSED - If the authorities have been contacted but refused the dispatch CANCELLED - If the alarm was cancelled before the authorities were contacted FAILED - If the signal to the monitoring station failed or the monitoring station did not clear the incident within a configured timeout. */
extern NSString *const kAttrAlarmIncidentMonitoringState;

/** An enum of the current platform&#x27;s view of the incident state.  If hubState is not present, this will be the same as alertState. */
extern NSString *const kAttrAlarmIncidentPlatformState;

/** An enum of the current hub&#x27;s view of the incident state.  If there is only a platform alarm provider this will not be present. */
extern NSString *const kAttrAlarmIncidentHubState;

/** The primary alert type */
extern NSString *const kAttrAlarmIncidentAlert;

/** Additional alerts that were part of this incident */
extern NSString *const kAttrAlarmIncidentAdditionalAlerts;

/** A time series list of tracker events. */
extern NSString *const kAttrAlarmIncidentTracker;

/** If this incident has been cancelled by the user.  It can&#x27;t be completely cleared until the sensors have stopped reporting smoke/CO and any professional monitoring dispatch has completed. */
extern NSString *const kAttrAlarmIncidentCancelled;

/** The address of the person who cancelled the alarm.  This will only be set if: 1 - the incident has cleared 2 - it was &quot;actively&quot; silenced by a user, rather than passively closed by timeout or other event */
extern NSString *const kAttrAlarmIncidentCancelledBy;

/** The monitored flag that should be true if any of the active alarms are monitored or false if none are monitored */
extern NSString *const kAttrAlarmIncidentMonitored;


extern NSString *const kCmdAlarmIncidentVerify;

extern NSString *const kCmdAlarmIncidentCancel;

extern NSString *const kCmdAlarmIncidentListHistoryEntries;


extern NSString *const kEvtAlarmIncidentCOAlert;

extern NSString *const kEvtAlarmIncidentPanicAlert;

extern NSString *const kEvtAlarmIncidentSecurityAlert;

extern NSString *const kEvtAlarmIncidentSmokeAlert;

extern NSString *const kEvtAlarmIncidentWaterAlert;

extern NSString *const kEvtAlarmIncidentHistoryAdded;

extern NSString *const kEvtAlarmIncidentCompleted;

extern NSString *const kEnumAlarmIncidentAlertStatePREALERT;
extern NSString *const kEnumAlarmIncidentAlertStateALERT;
extern NSString *const kEnumAlarmIncidentAlertStateCANCELLING;
extern NSString *const kEnumAlarmIncidentAlertStateCOMPLETE;
extern NSString *const kEnumAlarmIncidentMonitoringStateNONE;
extern NSString *const kEnumAlarmIncidentMonitoringStatePENDING;
extern NSString *const kEnumAlarmIncidentMonitoringStateDISPATCHING;
extern NSString *const kEnumAlarmIncidentMonitoringStateDISPATCHED;
extern NSString *const kEnumAlarmIncidentMonitoringStateREFUSED;
extern NSString *const kEnumAlarmIncidentMonitoringStateCANCELLED;
extern NSString *const kEnumAlarmIncidentMonitoringStateFAILED;
extern NSString *const kEnumAlarmIncidentPlatformStatePREALERT;
extern NSString *const kEnumAlarmIncidentPlatformStateALERT;
extern NSString *const kEnumAlarmIncidentPlatformStateCANCELLING;
extern NSString *const kEnumAlarmIncidentPlatformStateCOMPLETE;
extern NSString *const kEnumAlarmIncidentHubStatePREALERT;
extern NSString *const kEnumAlarmIncidentHubStateALERT;
extern NSString *const kEnumAlarmIncidentHubStateCANCELLING;
extern NSString *const kEnumAlarmIncidentHubStateCOMPLETE;
extern NSString *const kEnumAlarmIncidentAlertSECURITY;
extern NSString *const kEnumAlarmIncidentAlertPANIC;
extern NSString *const kEnumAlarmIncidentAlertSMOKE;
extern NSString *const kEnumAlarmIncidentAlertCO;
extern NSString *const kEnumAlarmIncidentAlertWATER;
extern NSString *const kEnumAlarmIncidentAlertCARE;
extern NSString *const kEnumAlarmIncidentAlertWEATHER;


@interface AlarmIncidentCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getPlaceIdFromModel:(AlarmIncidentModel *)modelObj;


+ (NSDate *)getStartTimeFromModel:(AlarmIncidentModel *)modelObj;


+ (NSDate *)getPrealertEndtimeFromModel:(AlarmIncidentModel *)modelObj;


+ (NSDate *)getEndTimeFromModel:(AlarmIncidentModel *)modelObj;


+ (NSString *)getAlertStateFromModel:(AlarmIncidentModel *)modelObj;


+ (BOOL)getConfirmedFromModel:(AlarmIncidentModel *)modelObj;


+ (NSString *)getMonitoringStateFromModel:(AlarmIncidentModel *)modelObj;


+ (NSString *)getPlatformStateFromModel:(AlarmIncidentModel *)modelObj;


+ (NSString *)getHubStateFromModel:(AlarmIncidentModel *)modelObj;


+ (NSString *)getAlertFromModel:(AlarmIncidentModel *)modelObj;


+ (NSArray *)getAdditionalAlertsFromModel:(AlarmIncidentModel *)modelObj;


+ (NSArray *)getTrackerFromModel:(AlarmIncidentModel *)modelObj;


+ (BOOL)getCancelledFromModel:(AlarmIncidentModel *)modelObj;


+ (NSString *)getCancelledByFromModel:(AlarmIncidentModel *)modelObj;


+ (BOOL)getMonitoredFromModel:(AlarmIncidentModel *)modelObj;





/** Escalates a PreAlert incident to Alerting immediately. */
+ (PMKPromise *) verifyOnModel:(Model *)modelObj;



/** Attempts to cancel the current alert, if one is active.  This will attempt to silence all alarms and stop the alert from going to the monitoring center if the alert is professionally monitored. */
+ (PMKPromise *) cancelOnModel:(Model *)modelObj;



/** Returns a list of all the history log entries associated with this incident */
+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(Model *)modelObj;



@end
