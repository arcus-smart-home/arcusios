

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;











/** The name of the driver handling the device. */
extern NSString *const kAttrDeviceAdvancedDrivername;

/** The current verison of the driver handling the device. */
extern NSString *const kAttrDeviceAdvancedDriverversion;

/** The commit id from the commit that this file was last changed in. */
extern NSString *const kAttrDeviceAdvancedDrivercommit;

/** A hash of the contents of the file. */
extern NSString *const kAttrDeviceAdvancedDriverhash;

/** The state of the driver.            CREATED - Transient state meaning the device has been created but the driver is not running.  Clients should not see this state generally.            PROVISIONING - The driver is still in the process of configuring the device for initial use.            ACTIVE - The driver is fully loaded.  Note there may be additional error preventing it from running &#x27;normally&#x27;, see devadv:errors.            UNSUPPORTED - The device is using the fallback driver, it is not really supported by the platform.  This is often due to pairing errors, in which case devadv:errors will be populated.            RECOVERABLE - The device has been deleted from the hub, but may be recovered by re-pairing it with the hub.            UNRECOVERABLE - The device has been deleted from the hub and it is not possible to re-pair it.            TOMBSTONED - The user has force removed the device but it still exists in the hub database.             */
extern NSString *const kAttrDeviceAdvancedDriverstate;

/** Protocol supported by the device; should initially be one of (zwave, zigbee, alljoyn, ipcd) */
extern NSString *const kAttrDeviceAdvancedProtocol;

/** Sub-protocol supported by the device. For zigbee devices, this may be ha1.1, ha1.2, etc. */
extern NSString *const kAttrDeviceAdvancedSubprotocol;

/** Protocol specific identifier for this device. This should be globally unique. For zigbee devices this will be the mac address. For zwave devices, this should be homeid.deviceid. */
extern NSString *const kAttrDeviceAdvancedProtocolid;

/** A map where the keys are the errorCode and the values are a more descriptive error message.  These errors should be used for devices that have an error status that may be cleared or may simply indicate the device has passed its usable lifetime.  This is not intended for maintenance errors such as low battery or air filter change. */
extern NSString *const kAttrDeviceAdvancedErrors;

/** Time at which this device was most recently added (date of driver instantiation) */
extern NSString *const kAttrDeviceAdvancedAdded;

/** The firmware version of the device, primarily for devices that do not support OTA. For ZigBee devices it contains the version from the basic cluster, the OTA cluster version goes in devota. */
extern NSString *const kAttrDeviceAdvancedFirmwareVersion;

/** True if the device is operating in a hub local manner. */
extern NSString *const kAttrDeviceAdvancedHubLocal;

/** True if the device is operating in a degraded manner for any reason. */
extern NSString *const kAttrDeviceAdvancedDegraded;

/** The code string indicating the reason that a device is operating in a degraded manner. */
extern NSString *const kAttrDeviceAdvancedDegradedCode;


extern NSString *const kCmdDeviceAdvancedUpgradeDriver;

extern NSString *const kCmdDeviceAdvancedGetReflexes;

extern NSString *const kCmdDeviceAdvancedReconfigure;


extern NSString *const kEvtDeviceAdvancedRemovedDevice;

extern NSString *const kEnumDeviceAdvancedDriverstateCREATED;
extern NSString *const kEnumDeviceAdvancedDriverstatePROVISIONING;
extern NSString *const kEnumDeviceAdvancedDriverstateACTIVE;
extern NSString *const kEnumDeviceAdvancedDriverstateUNSUPPORTED;
extern NSString *const kEnumDeviceAdvancedDriverstateRECOVERABLE;
extern NSString *const kEnumDeviceAdvancedDriverstateUNRECOVERABLE;
extern NSString *const kEnumDeviceAdvancedDriverstateTOMBSTONED;


@interface DeviceAdvancedCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getDrivernameFromModel:(DeviceModel *)modelObj;


+ (NSString *)getDriverversionFromModel:(DeviceModel *)modelObj;


+ (NSString *)getDrivercommitFromModel:(DeviceModel *)modelObj;


+ (NSString *)getDriverhashFromModel:(DeviceModel *)modelObj;


+ (NSString *)getDriverstateFromModel:(DeviceModel *)modelObj;


+ (NSString *)getProtocolFromModel:(DeviceModel *)modelObj;


+ (NSString *)getSubprotocolFromModel:(DeviceModel *)modelObj;


+ (NSString *)getProtocolidFromModel:(DeviceModel *)modelObj;


+ (NSDictionary *)getErrorsFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getAddedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getFirmwareVersionFromModel:(DeviceModel *)modelObj;


+ (BOOL)getHubLocalFromModel:(DeviceModel *)modelObj;


+ (BOOL)getDegradedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getDegradedCodeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setDegradedCode:(NSString *)degradedCode onModel:(DeviceModel *)modelObj;





/** Upgrades the driver for this device to the driver specified.  If not specified it will look for the most current driver for this device. */
+ (PMKPromise *) upgradeDriverWithDriverName:(NSString *)driverName withDriverVersion:(NSString *)driverVersion onModel:(Model *)modelObj;



/** Gets the currently defined reflexes for the driver as a json object. */
+ (PMKPromise *) getReflexesOnModel:(Model *)modelObj;



/** Attempts to re-apply initial configuration for the device, this may leave it in an unusable state if it fails. */
+ (PMKPromise *) reconfigureOnModel:(Model *)modelObj;



@end
