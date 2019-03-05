

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The parent device&#x27;s protocol address. */
extern NSString *const kAttrBridgeChildParentAddress;

/** The id assigned to this child device by its parent bridge device. */
extern NSString *const kAttrBridgeChildBridgeSpecificId;





@interface BridgeChildCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getParentAddressFromModel:(DeviceModel *)modelObj;


+ (NSString *)getBridgeSpecificIdFromModel:(DeviceModel *)modelObj;





@end
