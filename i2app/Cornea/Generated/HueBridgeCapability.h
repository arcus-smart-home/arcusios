

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Ip address of the hue bridge */
extern NSString *const kAttrHueBridgeIpaddress;

/** Mac address of the hue bridge ethernet port */
extern NSString *const kAttrHueBridgeMac;

/** Api version of the hue bridge */
extern NSString *const kAttrHueBridgeApiversion;

/** Software version of the hue bridge */
extern NSString *const kAttrHueBridgeSwversion;

/** Zigbee channel of hte hue bridge */
extern NSString *const kAttrHueBridgeZigbeechannel;

/** Model id of the hue bridge */
extern NSString *const kAttrHueBridgeModel;

/** Id of the hue bridge */
extern NSString *const kAttrHueBridgeBridgeid;





@interface HueBridgeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getIpaddressFromModel:(DeviceModel *)modelObj;


+ (NSString *)getMacFromModel:(DeviceModel *)modelObj;


+ (NSString *)getApiversionFromModel:(DeviceModel *)modelObj;


+ (NSString *)getSwversionFromModel:(DeviceModel *)modelObj;


+ (NSString *)getZigbeechannelFromModel:(DeviceModel *)modelObj;


+ (NSString *)getModelFromModel:(DeviceModel *)modelObj;


+ (NSString *)getBridgeidFromModel:(DeviceModel *)modelObj;





@end
