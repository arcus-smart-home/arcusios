

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/**  */
extern NSString *const kAttrCentraLiteSmartPlugHomeid;

/**  */
extern NSString *const kAttrCentraLiteSmartPlugNodeid;


extern NSString *const kCmdCentraLiteSmartPlugSetLearnMode;

extern NSString *const kCmdCentraLiteSmartPlugSendNif;

extern NSString *const kCmdCentraLiteSmartPlugReset;

extern NSString *const kCmdCentraLiteSmartPlugPair;

extern NSString *const kCmdCentraLiteSmartPlugQuery;




@interface CentraLiteSmartPlugCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getHomeidFromModel:(DeviceModel *)modelObj;


+ (NSString *)getNodeidFromModel:(DeviceModel *)modelObj;





/** Causes the Z-Wave side of the device to enter into learn mode for the specified duration. */
+ (PMKPromise *) setLearnModeOnModel:(Model *)modelObj;



/** Causes the Z-Wave side of the device to send a NIF frame. */
+ (PMKPromise *) sendNifOnModel:(Model *)modelObj;



/** Causes the Z-Wave side of the device to reset. */
+ (PMKPromise *) resetOnModel:(Model *)modelObj;



/** Attempt to pair the Z-Wave side of the device. */
+ (PMKPromise *) pairOnModel:(Model *)modelObj;



/** Attempt to determine the Z-Wave side node and home id. */
+ (PMKPromise *) queryOnModel:(Model *)modelObj;



@end
