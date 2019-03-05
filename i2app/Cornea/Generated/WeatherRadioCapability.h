

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;





/** Reflects the current state of the weather radio (alerting, no existing alert, or an existing hushed alert). */
extern NSString *const kAttrWeatherRadioAlertstate;

/** Reflects whether the weather radio is currently playing or is quiet. */
extern NSString *const kAttrWeatherRadioPlayingstate;

/** EAS code for current alert (three letter strings). Set to NONE when no alert is active. Set to UNKNOWN when a code not currently known is sent. */
extern NSString *const kAttrWeatherRadioCurrentalert;

/** UTC date time of last alert start time. Note if alert changes (county list or duration), timestamp will be updated. */
extern NSString *const kAttrWeatherRadioLastalerttime;

/** List of EAS alert codes the user wishes to be notifed of (three letter strings). */
extern NSString *const kAttrWeatherRadioAlertsofinterest;

/** Six digit S.A.M.E. code for locations published by NOAA. */
extern NSString *const kAttrWeatherRadioLocation;

/** station ID of selected station. */
extern NSString *const kAttrWeatherRadioStationselected;

/** Broadcast frequency of selected station. */
extern NSString *const kAttrWeatherRadioFrequency;


extern NSString *const kCmdWeatherRadioScanStations;

extern NSString *const kCmdWeatherRadioPlayStation;

extern NSString *const kCmdWeatherRadioStopPlayingStation;

extern NSString *const kCmdWeatherRadioSelectStation;


extern NSString *const kEnumWeatherRadioAlertstateALERT;
extern NSString *const kEnumWeatherRadioAlertstateNO_ALERT;
extern NSString *const kEnumWeatherRadioAlertstateHUSHED;
extern NSString *const kEnumWeatherRadioPlayingstatePLAYING;
extern NSString *const kEnumWeatherRadioPlayingstateQUIET;


@interface WeatherRadioCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getAlertstateFromModel:(DeviceModel *)modelObj;


+ (NSString *)getPlayingstateFromModel:(DeviceModel *)modelObj;


+ (NSString *)getCurrentalertFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getLastalerttimeFromModel:(DeviceModel *)modelObj;


+ (NSArray *)getAlertsofinterestFromModel:(DeviceModel *)modelObj;

+ (NSArray *)setAlertsofinterest:(NSArray *)alertsofinterest onModel:(DeviceModel *)modelObj;


+ (NSString *)getLocationFromModel:(DeviceModel *)modelObj;

+ (NSString *)setLocation:(NSString *)location onModel:(DeviceModel *)modelObj;


+ (int)getStationselectedFromModel:(DeviceModel *)modelObj;

+ (int)setStationselected:(int)stationselected onModel:(DeviceModel *)modelObj;


+ (NSString *)getFrequencyFromModel:(DeviceModel *)modelObj;





/** Scans all stations to determine which can be heard. */
+ (PMKPromise *) scanStationsOnModel:(Model *)modelObj;



/** Play selected station to allow user to select amongst the options. */
+ (PMKPromise *) playStationWithStation:(int)station withTime:(int)time onModel:(Model *)modelObj;



/** Stop playing current station. */
+ (PMKPromise *) stopPlayingStationOnModel:(Model *)modelObj;



/** Select station as the one Halo will use. */
+ (PMKPromise *) selectStationWithStation:(int)station onModel:(Model *)modelObj;



@end
