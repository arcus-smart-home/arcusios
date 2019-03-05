

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Indicates whether or not the device is experiencing excessive water flow */
extern NSString *const kAttrEcowaterWaterSoftenerExcessiveUse;

/** Indicates whether or not the device is experiencing continuous water flow */
extern NSString *const kAttrEcowaterWaterSoftenerContinuousUse;

/** Number of seconds where flow must meet or exceed continuousRate before continuousUse will be marked true */
extern NSString *const kAttrEcowaterWaterSoftenerContinuousDuration;

/** Flow threshold in gallons per minute used to determine continuousUse */
extern NSString *const kAttrEcowaterWaterSoftenerContinuousRate;

/** Indicates whether the user wants to receive continuous use notifications */
extern NSString *const kAttrEcowaterWaterSoftenerAlertOnContinuousUse;

/** Indicates whether the user wants to receive excessive use notifications */
extern NSString *const kAttrEcowaterWaterSoftenerAlertOnExcessiveUse;





@interface EcowaterWaterSoftenerCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getExcessiveUseFromModel:(DeviceModel *)modelObj;


+ (BOOL)getContinuousUseFromModel:(DeviceModel *)modelObj;


+ (int)getContinuousDurationFromModel:(DeviceModel *)modelObj;

+ (int)setContinuousDuration:(int)continuousDuration onModel:(DeviceModel *)modelObj;


+ (double)getContinuousRateFromModel:(DeviceModel *)modelObj;

+ (double)setContinuousRate:(double)continuousRate onModel:(DeviceModel *)modelObj;


+ (BOOL)getAlertOnContinuousUseFromModel:(DeviceModel *)modelObj;

+ (BOOL)setAlertOnContinuousUse:(BOOL)alertOnContinuousUse onModel:(DeviceModel *)modelObj;


+ (BOOL)getAlertOnExcessiveUseFromModel:(DeviceModel *)modelObj;

+ (BOOL)setAlertOnExcessiveUse:(BOOL)alertOnExcessiveUse onModel:(DeviceModel *)modelObj;





@end
