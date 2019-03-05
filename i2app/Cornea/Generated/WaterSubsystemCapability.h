

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/** When the first water heater is added it will be populated with that value.  This will be null if no water heater devices exist in the system. */
extern NSString *const kAttrWaterSubsystemPrimaryWaterHeater;

/** When the first water softener is added it will be populated with that value. This will be null if no water softener devices exist in the system. */
extern NSString *const kAttrWaterSubsystemPrimaryWaterSoftener;

/** The set of water shutoff valves that are currently closed. */
extern NSString *const kAttrWaterSubsystemClosedWaterValves;

/** The set of devices that participate in the water service. */
extern NSString *const kAttrWaterSubsystemWaterDevices;

/** The set of devices that have a continuous water use alert enabled and active. */
extern NSString *const kAttrWaterSubsystemContinuousWaterUseDevices;

/** The set of devices that have an excessive water use alert enabled and active. */
extern NSString *const kAttrWaterSubsystemExcessiveWaterUseDevices;

/** The set of water softeners that have a low salt level. */
extern NSString *const kAttrWaterSubsystemLowSaltDevices;



extern NSString *const kEvtWaterSubsystemContinuousWaterUse;

extern NSString *const kEvtWaterSubsystemExcessiveWaterUse;

extern NSString *const kEvtWaterSubsystemLowSalt;



@interface WaterSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getPrimaryWaterHeaterFromModel:(SubsystemModel *)modelObj;

+ (NSString *)setPrimaryWaterHeater:(NSString *)primaryWaterHeater onModel:(SubsystemModel *)modelObj;


+ (NSString *)getPrimaryWaterSoftenerFromModel:(SubsystemModel *)modelObj;

+ (NSString *)setPrimaryWaterSoftener:(NSString *)primaryWaterSoftener onModel:(SubsystemModel *)modelObj;


+ (NSArray *)getClosedWaterValvesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getWaterDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getContinuousWaterUseDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getExcessiveWaterUseDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getLowSaltDevicesFromModel:(SubsystemModel *)modelObj;





@end
