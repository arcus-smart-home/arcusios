

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WeatherSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrWeatherSubsystemWeatherRadios=@"subweather:weatherRadios";

NSString *const kAttrWeatherSubsystemWeatherAlert=@"subweather:weatherAlert";

NSString *const kAttrWeatherSubsystemAlertingRadios=@"subweather:alertingRadios";

NSString *const kAttrWeatherSubsystemLastWeatherAlertTime=@"subweather:lastWeatherAlertTime";


NSString *const kCmdWeatherSubsystemSnoozeAllAlerts=@"subweather:SnoozeAllAlerts";


NSString *const kEnumWeatherSubsystemWeatherAlertREADY = @"READY";
NSString *const kEnumWeatherSubsystemWeatherAlertALERT = @"ALERT";


@implementation WeatherSubsystemCapability
+ (NSString *)namespace { return @"subweather"; }
+ (NSString *)name { return @"WeatherSubsystem"; }

+ (NSArray *)getWeatherRadiosFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherSubsystemCapabilityLegacy getWeatherRadios:modelObj];
  
}


+ (NSString *)getWeatherAlertFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherSubsystemCapabilityLegacy getWeatherAlert:modelObj];
  
}


+ (NSDictionary *)getAlertingRadiosFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherSubsystemCapabilityLegacy getAlertingRadios:modelObj];
  
}


+ (NSDate *)getLastWeatherAlertTimeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherSubsystemCapabilityLegacy getLastWeatherAlertTime:modelObj];
  
}




+ (PMKPromise *) snoozeAllAlertsOnModel:(SubsystemModel *)modelObj {
  return [WeatherSubsystemCapabilityLegacy snoozeAllAlerts:modelObj ];
}

@end
