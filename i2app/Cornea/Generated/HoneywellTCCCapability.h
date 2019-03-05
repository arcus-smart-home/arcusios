

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Set to true when the end user needs to login into their Honeywell account to refresh tokens */
extern NSString *const kAttrHoneywellTCCRequiresLogin;

/** Whether the device is currently authorized for use by Arcus */
extern NSString *const kAttrHoneywellTCCAuthorizationState;



extern NSString *const kEnumHoneywellTCCAuthorizationStateAUTHORIZED;
extern NSString *const kEnumHoneywellTCCAuthorizationStateDEAUTHORIZED;


@interface HoneywellTCCCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getRequiresLoginFromModel:(DeviceModel *)modelObj;


+ (NSString *)getAuthorizationStateFromModel:(DeviceModel *)modelObj;





@end
