

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the state of the carbon monoxide presence. When &#x27;DETECTED&#x27; the sensor has detected CO, when &#x27;SAFE&#x27; no CO has been detected. */
extern NSString *const kAttrCarbonMonoxideCo;

/** Reflects the state of the carbon monoxide sensor itself. When &#x27;OK&#x27; the sensor is operational, when &#x27;EOL&#x27; the sensor has reached its &#x27;end-of-life&#x27; and should be replaced. */
extern NSString *const kAttrCarbonMonoxideEol;

/** UTC date time of last co change */
extern NSString *const kAttrCarbonMonoxideCochanged;

/** Measured value of the Carbon Monoxide in the room in parts per million */
extern NSString *const kAttrCarbonMonoxideCoppm;



extern NSString *const kEnumCarbonMonoxideCoSAFE;
extern NSString *const kEnumCarbonMonoxideCoDETECTED;
extern NSString *const kEnumCarbonMonoxideEolOK;
extern NSString *const kEnumCarbonMonoxideEolEOL;


@interface CarbonMonoxideCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getCoFromModel:(DeviceModel *)modelObj;


+ (NSString *)getEolFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getCochangedFromModel:(DeviceModel *)modelObj;


+ (long)getCoppmFromModel:(DeviceModel *)modelObj;





@end
