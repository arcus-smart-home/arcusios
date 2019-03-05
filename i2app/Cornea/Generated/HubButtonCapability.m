

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubButtonCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubButtonState=@"hubbutton:state";

NSString *const kAttrHubButtonDuration=@"hubbutton:duration";

NSString *const kAttrHubButtonStatechanged=@"hubbutton:statechanged";



NSString *const kEnumHubButtonStateRELEASED = @"RELEASED";
NSString *const kEnumHubButtonStatePRESSED = @"PRESSED";
NSString *const kEnumHubButtonStateDOUBLE_PRESSED = @"DOUBLE_PRESSED";


@implementation HubButtonCapability
+ (NSString *)namespace { return @"hubbutton"; }
+ (NSString *)name { return @"HubButton"; }

+ (NSString *)getStateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubButtonCapabilityLegacy getState:modelObj];
  
}

+ (NSString *)setState:(NSString *)state onModel:(HubModel *)modelObj {
  [HubButtonCapabilityLegacy setState:state model:modelObj];
  
  return [HubButtonCapabilityLegacy getState:modelObj];
  
}


+ (int)getDurationFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubButtonCapabilityLegacy getDuration:modelObj] intValue];
  
}


+ (NSDate *)getStatechangedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubButtonCapabilityLegacy getStatechanged:modelObj];
  
}



@end
