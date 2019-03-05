

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the relative humidity */
extern NSString *const kAttrRelativeHumidityHumidity;





@interface RelativeHumidityCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getHumidityFromModel:(DeviceModel *)modelObj;





@end
