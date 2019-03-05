

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PowerUseCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPowerUseInstantaneous=@"pow:instantaneous";

NSString *const kAttrPowerUseCumulative=@"pow:cumulative";

NSString *const kAttrPowerUseWholehome=@"pow:wholehome";





@implementation PowerUseCapability
+ (NSString *)namespace { return @"pow"; }
+ (NSString *)name { return @"PowerUse"; }

+ (double)getInstantaneousFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PowerUseCapabilityLegacy getInstantaneous:modelObj] doubleValue];
  
}


+ (double)getCumulativeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PowerUseCapabilityLegacy getCumulative:modelObj] doubleValue];
  
}


+ (BOOL)getWholehomeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PowerUseCapabilityLegacy getWholehome:modelObj] boolValue];
  
}



@end
