

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the ratio of volume of water per volume of soil (0.0 = No Moisture, 0.5 = Completely Saturated). */
extern NSString *const kAttrSoilMoistureWatercontent;

/** Reflects the type of soil in which the water content is being measured. Defaults to NORMAL. */
extern NSString *const kAttrSoilMoistureSoiltype;

/** UTC date time of when Water Content value was reported by sensor. */
extern NSString *const kAttrSoilMoistureWatercontentupdated;



extern NSString *const kEnumSoilMoistureSoiltypeNORMAL;
extern NSString *const kEnumSoilMoistureSoiltypeSANDY;
extern NSString *const kEnumSoilMoistureSoiltypeCLAY;


@interface SoilMoistureCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getWatercontentFromModel:(DeviceModel *)modelObj;


+ (NSString *)getSoiltypeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setSoiltype:(NSString *)soiltype onModel:(DeviceModel *)modelObj;


+ (NSDate *)getWatercontentupdatedFromModel:(DeviceModel *)modelObj;





@end
