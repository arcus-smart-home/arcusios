

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DeviceCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDeviceAccount=@"dev:account";

NSString *const kAttrDevicePlace=@"dev:place";

NSString *const kAttrDeviceDevtypehint=@"dev:devtypehint";

NSString *const kAttrDeviceName=@"dev:name";

NSString *const kAttrDeviceVendor=@"dev:vendor";

NSString *const kAttrDeviceModel=@"dev:model";

NSString *const kAttrDeviceProductId=@"dev:productId";


NSString *const kCmdDeviceListHistoryEntries=@"dev:ListHistoryEntries";

NSString *const kCmdDeviceRemove=@"dev:Remove";

NSString *const kCmdDeviceForceRemove=@"dev:ForceRemove";


NSString *const kEvtDeviceDeviceConnected=@"dev:DeviceConnected";

NSString *const kEvtDeviceDeviceDisconnected=@"dev:DeviceDisconnected";

NSString *const kEvtDeviceDeviceRemoved=@"dev:DeviceRemoved";



@implementation DeviceCapability
+ (NSString *)namespace { return @"dev"; }
+ (NSString *)name { return @"Device"; }

+ (NSString *)getAccountFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceCapabilityLegacy getAccount:modelObj];
  
}


+ (NSString *)getPlaceFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceCapabilityLegacy getPlace:modelObj];
  
}


+ (NSString *)getDevtypehintFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceCapabilityLegacy getDevtypehint:modelObj];
  
}


+ (NSString *)getNameFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceCapabilityLegacy getName:modelObj];
  
}

+ (NSString *)setName:(NSString *)name onModel:(DeviceModel *)modelObj {
  [DeviceCapabilityLegacy setName:name model:modelObj];
  
  return [DeviceCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getVendorFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceCapabilityLegacy getVendor:modelObj];
  
}


+ (NSString *)getModelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceCapabilityLegacy getModel:modelObj];
  
}


+ (NSString *)getProductIdFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceCapabilityLegacy getProductId:modelObj];
  
}




+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(DeviceModel *)modelObj {
  return [DeviceCapabilityLegacy listHistoryEntries:modelObj limit:limit token:token];

}


+ (PMKPromise *) removeWithTimeout:(long)timeout onModel:(DeviceModel *)modelObj {
  return [DeviceCapabilityLegacy remove:modelObj timeout:timeout];

}


+ (PMKPromise *) forceRemoveOnModel:(DeviceModel *)modelObj {
  return [DeviceCapabilityLegacy forceRemove:modelObj ];
}

@end
