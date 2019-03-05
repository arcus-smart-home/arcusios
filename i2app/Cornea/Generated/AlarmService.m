

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AlarmService.h"
#import <i2app-Swift.h>

@implementation AlarmService
+ (NSString *)name { return @"AlarmService"; }
+ (NSString *)address { return @"SERV:alarmservice:"; }


+ (PMKPromise *) addAlarmWithAlarm:(NSString *)alarm withAlarms:(NSArray *)alarms withTriggers:(NSArray *)triggers {
  return [AlarmServiceLegacy addAlarm:alarm alarms:alarms triggers:triggers];

}


+ (PMKPromise *) cancelAlertWithMethod:(NSString *)method withAlarms:(NSArray *)alarms {
  return [AlarmServiceLegacy cancelAlert:method alarms:alarms];

}

@end
