

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class ScheduleModel;



/** The scheduling group.  Only one Schedule in a scheduling group may be enabled at a time. */
extern NSString *const kAttrScheduleGroup;

/** Whether or not this scheduled is currently enabled to run.  When disabled no scheduled commands will be sent. */
extern NSString *const kAttrScheduleEnabled;

/** The next time the schedule will fire, this may be null if the schedule is disabled or there are no scheduled times. */
extern NSString *const kAttrScheduleNextFireTime;

/** The command that will be sent when it fires next.  This is a key into the commands attribute. */
extern NSString *const kAttrScheduleNextFireCommand;

/** The last time the schedule executed a command. */
extern NSString *const kAttrScheduleLastFireTime;

/** The id of the last command that was executed.  This may not exist in the commands attribute if the schedule has been modified since it last fired. */
extern NSString *const kAttrScheduleLastFireCommand;

/** The type of message that was sent on last execution. */
extern NSString *const kAttrScheduleLastFireMessageType;

/** The attributes that were sent on last execution. */
extern NSString *const kAttrScheduleLastFireAttributes;


extern NSString *const kCmdScheduleDelete;

extern NSString *const kCmdScheduleDeleteCommand;




@interface ScheduleCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getGroupFromModel:(ScheduleModel *)modelObj;


+ (BOOL)getEnabledFromModel:(ScheduleModel *)modelObj;

+ (BOOL)setEnabled:(BOOL)enabled onModel:(Model *)modelObj;


+ (NSDate *)getNextFireTimeFromModel:(ScheduleModel *)modelObj;


+ (NSString *)getNextFireCommandFromModel:(ScheduleModel *)modelObj;


+ (NSDate *)getLastFireTimeFromModel:(ScheduleModel *)modelObj;


+ (NSString *)getLastFireCommandFromModel:(ScheduleModel *)modelObj;


+ (NSString *)getLastFireMessageTypeFromModel:(ScheduleModel *)modelObj;


+ (NSDictionary *)getLastFireAttributesFromModel:(ScheduleModel *)modelObj;





/** Deletes this Schedule and removes any scheduled commands. */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



/** Deletes any occurrences of the scheduled command from this Schedule. */
+ (PMKPromise *) deleteCommandWithCommandId:(NSString *)commandId onModel:(Model *)modelObj;



@end
