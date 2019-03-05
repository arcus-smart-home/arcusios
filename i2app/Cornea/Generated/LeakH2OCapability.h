

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the state of the leak detector. */
extern NSString *const kAttrLeakH2OState;

/** UTC date time of last state change */
extern NSString *const kAttrLeakH2OStatechanged;


extern NSString *const kCmdLeakH2OLeakh2o;


extern NSString *const kEnumLeakH2OStateSAFE;
extern NSString *const kEnumLeakH2OStateLEAK;


@interface LeakH2OCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setState:(NSString *)state onModel:(DeviceModel *)modelObj;


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj;





/**  */
+ (PMKPromise *) leakh2oWithState:(NSString *)state onModel:(Model *)modelObj;



@end
