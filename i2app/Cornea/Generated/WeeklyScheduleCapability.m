

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WeeklyScheduleCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrWeeklyScheduleMon=@"schedweek:mon";

NSString *const kAttrWeeklyScheduleTue=@"schedweek:tue";

NSString *const kAttrWeeklyScheduleWed=@"schedweek:wed";

NSString *const kAttrWeeklyScheduleThu=@"schedweek:thu";

NSString *const kAttrWeeklyScheduleFri=@"schedweek:fri";

NSString *const kAttrWeeklyScheduleSat=@"schedweek:sat";

NSString *const kAttrWeeklyScheduleSun=@"schedweek:sun";


NSString *const kCmdWeeklyScheduleScheduleWeeklyCommand=@"schedweek:ScheduleWeeklyCommand";

NSString *const kCmdWeeklyScheduleUpdateWeeklyCommand=@"schedweek:UpdateWeeklyCommand";




@implementation WeeklyScheduleCapability
+ (NSString *)namespace { return @"schedweek"; }
+ (NSString *)name { return @"WeeklySchedule"; }

+ (NSArray *)getMonFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeeklyScheduleCapabilityLegacy getMon:modelObj];
  
}


+ (NSArray *)getTueFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeeklyScheduleCapabilityLegacy getTue:modelObj];
  
}


+ (NSArray *)getWedFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeeklyScheduleCapabilityLegacy getWed:modelObj];
  
}


+ (NSArray *)getThuFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeeklyScheduleCapabilityLegacy getThu:modelObj];
  
}


+ (NSArray *)getFriFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeeklyScheduleCapabilityLegacy getFri:modelObj];
  
}


+ (NSArray *)getSatFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeeklyScheduleCapabilityLegacy getSat:modelObj];
  
}


+ (NSArray *)getSunFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeeklyScheduleCapabilityLegacy getSun:modelObj];
  
}




+ (PMKPromise *) scheduleWeeklyCommandWithDays:(NSArray *)days withTime:(NSString *)time withMode:(NSString *)mode withOffsetMinutes:(int)offsetMinutes withMessageType:(NSString *)messageType withAttributes:(NSDictionary *)attributes onModel:(ScheduleModel *)modelObj {
  return [WeeklyScheduleCapabilityLegacy scheduleWeeklyCommand:modelObj days:days time:time mode:mode offsetMinutes:offsetMinutes messageType:messageType weeklyScheduleAttributes:attributes];

}


+ (PMKPromise *) updateWeeklyCommandWithCommandId:(NSString *)commandId withDays:(NSArray *)days withMode:(NSString *)mode withOffsetMinutes:(int)offsetMinutes withTime:(NSString *)time withMessageType:(NSString *)messageType withAttributes:(NSDictionary *)attributes onModel:(ScheduleModel *)modelObj {
  return [WeeklyScheduleCapabilityLegacy updateWeeklyCommand:modelObj commandId:commandId days:days mode:mode offsetMinutes:offsetMinutes time:time messageType:messageType weeklyScheduleAttributes:attributes];

}

@end
