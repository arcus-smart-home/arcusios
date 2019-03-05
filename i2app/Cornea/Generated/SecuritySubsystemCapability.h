

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;







/** The addresses of all the security devices in the safety alarm subsystem.  This includes sensor devices (contact and motion), input devices (keypads), and output devices (sirens). Whether or not these devices actually participate in any alarm states depend on the alarm mode. */
extern NSString *const kAttrSecuritySubsystemSecurityDevices;

/** Devices which are ready to be armed, this set is empty the the alarmState is not DISARMED.  This will only include sensors. */
extern NSString *const kAttrSecuritySubsystemTriggeredDevices;

/** Devices which are ready to be armed, this set is empty the the alarmState is not DISARMED.  This will only include sensors. */
extern NSString *const kAttrSecuritySubsystemReadyDevices;

/** Devices which may result in triggering an alarm.  This set is empty when the alarmState is DISARMED. Note that armedDevices / bypassedDevices / offlineDevices are disjoint, a value will only appear in one of these sets at a time.  Additionally when the alarm is not​ DISARMED the union of these sets should equals devices:{alarmMode}. */
extern NSString *const kAttrSecuritySubsystemArmedDevices;

/** Devices which are online and would normally be armed in the current mode but have been explicitly bypassed via ArmBypassed.  This set is empty when alarmState is DISARMED. Note that armedDevices / bypassedDevices / offlineDevices are disjoint, a value will only appear in one of these sets at a time.  Additionally when the alarm is not DISARMED the union of these sets should equals devices:{alarmMode}. */
extern NSString *const kAttrSecuritySubsystemBypassedDevices;

/** Devices which would normally be armed in the current mode but have fallen offline.  This state takes precedent over bypassedDevices. Note that armedDevices / bypassedDevices / offlineDevices are disjoint, a value will only appear in one of these sets at a time.  Additionally when the alarm is not DISARMED the union of these sets should equals devices:{alarmMode}. */
extern NSString *const kAttrSecuritySubsystemOfflineDevices;

/** Keypad devices */
extern NSString *const kAttrSecuritySubsystemKeypads;

/** Indicates the current state of the alarm:     DISARMED - The alarm is currently DISARMED.  Note that any devices in the triggered or warning state may prevent the alarm from going to fully armed.     ARMING - The alarm is in the process of arming, delaying giving users a chance to leave the house.     ARMED - Indicate the alarm is armed and any security device may trigger an alarm.  See armedDevices to determine which devices might trigger the alarm.     ALERT - The alarm is &#x27;going off&#x27;.  Any sirens are triggered, the call tree is activated, etc.     CLEARING - The alarm has been acknowledged and the system is waiting for all devices to no longer be triggered at which point it will return to DISARMED     SOAKING - An armed secuirty device has triggered the alarm and the system is waiting for the alarm to be disarmed. */
extern NSString *const kAttrSecuritySubsystemAlarmState;

/** If the alarmState is &#x27;DISARMED&#x27; this will be OFF.  Otherwise it will be id of the alarmMode which is currently active. */
extern NSString *const kAttrSecuritySubsystemAlarmMode;

/** The last time the alarm was fired. */
extern NSString *const kAttrSecuritySubsystemLastAlertTime;

/** The reason the alarm was fired. */
extern NSString *const kAttrSecuritySubsystemLastAlertCause;

/** A map of address to timestamp of when a device was triggered during an alert.  This map will not be populated until the alarm enters the alert state. Note this will only include the first time a device was triggered during an alert.  For more detailed information see the history log. */
extern NSString *const kAttrSecuritySubsystemCurrentAlertTriggers;

/** The reason the current alert was raised */
extern NSString *const kAttrSecuritySubsystemCurrentAlertCause;

/** A map of address to timestamp of when a device was triggered during an alert.  This map will not be populated until the alarm enters the soak state. Note this will only include the first time a device was triggered during an alert.  For more detailed information see the history log. */
extern NSString *const kAttrSecuritySubsystemLastAlertTriggers;

/** The current state of acknowledgement:     PENDING - Arcus is attempting to notify the user that an alarm has been triggered     ACKNOWLEDGED - One of the persons from the call tree has acknowledged the alarm     FAILED - No one acknowledged the alarm but no one was available to acknowledged it. */
extern NSString *const kAttrSecuritySubsystemLastAcknowledgement;

/** The last time the alarm was acknowledged. */
extern NSString *const kAttrSecuritySubsystemLastAcknowledgementTime;

/** The actor that acknowledge the alarm when lastAcknowledgement is ACKNOWLEDGED.  Otherwise this field will be empty. */
extern NSString *const kAttrSecuritySubsystemLastAcknowledgedBy;

/** The last time the alarm was armed. */
extern NSString *const kAttrSecuritySubsystemLastArmedTime;

/** The actor that armed the alarm, if available.  If it can&#x27;t be determined this will be empty. */
extern NSString *const kAttrSecuritySubsystemLastArmedBy;

/** The last time the alarm was disarmed. */
extern NSString *const kAttrSecuritySubsystemLastDisarmedTime;

/** The actor that disarmed the alarm, if available.  If it can&#x27;t be determined this will be empty. */
extern NSString *const kAttrSecuritySubsystemLastDisarmedBy;

/** Set to true if the account is PREMIUM, indicating the callTree will be used for alerts. Set to false if the account is BASIC, indicating that only the account owner will be notified. */
extern NSString *const kAttrSecuritySubsystemCallTreeEnabled;

/** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
extern NSString *const kAttrSecuritySubsystemCallTree;

/** The number of seconds the subsystem will allow for a second keypad ON push to armbypassed the system. */
extern NSString *const kAttrSecuritySubsystemKeypadArmBypassedTimeOutSec;

/** The addresses of all the devices that are blacklisted, and therefore not considered as security devices. */
extern NSString *const kAttrSecuritySubsystemBlacklistedSecurityDevices;


extern NSString *const kCmdSecuritySubsystemPanic;

extern NSString *const kCmdSecuritySubsystemArm;

extern NSString *const kCmdSecuritySubsystemArmBypassed;

extern NSString *const kCmdSecuritySubsystemAcknowledge;

extern NSString *const kCmdSecuritySubsystemDisarm;


extern NSString *const kEvtSecuritySubsystemArmed;

extern NSString *const kEvtSecuritySubsystemAlert;

extern NSString *const kEvtSecuritySubsystemDisarmed;

extern NSString *const kEnumSecuritySubsystemAlarmStateDISARMED;
extern NSString *const kEnumSecuritySubsystemAlarmStateARMING;
extern NSString *const kEnumSecuritySubsystemAlarmStateARMED;
extern NSString *const kEnumSecuritySubsystemAlarmStateALERT;
extern NSString *const kEnumSecuritySubsystemAlarmStateCLEARING;
extern NSString *const kEnumSecuritySubsystemAlarmStateSOAKING;
extern NSString *const kEnumSecuritySubsystemAlarmModeOFF;
extern NSString *const kEnumSecuritySubsystemAlarmModeON;
extern NSString *const kEnumSecuritySubsystemAlarmModePARTIAL;
extern NSString *const kEnumSecuritySubsystemCurrentAlertCauseALARM;
extern NSString *const kEnumSecuritySubsystemCurrentAlertCausePANIC;
extern NSString *const kEnumSecuritySubsystemCurrentAlertCauseNONE;
extern NSString *const kEnumSecuritySubsystemLastAcknowledgementNEVER;
extern NSString *const kEnumSecuritySubsystemLastAcknowledgementPENDING;
extern NSString *const kEnumSecuritySubsystemLastAcknowledgementACKNOWLEDGED;
extern NSString *const kEnumSecuritySubsystemLastAcknowledgementFAILED;


@interface SecuritySubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getSecurityDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getTriggeredDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getReadyDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getArmedDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getBypassedDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getOfflineDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getKeypadsFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getAlarmStateFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getAlarmModeFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastAlertTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastAlertCauseFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getCurrentAlertTriggersFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getCurrentAlertCauseFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getLastAlertTriggersFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastAcknowledgementFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastAcknowledgementTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastAcknowledgedByFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastArmedTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastArmedByFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastDisarmedTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastDisarmedByFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getCallTreeEnabledFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getCallTreeFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setCallTree:(NSArray *)callTree onModel:(SubsystemModel *)modelObj;


+ (int)getKeypadArmBypassedTimeOutSecFromModel:(SubsystemModel *)modelObj;

+ (int)setKeypadArmBypassedTimeOutSec:(int)keypadArmBypassedTimeOutSec onModel:(SubsystemModel *)modelObj;


+ (NSArray *)getBlacklistedSecurityDevicesFromModel:(SubsystemModel *)modelObj;





/** Immediately puts the alarm into ALERT mode and record the lastAlertCause as PANIC.  If it is in ALERT this will have no affect.  If it is in any other state this will return an error.The cause will be recorded as the lastAlertCause. */
+ (PMKPromise *) panicWithSilent:(BOOL)silent onModel:(Model *)modelObj;



/** Attempts to arm the alarm into the requested mode, if successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned.  If this call is invoked while the alarm is arming with bypassed devices it will return an error. If the alarm is in any state other than &#x27;DISARMED&#x27; this will return an error. If any devices associated with the alarm mode are triggered, this will return an error with code &#x27;TriggeredDevices&#x27;. */
+ (PMKPromise *) armWithMode:(NSString *)mode onModel:(Model *)modelObj;



/** Attempts to arm the alarm into the request mode, bypassing any triggered devices.  If successful it will return the delay until the alarm is armed.  If this call is repeated with the alarm is in the process of arming with the same mode, it will return the remaining seconds until the alarm is armed (making retries safe).  If this call is invoked with a new mode while the alarm is arming an error will be returned. If the alarm is in any state other than &#x27;DISARMED&#x27; this will return an error. If all devices in the requested mode are faulted, this will return an error. */
+ (PMKPromise *) armBypassedWithMode:(NSString *)mode onModel:(Model *)modelObj;



/** This call acknowledges the alarm and indicates the given user is taking responsibility for dealing with it.  This will stop call tree processing but not stop the alerts. */
+ (PMKPromise *) acknowledgeOnModel:(Model *)modelObj;



/** Requests that the alarm be returned to the disarmed state.  If the alarm is currently in Alert then this will acknowledge the alarm (if it was not previously acknowledged) and transition to CLEARING. */
+ (PMKPromise *) disarmOnModel:(Model *)modelObj;



@end
