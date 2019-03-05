

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubHueCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubHueBridgesAvailable=@"hubhue:bridgesAvailable";

NSString *const kAttrHubHueBridgesPaired=@"hubhue:bridgesPaired";

NSString *const kAttrHubHueLightsAvailable=@"hubhue:lightsAvailable";

NSString *const kAttrHubHueLightsPaired=@"hubhue:lightsPaired";


NSString *const kCmdHubHueReset=@"hubhue:Reset";




@implementation HubHueCapability
+ (NSString *)namespace { return @"hubhue"; }
+ (NSString *)name { return @"HubHue"; }

+ (NSDictionary *)getBridgesAvailableFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubHueCapabilityLegacy getBridgesAvailable:modelObj];
  
}


+ (NSDictionary *)getBridgesPairedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubHueCapabilityLegacy getBridgesPaired:modelObj];
  
}


+ (NSDictionary *)getLightsAvailableFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubHueCapabilityLegacy getLightsAvailable:modelObj];
  
}


+ (NSDictionary *)getLightsPairedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubHueCapabilityLegacy getLightsPaired:modelObj];
  
}




+ (PMKPromise *) resetOnModel:(HubModel *)modelObj {
  return [HubHueCapabilityLegacy reset:modelObj ];
}

@end
