

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Indicates that this device is currently line-powered */
extern NSString *const kAttrDevicePowerSource;

/** When true, indicates that it is possible to line-power this device from the mains. */
extern NSString *const kAttrDevicePowerLinecapable;

/** When true, indicates the device can support a back-up battery. */
extern NSString *const kAttrDevicePowerBackupbatterycapable;

/** Level of primary battery. 0 = battery not present. */
extern NSString *const kAttrDevicePowerBattery;

/** Level of primary battery. 0 = battery not present. */
extern NSString *const kAttrDevicePowerBackupbattery;

/** UTC date time of last source change */
extern NSString *const kAttrDevicePowerSourcechanged;

/** When true, indicates that the battery will recharge while the device is on LINE power.  Unset or null indicated that this is NOT rechargable */
extern NSString *const kAttrDevicePowerRechargeable;



extern NSString *const kEvtDevicePowerBackupBattery;

extern NSString *const kEvtDevicePowerLinePowerRestored;

extern NSString *const kEvtDevicePowerBatteryLow;

extern NSString *const kEnumDevicePowerSourceLINE;
extern NSString *const kEnumDevicePowerSourceBATTERY;
extern NSString *const kEnumDevicePowerSourceBACKUPBATTERY;


@interface DevicePowerCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getSourceFromModel:(DeviceModel *)modelObj;


+ (BOOL)getLinecapableFromModel:(DeviceModel *)modelObj;


+ (BOOL)getBackupbatterycapableFromModel:(DeviceModel *)modelObj;


+ (int)getBatteryFromModel:(DeviceModel *)modelObj;


+ (int)getBackupbatteryFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getSourcechangedFromModel:(DeviceModel *)modelObj;


+ (BOOL)getRechargeableFromModel:(DeviceModel *)modelObj;





@end
