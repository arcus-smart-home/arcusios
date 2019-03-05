

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the state of the motion sensor. When detected the motion sensor has detected motion, when none no motion has been detected. */
extern NSString *const kAttrMotionMotion;

/** UTC date time of last motion change */
extern NSString *const kAttrMotionMotionchanged;

/** A set of sensitivities that are supported by this motion sensor.  If the set is null or empty modification of the sensitivity is not supported. */
extern NSString *const kAttrMotionSensitivitiesSupported;

/** The sensitivity of the motion sensor where:  OFF:   Implies that the motion sensor is disabled and will not detect motion LOW:   Arcust possible detection sensitivity MED:   Moderate detection sensitivity HIGH:  High detection sensitivity MAX:   Maximum sensitivity the device can be set to.  This will be null for motion sensors that do not support modification of sensitivity.  */
extern NSString *const kAttrMotionSensitivity;



extern NSString *const kEnumMotionMotionNONE;
extern NSString *const kEnumMotionMotionDETECTED;
extern NSString *const kEnumMotionSensitivityOFF;
extern NSString *const kEnumMotionSensitivityLOW;
extern NSString *const kEnumMotionSensitivityMED;
extern NSString *const kEnumMotionSensitivityHIGH;
extern NSString *const kEnumMotionSensitivityMAX;


@interface MotionCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getMotionFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getMotionchangedFromModel:(DeviceModel *)modelObj;


+ (NSArray *)getSensitivitiesSupportedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getSensitivityFromModel:(DeviceModel *)modelObj;

+ (NSString *)setSensitivity:(NSString *)sensitivity onModel:(DeviceModel *)modelObj;





@end
