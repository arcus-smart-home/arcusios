

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The instantaneous flow measurement. */
extern NSString *const kAttrFlowFlow;





@interface FlowCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getFlowFromModel:(DeviceModel *)modelObj;





@end
