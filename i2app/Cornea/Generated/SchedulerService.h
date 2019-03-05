

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface SchedulerService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Lists all the schedulers for a given place. */
+ (PMKPromise *) listSchedulersWithPlaceId:(NSString *)placeId withIncludeWeekdays:(BOOL)includeWeekdays;



/** Creates a new Scheduler or returns the existing scheduler for target.  Generally this is used when there is no Scheduler in ListSchedulers for the given object. */
+ (PMKPromise *) getSchedulerWithTarget:(NSString *)target;



/** Fires the requested command right now, generally used for testing. */
+ (PMKPromise *) fireCommandWithTarget:(NSString *)target withCommandId:(NSString *)commandId;



/**  Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event. If no Scheduler exists for the given target then it will be created.  If no Schedule exists for the given schedule, it will be created.          */
+ (PMKPromise *) scheduleCommandsWithTarget:(NSString *)target withGroup:(NSString *)group withCommands:(NSArray *)commands;



/**  This is a convenience for Scheduler#GetScheduler(target)#AddSchedule(schedule, &#x27;WEEKLY&#x27;)#ScheduleWeeklyEvent(time, messageType, attributeMap). Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event. If no Scheduler exists for the given target then it will be created.  If no Schedule exists for the given schedule, it will be created.          */
+ (PMKPromise *) scheduleWeeklyCommandWithTarget:(NSString *)target withSchedule:(NSString *)schedule withDays:(NSArray *)days withMode:(NSString *)mode withTime:(NSString *)time withOffsetMinutes:(int)offsetMinutes withMessageType:(NSString *)messageType withAttributes:(NSDictionary *)attributes;



/**  This is a convenience for Scheduler#GetScheduler(target)[schedule]#UpdateWeeklyEvent(commandId, time, attributes). Updates schedule for an existing scheduled event.   */
+ (PMKPromise *) updateWeeklyCommandWithTarget:(NSString *)target withSchedule:(NSString *)schedule withCommandId:(NSString *)commandId withDays:(NSArray *)days withMode:(NSString *)mode withTime:(NSString *)time withOffsetMinutes:(int)offsetMinutes withMessageType:(NSString *)messageType withAttributes:(NSDictionary *)attributes;



/**  This is a convenience for Scheduler#GetScheduler(target)[schedule]#DeleteCommand(comandId). Deletes any occurrence of the specified command from the week.   */
+ (PMKPromise *) deleteCommandWithTarget:(NSString *)target withSchedule:(NSString *)schedule withCommandId:(NSString *)commandId;



@end
