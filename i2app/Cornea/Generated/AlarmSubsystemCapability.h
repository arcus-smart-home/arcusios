

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;









/** The combined state of the alarm across all alerts. */
extern NSString *const kAttrAlarmSubsystemAlarmState;

/** The state of the security alarm. */
extern NSString *const kAttrAlarmSubsystemSecurityMode;

/** The time at which the security system was or will be armed.  This will be cleared when the security system is disarmed. */
extern NSString *const kAttrAlarmSubsystemSecurityArmTime;

/** The last time the security alarm was armed. */
extern NSString *const kAttrAlarmSubsystemLastArmedTime;

/** The address of the last person to arm the security alarm, this may be empty if it was armed from a scene or a rule. */
extern NSString *const kAttrAlarmSubsystemLastArmedBy;

/** The address of the keypad, rule, scene, or app the security alarm was armed from. */
extern NSString *const kAttrAlarmSubsystemLastArmedFrom;

/** The last time at which the security system was disarmed. */
extern NSString *const kAttrAlarmSubsystemLastDisarmedTime;

/** The address of the last person to disarm the security alarm, this may be empty if it was disarmed from a scene or a rule. */
extern NSString *const kAttrAlarmSubsystemLastDisarmedBy;

/** The address of the keypad, rule, scene, or app the security alarm was disarmed from. */
extern NSString *const kAttrAlarmSubsystemLastDisarmedFrom;

/** A priority ordered list of alerts that are currently active.  Note that the banner should always use the first element from this list, it is ordered. */
extern NSString *const kAttrAlarmSubsystemActiveAlerts;

/** The set of alarms which are supported by the devices paired at the current place. */
extern NSString *const kAttrAlarmSubsystemAvailableAlerts;

/** The set of alarms which are professionally monitored. */
extern NSString *const kAttrAlarmSubsystemMonitoredAlerts;

/** The currently incident, will be the empty string when there is no current incident.  This may stay populated for a period of time after this incident is over to notify the user that an incident happened next time they login.   Cancelling the incident or disarming from the keypad will clear out the current incident, although it will remain active until dispatch has completed.  When this field is populated the incident screen should be shown. */
extern NSString *const kAttrAlarmSubsystemCurrentIncident;

/** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
extern NSString *const kAttrAlarmSubsystemCallTree;

/** Flag used by AlarmIncidentService. When true the service implementation should create a mock incident instead. Defaults to false */
extern NSString *const kAttrAlarmSubsystemTestModeEnabled;

/** Indicates whether fanShutoffOnSmoke and fanShutoffOnCO are supported for the current place.  True if there are any fans, thermostats or space heaters at the current place. */
extern NSString *const kAttrAlarmSubsystemFanShutoffSupported;

/** When set to true, all fans, thermostats and space heaters will be turned off when a Smoke alarm is triggered.  Defaults to false. */
extern NSString *const kAttrAlarmSubsystemFanShutoffOnSmoke;

/** When set to true, all fans, thermostats and space heaters will be turned off when a CO alarm is triggered.  Defaults to true */
extern NSString *const kAttrAlarmSubsystemFanShutoffOnCO;

/** Whether or not the alarm subsystem supports recording on alarm.  This requires the user to have cameras and a premium / promonitoring service level to support recording. */
extern NSString *const kAttrAlarmSubsystemRecordingSupported;

/** When set to true all cameras will record.  This flag may be true even if recordingSupported is false.  Default to be true. */
extern NSString *const kAttrAlarmSubsystemRecordOnSecurity;

/** The number of seconds to record for when a security alarm is triggered.  Default to be 60 seconds. */
extern NSString *const kAttrAlarmSubsystemRecordingDurationSec;

/** The provider of the alarming implementation. Defaults to PLATFORM. */
extern NSString *const kAttrAlarmSubsystemAlarmProvider;

/** The provider of the alarming implementation that was requested. Defaults to HUB */
extern NSString *const kAttrAlarmSubsystemRequestedAlarmProvider;

/** The last time at which the change of provider of the alarming implementation requested. */
extern NSString *const kAttrAlarmSubsystemLastAlarmProviderAttempt;

/** The error message upon the last change of provider of the alarming implementation. */
extern NSString *const kAttrAlarmSubsystemLastAlarmProviderError;


extern NSString *const kCmdAlarmSubsystemListIncidents;

extern NSString *const kCmdAlarmSubsystemArm;

extern NSString *const kCmdAlarmSubsystemArmBypassed;

extern NSString *const kCmdAlarmSubsystemDisarm;

extern NSString *const kCmdAlarmSubsystemPanic;

extern NSString *const kCmdAlarmSubsystemSetProvider;


extern NSString *const kEnumAlarmSubsystemAlarmStateINACTIVE;
extern NSString *const kEnumAlarmSubsystemAlarmStateREADY;
extern NSString *const kEnumAlarmSubsystemAlarmStatePREALERT;
extern NSString *const kEnumAlarmSubsystemAlarmStateALERTING;
extern NSString *const kEnumAlarmSubsystemAlarmStateCLEARING;
extern NSString *const kEnumAlarmSubsystemSecurityModeINACTIVE;
extern NSString *const kEnumAlarmSubsystemSecurityModeDISARMED;
extern NSString *const kEnumAlarmSubsystemSecurityModeON;
extern NSString *const kEnumAlarmSubsystemSecurityModePARTIAL;
extern NSString *const kEnumAlarmSubsystemAlarmProviderPLATFORM;
extern NSString *const kEnumAlarmSubsystemAlarmProviderHUB;
extern NSString *const kEnumAlarmSubsystemRequestedAlarmProviderPLATFORM;
extern NSString *const kEnumAlarmSubsystemRequestedAlarmProviderHUB;


@interface AlarmSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getAlarmStateFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getSecurityModeFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getSecurityArmTimeFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastArmedTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastArmedByFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastArmedFromFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastDisarmedTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastDisarmedByFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastDisarmedFromFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getActiveAlertsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getAvailableAlertsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getMonitoredAlertsFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setMonitoredAlerts:(NSArray *)monitoredAlerts onModel:(SubsystemModel *)modelObj;


+ (NSString *)getCurrentIncidentFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getCallTreeFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setCallTree:(NSArray *)callTree onModel:(SubsystemModel *)modelObj;


+ (BOOL)getTestModeEnabledFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setTestModeEnabled:(BOOL)testModeEnabled onModel:(SubsystemModel *)modelObj;


+ (BOOL)getFanShutoffSupportedFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getFanShutoffOnSmokeFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setFanShutoffOnSmoke:(BOOL)fanShutoffOnSmoke onModel:(SubsystemModel *)modelObj;


+ (BOOL)getFanShutoffOnCOFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setFanShutoffOnCO:(BOOL)fanShutoffOnCO onModel:(SubsystemModel *)modelObj;


+ (BOOL)getRecordingSupportedFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getRecordOnSecurityFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setRecordOnSecurity:(BOOL)recordOnSecurity onModel:(SubsystemModel *)modelObj;


+ (int)getRecordingDurationSecFromModel:(SubsystemModel *)modelObj;

+ (int)setRecordingDurationSec:(int)recordingDurationSec onModel:(SubsystemModel *)modelObj;


+ (NSString *)getAlarmProviderFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getRequestedAlarmProviderFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastAlarmProviderAttemptFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastAlarmProviderErrorFromModel:(SubsystemModel *)modelObj;





/** Immediately puts the alarm into ALERT mode and record the lastAlertCause as PANIC.  If it is in ALERT this will have no affect.  If it is in any other state this will return an error.The cause will be recorded as the lastAlertCause. */
+ (PMKPromise *) listIncidentsOnModel:(Model *)modelObj;



/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
+ (PMKPromise *) armWithMode:(NSString *)mode onModel:(Model *)modelObj;



/** Attempts to arm the alarm into the requested mode, excluding any offline or currently tripped devices.  If successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. */
+ (PMKPromise *) armBypassedWithMode:(NSString *)mode onModel:(Model *)modelObj;



/** Attempts to disarm the security alarm.  This MAY also cancel any incidents in progress. */
+ (PMKPromise *) disarmOnModel:(Model *)modelObj;



/** Triggers the PANIC alarm. */
+ (PMKPromise *) panicOnModel:(Model *)modelObj;



/** . */
+ (PMKPromise *) setProviderWithProvider:(NSString *)provider onModel:(Model *)modelObj;



@end
