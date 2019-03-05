

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SchedulerModel;



/** The ID of the place that this object is associated with. */
extern NSString *const kAttrSchedulerPlaceId;

/** The target that scheduled messages will be sent to. */
extern NSString *const kAttrSchedulerTarget;

/** The next time a scheduled command will fire.  This may be null if all schedules are disabled. */
extern NSString *const kAttrSchedulerNextFireTime;

/** ID of the schedule that will fire next. */
extern NSString *const kAttrSchedulerNextFireSchedule;

/** The last time the schedule executed a command. */
extern NSString *const kAttrSchedulerLastFireTime;

/** ID of the schedule that fired previously. */
extern NSString *const kAttrSchedulerLastFireSchedule;

/**  The commands that this schedule may send.  This is a derived, read-only view.  The specific format of the ScheduledCommand depends on the type of schedule this is.  Currently only WeeklySchedule and TimeOfDayCommand are supported.           */
extern NSString *const kAttrSchedulerCommands;


extern NSString *const kCmdSchedulerFireCommand;

extern NSString *const kCmdSchedulerAddWeeklySchedule;

extern NSString *const kCmdSchedulerDelete;




@interface SchedulerCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getPlaceIdFromModel:(SchedulerModel *)modelObj;


+ (NSString *)getTargetFromModel:(SchedulerModel *)modelObj;


+ (NSDate *)getNextFireTimeFromModel:(SchedulerModel *)modelObj;


+ (NSString *)getNextFireScheduleFromModel:(SchedulerModel *)modelObj;


+ (NSDate *)getLastFireTimeFromModel:(SchedulerModel *)modelObj;


+ (NSString *)getLastFireScheduleFromModel:(SchedulerModel *)modelObj;


+ (NSDictionary *)getCommandsFromModel:(SchedulerModel *)modelObj;





/** Fires the requested command right now, generally used for testing. */
+ (PMKPromise *) fireCommandWithCommandId:(NSString *)commandId onModel:(Model *)modelObj;



/**  Creates a new schedule which will appear as a new multi-instance object on the Scheduler with the given id. If a schedule with the given id already exists with the same type this will be a no-op.  If a schedule with the same id and a different type exists, this will return an error.           */
+ (PMKPromise *) addWeeklyScheduleWithId:(NSString *)id withGroup:(NSString *)group onModel:(Model *)modelObj;



/** Deletes this scheduler object and all associated schedules, this is generally not recommended.  If the target object is deleted, this Scheduler will automatically be deleted. */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



@end
