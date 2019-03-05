

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DimmerCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDimmerBrightness=@"dim:brightness";

NSString *const kAttrDimmerRampingtarget=@"dim:rampingtarget";

NSString *const kAttrDimmerRampingtime=@"dim:rampingtime";


NSString *const kCmdDimmerRampBrightness=@"dim:RampBrightness";

NSString *const kCmdDimmerIncrementBrightness=@"dim:IncrementBrightness";

NSString *const kCmdDimmerDecrementBrightness=@"dim:DecrementBrightness";




@implementation DimmerCapability
+ (NSString *)namespace { return @"dim"; }
+ (NSString *)name { return @"Dimmer"; }

+ (int)getBrightnessFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DimmerCapabilityLegacy getBrightness:modelObj] intValue];
  
}

+ (int)setBrightness:(int)brightness onModel:(DeviceModel *)modelObj {
  [DimmerCapabilityLegacy setBrightness:brightness model:modelObj];
  
  return [[DimmerCapabilityLegacy getBrightness:modelObj] intValue];
  
}


+ (int)getRampingtargetFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DimmerCapabilityLegacy getRampingtarget:modelObj] intValue];
  
}


+ (int)getRampingtimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DimmerCapabilityLegacy getRampingtime:modelObj] intValue];
  
}




+ (PMKPromise *) rampBrightnessWithBrightness:(int)brightness withSeconds:(int)seconds onModel:(DeviceModel *)modelObj {
  return [DimmerCapabilityLegacy rampBrightness:modelObj brightness:brightness seconds:seconds];

}


+ (PMKPromise *) incrementBrightnessWithAmount:(int)amount onModel:(DeviceModel *)modelObj {
  return [DimmerCapabilityLegacy incrementBrightness:modelObj amount:amount];

}


+ (PMKPromise *) decrementBrightnessWithAmount:(int)amount onModel:(DeviceModel *)modelObj {
  return [DimmerCapabilityLegacy decrementBrightness:modelObj amount:amount];

}

@end
