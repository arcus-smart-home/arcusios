

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Hardness of water in grains per gallon */
extern NSString *const kAttrWaterHardnessHardness;





@interface WaterHardnessCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getHardnessFromModel:(DeviceModel *)modelObj;





@end
