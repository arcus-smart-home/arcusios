

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HoneywellTCCCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHoneywellTCCRequiresLogin=@"honeywelltcc:requiresLogin";

NSString *const kAttrHoneywellTCCAuthorizationState=@"honeywelltcc:authorizationState";



NSString *const kEnumHoneywellTCCAuthorizationStateAUTHORIZED = @"AUTHORIZED";
NSString *const kEnumHoneywellTCCAuthorizationStateDEAUTHORIZED = @"DEAUTHORIZED";


@implementation HoneywellTCCCapability
+ (NSString *)namespace { return @"honeywelltcc"; }
+ (NSString *)name { return @"HoneywellTCC"; }

+ (BOOL)getRequiresLoginFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HoneywellTCCCapabilityLegacy getRequiresLogin:modelObj] boolValue];
  
}


+ (NSString *)getAuthorizationStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HoneywellTCCCapabilityLegacy getAuthorizationState:modelObj];
  
}



@end
