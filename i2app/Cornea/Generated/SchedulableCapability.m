

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SchedulableCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSchedulableType=@"schedulable:type";

NSString *const kAttrSchedulableScheduleEnabled=@"schedulable:scheduleEnabled";


NSString *const kCmdSchedulableEnableSchedule=@"schedulable:EnableSchedule";

NSString *const kCmdSchedulableDisableSchedule=@"schedulable:DisableSchedule";


NSString *const kEnumSchedulableTypeNOT_SUPPORTED = @"NOT_SUPPORTED";
NSString *const kEnumSchedulableTypeDEVICE_ONLY = @"DEVICE_ONLY";
NSString *const kEnumSchedulableTypeDRIVER_READ_ONLY = @"DRIVER_READ_ONLY";
NSString *const kEnumSchedulableTypeDRIVER_WRITE_ONLY = @"DRIVER_WRITE_ONLY";
NSString *const kEnumSchedulableTypeSUPPORTED_DRIVER = @"SUPPORTED_DRIVER";
NSString *const kEnumSchedulableTypeSUPPORTED_CLOUD = @"SUPPORTED_CLOUD";


@implementation SchedulableCapability
+ (NSString *)namespace { return @"schedulable"; }
+ (NSString *)name { return @"Schedulable"; }

+ (NSString *)getTypeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SchedulableCapabilityLegacy getType:modelObj];
  
}


+ (BOOL)getScheduleEnabledFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SchedulableCapabilityLegacy getScheduleEnabled:modelObj] boolValue];
  
}




+ (PMKPromise *) enableScheduleOnModel:(DeviceModel *)modelObj {
  return [SchedulableCapabilityLegacy enableSchedule:modelObj ];
}


+ (PMKPromise *) disableScheduleOnModel:(DeviceModel *)modelObj {
  return [SchedulableCapabilityLegacy disableSchedule:modelObj ];
}

@end
