

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;

















/** The addresses of all the currently triggered care-capable devices in this place. */
extern NSString *const kAttrCareSubsystemTriggeredDevices;

/** The addresses of all the currently inactive care-capable devices in this place. */
extern NSString *const kAttrCareSubsystemInactiveDevices;

/** This addresses of all the current care devices in this place. */
extern NSString *const kAttrCareSubsystemCareDevices;

/** The addresses of all the current care-capable devices in this place. */
extern NSString *const kAttrCareSubsystemCareCapableDevices;

/** The addresses of all the presence devices such as fobs in this place. */
extern NSString *const kAttrCareSubsystemPresenceDevices;

/** The list of ids of behaviors that are currently defined on the subsystem.  Use ListBehaviors to get details. */
extern NSString *const kAttrCareSubsystemBehaviors;

/** The list of ids of behaviors that are currently active */
extern NSString *const kAttrCareSubsystemActiveBehaviors;

/** Whether the care alarm is currently turned on or in visit mode.  During visit mode behaviors will not trigger the care alarm, but the care pendant may still generate a panic. */
extern NSString *const kAttrCareSubsystemAlarmMode;

/** Whether the alarm is currently going of or not. */
extern NSString *const kAttrCareSubsystemAlarmState;

/** The last time the alarm was fired. */
extern NSString *const kAttrCareSubsystemLastAlertTime;

/** The reason the alarm was fired. */
extern NSString *const kAttrCareSubsystemLastAlertCause;

/** A map of behavior id to timestamp of when a behavior was triggered during an alert.  This map will not be populated until the alarm enters the alert state. Note this will only include the first time a behavior was triggered during an alert.  For more detailed information see the history log. */
extern NSString *const kAttrCareSubsystemLastAlertTriggers;

/** The current state of acknowledgement:     PENDING - Arcus is attempting to notify the user that an alarm has been triggered     ACKNOWLEDGED - One of the persons from the call tree has acknowledged the alarm     FAILED - No one acknowledged the alarm but no one was available to acknowledged it. */
extern NSString *const kAttrCareSubsystemLastAcknowledgement;

/** The last time at which acknowledgement changed to ACKNOWLEDGED or FAILED.  This will be empty when lastAcknowledgement is PENDING. */
extern NSString *const kAttrCareSubsystemLastAcknowledgementTime;

/** The actor that acknowledge the alarm when lastAcknowledgement is ACKNOWLEDGED.  Otherwise this field will be empty. */
extern NSString *const kAttrCareSubsystemLastAcknowledgedBy;

/** The last time the alarm was disarmed.  This is the time that Disarm was requested, not the time at which CLEARING completed. */
extern NSString *const kAttrCareSubsystemLastClearTime;

/** The actor that disarmed the alarm, if available.  If it can&#x27;t be determined this will be empty. */
extern NSString *const kAttrCareSubsystemLastClearedBy;

/** Whether the call tree should be used or just the account owner should be notified in an alarm scenario.  This will currently be false when the place is on BASIC and true when the place is on PREMIUM. */
extern NSString *const kAttrCareSubsystemCallTreeEnabled;

/**  The call tree of users to notify when an alarm is triggered.  This list includes all the persons associated with the current place, whether or not they are alerted is determined by the boolean flag.  Order is determined by the order of the list. */
extern NSString *const kAttrCareSubsystemCallTree;

/** When true only notifications will be sent, alert devices will not be triggered. */
extern NSString *const kAttrCareSubsystemSilent;

/** Flag indicating that careDevices has been initialized from careCapableDevices.  This is to initialize the field a single time. Data FIX */
extern NSString *const kAttrCareSubsystemCareDevicesPopulated;


extern NSString *const kCmdCareSubsystemPanic;

extern NSString *const kCmdCareSubsystemAcknowledge;

extern NSString *const kCmdCareSubsystemClear;

extern NSString *const kCmdCareSubsystemListActivity;

extern NSString *const kCmdCareSubsystemListDetailedActivity;

extern NSString *const kCmdCareSubsystemListBehaviors;

extern NSString *const kCmdCareSubsystemListBehaviorTemplates;

extern NSString *const kCmdCareSubsystemAddBehavior;

extern NSString *const kCmdCareSubsystemUpdateBehavior;

extern NSString *const kCmdCareSubsystemRemoveBehavior;


extern NSString *const kEvtCareSubsystemBehaviorAlert;

extern NSString *const kEvtCareSubsystemBehaviorAlertCleared;

extern NSString *const kEvtCareSubsystemBehaviorAlertAcknowledged;

extern NSString *const kEvtCareSubsystemBehaviorAction;

extern NSString *const kEnumCareSubsystemAlarmModeON;
extern NSString *const kEnumCareSubsystemAlarmModeVISIT;
extern NSString *const kEnumCareSubsystemAlarmStateREADY;
extern NSString *const kEnumCareSubsystemAlarmStateALERT;
extern NSString *const kEnumCareSubsystemLastAcknowledgementPENDING;
extern NSString *const kEnumCareSubsystemLastAcknowledgementACKNOWLEDGED;
extern NSString *const kEnumCareSubsystemLastAcknowledgementFAILED;


@interface CareSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getTriggeredDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getInactiveDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getCareDevicesFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setCareDevices:(NSArray *)careDevices onModel:(SubsystemModel *)modelObj;


+ (NSArray *)getCareCapableDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getPresenceDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getBehaviorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getActiveBehaviorsFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getAlarmModeFromModel:(SubsystemModel *)modelObj;

+ (NSString *)setAlarmMode:(NSString *)alarmMode onModel:(SubsystemModel *)modelObj;


+ (NSString *)getAlarmStateFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastAlertTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastAlertCauseFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getLastAlertTriggersFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastAcknowledgementFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastAcknowledgementTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastAcknowledgedByFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastClearTimeFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getLastClearedByFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getCallTreeEnabledFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getCallTreeFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setCallTree:(NSArray *)callTree onModel:(SubsystemModel *)modelObj;


+ (BOOL)getSilentFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setSilent:(BOOL)silent onModel:(SubsystemModel *)modelObj;


+ (BOOL)getCareDevicesPopulatedFromModel:(SubsystemModel *)modelObj;





/**  */
+ (PMKPromise *) panicOnModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) acknowledgeOnModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) clearOnModel:(Model *)modelObj;



/** Creates a list of time buckets and indicates which care devices, optionally filtered, are triggered during that bucket. */
+ (PMKPromise *) listActivityWithStart:(double)start withEnd:(double)end withBucket:(int)bucket withDevices:(NSArray *)devices onModel:(Model *)modelObj;



/** Returns a list of all the history log entries associated with this subsystem. */
+ (PMKPromise *) listDetailedActivityWithLimit:(int)limit withToken:(NSString *)token withDevices:(NSArray *)devices onModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) listBehaviorsOnModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) listBehaviorTemplatesOnModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) addBehaviorWithBehavior:(id)behavior onModel:(Model *)modelObj;



/** Updates the requested attributes on the specified behavior. */
+ (PMKPromise *) updateBehaviorWithBehavior:(id)behavior onModel:(Model *)modelObj;



/** Updates the requested attributes on the specified behavior. */
+ (PMKPromise *) removeBehaviorWithId:(NSString *)id onModel:(Model *)modelObj;



@end
