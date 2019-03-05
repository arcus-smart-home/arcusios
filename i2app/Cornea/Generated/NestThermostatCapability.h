

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Updated to reflect whether nest thermostat is showing a leaf (read from Nest platform) */
extern NSString *const kAttrNestThermostatHasleaf;

/** Name of the room this nest thermostat is located in */
extern NSString *const kAttrNestThermostatRoomname;

/** Updated to reflect whether nest thermostat is is locked to allow sets only within a particular temperature range */
extern NSString *const kAttrNestThermostatLocked;

/** The minimum temperature that the nest thermostat can be set to when locked is true. */
extern NSString *const kAttrNestThermostatLockedtempmin;

/** The maximum temperature that the nest thermostat can be set to when locked is true. */
extern NSString *const kAttrNestThermostatLockedtempmax;





@interface NestThermostatCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getHasleafFromModel:(DeviceModel *)modelObj;


+ (NSString *)getRoomnameFromModel:(DeviceModel *)modelObj;


+ (BOOL)getLockedFromModel:(DeviceModel *)modelObj;


+ (double)getLockedtempminFromModel:(DeviceModel *)modelObj;


+ (double)getLockedtempmaxFromModel:(DeviceModel *)modelObj;





@end
