

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current level of brightness, as a percentage. If ramping is not desired, this parameter can be set to immediately achieve the desired brightness level. */
extern NSString *const kAttrDimmerBrightness;

/** Reflects the target brightness, as a percentage, that the dimmer is ramping towards. This should be set to current brightness if ramping is complete. This parameter is read-only and should be controlled via the RampBrightness method if ramping is desired. */
extern NSString *const kAttrDimmerRampingtarget;

/** Number of seconds remaining at current ramping rate before brightness is equal to rampingtarget. When ramping is complete, this value should be set to 0. This parameter is read-only and should be controlled via the RampBrightness method if ramping is desired. */
extern NSString *const kAttrDimmerRampingtime;


extern NSString *const kCmdDimmerRampBrightness;

extern NSString *const kCmdDimmerIncrementBrightness;

extern NSString *const kCmdDimmerDecrementBrightness;




@interface DimmerCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getBrightnessFromModel:(DeviceModel *)modelObj;

+ (int)setBrightness:(int)brightness onModel:(DeviceModel *)modelObj;


+ (int)getRampingtargetFromModel:(DeviceModel *)modelObj;


+ (int)getRampingtimeFromModel:(DeviceModel *)modelObj;





/** Sets a rampingtarget and a rampingtime for the dimmer. Brightness must be 0..100, seconds must be a positive integer. */
+ (PMKPromise *) rampBrightnessWithBrightness:(int)brightness withSeconds:(int)seconds onModel:(Model *)modelObj;



/** Increments the brightness of the dimmer by a given amount. */
+ (PMKPromise *) incrementBrightnessWithAmount:(int)amount onModel:(Model *)modelObj;



/** Decrements the brightness of the dimmer by a given amount. */
+ (PMKPromise *) decrementBrightnessWithAmount:(int)amount onModel:(Model *)modelObj;



@end
