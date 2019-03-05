

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubAlarmModel;





/** The current state of the hub local alarm subsystem. */
extern NSString *const kAttrHubAlarmState;

/** The combined state of the alarm across all alerts. */
extern NSString *const kAttrHubAlarmAlarmState;

/** The state of the security alarm. */
extern NSString *const kAttrHubAlarmSecurityMode;

/** The time at which the security system was or will be armed.  This will be cleared when the security system is disarmed. */
extern NSString *const kAttrHubAlarmSecurityArmTime;

/** The last time the security alarm was armed. */
extern NSString *const kAttrHubAlarmLastArmedTime;

/** The address of the last person to arm the security alarm, this may be empty if it was armed from a scene or a rule. */
extern NSString *const kAttrHubAlarmLastArmedBy;

/** The address of the keypad, rule, scene, or app the security alarm was armed from. */
extern NSString *const kAttrHubAlarmLastArmedFrom;

/** The last time at which the security system was disarmed. */
extern NSString *const kAttrHubAlarmLastDisarmedTime;

/** The address of the last person to disarm the security alarm, this may be empty if it was disarmed from a scene or a rule. */
extern NSString *const kAttrHubAlarmLastDisarmedBy;

/** The address of the keypad, rule, scene, or app the security alarm was disarmed from. */
extern NSString *const kAttrHubAlarmLastDisarmedFrom;

/** A priority ordered list of alerts that are currently active.  Note that the banner should always use the first element from this list, it is ordered. */
extern NSString *const kAttrHubAlarmActiveAlerts;

/** The set of alarms which are supported by the devices paired at the current place. */
extern NSString *const kAttrHubAlarmAvailableAlerts;

/** The currently incident, will be the empty string when there is no current incident. */
extern NSString *const kAttrHubAlarmCurrentIncident;

/** True if the report issued by the hub is due to a reconnect. */
extern NSString *const kAttrHubAlarmReconnectReport;

/** The current state of this alert. */
extern NSString *const kAttrHubAlarmSecurityAlertState;

/** The addresss of all devices that could participate in the security alarm. */
extern NSString *const kAttrHubAlarmSecurityDevices;

/** The addresses of the devices that are excluded from participating in this alarm. */
extern NSString *const kAttrHubAlarmSecurityExcludedDevices;

/** The addresses of the devices that are participating in this alarm. */
extern NSString *const kAttrHubAlarmSecurityActiveDevices;

/** The addresses of the devices that were initially active at arm time. */
extern NSString *const kAttrHubAlarmSecurityCurrentActive;

/** The addresses of the devices would be active except they have fallen offline. */
extern NSString *const kAttrHubAlarmSecurityOfflineDevices;

/** The addresses of the devices which are currently triggered. */
extern NSString *const kAttrHubAlarmSecurityTriggeredDevices;

/** The triggers associated with the current alert. */
extern NSString *const kAttrHubAlarmSecurityTriggers;

/** The time at which the prealert time for the current incident expires. */
extern NSString *const kAttrHubAlarmSecurityPreAlertEndTime;

/** When true only notifications will be sent, alert devices / keypads will not sound. */
extern NSString *const kAttrHubAlarmSecuritySilent;

/** The amount of time an alarm device must be triggering for before the alarm is fired for the current arming cycle..&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
extern NSString *const kAttrHubAlarmSecurityEntranceDelay;

/** The number of alarm devices which must trigger before the alarm is fired for the current arming cycle.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
extern NSString *const kAttrHubAlarmSecuritySensitivity;

/** The current state of this alert. */
extern NSString *const kAttrHubAlarmPanicAlertState;

/** The addresses of the devices that are participating in this alarm. */
extern NSString *const kAttrHubAlarmPanicActiveDevices;

/** The addresses of the devices would be active except they have fallen offline. */
extern NSString *const kAttrHubAlarmPanicOfflineDevices;

/** The addresses of the devices which are currently triggered. */
extern NSString *const kAttrHubAlarmPanicTriggeredDevices;

/** The triggers associated with the current alert. */
extern NSString *const kAttrHubAlarmPanicTriggers;

/** When true only notifications will be sent, alert devices / keypads will not sound. */
extern NSString *const kAttrHubAlarmPanicSilent;

/** The current state of this alert. */
extern NSString *const kAttrHubAlarmSmokeAlertState;

/** The addresses of the devices that are participating in this alarm. */
extern NSString *const kAttrHubAlarmSmokeActiveDevices;

/** The addresses of the devices would be active except they have fallen offline. */
extern NSString *const kAttrHubAlarmSmokeOfflineDevices;

/** The addresses of the devices which are currently triggered. */
extern NSString *const kAttrHubAlarmSmokeTriggeredDevices;

/** The triggers associated with the current alert. */
extern NSString *const kAttrHubAlarmSmokeTriggers;

/** When true only notifications will be sent, alert devices / keypads will not sound. */
extern NSString *const kAttrHubAlarmSmokeSilent;

/** The current state of this alert. */
extern NSString *const kAttrHubAlarmCoAlertState;

/** The addresses of the devices that are participating in this alarm. */
extern NSString *const kAttrHubAlarmCoActiveDevices;

/** The addresses of the devices would be active except they have fallen offline. */
extern NSString *const kAttrHubAlarmCoOfflineDevices;

/** The addresses of the devices which are currently triggered. */
extern NSString *const kAttrHubAlarmCoTriggeredDevices;

/** The triggers associated with the current alert. */
extern NSString *const kAttrHubAlarmCoTriggers;

/** When true only notifications will be sent, alert devices / keypads will not sound. */
extern NSString *const kAttrHubAlarmCoSilent;

/** The current state of this alert. */
extern NSString *const kAttrHubAlarmWaterAlertState;

/** The addresses of the devices that are participating in this alarm. */
extern NSString *const kAttrHubAlarmWaterActiveDevices;

/** The addresses of the devices would be active except they have fallen offline. */
extern NSString *const kAttrHubAlarmWaterOfflineDevices;

/** The addresses of the devices which are currently triggered. */
extern NSString *const kAttrHubAlarmWaterTriggeredDevices;

/** The triggers associated with the current alert. */
extern NSString *const kAttrHubAlarmWaterTriggers;

/** When true only notifications will be sent, alert devices / keypads will not sound. */
extern NSString *const kAttrHubAlarmWaterSilent;


extern NSString *const kCmdHubAlarmActivate;

extern NSString *const kCmdHubAlarmSuspend;

extern NSString *const kCmdHubAlarmArm;

extern NSString *const kCmdHubAlarmDisarm;

extern NSString *const kCmdHubAlarmPanic;

extern NSString *const kCmdHubAlarmClearIncident;


extern NSString *const kEvtHubAlarmVerified;

extern NSString *const kEnumHubAlarmStateSUSPENDED;
extern NSString *const kEnumHubAlarmStateACTIVE;
extern NSString *const kEnumHubAlarmAlarmStateINACTIVE;
extern NSString *const kEnumHubAlarmAlarmStateREADY;
extern NSString *const kEnumHubAlarmAlarmStatePREALERT;
extern NSString *const kEnumHubAlarmAlarmStateALERTING;
extern NSString *const kEnumHubAlarmAlarmStateCLEARING;
extern NSString *const kEnumHubAlarmSecurityModeINACTIVE;
extern NSString *const kEnumHubAlarmSecurityModeDISARMED;
extern NSString *const kEnumHubAlarmSecurityModeON;
extern NSString *const kEnumHubAlarmSecurityModePARTIAL;
extern NSString *const kEnumHubAlarmSecurityAlertStateINACTIVE;
extern NSString *const kEnumHubAlarmSecurityAlertStatePENDING_CLEAR;
extern NSString *const kEnumHubAlarmSecurityAlertStateDISARMED;
extern NSString *const kEnumHubAlarmSecurityAlertStateARMING;
extern NSString *const kEnumHubAlarmSecurityAlertStateREADY;
extern NSString *const kEnumHubAlarmSecurityAlertStatePREALERT;
extern NSString *const kEnumHubAlarmSecurityAlertStateALERT;
extern NSString *const kEnumHubAlarmSecurityAlertStateCLEARING;
extern NSString *const kEnumHubAlarmPanicAlertStateINACTIVE;
extern NSString *const kEnumHubAlarmPanicAlertStatePENDING_CLEAR;
extern NSString *const kEnumHubAlarmPanicAlertStateDISARMED;
extern NSString *const kEnumHubAlarmPanicAlertStateARMING;
extern NSString *const kEnumHubAlarmPanicAlertStateREADY;
extern NSString *const kEnumHubAlarmPanicAlertStatePREALERT;
extern NSString *const kEnumHubAlarmPanicAlertStateALERT;
extern NSString *const kEnumHubAlarmPanicAlertStateCLEARING;
extern NSString *const kEnumHubAlarmSmokeAlertStateINACTIVE;
extern NSString *const kEnumHubAlarmSmokeAlertStatePENDING_CLEAR;
extern NSString *const kEnumHubAlarmSmokeAlertStateDISARMED;
extern NSString *const kEnumHubAlarmSmokeAlertStateARMING;
extern NSString *const kEnumHubAlarmSmokeAlertStateREADY;
extern NSString *const kEnumHubAlarmSmokeAlertStatePREALERT;
extern NSString *const kEnumHubAlarmSmokeAlertStateALERT;
extern NSString *const kEnumHubAlarmSmokeAlertStateCLEARING;
extern NSString *const kEnumHubAlarmCoAlertStateINACTIVE;
extern NSString *const kEnumHubAlarmCoAlertStatePENDING_CLEAR;
extern NSString *const kEnumHubAlarmCoAlertStateDISARMED;
extern NSString *const kEnumHubAlarmCoAlertStateARMING;
extern NSString *const kEnumHubAlarmCoAlertStateREADY;
extern NSString *const kEnumHubAlarmCoAlertStatePREALERT;
extern NSString *const kEnumHubAlarmCoAlertStateALERT;
extern NSString *const kEnumHubAlarmCoAlertStateCLEARING;
extern NSString *const kEnumHubAlarmWaterAlertStateINACTIVE;
extern NSString *const kEnumHubAlarmWaterAlertStatePENDING_CLEAR;
extern NSString *const kEnumHubAlarmWaterAlertStateDISARMED;
extern NSString *const kEnumHubAlarmWaterAlertStateARMING;
extern NSString *const kEnumHubAlarmWaterAlertStateREADY;
extern NSString *const kEnumHubAlarmWaterAlertStatePREALERT;
extern NSString *const kEnumHubAlarmWaterAlertStateALERT;
extern NSString *const kEnumHubAlarmWaterAlertStateCLEARING;


@interface HubAlarmCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getAlarmStateFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getSecurityModeFromModel:(HubAlarmModel *)modelObj;


+ (NSDate *)getSecurityArmTimeFromModel:(HubAlarmModel *)modelObj;


+ (NSDate *)getLastArmedTimeFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getLastArmedByFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getLastArmedFromFromModel:(HubAlarmModel *)modelObj;


+ (NSDate *)getLastDisarmedTimeFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getLastDisarmedByFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getLastDisarmedFromFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getActiveAlertsFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getAvailableAlertsFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getCurrentIncidentFromModel:(HubAlarmModel *)modelObj;


+ (BOOL)getReconnectReportFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getSecurityAlertStateFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSecurityDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSecurityExcludedDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSecurityActiveDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSecurityCurrentActiveFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSecurityOfflineDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSecurityTriggeredDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSecurityTriggersFromModel:(HubAlarmModel *)modelObj;


+ (NSDate *)getSecurityPreAlertEndTimeFromModel:(HubAlarmModel *)modelObj;


+ (BOOL)getSecuritySilentFromModel:(HubAlarmModel *)modelObj;


+ (int)getSecurityEntranceDelayFromModel:(HubAlarmModel *)modelObj;


+ (int)getSecuritySensitivityFromModel:(HubAlarmModel *)modelObj;


+ (NSString *)getPanicAlertStateFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getPanicActiveDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getPanicOfflineDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getPanicTriggeredDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getPanicTriggersFromModel:(HubAlarmModel *)modelObj;


+ (BOOL)getPanicSilentFromModel:(HubAlarmModel *)modelObj;

+ (BOOL)setPanicSilent:(BOOL)panicSilent onModel:(Model *)modelObj;


+ (NSString *)getSmokeAlertStateFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSmokeActiveDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSmokeOfflineDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSmokeTriggeredDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getSmokeTriggersFromModel:(HubAlarmModel *)modelObj;


+ (BOOL)getSmokeSilentFromModel:(HubAlarmModel *)modelObj;

+ (BOOL)setSmokeSilent:(BOOL)smokeSilent onModel:(Model *)modelObj;


+ (NSString *)getCoAlertStateFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getCoActiveDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getCoOfflineDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getCoTriggeredDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getCoTriggersFromModel:(HubAlarmModel *)modelObj;


+ (BOOL)getCoSilentFromModel:(HubAlarmModel *)modelObj;

+ (BOOL)setCoSilent:(BOOL)coSilent onModel:(Model *)modelObj;


+ (NSString *)getWaterAlertStateFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getWaterActiveDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getWaterOfflineDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getWaterTriggeredDevicesFromModel:(HubAlarmModel *)modelObj;


+ (NSArray *)getWaterTriggersFromModel:(HubAlarmModel *)modelObj;


+ (BOOL)getWaterSilentFromModel:(HubAlarmModel *)modelObj;

+ (BOOL)setWaterSilent:(BOOL)waterSilent onModel:(Model *)modelObj;





/** Puts the hub local alarm into an &#x27;active&#x27; state. */
+ (PMKPromise *) activateOnModel:(Model *)modelObj;



/** Puts the subsystem into a &#x27;suspended&#x27; state. */
+ (PMKPromise *) suspendOnModel:(Model *)modelObj;



/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
+ (PMKPromise *) armWithMode:(NSString *)mode withBypassed:(BOOL)bypassed withEntranceDelaySecs:(int)entranceDelaySecs withExitDelaySecs:(int)exitDelaySecs withAlarmSensitivityDeviceCount:(int)alarmSensitivityDeviceCount withSilent:(BOOL)silent withSoundsEnabled:(BOOL)soundsEnabled withActiveDevices:(NSArray *)activeDevices withArmedBy:(NSString *)armedBy withArmedFrom:(NSString *)armedFrom onModel:(Model *)modelObj;



/** Attempts to disarm the security alarm.  This MAY also cancel any incidents in progress. */
+ (PMKPromise *) disarmWithDisarmedBy:(NSString *)disarmedBy withDisarmedFrom:(NSString *)disarmedFrom onModel:(Model *)modelObj;



/** Triggers the PANIC alarm. */
+ (PMKPromise *) panicWithSource:(NSString *)source withEvent:(NSString *)event onModel:(Model *)modelObj;



/** Issued by the platform when an incident has been fully canceled so the hub will clear out the current incident and related triggers. */
+ (PMKPromise *) clearIncidentOnModel:(Model *)modelObj;



@end
