

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;




extern NSString *const kCmdIdentifyIdentify;




@interface IdentifyCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;




/** Causes this device to identify itself by blinking an LED or playing a sound.  This method should not return a response to a request until the device has started its notification.  It is expected notification will last for a short period of time, and this call will be repeated often.  A second call to Identify while the device is already actively identifying itself should be a no-op and return immediately. */
+ (PMKPromise *) identifyOnModel:(Model *)modelObj;



@end
