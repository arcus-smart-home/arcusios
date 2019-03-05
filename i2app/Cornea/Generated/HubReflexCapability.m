

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubReflexCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubReflexNumDrivers=@"hubrflx:numDrivers";

NSString *const kAttrHubReflexDbHash=@"hubrflx:dbHash";

NSString *const kAttrHubReflexNumDevices=@"hubrflx:numDevices";

NSString *const kAttrHubReflexNumPins=@"hubrflx:numPins";

NSString *const kAttrHubReflexVersionSupported=@"hubrflx:versionSupported";



NSString *const kEvtHubReflexSyncNeeded=@"hubrflx:SyncNeeded";



@implementation HubReflexCapability
+ (NSString *)namespace { return @"hubrflx"; }
+ (NSString *)name { return @"HubReflex"; }

+ (int)getNumDriversFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubReflexCapabilityLegacy getNumDrivers:modelObj] intValue];
  
}


+ (NSString *)getDbHashFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubReflexCapabilityLegacy getDbHash:modelObj];
  
}


+ (int)getNumDevicesFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubReflexCapabilityLegacy getNumDevices:modelObj] intValue];
  
}


+ (int)getNumPinsFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubReflexCapabilityLegacy getNumPins:modelObj] intValue];
  
}


+ (int)getVersionSupportedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubReflexCapabilityLegacy getVersionSupported:modelObj] intValue];
  
}



@end
