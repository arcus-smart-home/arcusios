

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/** The set of weather radio devices in the place */
extern NSString *const kAttrWeatherSubsystemWeatherRadios;

/** Indicates the whether any weather radios are currently alerting         - READY - No weather radios are alerting         - ALERT - One or more weather radios are alerting */
extern NSString *const kAttrWeatherSubsystemWeatherAlert;

/** A map of NWS EAS event codes for the current alert to the devices that are reporting that alert */
extern NSString *const kAttrWeatherSubsystemAlertingRadios;

/** The last time a weather alert was raised */
extern NSString *const kAttrWeatherSubsystemLastWeatherAlertTime;


extern NSString *const kCmdWeatherSubsystemSnoozeAllAlerts;


extern NSString *const kEnumWeatherSubsystemWeatherAlertREADY;
extern NSString *const kEnumWeatherSubsystemWeatherAlertALERT;


@interface WeatherSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getWeatherRadiosFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getWeatherAlertFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getAlertingRadiosFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getLastWeatherAlertTimeFromModel:(SubsystemModel *)modelObj;





/** Send a stopplaying request to each station that is playing a weather alert. */
+ (PMKPromise *) snoozeAllAlertsOnModel:(Model *)modelObj;



@end
