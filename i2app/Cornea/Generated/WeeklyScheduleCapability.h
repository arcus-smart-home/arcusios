

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class ScheduleModel;





/** The commands that are scheduled to run on Mondays */
extern NSString *const kAttrWeeklyScheduleMon;

/** The commands that are scheduled to run on Tuesdays */
extern NSString *const kAttrWeeklyScheduleTue;

/** The commands that are scheduled to run on Wednesdays */
extern NSString *const kAttrWeeklyScheduleWed;

/** The commands that are scheduled to run on Thursdays */
extern NSString *const kAttrWeeklyScheduleThu;

/** The commands that are scheduled to run on Fridays */
extern NSString *const kAttrWeeklyScheduleFri;

/** The commands that are scheduled to run on Saturdays */
extern NSString *const kAttrWeeklyScheduleSat;

/** The commands that are scheduled to run on Sundays */
extern NSString *const kAttrWeeklyScheduleSun;


extern NSString *const kCmdWeeklyScheduleScheduleWeeklyCommand;

extern NSString *const kCmdWeeklyScheduleUpdateWeeklyCommand;




@interface WeeklyScheduleCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getMonFromModel:(ScheduleModel *)modelObj;


+ (NSArray *)getTueFromModel:(ScheduleModel *)modelObj;


+ (NSArray *)getWedFromModel:(ScheduleModel *)modelObj;


+ (NSArray *)getThuFromModel:(ScheduleModel *)modelObj;


+ (NSArray *)getFriFromModel:(ScheduleModel *)modelObj;


+ (NSArray *)getSatFromModel:(ScheduleModel *)modelObj;


+ (NSArray *)getSunFromModel:(ScheduleModel *)modelObj;





/**  Adds or modifies a scheduled weekly event running at the given time on the requested days. Note that if an event with the same messageType, attributes and time of day exists this call will modify that event.      */
+ (PMKPromise *) scheduleWeeklyCommandWithDays:(NSArray *)days withTime:(NSString *)time withMode:(NSString *)mode withOffsetMinutes:(int)offsetMinutes withMessageType:(NSString *)messageType withAttributes:(NSDictionary *)attributes onModel:(Model *)modelObj;



/** Updates schedule for an existing scheduled command. */
+ (PMKPromise *) updateWeeklyCommandWithCommandId:(NSString *)commandId withDays:(NSArray *)days withMode:(NSString *)mode withOffsetMinutes:(int)offsetMinutes withTime:(NSString *)time withMessageType:(NSString *)messageType withAttributes:(NSDictionary *)attributes onModel:(Model *)modelObj;



@end
