

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current illuminance measured by the device. */
extern NSString *const kAttrIlluminanceIlluminance;

/** Reflects the type of illuminance sensor included in the device. */
extern NSString *const kAttrIlluminanceSensorType;



extern NSString *const kEnumIlluminanceSensorTypePHOTODIODE;
extern NSString *const kEnumIlluminanceSensorTypeCMOS;


@interface IlluminanceCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getIlluminanceFromModel:(DeviceModel *)modelObj;


+ (NSString *)getSensorTypeFromModel:(DeviceModel *)modelObj;





@end
