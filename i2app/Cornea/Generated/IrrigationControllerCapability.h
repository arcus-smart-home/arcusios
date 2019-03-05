

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;











/** The number of irrigation zones this device controls. */
extern NSString *const kAttrIrrigationControllerNumZones;

/** Indicates whether the zone is currently watering or not */
extern NSString *const kAttrIrrigationControllerControllerState;

/** The start time of a rain delay. Used together with rainDelayDuration this can be used to define a time range during which the rain delay is active. */
extern NSString *const kAttrIrrigationControllerRainDelayStart;

/** If zero, no rain delay is in affect. If non-zero, this value can be used together with rainDelayStart to define a time range during which the rain delay is active. */
extern NSString *const kAttrIrrigationControllerRainDelayDuration;

/** Maximum number of schedule events this device can support. The schedule cannot allow the user to set more total events than this. */
extern NSString *const kAttrIrrigationControllerMaxtransitions;

/** Maximum number of schedule events per day this device can support. */
extern NSString *const kAttrIrrigationControllerMaxdailytransitions;

/** Minimum time one zone can be watering at a time. */
extern NSString *const kAttrIrrigationControllerMinirrigationtime;

/** Maximum time one zone can be watering at a time. */
extern NSString *const kAttrIrrigationControllerMaxirrigationtime;

/** Default: 100. Setting this number from 10-90 (most devices only support 10% increments) reduces the water usage to that percentage. Setting this number from 110-200) increases water usage for dryer moments. Note: current Orbit devices support &#x27;stacking&#x27; meaning if the increased schedule results in a subsequent start time to be delayed, this start time becomes &#x27;stacked&#x27; and handled as soon as possible. If the UI supports showing the user what zone is running, supporting budget&gt;100 means the UI will need to compute this stacking. Alternative is to not allow this number to be over 100 (as Arcus1 does). */
extern NSString *const kAttrIrrigationControllerBudget;

/** Which zones are currently in fault (solenoid jammed, usually). 0 can represent a single pump, if each zone has a pump than pump and/or solenoid should be represented by zonenum. */
extern NSString *const kAttrIrrigationControllerZonesinfault;

/** This attribute was deprecated in 1.8. */
extern NSString *const kAttrIrrigationControllerRainDelay;


extern NSString *const kCmdIrrigationControllerWaterNowV2;

extern NSString *const kCmdIrrigationControllerCancelV2;

extern NSString *const kCmdIrrigationControllerWaterNow;

extern NSString *const kCmdIrrigationControllerCancel;


extern NSString *const kEnumIrrigationControllerControllerStateOFF;
extern NSString *const kEnumIrrigationControllerControllerStateWATERING;
extern NSString *const kEnumIrrigationControllerControllerStateNOT_WATERING;
extern NSString *const kEnumIrrigationControllerControllerStateRAIN_DELAY;


@interface IrrigationControllerCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getNumZonesFromModel:(DeviceModel *)modelObj;


+ (NSString *)getControllerStateFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getRainDelayStartFromModel:(DeviceModel *)modelObj;


+ (int)getRainDelayDurationFromModel:(DeviceModel *)modelObj;


+ (int)getMaxtransitionsFromModel:(DeviceModel *)modelObj;


+ (int)getMaxdailytransitionsFromModel:(DeviceModel *)modelObj;


+ (int)getMinirrigationtimeFromModel:(DeviceModel *)modelObj;


+ (int)getMaxirrigationtimeFromModel:(DeviceModel *)modelObj;


+ (int)getBudgetFromModel:(DeviceModel *)modelObj;

+ (int)setBudget:(int)budget onModel:(DeviceModel *)modelObj;


+ (NSArray *)getZonesinfaultFromModel:(DeviceModel *)modelObj;


+ (int)getRainDelayFromModel:(DeviceModel *)modelObj;

+ (int)setRainDelay:(int)rainDelay onModel:(DeviceModel *)modelObj;





/** Starts watering the indicated zone for the duration specified. */
+ (PMKPromise *) waterNowV2WithZone:(NSString *)zone withDuration:(int)duration onModel:(Model *)modelObj;



/** Cancels any watering currently in progress. */
+ (PMKPromise *) cancelV2WithZone:(NSString *)zone onModel:(Model *)modelObj;



/** This method was deprecated in 1.8. */
+ (PMKPromise *) waterNowWithZonenum:(int)zonenum withDuration:(int)duration onModel:(Model *)modelObj;



/** This method was deprecated in 1.8. */
+ (PMKPromise *) cancelWithZonenum:(int)zonenum onModel:(Model *)modelObj;



@end
