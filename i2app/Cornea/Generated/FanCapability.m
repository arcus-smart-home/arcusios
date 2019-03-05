

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "FanCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrFanSpeed=@"fan:speed";

NSString *const kAttrFanMaxSpeed=@"fan:maxSpeed";

NSString *const kAttrFanDirection=@"fan:direction";



NSString *const kEnumFanDirectionUP = @"UP";
NSString *const kEnumFanDirectionDOWN = @"DOWN";


@implementation FanCapability
+ (NSString *)namespace { return @"fan"; }
+ (NSString *)name { return @"Fan"; }

+ (int)getSpeedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[FanCapabilityLegacy getSpeed:modelObj] intValue];
  
}

+ (int)setSpeed:(int)speed onModel:(DeviceModel *)modelObj {
  [FanCapabilityLegacy setSpeed:speed model:modelObj];
  
  return [[FanCapabilityLegacy getSpeed:modelObj] intValue];
  
}


+ (int)getMaxSpeedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[FanCapabilityLegacy getMaxSpeed:modelObj] intValue];
  
}


+ (NSString *)getDirectionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [FanCapabilityLegacy getDirection:modelObj];
  
}

+ (NSString *)setDirection:(NSString *)direction onModel:(DeviceModel *)modelObj {
  [FanCapabilityLegacy setDirection:direction model:modelObj];
  
  return [FanCapabilityLegacy getDirection:modelObj];
  
}



@end
