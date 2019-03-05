

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects whether or not a natural gas leak has been detected by the sensor. */
extern NSString *const kAttrLeakGasState;

/** UTC date time of last state change */
extern NSString *const kAttrLeakGasStatechanged;



extern NSString *const kEnumLeakGasStateSAFE;
extern NSString *const kEnumLeakGasStateLEAK;


@interface LeakGasCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj;





@end
