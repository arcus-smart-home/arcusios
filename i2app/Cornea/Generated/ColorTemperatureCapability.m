

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ColorTemperatureCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrColorTemperatureColortemp=@"colortemp:colortemp";

NSString *const kAttrColorTemperatureMincolortemp=@"colortemp:mincolortemp";

NSString *const kAttrColorTemperatureMaxcolortemp=@"colortemp:maxcolortemp";





@implementation ColorTemperatureCapability
+ (NSString *)namespace { return @"colortemp"; }
+ (NSString *)name { return @"ColorTemperature"; }

+ (int)getColortempFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ColorTemperatureCapabilityLegacy getColortemp:modelObj] intValue];
  
}

+ (int)setColortemp:(int)colortemp onModel:(DeviceModel *)modelObj {
  [ColorTemperatureCapabilityLegacy setColortemp:colortemp model:modelObj];
  
  return [[ColorTemperatureCapabilityLegacy getColortemp:modelObj] intValue];
  
}


+ (int)getMincolortempFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ColorTemperatureCapabilityLegacy getMincolortemp:modelObj] intValue];
  
}


+ (int)getMaxcolortempFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ColorTemperatureCapabilityLegacy getMaxcolortemp:modelObj] intValue];
  
}



@end
