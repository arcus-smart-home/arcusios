

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Current local IP address */
extern NSString *const kAttrIpInfoIp;

/** MAC Address */
extern NSString *const kAttrIpInfoMac;

/** Current network mask */
extern NSString *const kAttrIpInfoNetmask;

/** Current gateway IP address */
extern NSString *const kAttrIpInfoGateway;





@interface IpInfoCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getIpFromModel:(DeviceModel *)modelObj;


+ (NSString *)getMacFromModel:(DeviceModel *)modelObj;


+ (NSString *)getNetmaskFromModel:(DeviceModel *)modelObj;


+ (NSString *)getGatewayFromModel:(DeviceModel *)modelObj;





@end
