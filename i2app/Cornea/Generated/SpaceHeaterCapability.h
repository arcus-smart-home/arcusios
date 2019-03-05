

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The desired temperature when the unit is running, maps to heatsetpoint in  thermostat. May also be used to set the target temperature. */
extern NSString *const kAttrSpaceHeaterSetpoint;

/** The minimum temperature that can be placed in setpoint. */
extern NSString *const kAttrSpaceHeaterMinsetpoint;

/** The maximum temperature that can be placed in setpoint. */
extern NSString *const kAttrSpaceHeaterMaxsetpoint;

/** The current mode of the device, maps to OFF, HEAT in thermostat:mode. */
extern NSString *const kAttrSpaceHeaterHeatstate;



extern NSString *const kEnumSpaceHeaterHeatstateOFF;
extern NSString *const kEnumSpaceHeaterHeatstateON;


@interface SpaceHeaterCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (double)getSetpointFromModel:(DeviceModel *)modelObj;

+ (double)setSetpoint:(double)setpoint onModel:(DeviceModel *)modelObj;


+ (double)getMinsetpointFromModel:(DeviceModel *)modelObj;


+ (double)getMaxsetpointFromModel:(DeviceModel *)modelObj;


+ (NSString *)getHeatstateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setHeatstate:(NSString *)heatstate onModel:(DeviceModel *)modelObj;





@end
