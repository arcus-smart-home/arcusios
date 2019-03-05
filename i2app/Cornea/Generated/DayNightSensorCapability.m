

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DayNightSensorCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDayNightSensorMode=@"daynight:mode";

NSString *const kAttrDayNightSensorModechanged=@"daynight:modechanged";



NSString *const kEnumDayNightSensorModeday = @"day";
NSString *const kEnumDayNightSensorModenight = @"night";


@implementation DayNightSensorCapability
+ (NSString *)namespace { return @"daynight"; }
+ (NSString *)name { return @"DayNightSensor"; }

+ (NSString *)getModeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DayNightSensorCapabilityLegacy getMode:modelObj];
  
}


+ (NSDate *)getModechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DayNightSensorCapabilityLegacy getModechanged:modelObj];
  
}



@end
