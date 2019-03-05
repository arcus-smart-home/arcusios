

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Current operating mode fo the system. */
extern NSString *const kAttrLutronBridgeOperatingmode;

/** Serial number of the device. */
extern NSString *const kAttrLutronBridgeSerialnumber;



extern NSString *const kEnumLutronBridgeOperatingmodeSTARTUP;
extern NSString *const kEnumLutronBridgeOperatingmodeNORMAL;
extern NSString *const kEnumLutronBridgeOperatingmodeASSOCIATION;
extern NSString *const kEnumLutronBridgeOperatingmodeERROR;


@interface LutronBridgeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getOperatingmodeFromModel:(DeviceModel *)modelObj;


+ (NSString *)getSerialnumberFromModel:(DeviceModel *)modelObj;





@end
