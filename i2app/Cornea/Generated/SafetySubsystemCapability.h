

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/** The addresses of all the safety devices in this place. */
extern NSString *const kAttrSafetySubsystemTotalDevices;

/** the addresses of all the currently active (online) safety devices in this place. */
extern NSString *const kAttrSafetySubsystemActiveDevices;

/** The addresses of the devices which should not be used to trigger safety alarms. */
extern NSString *const kAttrSafetySubsystemIgnoredDevices;

/** The addresses of the devices that are water shutoff valves. */
extern NSString *const kAttrSafetySubsystemWaterShutoffValves;

/** Indicates the current state of the alarm:         - READY - The alarm is active and watching for safety alerts         - WARN - The alarm is active, but one or more of the safety sensors has low battery or connectivity issues that could potentially cause an alarm to be missed         - SOAKING - One or more safety devices have triggered, but not a sufficient amount of time or devices to set off the whole system.         - ALERT - A safety device has triggered an alarm         - CLEARING - A request has been made to CLEAR the alarm, but there are still devices triggering an alarm. */
extern NSString *const kAttrSafetySubsystemAlarm;

/** The addresses of all devices which currently have their alarm triggered.  If this is non-empty the alarm will be either ALERT, SOAKING or CLEARING */
extern NSString *const kAttrSafetySubsystemTriggers;

/** The list of events that were outstanding at the time the user canceled the alarm still waiting for an all clear from the device. */
extern NSString *const kAttrSafetySubsystemPendingClear;

/** A set of warnings about devices which have potential issues that could cause an alarm to be missed.  The key is the address of the device with a warning and the value is an I18N code with the description of the problem. */
extern NSString *const kAttrSafetySubsystemWarnings;

/** Set to true if the account is PREMIUM, indicating the callTree will be used for alerts. Set to false if the account is BASIC, indicating that only the account owner will be notified. */
extern NSString *const kAttrSafetySubsystemCallTreeEnabled;

/** The list of people who should be notified when the alarm goes into alert mode.  This is marked as a list to maintain ordering, but each entry may only appear once. Note that all addresses must be persons associated with this place. */
extern NSString *const kAttrSafetySubsystemCallTree;

/** A map of types of safety sensors to the current status. Each value means:     NONE - There are no devices of the given type     SAFE - All devices of that type are on and haven&#x27;t detected a safety alarm     OFFLINE - At least one device of the given type is offline, but none have detected a safety alarm     DETECTED - At least one device of the given type has detected a safety alarm */
extern NSString *const kAttrSafetySubsystemSensorState;

/** The last time the alarm was fired. */
extern NSString *const kAttrSafetySubsystemLastAlertTime;

/** The reason the alarm was fired. */
extern NSString *const kAttrSafetySubsystemLastAlertCause;

/** The last time the alarm was cleared. */
extern NSString *const kAttrSafetySubsystemLastClearTime;

/** The actor that cleared the alarm. */
extern NSString *const kAttrSafetySubsystemLastClearedBy;

/** The amount of time an alarm device must be triggering for before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 0&lt;/b&gt; */
extern NSString *const kAttrSafetySubsystemAlarmSensitivitySec;

/** The number of alarm devices which must trigger before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
extern NSString *const kAttrSafetySubsystemAlarmSensitivityDeviceCount;

/** The number of seconds after an alarm has been cleared before it can be fired again.&lt;br/&gt;&lt;b&gt;Default: 0&lt;/b&gt; */
extern NSString *const kAttrSafetySubsystemQuietPeriodSec;

/** When set to true &#x27;alert&#x27; devices will not be triggered when the alarm is raised. */
extern NSString *const kAttrSafetySubsystemSilentAlarm;

/** When set to true &#x27;valve&#x27; devices will be turned off when a water leak is detected. */
extern NSString *const kAttrSafetySubsystemWaterShutOff;

/** The addresses of all the devices in this place that are in smoke pre-alert state. */
extern NSString *const kAttrSafetySubsystemSmokePreAlertDevices;

/** Indicates the whether any devices that can provide a smoke pre-alert are alerting         - READY - The alarm is active and watching for safety alerts         - ALERT - A safety device has triggered a prealarm */
extern NSString *const kAttrSafetySubsystemSmokePreAlert;

/** The last time the alarm was fired. */
extern NSString *const kAttrSafetySubsystemLastSmokePreAlertTime;


extern NSString *const kCmdSafetySubsystemTrigger;

extern NSString *const kCmdSafetySubsystemClear;


extern NSString *const kEnumSafetySubsystemAlarmREADY;
extern NSString *const kEnumSafetySubsystemAlarmWARN;
extern NSString *const kEnumSafetySubsystemAlarmSOAKING;
extern NSString *const kEnumSafetySubsystemAlarmALERT;
extern NSString *const kEnumSafetySubsystemAlarmCLEARING;
extern NSString *const kEnumSafetySubsystemSmokePreAlertREADY;
extern NSString *const kEnumSafetySubsystemSmokePreAlertALERT;


@interface SafetySubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getTotalDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getActiveDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getIgnoredDevicesFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setIgnoredDevices:(NSArray *)ignoredDevices onModel:(SubsystemModel *)modelObj;


+ (NSArray *)getWaterShutoffValvesFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getAlarmFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getTriggersFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getPendingClearFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getWarningsFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getCallTreeEnabledFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getCallTreeFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setCallTree:(NSArray *)callTree onModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getSensorStateFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastAlertTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastAlertCauseFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastClearTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastClearedByFromModel:(SubsystemModel *)modelObj;


+ (int)getAlarmSensitivitySecFromModel:(SubsystemModel *)modelObj;


+ (int)getAlarmSensitivityDeviceCountFromModel:(SubsystemModel *)modelObj;

+ (int)setAlarmSensitivityDeviceCount:(int)alarmSensitivityDeviceCount onModel:(SubsystemModel *)modelObj;


+ (int)getQuietPeriodSecFromModel:(SubsystemModel *)modelObj;

+ (int)setQuietPeriodSec:(int)quietPeriodSec onModel:(SubsystemModel *)modelObj;


+ (BOOL)getSilentAlarmFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setSilentAlarm:(BOOL)silentAlarm onModel:(SubsystemModel *)modelObj;


+ (BOOL)getWaterShutOffFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setWaterShutOff:(BOOL)waterShutOff onModel:(SubsystemModel *)modelObj;


+ (NSArray *)getSmokePreAlertDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getSmokePreAlertFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastSmokePreAlertTimeFromModel:(SubsystemModel *)modelObj;





/** Immediately puts the alarm into ALERT mode IF it is in READY.  The cause will be recorded as the lastAlertCause. */
+ (PMKPromise *) triggerWithCause:(NSString *)cause onModel:(Model *)modelObj;



/** Immediately clear and cancel the active alarm. */
+ (PMKPromise *) clearOnModel:(Model *)modelObj;



@end
