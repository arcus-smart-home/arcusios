

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the state of the switch. Also used to set the state of the switch. */
extern NSString *const kAttrSwitchState;

/** Indicates whether operation of the physical switch toggle should be inverted, if supported. */
extern NSString *const kAttrSwitchInverted;

/** UTC date time of last state change */
extern NSString *const kAttrSwitchStatechanged;



extern NSString *const kEnumSwitchStateON;
extern NSString *const kEnumSwitchStateOFF;


@interface SwitchCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setState:(NSString *)state onModel:(DeviceModel *)modelObj;


+ (BOOL)getInvertedFromModel:(DeviceModel *)modelObj;

+ (BOOL)setInverted:(BOOL)inverted onModel:(DeviceModel *)modelObj;


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj;





@end
