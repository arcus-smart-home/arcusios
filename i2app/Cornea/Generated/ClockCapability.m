

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ClockCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrClockYear=@"clock:year";

NSString *const kAttrClockMonth=@"clock:month";

NSString *const kAttrClockDay=@"clock:day";

NSString *const kAttrClockHour=@"clock:hour";

NSString *const kAttrClockMinute=@"clock:minute";

NSString *const kAttrClockSecond=@"clock:second";

NSString *const kAttrClockDay_of_week=@"clock:day_of_week";





@implementation ClockCapability
+ (NSString *)namespace { return @"clock"; }
+ (NSString *)name { return @"Clock"; }

+ (int)getYearFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClockCapabilityLegacy getYear:modelObj] intValue];
  
}


+ (int)getMonthFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClockCapabilityLegacy getMonth:modelObj] intValue];
  
}


+ (int)getDayFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClockCapabilityLegacy getDay:modelObj] intValue];
  
}


+ (int)getHourFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClockCapabilityLegacy getHour:modelObj] intValue];
  
}


+ (int)getMinuteFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClockCapabilityLegacy getMinute:modelObj] intValue];
  
}


+ (int)getSecondFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClockCapabilityLegacy getSecond:modelObj] intValue];
  
}


+ (int)getDay_of_weekFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClockCapabilityLegacy getDay_of_week:modelObj] intValue];
  
}



@end
