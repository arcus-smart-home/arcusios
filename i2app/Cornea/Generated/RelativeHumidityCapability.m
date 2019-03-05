

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "RelativeHumidityCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrRelativeHumidityHumidity=@"humid:humidity";





@implementation RelativeHumidityCapability
+ (NSString *)namespace { return @"humid"; }
+ (NSString *)name { return @"RelativeHumidity"; }

+ (double)getHumidityFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RelativeHumidityCapabilityLegacy getHumidity:modelObj] doubleValue];
  
}



@end
