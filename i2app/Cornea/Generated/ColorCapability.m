

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ColorCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrColorHue=@"color:hue";

NSString *const kAttrColorSaturation=@"color:saturation";





@implementation ColorCapability
+ (NSString *)namespace { return @"color"; }
+ (NSString *)name { return @"Color"; }

+ (int)getHueFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ColorCapabilityLegacy getHue:modelObj] intValue];
  
}

+ (int)setHue:(int)hue onModel:(DeviceModel *)modelObj {
  [ColorCapabilityLegacy setHue:hue model:modelObj];
  
  return [[ColorCapabilityLegacy getHue:modelObj] intValue];
  
}


+ (int)getSaturationFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ColorCapabilityLegacy getSaturation:modelObj] intValue];
  
}

+ (int)setSaturation:(int)saturation onModel:(DeviceModel *)modelObj {
  [ColorCapabilityLegacy setSaturation:saturation model:modelObj];
  
  return [[ColorCapabilityLegacy getSaturation:modelObj] intValue];
  
}



@end
