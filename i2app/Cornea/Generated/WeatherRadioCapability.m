

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WeatherRadioCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrWeatherRadioAlertstate=@"noaa:alertstate";

NSString *const kAttrWeatherRadioPlayingstate=@"noaa:playingstate";

NSString *const kAttrWeatherRadioCurrentalert=@"noaa:currentalert";

NSString *const kAttrWeatherRadioLastalerttime=@"noaa:lastalerttime";

NSString *const kAttrWeatherRadioAlertsofinterest=@"noaa:alertsofinterest";

NSString *const kAttrWeatherRadioLocation=@"noaa:location";

NSString *const kAttrWeatherRadioStationselected=@"noaa:stationselected";

NSString *const kAttrWeatherRadioFrequency=@"noaa:frequency";


NSString *const kCmdWeatherRadioScanStations=@"noaa:ScanStations";

NSString *const kCmdWeatherRadioPlayStation=@"noaa:PlayStation";

NSString *const kCmdWeatherRadioStopPlayingStation=@"noaa:StopPlayingStation";

NSString *const kCmdWeatherRadioSelectStation=@"noaa:SelectStation";


NSString *const kEnumWeatherRadioAlertstateALERT = @"ALERT";
NSString *const kEnumWeatherRadioAlertstateNO_ALERT = @"NO_ALERT";
NSString *const kEnumWeatherRadioAlertstateHUSHED = @"HUSHED";
NSString *const kEnumWeatherRadioPlayingstatePLAYING = @"PLAYING";
NSString *const kEnumWeatherRadioPlayingstateQUIET = @"QUIET";


@implementation WeatherRadioCapability
+ (NSString *)namespace { return @"noaa"; }
+ (NSString *)name { return @"WeatherRadio"; }

+ (NSString *)getAlertstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherRadioCapabilityLegacy getAlertstate:modelObj];
  
}


+ (NSString *)getPlayingstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherRadioCapabilityLegacy getPlayingstate:modelObj];
  
}


+ (NSString *)getCurrentalertFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherRadioCapabilityLegacy getCurrentalert:modelObj];
  
}


+ (NSDate *)getLastalerttimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherRadioCapabilityLegacy getLastalerttime:modelObj];
  
}


+ (NSArray *)getAlertsofinterestFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherRadioCapabilityLegacy getAlertsofinterest:modelObj];
  
}

+ (NSArray *)setAlertsofinterest:(NSArray *)alertsofinterest onModel:(DeviceModel *)modelObj {
  [WeatherRadioCapabilityLegacy setAlertsofinterest:alertsofinterest model:modelObj];
  
  return [WeatherRadioCapabilityLegacy getAlertsofinterest:modelObj];
  
}


+ (NSString *)getLocationFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherRadioCapabilityLegacy getLocation:modelObj];
  
}

+ (NSString *)setLocation:(NSString *)location onModel:(DeviceModel *)modelObj {
  [WeatherRadioCapabilityLegacy setLocation:location model:modelObj];
  
  return [WeatherRadioCapabilityLegacy getLocation:modelObj];
  
}


+ (int)getStationselectedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WeatherRadioCapabilityLegacy getStationselected:modelObj] intValue];
  
}

+ (int)setStationselected:(int)stationselected onModel:(DeviceModel *)modelObj {
  [WeatherRadioCapabilityLegacy setStationselected:stationselected model:modelObj];
  
  return [[WeatherRadioCapabilityLegacy getStationselected:modelObj] intValue];
  
}


+ (NSString *)getFrequencyFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WeatherRadioCapabilityLegacy getFrequency:modelObj];
  
}




+ (PMKPromise *) scanStationsOnModel:(DeviceModel *)modelObj {
  return [WeatherRadioCapabilityLegacy scanStations:modelObj ];
}


+ (PMKPromise *) playStationWithStation:(int)station withTime:(int)time onModel:(DeviceModel *)modelObj {
  return [WeatherRadioCapabilityLegacy playStation:modelObj station:station time:time];

}


+ (PMKPromise *) stopPlayingStationOnModel:(DeviceModel *)modelObj {
  return [WeatherRadioCapabilityLegacy stopPlayingStation:modelObj ];
}


+ (PMKPromise *) selectStationWithStation:(int)station onModel:(DeviceModel *)modelObj {
  return [WeatherRadioCapabilityLegacy selectStation:modelObj station:station];

}

@end
