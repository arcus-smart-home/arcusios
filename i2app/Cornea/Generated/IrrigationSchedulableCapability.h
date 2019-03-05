

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** If true then the device needs to schedule synchronized with the platform. */
extern NSString *const kAttrIrrigationSchedulableRefreshSchedule;


extern NSString *const kCmdIrrigationSchedulableEnableSchedule;

extern NSString *const kCmdIrrigationSchedulableDisableSchedule;

extern NSString *const kCmdIrrigationSchedulableClearEvenOddSchedule;

extern NSString *const kCmdIrrigationSchedulableSetEvenOddSchedule;

extern NSString *const kCmdIrrigationSchedulableClearIntervalSchedule;

extern NSString *const kCmdIrrigationSchedulableSetIntervalSchedule;

extern NSString *const kCmdIrrigationSchedulableSetIntervalStart;

extern NSString *const kCmdIrrigationSchedulableClearWeeklySchedule;

extern NSString *const kCmdIrrigationSchedulableSetWeeklySchedule;


extern NSString *const kEvtIrrigationSchedulableScheduleEnabled;

extern NSString *const kEvtIrrigationSchedulableScheduleApplied;

extern NSString *const kEvtIrrigationSchedulableScheduleCleared;

extern NSString *const kEvtIrrigationSchedulableScheduleFailed;

extern NSString *const kEvtIrrigationSchedulableScheduleClearFailed;

extern NSString *const kEvtIrrigationSchedulableSetIntervalStartSucceeded;

extern NSString *const kEvtIrrigationSchedulableSetIntervalStartFailed;



@interface IrrigationSchedulableCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getRefreshScheduleFromModel:(DeviceModel *)modelObj;

+ (BOOL)setRefreshSchedule:(BOOL)refreshSchedule onModel:(DeviceModel *)modelObj;





/** Enables scheduling on the device */
+ (PMKPromise *) enableScheduleOnModel:(Model *)modelObj;



/** Disables schedulig on the device for an optional amount of time */
+ (PMKPromise *) disableScheduleWithDuration:(int)duration onModel:(Model *)modelObj;



/** Clears the even/odd day schedule for the given zone */
+ (PMKPromise *) clearEvenOddScheduleWithZone:(NSString *)zone withOpId:(NSString *)opId onModel:(Model *)modelObj;



/** Sets an even/odd day schedule for the given zone */
+ (PMKPromise *) setEvenOddScheduleWithZone:(NSString *)zone withEven:(BOOL)even withTransitions:(NSArray *)transitions withOpId:(NSString *)opId onModel:(Model *)modelObj;



/** Clears the interval schedule for the given zone */
+ (PMKPromise *) clearIntervalScheduleWithZone:(NSString *)zone withOpId:(NSString *)opId onModel:(Model *)modelObj;



/** Sets an interval schedule for the given zone */
+ (PMKPromise *) setIntervalScheduleWithZone:(NSString *)zone withDays:(int)days withTransitions:(NSArray *)transitions withOpId:(NSString *)opId onModel:(Model *)modelObj;



/** Sets the interval start date */
+ (PMKPromise *) setIntervalStartWithZone:(NSString *)zone withStartDate:(double)startDate withOpId:(NSString *)opId onModel:(Model *)modelObj;



/** Clears the weekly schedule for the given zone */
+ (PMKPromise *) clearWeeklyScheduleWithZone:(NSString *)zone withOpId:(NSString *)opId onModel:(Model *)modelObj;



/** Sets a weekly schedule for the given zone */
+ (PMKPromise *) setWeeklyScheduleWithZone:(NSString *)zone withDays:(NSArray *)days withTransitions:(NSArray *)transitions withOpId:(NSString *)opId onModel:(Model *)modelObj;



@end
