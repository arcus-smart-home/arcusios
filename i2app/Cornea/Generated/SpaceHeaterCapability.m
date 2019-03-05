

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SpaceHeaterCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSpaceHeaterSetpoint=@"spaceheater:setpoint";

NSString *const kAttrSpaceHeaterMinsetpoint=@"spaceheater:minsetpoint";

NSString *const kAttrSpaceHeaterMaxsetpoint=@"spaceheater:maxsetpoint";

NSString *const kAttrSpaceHeaterHeatstate=@"spaceheater:heatstate";



NSString *const kEnumSpaceHeaterHeatstateOFF = @"OFF";
NSString *const kEnumSpaceHeaterHeatstateON = @"ON";


@implementation SpaceHeaterCapability
+ (NSString *)namespace { return @"spaceheater"; }
+ (NSString *)name { return @"SpaceHeater"; }

+ (double)getSetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SpaceHeaterCapabilityLegacy getSetpoint:modelObj] doubleValue];
  
}

+ (double)setSetpoint:(double)setpoint onModel:(DeviceModel *)modelObj {
  [SpaceHeaterCapabilityLegacy setSetpoint:setpoint model:modelObj];
  
  return [[SpaceHeaterCapabilityLegacy getSetpoint:modelObj] doubleValue];
  
}


+ (double)getMinsetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SpaceHeaterCapabilityLegacy getMinsetpoint:modelObj] doubleValue];
  
}


+ (double)getMaxsetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SpaceHeaterCapabilityLegacy getMaxsetpoint:modelObj] doubleValue];
  
}


+ (NSString *)getHeatstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SpaceHeaterCapabilityLegacy getHeatstate:modelObj];
  
}

+ (NSString *)setHeatstate:(NSString *)heatstate onModel:(DeviceModel *)modelObj {
  [SpaceHeaterCapabilityLegacy setHeatstate:heatstate model:modelObj];
  
  return [SpaceHeaterCapabilityLegacy getHeatstate:modelObj];
  
}



@end
