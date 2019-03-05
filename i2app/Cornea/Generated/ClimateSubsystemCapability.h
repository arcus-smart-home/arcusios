

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/** The addresses of all the climate control devices in the climate subsystem, this includes thermostats, fans, vents and spaceheaters. */
extern NSString *const kAttrClimateSubsystemControlDevices;

/** The addresses of all the devices in the place that have the temperature capability. */
extern NSString *const kAttrClimateSubsystemTemperatureDevices;

/** The addresses of all the devices in the place that have the humidity capability. */
extern NSString *const kAttrClimateSubsystemHumidityDevices;

/** DEPRECATED: This attribute is deprecated and will be removed in future iterations! The addresses of all the devices in the place that have the thermostat capability. */
extern NSString *const kAttrClimateSubsystemThermostats;

/** The current status of the schedule for each thermostat */
extern NSString *const kAttrClimateSubsystemThermostatSchedules;

/**  The addresses of all vents that are currently closed. */
extern NSString *const kAttrClimateSubsystemClosedVents;

/** The addresses of all fans that are currently turned on. */
extern NSString *const kAttrClimateSubsystemActiveFans;

/** The temperature sensor that should be used when displaying the temperature for the whole place.  This may be null if no devices support temperature. */
extern NSString *const kAttrClimateSubsystemPrimaryTemperatureDevice;

/**  The humidity sensor that should be used when displaying the humidity for the whole place.  This may be null if no devices support humidity. */
extern NSString *const kAttrClimateSubsystemPrimaryHumidityDevice;

/** The primary thermostat for the house, this may be null if there are no thermostat devices. */
extern NSString *const kAttrClimateSubsystemPrimaryThermostat;

/** The current temperature for the place, this may be null if there are no temperature devices.  This is currently calculated from primaryTemperatureDevice. */
extern NSString *const kAttrClimateSubsystemTemperature;

/** The current humidity for the place, this may be null if there are no humidity devices.  This is currently calculated from primaryHumidityDevice. */
extern NSString *const kAttrClimateSubsystemHumidity;

/** The addresses of all devices that implement spaceheater and have heatstate value of ON */
extern NSString *const kAttrClimateSubsystemActiveHeaters;


extern NSString *const kCmdClimateSubsystemEnableScheduler;

extern NSString *const kCmdClimateSubsystemDisableScheduler;




@interface ClimateSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getControlDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getTemperatureDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getHumidityDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getThermostatsFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getThermostatSchedulesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getClosedVentsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getActiveFansFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getPrimaryTemperatureDeviceFromModel:(SubsystemModel *)modelObj;

+ (NSString *)setPrimaryTemperatureDevice:(NSString *)primaryTemperatureDevice onModel:(SubsystemModel *)modelObj;


+ (NSString *)getPrimaryHumidityDeviceFromModel:(SubsystemModel *)modelObj;

+ (NSString *)setPrimaryHumidityDevice:(NSString *)primaryHumidityDevice onModel:(SubsystemModel *)modelObj;


+ (NSString *)getPrimaryThermostatFromModel:(SubsystemModel *)modelObj;

+ (NSString *)setPrimaryThermostat:(NSString *)primaryThermostat onModel:(SubsystemModel *)modelObj;


+ (double)getTemperatureFromModel:(SubsystemModel *)modelObj;


+ (double)getHumidityFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getActiveHeatersFromModel:(SubsystemModel *)modelObj;





/** Enables the scheduler associated with the given thermostat.  NOTE this will return a &#x27;timezone.notset&#x27; error if the place does not have a valid timezone. */
+ (PMKPromise *) enableSchedulerWithThermostat:(NSString *)thermostat onModel:(Model *)modelObj;



/** Enables the scheduler associated with the given thermostat. */
+ (PMKPromise *) disableSchedulerWithThermostat:(NSString *)thermostat onModel:(Model *)modelObj;



@end
