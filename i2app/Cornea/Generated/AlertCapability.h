

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current state of the alert where quiet means that whatever alarm the device is now silent and alerting implies the device is currently alarming (blinking lights, making some noise). */
extern NSString *const kAttrAlertState;

/** Maximum number of seconds that the alert device will stay in alerting state before it will be reset to quiet automatically by its driver. 0 = No Limit. */
extern NSString *const kAttrAlertMaxAlertSecs;

/** Default value of maxAlertSecs. */
extern NSString *const kAttrAlertDefaultMaxAlertSecs;

/** The last time this device went to alert state. */
extern NSString *const kAttrAlertLastAlertTime;



extern NSString *const kEnumAlertStateQUIET;
extern NSString *const kEnumAlertStateALERTING;


@interface AlertCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setState:(NSString *)state onModel:(DeviceModel *)modelObj;


+ (int)getMaxAlertSecsFromModel:(DeviceModel *)modelObj;

+ (int)setMaxAlertSecs:(int)maxAlertSecs onModel:(DeviceModel *)modelObj;


+ (int)getDefaultMaxAlertSecsFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getLastAlertTimeFromModel:(DeviceModel *)modelObj;





@end
