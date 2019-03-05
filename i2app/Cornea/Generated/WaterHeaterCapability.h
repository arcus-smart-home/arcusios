

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Indicates if system is currently heating water through an element. */
extern NSString *const kAttrWaterHeaterHeatingstate;

/** This is the maximum temperature as set on the device. It can be changed on the device and it will report that here. */
extern NSString *const kAttrWaterHeaterMaxsetpoint;

/** This is the user-defined setpoint of desired hotwater. The setting cannot be above the (max) setpoint set on the hardware. */
extern NSString *const kAttrWaterHeaterSetpoint;

/** How much hot water is available. */
extern NSString *const kAttrWaterHeaterHotwaterlevel;



extern NSString *const kEnumWaterHeaterHotwaterlevelLOW;
extern NSString *const kEnumWaterHeaterHotwaterlevelMEDIUM;
extern NSString *const kEnumWaterHeaterHotwaterlevelHIGH;


@interface WaterHeaterCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getHeatingstateFromModel:(DeviceModel *)modelObj;


+ (double)getMaxsetpointFromModel:(DeviceModel *)modelObj;


+ (double)getSetpointFromModel:(DeviceModel *)modelObj;

+ (double)setSetpoint:(double)setpoint onModel:(DeviceModel *)modelObj;


+ (NSString *)getHotwaterlevelFromModel:(DeviceModel *)modelObj;





@end
