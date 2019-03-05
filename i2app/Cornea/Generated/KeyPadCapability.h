

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/**           Current alarm state of the keypad.          Generally this should only be controlled via the specific methods (BeginArming, Armed, Disarmed, Soaking, Alerting).          However it may be set manually in case the keypad is no longer in sync with the security system.  In this case the          keypad should avoid making transition noises (such as the armed or disarmed beeps).  However if the state is          ARMING, SOAKING, or ALERTING and the associated sounds are enabled it should beep accordingly.           */
extern NSString *const kAttrKeyPadAlarmState;

/**           The current mode of the alarm.          Generally this should only be controlled via the specific methods (BeginArming, Armed, Disarmed, Soaking, Alerting).          However it may be set manually in case the keypad is no longer in sync with the security system.           */
extern NSString *const kAttrKeyPadAlarmMode;

/**           DEPRECATED           When set to ON enabledSounds should be set to [BUTTONS,DISARMED,ARMED,ARMING,SOAKING,ALERTING].          When set to OFF enabledSounds should be set to [].          If enabledSounds is set to a value other than [] this should be changed to ON.          If both alarmSounder and enabledSounds are set in the same request an error should be thrown.           */
extern NSString *const kAttrKeyPadAlarmSounder;

/**           This contains the set of times when the keypad should play tones, the common combinations are:          Keypad Sounds On  / Normal Alarm  - [BUTTONS,DISARMED,ARMED,ARMING,SOAKING,ALERTING]          Keypad Sounds Off / Normal Alarm  - [ALERTING]          Keypad Sounds On  / Silent Alarm  - [BUTTONS,DISARMED,ARMED,ARMING]          Keypad Sounds Off / Silent Alarm  - []                    Each sound should be enabled if it is present in the set or disabled if it is not present:          BUTTONS - Button presses should beep          DISARMED - Play a tone when the keypad disarms          ARMING - Play an exit delay tone          ARMED - Play a tone when the keypad is armed          SOAKING - Play an entrance delay tone          ALERTING - Play an alert tone           */
extern NSString *const kAttrKeyPadEnabledSounds;


extern NSString *const kCmdKeyPadBeginArming;

extern NSString *const kCmdKeyPadArmed;

extern NSString *const kCmdKeyPadDisarmed;

extern NSString *const kCmdKeyPadSoaking;

extern NSString *const kCmdKeyPadAlerting;

extern NSString *const kCmdKeyPadChime;

extern NSString *const kCmdKeyPadArmingUnavailable;


extern NSString *const kEvtKeyPadArmPressed;

extern NSString *const kEvtKeyPadDisarmPressed;

extern NSString *const kEvtKeyPadPanicPressed;

extern NSString *const kEvtKeyPadInvalidPinEntered;

extern NSString *const kEnumKeyPadAlarmStateDISARMED;
extern NSString *const kEnumKeyPadAlarmStateARMED;
extern NSString *const kEnumKeyPadAlarmStateARMING;
extern NSString *const kEnumKeyPadAlarmStateALERTING;
extern NSString *const kEnumKeyPadAlarmStateSOAKING;
extern NSString *const kEnumKeyPadAlarmModeON;
extern NSString *const kEnumKeyPadAlarmModePARTIAL;
extern NSString *const kEnumKeyPadAlarmModeOFF;
extern NSString *const kEnumKeyPadAlarmSounderON;
extern NSString *const kEnumKeyPadAlarmSounderOFF;


@interface KeyPadCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getAlarmStateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setAlarmState:(NSString *)alarmState onModel:(DeviceModel *)modelObj;


+ (NSString *)getAlarmModeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setAlarmMode:(NSString *)alarmMode onModel:(DeviceModel *)modelObj;


+ (NSString *)getAlarmSounderFromModel:(DeviceModel *)modelObj;

+ (NSString *)setAlarmSounder:(NSString *)alarmSounder onModel:(DeviceModel *)modelObj;


+ (NSArray *)getEnabledSoundsFromModel:(DeviceModel *)modelObj;

+ (NSArray *)setEnabledSounds:(NSArray *)enabledSounds onModel:(DeviceModel *)modelObj;





/**           Tell the Keypad that the arming process has started (exit delay), if sounds are enabled this should beep for the specified period.          The delay should be used to allow the beep to speed up as the end of the time window is reached.          The driver should update alarmState to ARMING and alarmMode to match the requested alarmMode.           */
+ (PMKPromise *) beginArmingWithDelayInS:(int)delayInS withAlarmMode:(NSString *)alarmMode onModel:(Model *)modelObj;



/**           Tell the Keypad that it has been armed, if sounds are enabled it should beep the tone matching the given mode.          This should update alarmState to ARMED and alarmMode to match the requested alarmMode.           */
+ (PMKPromise *) armedWithAlarmMode:(NSString *)alarmMode onModel:(Model *)modelObj;



/**           Tell the Keypad that it has been armed, if sounds are enabled it should beep the tone matching the given mode.          This should update alarmState to ARMED and alarmMode to match the requested alarmMode.           */
+ (PMKPromise *) disarmedOnModel:(Model *)modelObj;



/**           Tell the Keypad that the alarm is preparing to go off (entrance delay), if sounds are enabled it should beep the tone matching the given mode.          The duration should be used to allow the beep to speed up as the end of the time window is reached.          This should update alarmState to SOAKING and alarmMode to match the requested alarmMode.           */
+ (PMKPromise *) soakingWithDurationInS:(int)durationInS withAlarmMode:(NSString *)alarmMode onModel:(Model *)modelObj;



/**           Tell the Keypad that the alarm is currently alerting.          This should update alarmState to ALERTING and alarmMode to match the requested alarmMode.           */
+ (PMKPromise *) alertingWithAlarmMode:(NSString *)alarmMode onModel:(Model *)modelObj;



/** Tell the Keypad to make a chime noise. */
+ (PMKPromise *) chimeOnModel:(Model *)modelObj;



/** Tell the Keypad that the arming process cannot be started due to triggered devices */
+ (PMKPromise *) armingUnavailableOnModel:(Model *)modelObj;



@end
