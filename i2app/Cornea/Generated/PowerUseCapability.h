

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects an instantaneous power reading from the device. */
extern NSString *const kAttrPowerUseInstantaneous;

/** Reflects the cumulative power reading from the device if possible. */
extern NSString *const kAttrPowerUseCumulative;

/** If true, this represents a whole-home meter. */
extern NSString *const kAttrPowerUseWholehome;





@interface PowerUseCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getInstantaneousFromModel:(DeviceModel *)modelObj;


+ (double)getCumulativeFromModel:(DeviceModel *)modelObj;


+ (BOOL)getWholehomeFromModel:(DeviceModel *)modelObj;





@end
