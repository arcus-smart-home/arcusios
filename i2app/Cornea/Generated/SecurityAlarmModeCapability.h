

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/** The addresses of all the security devices that participate in this mode. */
extern NSString *const kAttrSecurityAlarmModeDevices;

/** The amount of time an alarm device must be triggering for before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
extern NSString *const kAttrSecurityAlarmModeEntranceDelaySec;

/** The amount of time before the alarm is fully armed.&lt;br/&gt;&lt;b&gt;Default: 30&lt;/b&gt; */
extern NSString *const kAttrSecurityAlarmModeExitDelaySec;

/** The number of alarm devices which must trigger before the alarm is fired.&lt;br/&gt;&lt;b&gt;Default: 1&lt;/b&gt; */
extern NSString *const kAttrSecurityAlarmModeAlarmSensitivityDeviceCount;

/** When true only notifications will be sent, alert devices will not be triggered. */
extern NSString *const kAttrSecurityAlarmModeSilent;

/** Hub and keypad make sounds when arming.&lt;br/&gt;&lt;b&gt;Default: true&lt;/b&gt; */
extern NSString *const kAttrSecurityAlarmModeSoundsEnabled;

/** The number of the number of motion sensors associated with this mode */
extern NSString *const kAttrSecurityAlarmModeMotionSensorCount;





@interface SecurityAlarmModeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getDevicesFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setDevices:(NSArray *)devices onModel:(SubsystemModel *)modelObj;


+ (int)getEntranceDelaySecFromModel:(SubsystemModel *)modelObj;

+ (int)setEntranceDelaySec:(int)entranceDelaySec onModel:(SubsystemModel *)modelObj;


+ (int)getExitDelaySecFromModel:(SubsystemModel *)modelObj;

+ (int)setExitDelaySec:(int)exitDelaySec onModel:(SubsystemModel *)modelObj;


+ (int)getAlarmSensitivityDeviceCountFromModel:(SubsystemModel *)modelObj;

+ (int)setAlarmSensitivityDeviceCount:(int)alarmSensitivityDeviceCount onModel:(SubsystemModel *)modelObj;


+ (BOOL)getSilentFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setSilent:(BOOL)silent onModel:(SubsystemModel *)modelObj;


+ (BOOL)getSoundsEnabledFromModel:(SubsystemModel *)modelObj;

+ (BOOL)setSoundsEnabled:(BOOL)soundsEnabled onModel:(SubsystemModel *)modelObj;


+ (int)getMotionSensorCountFromModel:(SubsystemModel *)modelObj;

+ (int)setMotionSensorCount:(int)motionSensorCount onModel:(SubsystemModel *)modelObj;





@end
