

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Year gregorian calendar */
extern NSString *const kAttrClockYear;

/** Month 1-12 (Jan - Dec) */
extern NSString *const kAttrClockMonth;

/** Day of the month */
extern NSString *const kAttrClockDay;

/** Hour of the day 0-23.  Midnight = 0 */
extern NSString *const kAttrClockHour;

/** Minute of the hour */
extern NSString *const kAttrClockMinute;

/** Second of the minute */
extern NSString *const kAttrClockSecond;

/** Day of the week */
extern NSString *const kAttrClockDay_of_week;





@interface ClockCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getYearFromModel:(DeviceModel *)modelObj;


+ (int)getMonthFromModel:(DeviceModel *)modelObj;


+ (int)getDayFromModel:(DeviceModel *)modelObj;


+ (int)getHourFromModel:(DeviceModel *)modelObj;


+ (int)getMinuteFromModel:(DeviceModel *)modelObj;


+ (int)getSecondFromModel:(DeviceModel *)modelObj;


+ (int)getDay_of_weekFromModel:(DeviceModel *)modelObj;





@end
