

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Indicates whether the zone is currently watering or not */
extern NSString *const kAttrIrrigationZoneZoneState;

/** If watering, the time at which the watering started. Together with wateringDuration this defines a time range during which watering will be acive. */
extern NSString *const kAttrIrrigationZoneWateringStart;

/** If not watering, set to 0. If non-zero, can be used with wateringStart to define a time range during which watering will be active. */
extern NSString *const kAttrIrrigationZoneWateringDuration;

/** If watering, what triggered the watering event */
extern NSString *const kAttrIrrigationZoneWateringTrigger;

/** The default duration in minutes for scheduling this zone */
extern NSString *const kAttrIrrigationZoneDefaultDuration;

/** Index of this zone on the system. Should start at 1 so 0 can represent pump or full system. */
extern NSString *const kAttrIrrigationZoneZonenum;

/** Name of the zone on the platform. (&#x27;front yard&#x27;, &#x27;roses&#x27;, etc.) */
extern NSString *const kAttrIrrigationZoneZonename;

/** Color used to represent the zone on the UI. */
extern NSString *const kAttrIrrigationZoneZonecolor;

/** This attribute was deprecated in the 1.8 release. */
extern NSString *const kAttrIrrigationZoneWateringRemainingTime;



extern NSString *const kEnumIrrigationZoneZoneStateWATERING;
extern NSString *const kEnumIrrigationZoneZoneStateNOT_WATERING;
extern NSString *const kEnumIrrigationZoneWateringTriggerMANUAL;
extern NSString *const kEnumIrrigationZoneWateringTriggerSCHEDULED;
extern NSString *const kEnumIrrigationZoneZonecolorLIGHTRED;
extern NSString *const kEnumIrrigationZoneZonecolorDARKRED;
extern NSString *const kEnumIrrigationZoneZonecolorORANGE;
extern NSString *const kEnumIrrigationZoneZonecolorYELLOW;
extern NSString *const kEnumIrrigationZoneZonecolorLIGHTGREEN;
extern NSString *const kEnumIrrigationZoneZonecolorDARKGREEN;
extern NSString *const kEnumIrrigationZoneZonecolorLIGHTBLUE;
extern NSString *const kEnumIrrigationZoneZonecolorDARKBLUE;
extern NSString *const kEnumIrrigationZoneZonecolorVIOLET;
extern NSString *const kEnumIrrigationZoneZonecolorWHITE;
extern NSString *const kEnumIrrigationZoneZonecolorGREY;
extern NSString *const kEnumIrrigationZoneZonecolorBLACK;


@interface IrrigationZoneCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getZoneStateFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getWateringStartFromModel:(DeviceModel *)modelObj;


+ (int)getWateringDurationFromModel:(DeviceModel *)modelObj;


+ (NSString *)getWateringTriggerFromModel:(DeviceModel *)modelObj;


+ (int)getDefaultDurationFromModel:(DeviceModel *)modelObj;

+ (int)setDefaultDuration:(int)defaultDuration onModel:(DeviceModel *)modelObj;


+ (int)getZonenumFromModel:(DeviceModel *)modelObj;


+ (NSString *)getZonenameFromModel:(DeviceModel *)modelObj;

+ (NSString *)setZonename:(NSString *)zonename onModel:(DeviceModel *)modelObj;


+ (NSString *)getZonecolorFromModel:(DeviceModel *)modelObj;

+ (NSString *)setZonecolor:(NSString *)zonecolor onModel:(DeviceModel *)modelObj;


+ (int)getWateringRemainingTimeFromModel:(DeviceModel *)modelObj;





@end
