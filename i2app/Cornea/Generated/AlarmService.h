

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface AlarmService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Issued by the alarm subsystem when a new alert is added to an incident. */
+ (PMKPromise *) addAlarmWithAlarm:(NSString *)alarm withAlarms:(NSArray *)alarms withTriggers:(NSArray *)triggers;



/** Issued by the alarm subsystem when the alarm has been cleared */
+ (PMKPromise *) cancelAlertWithMethod:(NSString *)method withAlarms:(NSArray *)alarms;



@end
