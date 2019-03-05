

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "BridgeChildCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrBridgeChildParentAddress=@"bridgechild:parentAddress";

NSString *const kAttrBridgeChildBridgeSpecificId=@"bridgechild:bridgeSpecificId";





@implementation BridgeChildCapability
+ (NSString *)namespace { return @"bridgechild"; }
+ (NSString *)name { return @"BridgeChild"; }

+ (NSString *)getParentAddressFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [BridgeChildCapabilityLegacy getParentAddress:modelObj];
  
}


+ (NSString *)getBridgeSpecificIdFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [BridgeChildCapabilityLegacy getBridgeSpecificId:modelObj];
  
}



@end
