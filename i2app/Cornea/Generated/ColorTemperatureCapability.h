

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Current color temperature in degrees Kelvin. */
extern NSString *const kAttrColorTemperatureColortemp;

/** Warmest color temperature supported. */
extern NSString *const kAttrColorTemperatureMincolortemp;

/** Coolest color temperature supported. */
extern NSString *const kAttrColorTemperatureMaxcolortemp;





@interface ColorTemperatureCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getColortempFromModel:(DeviceModel *)modelObj;

+ (int)setColortemp:(int)colortemp onModel:(DeviceModel *)modelObj;


+ (int)getMincolortempFromModel:(DeviceModel *)modelObj;


+ (int)getMaxcolortempFromModel:(DeviceModel *)modelObj;





@end
