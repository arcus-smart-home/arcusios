

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the speed of the device. Also used to set the speed of the device. */
extern NSString *const kAttrFanSpeed;

/** Determine the max speed as reported by the fan. */
extern NSString *const kAttrFanMaxSpeed;

/** Reflects the direction of air flow through the fan. */
extern NSString *const kAttrFanDirection;



extern NSString *const kEnumFanDirectionUP;
extern NSString *const kEnumFanDirectionDOWN;


@interface FanCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getSpeedFromModel:(DeviceModel *)modelObj;

+ (int)setSpeed:(int)speed onModel:(DeviceModel *)modelObj;


+ (int)getMaxSpeedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getDirectionFromModel:(DeviceModel *)modelObj;

+ (NSString *)setDirection:(NSString *)direction onModel:(DeviceModel *)modelObj;





@end
