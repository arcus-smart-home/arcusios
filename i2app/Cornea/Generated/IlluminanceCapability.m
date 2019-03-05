

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IlluminanceCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrIlluminanceIlluminance=@"ill:illuminance";

NSString *const kAttrIlluminanceSensorType=@"ill:sensorType";



NSString *const kEnumIlluminanceSensorTypePHOTODIODE = @"PHOTODIODE";
NSString *const kEnumIlluminanceSensorTypeCMOS = @"CMOS";


@implementation IlluminanceCapability
+ (NSString *)namespace { return @"ill"; }
+ (NSString *)name { return @"Illuminance"; }

+ (double)getIlluminanceFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IlluminanceCapabilityLegacy getIlluminance:modelObj] doubleValue];
  
}


+ (NSString *)getSensorTypeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IlluminanceCapabilityLegacy getSensorType:modelObj];
  
}



@end
