

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CentraLiteSmartPlugCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCentraLiteSmartPlugHomeid=@"centralitesmartplug:homeid";

NSString *const kAttrCentraLiteSmartPlugNodeid=@"centralitesmartplug:nodeid";


NSString *const kCmdCentraLiteSmartPlugSetLearnMode=@"centralitesmartplug:SetLearnMode";

NSString *const kCmdCentraLiteSmartPlugSendNif=@"centralitesmartplug:SendNif";

NSString *const kCmdCentraLiteSmartPlugReset=@"centralitesmartplug:Reset";

NSString *const kCmdCentraLiteSmartPlugPair=@"centralitesmartplug:Pair";

NSString *const kCmdCentraLiteSmartPlugQuery=@"centralitesmartplug:Query";




@implementation CentraLiteSmartPlugCapability
+ (NSString *)namespace { return @"centralitesmartplug"; }
+ (NSString *)name { return @"CentraLiteSmartPlug"; }

+ (NSString *)getHomeidFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CentraLiteSmartPlugCapabilityLegacy getHomeid:modelObj];
  
}


+ (NSString *)getNodeidFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CentraLiteSmartPlugCapabilityLegacy getNodeid:modelObj];
  
}




+ (PMKPromise *) setLearnModeOnModel:(DeviceModel *)modelObj {
  return [CentraLiteSmartPlugCapabilityLegacy setLearnMode:modelObj ];
}


+ (PMKPromise *) sendNifOnModel:(DeviceModel *)modelObj {
  return [CentraLiteSmartPlugCapabilityLegacy sendNif:modelObj ];
}


+ (PMKPromise *) resetOnModel:(DeviceModel *)modelObj {
  return [CentraLiteSmartPlugCapabilityLegacy reset:modelObj ];
}


+ (PMKPromise *) pairOnModel:(DeviceModel *)modelObj {
  return [CentraLiteSmartPlugCapabilityLegacy pair:modelObj ];
}


+ (PMKPromise *) queryOnModel:(DeviceModel *)modelObj {
  return [CentraLiteSmartPlugCapabilityLegacy query:modelObj ];
}

@end
