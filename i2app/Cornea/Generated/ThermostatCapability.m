

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ThermostatCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrThermostatCoolsetpoint=@"therm:coolsetpoint";

NSString *const kAttrThermostatHeatsetpoint=@"therm:heatsetpoint";

NSString *const kAttrThermostatMinsetpoint=@"therm:minsetpoint";

NSString *const kAttrThermostatMaxsetpoint=@"therm:maxsetpoint";

NSString *const kAttrThermostatSetpointseparation=@"therm:setpointseparation";

NSString *const kAttrThermostatHvacmode=@"therm:hvacmode";

NSString *const kAttrThermostatSupportedmodes=@"therm:supportedmodes";

NSString *const kAttrThermostatSupportsAuto=@"therm:supportsAuto";

NSString *const kAttrThermostatFanmode=@"therm:fanmode";

NSString *const kAttrThermostatMaxfanspeed=@"therm:maxfanspeed";

NSString *const kAttrThermostatAutofanspeed=@"therm:autofanspeed";

NSString *const kAttrThermostatEmergencyheat=@"therm:emergencyheat";

NSString *const kAttrThermostatControlmode=@"therm:controlmode";

NSString *const kAttrThermostatFiltertype=@"therm:filtertype";

NSString *const kAttrThermostatFilterlifespanruntime=@"therm:filterlifespanruntime";

NSString *const kAttrThermostatFilterlifespandays=@"therm:filterlifespandays";

NSString *const kAttrThermostatRuntimesincefilterchange=@"therm:runtimesincefilterchange";

NSString *const kAttrThermostatDayssincefilterchange=@"therm:dayssincefilterchange";

NSString *const kAttrThermostatActive=@"therm:active";


NSString *const kCmdThermostatChangeFilter=@"therm:changeFilter";

NSString *const kCmdThermostatSetIdealTemperature=@"therm:SetIdealTemperature";

NSString *const kCmdThermostatIncrementIdealTemperature=@"therm:IncrementIdealTemperature";

NSString *const kCmdThermostatDecrementIdealTemperature=@"therm:DecrementIdealTemperature";


NSString *const kEvtThermostatSetPointChanged=@"therm:SetPointChanged";

NSString *const kEnumThermostatHvacmodeOFF = @"OFF";
NSString *const kEnumThermostatHvacmodeAUTO = @"AUTO";
NSString *const kEnumThermostatHvacmodeCOOL = @"COOL";
NSString *const kEnumThermostatHvacmodeHEAT = @"HEAT";
NSString *const kEnumThermostatHvacmodeECO = @"ECO";
NSString *const kEnumThermostatEmergencyheatON = @"ON";
NSString *const kEnumThermostatEmergencyheatOFF = @"OFF";
NSString *const kEnumThermostatControlmodePRESENCE = @"PRESENCE";
NSString *const kEnumThermostatControlmodeMANUAL = @"MANUAL";
NSString *const kEnumThermostatControlmodeSCHEDULESIMPLE = @"SCHEDULESIMPLE";
NSString *const kEnumThermostatControlmodeSCHEDULEADVANCED = @"SCHEDULEADVANCED";
NSString *const kEnumThermostatActiveRUNNING = @"RUNNING";
NSString *const kEnumThermostatActiveNOTRUNNING = @"NOTRUNNING";


@implementation ThermostatCapability
+ (NSString *)namespace { return @"therm"; }
+ (NSString *)name { return @"Thermostat"; }

+ (double)getCoolsetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getCoolsetpoint:modelObj] doubleValue];
  
}

+ (double)setCoolsetpoint:(double)coolsetpoint onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setCoolsetpoint:coolsetpoint model:modelObj];
  
  return [[ThermostatCapabilityLegacy getCoolsetpoint:modelObj] doubleValue];
  
}


+ (double)getHeatsetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getHeatsetpoint:modelObj] doubleValue];
  
}

+ (double)setHeatsetpoint:(double)heatsetpoint onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setHeatsetpoint:heatsetpoint model:modelObj];
  
  return [[ThermostatCapabilityLegacy getHeatsetpoint:modelObj] doubleValue];
  
}


+ (double)getMinsetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getMinsetpoint:modelObj] doubleValue];
  
}


+ (double)getMaxsetpointFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getMaxsetpoint:modelObj] doubleValue];
  
}


+ (double)getSetpointseparationFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getSetpointseparation:modelObj] doubleValue];
  
}


+ (NSString *)getHvacmodeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ThermostatCapabilityLegacy getHvacmode:modelObj];
  
}

+ (NSString *)setHvacmode:(NSString *)hvacmode onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setHvacmode:hvacmode model:modelObj];
  
  return [ThermostatCapabilityLegacy getHvacmode:modelObj];
  
}


+ (NSArray *)getSupportedmodesFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ThermostatCapabilityLegacy getSupportedmodes:modelObj];
  
}


+ (BOOL)getSupportsAutoFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getSupportsAuto:modelObj] boolValue];
  
}


+ (int)getFanmodeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getFanmode:modelObj] intValue];
  
}

+ (int)setFanmode:(int)fanmode onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setFanmode:fanmode model:modelObj];
  
  return [[ThermostatCapabilityLegacy getFanmode:modelObj] intValue];
  
}


+ (int)getMaxfanspeedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getMaxfanspeed:modelObj] intValue];
  
}


+ (int)getAutofanspeedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getAutofanspeed:modelObj] intValue];
  
}


+ (NSString *)getEmergencyheatFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ThermostatCapabilityLegacy getEmergencyheat:modelObj];
  
}

+ (NSString *)setEmergencyheat:(NSString *)emergencyheat onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setEmergencyheat:emergencyheat model:modelObj];
  
  return [ThermostatCapabilityLegacy getEmergencyheat:modelObj];
  
}


+ (NSString *)getControlmodeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ThermostatCapabilityLegacy getControlmode:modelObj];
  
}

+ (NSString *)setControlmode:(NSString *)controlmode onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setControlmode:controlmode model:modelObj];
  
  return [ThermostatCapabilityLegacy getControlmode:modelObj];
  
}


+ (NSString *)getFiltertypeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ThermostatCapabilityLegacy getFiltertype:modelObj];
  
}

+ (NSString *)setFiltertype:(NSString *)filtertype onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setFiltertype:filtertype model:modelObj];
  
  return [ThermostatCapabilityLegacy getFiltertype:modelObj];
  
}


+ (int)getFilterlifespanruntimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getFilterlifespanruntime:modelObj] intValue];
  
}

+ (int)setFilterlifespanruntime:(int)filterlifespanruntime onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setFilterlifespanruntime:filterlifespanruntime model:modelObj];
  
  return [[ThermostatCapabilityLegacy getFilterlifespanruntime:modelObj] intValue];
  
}


+ (int)getFilterlifespandaysFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getFilterlifespandays:modelObj] intValue];
  
}

+ (int)setFilterlifespandays:(int)filterlifespandays onModel:(DeviceModel *)modelObj {
  [ThermostatCapabilityLegacy setFilterlifespandays:filterlifespandays model:modelObj];
  
  return [[ThermostatCapabilityLegacy getFilterlifespandays:modelObj] intValue];
  
}


+ (int)getRuntimesincefilterchangeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getRuntimesincefilterchange:modelObj] intValue];
  
}


+ (int)getDayssincefilterchangeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ThermostatCapabilityLegacy getDayssincefilterchange:modelObj] intValue];
  
}


+ (NSString *)getActiveFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ThermostatCapabilityLegacy getActive:modelObj];
  
}




+ (PMKPromise *) changeFilterOnModel:(DeviceModel *)modelObj {
  return [ThermostatCapabilityLegacy changeFilter:modelObj ];
}


+ (PMKPromise *) setIdealTemperatureWithTemperature:(double)temperature onModel:(DeviceModel *)modelObj {
  return [ThermostatCapabilityLegacy setIdealTemperature:modelObj temperature:temperature];

}


+ (PMKPromise *) incrementIdealTemperatureWithAmount:(double)amount onModel:(DeviceModel *)modelObj {
  return [ThermostatCapabilityLegacy incrementIdealTemperature:modelObj amount:amount];

}


+ (PMKPromise *) decrementIdealTemperatureWithAmount:(double)amount onModel:(DeviceModel *)modelObj {
  return [ThermostatCapabilityLegacy decrementIdealTemperature:modelObj amount:amount];

}

@end
