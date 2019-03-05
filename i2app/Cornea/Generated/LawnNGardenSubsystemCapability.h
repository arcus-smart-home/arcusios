

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/** The addresses of all irrigation controllers at this place */
extern NSString *const kAttrLawnNGardenSubsystemControllers;

/** The current scheduling status of all controllers */
extern NSString *const kAttrLawnNGardenSubsystemScheduleStatus;

/** The odd day schedules for all controllers */
extern NSString *const kAttrLawnNGardenSubsystemOddSchedules;

/** The even day schedules for all controllers */
extern NSString *const kAttrLawnNGardenSubsystemEvenSchedules;

/** The weekly schedules for all controllers */
extern NSString *const kAttrLawnNGardenSubsystemWeeklySchedules;

/** The interval schedules for all controllers */
extern NSString *const kAttrLawnNGardenSubsystemIntervalSchedules;

/** The immediate next event across all active schedules */
extern NSString *const kAttrLawnNGardenSubsystemNextEvent;

/** Metadata about the current watering zone for each controller. */
extern NSString *const kAttrLawnNGardenSubsystemZonesWatering;


extern NSString *const kCmdLawnNGardenSubsystemStopWatering;

extern NSString *const kCmdLawnNGardenSubsystemSwitchScheduleMode;

extern NSString *const kCmdLawnNGardenSubsystemEnableScheduling;

extern NSString *const kCmdLawnNGardenSubsystemDisableScheduling;

extern NSString *const kCmdLawnNGardenSubsystemSkip;

extern NSString *const kCmdLawnNGardenSubsystemCancelSkip;

extern NSString *const kCmdLawnNGardenSubsystemConfigureIntervalSchedule;

extern NSString *const kCmdLawnNGardenSubsystemCreateWeeklyEvent;

extern NSString *const kCmdLawnNGardenSubsystemUpdateWeeklyEvent;

extern NSString *const kCmdLawnNGardenSubsystemRemoveWeeklyEvent;

extern NSString *const kCmdLawnNGardenSubsystemCreateScheduleEvent;

extern NSString *const kCmdLawnNGardenSubsystemUpdateScheduleEvent;

extern NSString *const kCmdLawnNGardenSubsystemRemoveScheduleEvent;

extern NSString *const kCmdLawnNGardenSubsystemSyncSchedule;

extern NSString *const kCmdLawnNGardenSubsystemSyncScheduleEvent;


extern NSString *const kEvtLawnNGardenSubsystemStartWatering;

extern NSString *const kEvtLawnNGardenSubsystemStopWatering;

extern NSString *const kEvtLawnNGardenSubsystemSkipWatering;

extern NSString *const kEvtLawnNGardenSubsystemUpdateSchedule;

extern NSString *const kEvtLawnNGardenSubsystemApplyScheduleToDevice;

extern NSString *const kEvtLawnNGardenSubsystemApplyScheduleToDeviceFailed;



@interface LawnNGardenSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getControllersFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getScheduleStatusFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getOddSchedulesFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getEvenSchedulesFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getWeeklySchedulesFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getIntervalSchedulesFromModel:(SubsystemModel *)modelObj;


+ (id)getNextEventFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getZonesWateringFromModel:(SubsystemModel *)modelObj;





/** Stops a controller from watering whether it was started manually or not. */
+ (PMKPromise *) stopWateringWithController:(NSString *)controller withCurrentOnly:(BOOL)currentOnly onModel:(Model *)modelObj;



/** Changes the scheduling mode on a controller between the various types */
+ (PMKPromise *) switchScheduleModeWithController:(NSString *)controller withMode:(NSString *)mode onModel:(Model *)modelObj;



/** Enables the current schedule */
+ (PMKPromise *) enableSchedulingWithController:(NSString *)controller onModel:(Model *)modelObj;



/** Disables the current schedule */
+ (PMKPromise *) disableSchedulingWithController:(NSString *)controller onModel:(Model *)modelObj;



/** Skips scheduled watering events for a specific length of time */
+ (PMKPromise *) skipWithController:(NSString *)controller withHours:(int)hours onModel:(Model *)modelObj;



/** Cancels skipping (rain delay) */
+ (PMKPromise *) cancelSkipWithController:(NSString *)controller onModel:(Model *)modelObj;



/** Configures the start time and interval for the interval schedule */
+ (PMKPromise *) configureIntervalScheduleWithController:(NSString *)controller withStartTime:(double)startTime withDays:(int)days onModel:(Model *)modelObj;



/** Creates a weekly schedule event */
+ (PMKPromise *) createWeeklyEventWithController:(NSString *)controller withDays:(NSArray *)days withTimeOfDay:(NSString *)timeOfDay withZoneDurations:(NSArray *)zoneDurations onModel:(Model *)modelObj;



/** Updates a weekly schedule event */
+ (PMKPromise *) updateWeeklyEventWithController:(NSString *)controller withEventId:(NSString *)eventId withDays:(NSArray *)days withTimeOfDay:(NSString *)timeOfDay withZoneDurations:(NSArray *)zoneDurations withDay:(NSString *)day onModel:(Model *)modelObj;



/** Removes a weekly schedule event */
+ (PMKPromise *) removeWeeklyEventWithController:(NSString *)controller withEventId:(NSString *)eventId withDay:(NSString *)day onModel:(Model *)modelObj;



/** Creates a non-weekly scheduling event */
+ (PMKPromise *) createScheduleEventWithController:(NSString *)controller withMode:(NSString *)mode withTimeOfDay:(NSString *)timeOfDay withZoneDurations:(NSArray *)zoneDurations onModel:(Model *)modelObj;



/** Updates an existing non-weekly schedule event */
+ (PMKPromise *) updateScheduleEventWithController:(NSString *)controller withMode:(NSString *)mode withEventId:(NSString *)eventId withTimeOfDay:(NSString *)timeOfDay withZoneDurations:(NSArray *)zoneDurations onModel:(Model *)modelObj;



/** Removes an existing non-weekly schedule event */
+ (PMKPromise *) removeScheduleEventWithController:(NSString *)controller withMode:(NSString *)mode withEventId:(NSString *)eventId onModel:(Model *)modelObj;



/** Attempts to repush an entire scheduled identified by the mode down to the device, typically useful when applying some event has failed */
+ (PMKPromise *) syncScheduleWithController:(NSString *)controller withMode:(NSString *)mode onModel:(Model *)modelObj;



/** Attempts to repush an entire scheduled event down to the device, typically useful when applying some event has failed */
+ (PMKPromise *) syncScheduleEventWithController:(NSString *)controller withMode:(NSString *)mode withEventId:(NSString *)eventId onModel:(Model *)modelObj;



@end
