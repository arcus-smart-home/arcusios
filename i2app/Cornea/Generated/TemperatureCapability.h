

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects a temperature measurement taken from a thermistor. */
extern NSString *const kAttrTemperatureTemperature;





@interface TemperatureCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getTemperatureFromModel:(DeviceModel *)modelObj;





@end
