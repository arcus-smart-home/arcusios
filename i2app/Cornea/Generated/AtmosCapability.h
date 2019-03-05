

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Atmospheric air pressure. */
extern NSString *const kAttrAtmosPressure;





@interface AtmosCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getPressureFromModel:(DeviceModel *)modelObj;





@end
