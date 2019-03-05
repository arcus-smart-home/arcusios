

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Indicates whether sensor believes it is day or night */
extern NSString *const kAttrDayNightSensorMode;

/** UTC date time of last mode change */
extern NSString *const kAttrDayNightSensorModechanged;



extern NSString *const kEnumDayNightSensorModeday;
extern NSString *const kEnumDayNightSensorModenight;


@interface DayNightSensorCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getModeFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getModechangedFromModel:(DeviceModel *)modelObj;





@end
