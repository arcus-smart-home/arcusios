

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;




extern NSString *const kCmdDeviceMockSetAttributes;

extern NSString *const kCmdDeviceMockConnect;

extern NSString *const kCmdDeviceMockDisconnect;




@interface DeviceMockCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;




/** Sets the attributes on the mock device */
+ (PMKPromise *) setAttributesWithAttrs:(NSDictionary *)attrs onModel:(Model *)modelObj;



/** Causes the device to connect */
+ (PMKPromise *) connectOnModel:(Model *)modelObj;



/** Causes the device to disconnect */
+ (PMKPromise *) disconnectOnModel:(Model *)modelObj;



@end
