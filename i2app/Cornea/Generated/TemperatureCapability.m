

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "TemperatureCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrTemperatureTemperature=@"temp:temperature";





@implementation TemperatureCapability
+ (NSString *)namespace { return @"temp"; }
+ (NSString *)name { return @"Temperature"; }

+ (double)getTemperatureFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[TemperatureCapabilityLegacy getTemperature:modelObj] doubleValue];
  
}



@end
