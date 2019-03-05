

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SchedulerService.h"
#import <i2app-Swift.h>

@implementation SchedulerService
+ (NSString *)name { return @"SchedulerService"; }
+ (NSString *)address { return @"SERV:scheduler:"; }


+ (PMKPromise *) listSchedulersWithPlaceId:(NSString *)placeId withIncludeWeekdays:(BOOL)includeWeekdays {
  return [SchedulerServiceLegacy listSchedulers:placeId includeWeekdays:includeWeekdays];

}


+ (PMKPromise *) getSchedulerWithTarget:(NSString *)target {
  return [SchedulerServiceLegacy getScheduler:target];

}


+ (PMKPromise *) fireCommandWithTarget:(NSString *)target withCommandId:(NSString *)commandId {
  return [SchedulerServiceLegacy fireCommand:target commandId:commandId];

}


+ (PMKPromise *) scheduleCommandsWithTarget:(NSString *)target withGroup:(NSString *)group withCommands:(NSArray *)commands {
  return [SchedulerServiceLegacy scheduleCommands:target group:group commands:commands];

}


+ (PMKPromise *) scheduleWeeklyCommandWithTarget:(NSString *)target withSchedule:(NSString *)schedule withDays:(NSArray *)days withMode:(NSString *)mode withTime:(NSString *)time withOffsetMinutes:(int)offsetMinutes withMessageType:(NSString *)messageType withAttributes:(NSDictionary *)attributes {
  return [SchedulerServiceLegacy scheduleWeeklyCommand:target schedule:schedule days:days mode:mode time:time offsetMinutes:offsetMinutes messageType:messageType schedulerServiceAttributes:attributes];

}


+ (PMKPromise *) updateWeeklyCommandWithTarget:(NSString *)target withSchedule:(NSString *)schedule withCommandId:(NSString *)commandId withDays:(NSArray *)days withMode:(NSString *)mode withTime:(NSString *)time withOffsetMinutes:(int)offsetMinutes withMessageType:(NSString *)messageType withAttributes:(NSDictionary *)attributes {
  return [SchedulerServiceLegacy updateWeeklyCommand:target schedule:schedule commandId:commandId days:days mode:mode time:time offsetMinutes:offsetMinutes messageType:messageType schedulerServiceAttributes:attributes];

}


+ (PMKPromise *) deleteCommandWithTarget:(NSString *)target withSchedule:(NSString *)schedule withCommandId:(NSString *)commandId {
  return [SchedulerServiceLegacy deleteCommand:target schedule:schedule commandId:commandId];

}

@end
