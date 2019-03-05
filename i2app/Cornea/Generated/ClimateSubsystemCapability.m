

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ClimateSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrClimateSubsystemControlDevices=@"subclimate:controlDevices";

NSString *const kAttrClimateSubsystemTemperatureDevices=@"subclimate:temperatureDevices";

NSString *const kAttrClimateSubsystemHumidityDevices=@"subclimate:humidityDevices";

NSString *const kAttrClimateSubsystemThermostats=@"subclimate:thermostats";

NSString *const kAttrClimateSubsystemThermostatSchedules=@"subclimate:thermostatSchedules";

NSString *const kAttrClimateSubsystemClosedVents=@"subclimate:closedVents";

NSString *const kAttrClimateSubsystemActiveFans=@"subclimate:activeFans";

NSString *const kAttrClimateSubsystemPrimaryTemperatureDevice=@"subclimate:primaryTemperatureDevice";

NSString *const kAttrClimateSubsystemPrimaryHumidityDevice=@"subclimate:primaryHumidityDevice";

NSString *const kAttrClimateSubsystemPrimaryThermostat=@"subclimate:primaryThermostat";

NSString *const kAttrClimateSubsystemTemperature=@"subclimate:temperature";

NSString *const kAttrClimateSubsystemHumidity=@"subclimate:humidity";

NSString *const kAttrClimateSubsystemActiveHeaters=@"subclimate:activeHeaters";


NSString *const kCmdClimateSubsystemEnableScheduler=@"subclimate:EnableScheduler";

NSString *const kCmdClimateSubsystemDisableScheduler=@"subclimate:DisableScheduler";




@implementation ClimateSubsystemCapability
+ (NSString *)namespace { return @"subclimate"; }
+ (NSString *)name { return @"ClimateSubsystem"; }

+ (NSArray *)getControlDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getControlDevices:modelObj];
  
}


+ (NSArray *)getTemperatureDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getTemperatureDevices:modelObj];
  
}


+ (NSArray *)getHumidityDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getHumidityDevices:modelObj];
  
}


+ (NSArray *)getThermostatsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getThermostats:modelObj];
  
}


+ (NSDictionary *)getThermostatSchedulesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getThermostatSchedules:modelObj];
  
}


+ (NSArray *)getClosedVentsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getClosedVents:modelObj];
  
}


+ (NSArray *)getActiveFansFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getActiveFans:modelObj];
  
}


+ (NSString *)getPrimaryTemperatureDeviceFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getPrimaryTemperatureDevice:modelObj];
  
}

+ (NSString *)setPrimaryTemperatureDevice:(NSString *)primaryTemperatureDevice onModel:(SubsystemModel *)modelObj {
  [ClimateSubsystemCapabilityLegacy setPrimaryTemperatureDevice:primaryTemperatureDevice model:modelObj];
  
  return [ClimateSubsystemCapabilityLegacy getPrimaryTemperatureDevice:modelObj];
  
}


+ (NSString *)getPrimaryHumidityDeviceFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getPrimaryHumidityDevice:modelObj];
  
}

+ (NSString *)setPrimaryHumidityDevice:(NSString *)primaryHumidityDevice onModel:(SubsystemModel *)modelObj {
  [ClimateSubsystemCapabilityLegacy setPrimaryHumidityDevice:primaryHumidityDevice model:modelObj];
  
  return [ClimateSubsystemCapabilityLegacy getPrimaryHumidityDevice:modelObj];
  
}


+ (NSString *)getPrimaryThermostatFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getPrimaryThermostat:modelObj];
  
}

+ (NSString *)setPrimaryThermostat:(NSString *)primaryThermostat onModel:(SubsystemModel *)modelObj {
  [ClimateSubsystemCapabilityLegacy setPrimaryThermostat:primaryThermostat model:modelObj];
  
  return [ClimateSubsystemCapabilityLegacy getPrimaryThermostat:modelObj];
  
}


+ (double)getTemperatureFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClimateSubsystemCapabilityLegacy getTemperature:modelObj] doubleValue];
  
}


+ (double)getHumidityFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ClimateSubsystemCapabilityLegacy getHumidity:modelObj] doubleValue];
  
}


+ (NSArray *)getActiveHeatersFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ClimateSubsystemCapabilityLegacy getActiveHeaters:modelObj];
  
}




+ (PMKPromise *) enableSchedulerWithThermostat:(NSString *)thermostat onModel:(SubsystemModel *)modelObj {
  return [ClimateSubsystemCapabilityLegacy enableScheduler:modelObj thermostat:thermostat];

}


+ (PMKPromise *) disableSchedulerWithThermostat:(NSString *)thermostat onModel:(SubsystemModel *)modelObj {
  return [ClimateSubsystemCapabilityLegacy disableScheduler:modelObj thermostat:thermostat];

}

@end
