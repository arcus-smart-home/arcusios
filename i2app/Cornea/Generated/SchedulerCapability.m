

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SchedulerCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSchedulerPlaceId=@"scheduler:placeId";

NSString *const kAttrSchedulerTarget=@"scheduler:target";

NSString *const kAttrSchedulerNextFireTime=@"scheduler:nextFireTime";

NSString *const kAttrSchedulerNextFireSchedule=@"scheduler:nextFireSchedule";

NSString *const kAttrSchedulerLastFireTime=@"scheduler:lastFireTime";

NSString *const kAttrSchedulerLastFireSchedule=@"scheduler:lastFireSchedule";

NSString *const kAttrSchedulerCommands=@"scheduler:commands";


NSString *const kCmdSchedulerFireCommand=@"scheduler:FireCommand";

NSString *const kCmdSchedulerAddWeeklySchedule=@"scheduler:AddWeeklySchedule";

NSString *const kCmdSchedulerDelete=@"scheduler:Delete";




@implementation SchedulerCapability
+ (NSString *)namespace { return @"scheduler"; }
+ (NSString *)name { return @"Scheduler"; }

+ (NSString *)getPlaceIdFromModel:(SchedulerModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SchedulerCapabilityLegacy getPlaceId:modelObj];
  
}


+ (NSString *)getTargetFromModel:(SchedulerModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SchedulerCapabilityLegacy getTarget:modelObj];
  
}


+ (NSDate *)getNextFireTimeFromModel:(SchedulerModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SchedulerCapabilityLegacy getNextFireTime:modelObj];
  
}


+ (NSString *)getNextFireScheduleFromModel:(SchedulerModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SchedulerCapabilityLegacy getNextFireSchedule:modelObj];
  
}


+ (NSDate *)getLastFireTimeFromModel:(SchedulerModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SchedulerCapabilityLegacy getLastFireTime:modelObj];
  
}


+ (NSString *)getLastFireScheduleFromModel:(SchedulerModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SchedulerCapabilityLegacy getLastFireSchedule:modelObj];
  
}


+ (NSDictionary *)getCommandsFromModel:(SchedulerModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SchedulerCapabilityLegacy getCommands:modelObj];
  
}




+ (PMKPromise *) fireCommandWithCommandId:(NSString *)commandId onModel:(SchedulerModel *)modelObj {
  return [SchedulerCapabilityLegacy fireCommand:modelObj commandId:commandId];

}


+ (PMKPromise *) addWeeklyScheduleWithId:(NSString *)id withGroup:(NSString *)group onModel:(SchedulerModel *)modelObj {
  return [SchedulerCapabilityLegacy addWeeklySchedule:modelObj id:id group:group];

}


+ (PMKPromise *) deleteOnModel:(SchedulerModel *)modelObj {
  return [SchedulerCapabilityLegacy delete:modelObj ];
}

@end
