

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WaterHeaterCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrWaterHeaterHeatingstate=@"waterheater:heatingstate";

NSString *const kAttrWaterHeaterMaxsetpoint=@"waterheater:maxsetpoint";

NSString *const kAttrWaterHeaterSetpoint=@"waterheater:setpoint";

NSString *const kAttrWaterHeaterHotwaterlevel=@"waterheater:hotwaterlevel";



NSString *const kEnumWaterHeaterHotwaterlevelLOW = @"LOW";
NSString *const kEnumWaterHeaterHotwaterlevelMEDIUM = @"MEDIUM";
NSString *const kEnumWaterHeaterHotwaterlevelHIGH = @"HIGH";


@implementation WaterHeaterCapability
+ (NSString *)namespace { return @"waterheater"; }
+ (NSString *)name { return @"WaterHeater"; }

+ (BOOL)getHeatingstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterHeaterCapabilityLegacy getHeatingstate:modelObj] boolValue];
  
}


+ (double)getMaxsetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterHeaterCapabilityLegacy getMaxsetpoint:modelObj] doubleValue];
  
}


+ (double)getSetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterHeaterCapabilityLegacy getSetpoint:modelObj] doubleValue];
  
}

+ (double)setSetpoint:(double)setpoint onModel:(DeviceModel *)modelObj {
  [WaterHeaterCapabilityLegacy setSetpoint:setpoint model:modelObj];
  
  return [[WaterHeaterCapabilityLegacy getSetpoint:modelObj] doubleValue];
  
}


+ (NSString *)getHotwaterlevelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterHeaterCapabilityLegacy getHotwaterlevel:modelObj];
  
}



@end
