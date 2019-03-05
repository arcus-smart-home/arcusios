

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class AlarmModel;



/** The current state of this alert. */
extern NSString *const kAttrAlarmAlertState;

/** The addresses of all the devices that are able to participate in this alarm. */
extern NSString *const kAttrAlarmDevices;

/** The addresses of the devices that are excluded from participating in this alarm. */
extern NSString *const kAttrAlarmExcludedDevices;

/** The addresses of the devices that are participating in this alarm. */
extern NSString *const kAttrAlarmActiveDevices;

/** The addresses of the devices would be active except they have fallen offline. */
extern NSString *const kAttrAlarmOfflineDevices;

/** The addresses of the devices which are currently triggered. */
extern NSString *const kAttrAlarmTriggeredDevices;

/** The triggers associated with the current alert. */
extern NSString *const kAttrAlarmTriggers;

/** True if this alarm is professionally monitored. */
extern NSString *const kAttrAlarmMonitored;

/** When true only notifications will be sent, alert devices / keypads will not sound. */
extern NSString *const kAttrAlarmSilent;



extern NSString *const kEnumAlarmAlertStateINACTIVE;
extern NSString *const kEnumAlarmAlertStateDISARMED;
extern NSString *const kEnumAlarmAlertStateARMING;
extern NSString *const kEnumAlarmAlertStateREADY;
extern NSString *const kEnumAlarmAlertStatePREALERT;
extern NSString *const kEnumAlarmAlertStateALERT;
extern NSString *const kEnumAlarmAlertStateCLEARING;


@interface AlarmCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getAlertStateFromModel:(AlarmModel *)modelObj;


+ (NSArray *)getDevicesFromModel:(AlarmModel *)modelObj;


+ (NSArray *)getExcludedDevicesFromModel:(AlarmModel *)modelObj;


+ (NSArray *)getActiveDevicesFromModel:(AlarmModel *)modelObj;


+ (NSArray *)getOfflineDevicesFromModel:(AlarmModel *)modelObj;


+ (NSArray *)getTriggeredDevicesFromModel:(AlarmModel *)modelObj;


+ (NSArray *)getTriggersFromModel:(AlarmModel *)modelObj;


+ (BOOL)getMonitoredFromModel:(AlarmModel *)modelObj;


+ (BOOL)getSilentFromModel:(AlarmModel *)modelObj;

+ (BOOL)setSilent:(BOOL)silent onModel:(Model *)modelObj;





@end
