

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current state of the button where pressed implies the user has pressed the button and released the opposite. Also used to set the state of the button. */
extern NSString *const kAttrButtonState;

/** UTC date time of last state change */
extern NSString *const kAttrButtonStatechanged;



extern NSString *const kEnumButtonStatePRESSED;
extern NSString *const kEnumButtonStateRELEASED;


@interface ButtonCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setState:(NSString *)state onModel:(DeviceModel *)modelObj;


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj;





@end
