

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HueBridgeCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHueBridgeIpaddress=@"huebridge:ipaddress";

NSString *const kAttrHueBridgeMac=@"huebridge:mac";

NSString *const kAttrHueBridgeApiversion=@"huebridge:apiversion";

NSString *const kAttrHueBridgeSwversion=@"huebridge:swversion";

NSString *const kAttrHueBridgeZigbeechannel=@"huebridge:zigbeechannel";

NSString *const kAttrHueBridgeModel=@"huebridge:model";

NSString *const kAttrHueBridgeBridgeid=@"huebridge:bridgeid";





@implementation HueBridgeCapability
+ (NSString *)namespace { return @"huebridge"; }
+ (NSString *)name { return @"HueBridge"; }

+ (NSString *)getIpaddressFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HueBridgeCapabilityLegacy getIpaddress:modelObj];
  
}


+ (NSString *)getMacFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HueBridgeCapabilityLegacy getMac:modelObj];
  
}


+ (NSString *)getApiversionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HueBridgeCapabilityLegacy getApiversion:modelObj];
  
}


+ (NSString *)getSwversionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HueBridgeCapabilityLegacy getSwversion:modelObj];
  
}


+ (NSString *)getZigbeechannelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HueBridgeCapabilityLegacy getZigbeechannel:modelObj];
  
}


+ (NSString *)getModelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HueBridgeCapabilityLegacy getModel:modelObj];
  
}


+ (NSString *)getBridgeidFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HueBridgeCapabilityLegacy getBridgeid:modelObj];
  
}



@end
