

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;







































/** The desired low temperature when the HVAC unit is in cooling or auto mode. May also be used to set the target temperature. */
extern NSString *const kAttrThermostatCoolsetpoint;

/** The desired high temperature when the HVAC unit is in heating or auto mode. May also be used to set the target temperature. */
extern NSString *const kAttrThermostatHeatsetpoint;

/** The minimum setpoint for the thermostat, inclusive.  The heatsetpoint can&#x27;t be set below this and the coolsetpoint can&#x27;t be set below minsetpoint + setpointseparation. */
extern NSString *const kAttrThermostatMinsetpoint;

/** The maximum setpoint for the thermostat, inclusive.  The coolsetpoint can&#x27;t be set above this and the heatsetpoint can&#x27;t be set above maxsetpoint - setpointseparation. */
extern NSString *const kAttrThermostatMaxsetpoint;

/** The heatsetpoint and coolsetpoint should be kept apart by at least this many degrees.  If only heatsetpoint or coolsetpoint are changed then the driver must automatically adjust the other setpoint if needed.  If both are specified and within setpointseparation of each other the driver may adjust either setpoint as needed to maintain the proper amount of separation. */
extern NSString *const kAttrThermostatSetpointseparation;

/** The current mode of the HVAC system. */
extern NSString *const kAttrThermostatHvacmode;

/** Modes supported by this thermostat */
extern NSString *const kAttrThermostatSupportedmodes;

/** Whether or not the thermostat supports AUTO mode.  If not present, assume true */
extern NSString *const kAttrThermostatSupportsAuto;

/** Current fan mode setting. */
extern NSString *const kAttrThermostatFanmode;

/** The maximum speed supported by the fan. */
extern NSString *const kAttrThermostatMaxfanspeed;

/** Set the speed of the fan when in auto mode. */
extern NSString *const kAttrThermostatAutofanspeed;

/** Useful only for 2 stage heat pumps that require a secondary (usually electric) heater when the external temperature is below a certain threshold. */
extern NSString *const kAttrThermostatEmergencyheat;

/** The current mode of the HVAC system. */
extern NSString *const kAttrThermostatControlmode;

/** Placeholder for user to enter filter type like 16x25x1. */
extern NSString *const kAttrThermostatFiltertype;

/** Placeholder for user to enter life span (in runtime hours) of the filter. */
extern NSString *const kAttrThermostatFilterlifespanruntime;

/** Placeholder for user to enter life span (in total days) of the filter. */
extern NSString *const kAttrThermostatFilterlifespandays;

/** Number of hours of runtime since the last filter change. */
extern NSString *const kAttrThermostatRuntimesincefilterchange;

/** Number of days elapsed since the last filter change. */
extern NSString *const kAttrThermostatDayssincefilterchange;

/** Indicator of whether the HVAC system is actively running or not.  Interpreted as fan is blowing, not necessarily heating or cooling. */
extern NSString *const kAttrThermostatActive;


extern NSString *const kCmdThermostatChangeFilter;

extern NSString *const kCmdThermostatSetIdealTemperature;

extern NSString *const kCmdThermostatIncrementIdealTemperature;

extern NSString *const kCmdThermostatDecrementIdealTemperature;


extern NSString *const kEvtThermostatSetPointChanged;

extern NSString *const kEnumThermostatHvacmodeOFF;
extern NSString *const kEnumThermostatHvacmodeAUTO;
extern NSString *const kEnumThermostatHvacmodeCOOL;
extern NSString *const kEnumThermostatHvacmodeHEAT;
extern NSString *const kEnumThermostatHvacmodeECO;
extern NSString *const kEnumThermostatEmergencyheatON;
extern NSString *const kEnumThermostatEmergencyheatOFF;
extern NSString *const kEnumThermostatControlmodePRESENCE;
extern NSString *const kEnumThermostatControlmodeMANUAL;
extern NSString *const kEnumThermostatControlmodeSCHEDULESIMPLE;
extern NSString *const kEnumThermostatControlmodeSCHEDULEADVANCED;
extern NSString *const kEnumThermostatActiveRUNNING;
extern NSString *const kEnumThermostatActiveNOTRUNNING;


@interface ThermostatCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getCoolsetpointFromModel:(DeviceModel *)modelObj;

+ (double)setCoolsetpoint:(double)coolsetpoint onModel:(DeviceModel *)modelObj;


+ (double)getHeatsetpointFromModel:(DeviceModel *)modelObj;

+ (double)setHeatsetpoint:(double)heatsetpoint onModel:(DeviceModel *)modelObj;


+ (double)getMinsetpointFromModel:(DeviceModel *)modelObj;


+ (double)getMaxsetpointFromModel:(DeviceModel *)modelObj;


+ (double)getSetpointseparationFromModel:(DeviceModel *)modelObj;


+ (NSString *)getHvacmodeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setHvacmode:(NSString *)hvacmode onModel:(DeviceModel *)modelObj;


+ (NSArray *)getSupportedmodesFromModel:(DeviceModel *)modelObj;


+ (BOOL)getSupportsAutoFromModel:(DeviceModel *)modelObj;


+ (int)getFanmodeFromModel:(DeviceModel *)modelObj;

+ (int)setFanmode:(int)fanmode onModel:(DeviceModel *)modelObj;


+ (int)getMaxfanspeedFromModel:(DeviceModel *)modelObj;


+ (int)getAutofanspeedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getEmergencyheatFromModel:(DeviceModel *)modelObj;

+ (NSString *)setEmergencyheat:(NSString *)emergencyheat onModel:(DeviceModel *)modelObj;


+ (NSString *)getControlmodeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setControlmode:(NSString *)controlmode onModel:(DeviceModel *)modelObj;


+ (NSString *)getFiltertypeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setFiltertype:(NSString *)filtertype onModel:(DeviceModel *)modelObj;


+ (int)getFilterlifespanruntimeFromModel:(DeviceModel *)modelObj;

+ (int)setFilterlifespanruntime:(int)filterlifespanruntime onModel:(DeviceModel *)modelObj;


+ (int)getFilterlifespandaysFromModel:(DeviceModel *)modelObj;

+ (int)setFilterlifespandays:(int)filterlifespandays onModel:(DeviceModel *)modelObj;


+ (int)getRuntimesincefilterchangeFromModel:(DeviceModel *)modelObj;


+ (int)getDayssincefilterchangeFromModel:(DeviceModel *)modelObj;


+ (NSString *)getActiveFromModel:(DeviceModel *)modelObj;





/** Indicates that the filter has been changed and that runtimesincefilterchange and dayssincefilterchange should be reset. */
+ (PMKPromise *) changeFilterOnModel:(Model *)modelObj;



/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will set each 2 degrees F from the desired temp.  If the OFF no action should be taken. */
+ (PMKPromise *) setIdealTemperatureWithTemperature:(double)temperature onModel:(Model *)modelObj;



/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will attempt to determine the current ideal temp then adjust cool and heat points. */
+ (PMKPromise *) incrementIdealTemperatureWithAmount:(double)amount onModel:(Model *)modelObj;



/** Updates the heat and/or cool set point depending on the current mode.  When in heat mode this will adjust only the heat set point, when in cool mode it will adjust only the cool set point.  When in auto mode, it will attempt to determine the current ideal temp then adjust cool and heat points. */
+ (PMKPromise *) decrementIdealTemperatureWithAmount:(double)amount onModel:(Model *)modelObj;



@end
