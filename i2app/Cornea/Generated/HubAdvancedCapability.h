

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;











/** Primary MAC address of the hub (corresponds to ethernet MAC) */
extern NSString *const kAttrHubAdvancedMac;

/** Version of the hardware */
extern NSString *const kAttrHubAdvancedHardwarever;

/** Version of the base hub OS software */
extern NSString *const kAttrHubAdvancedOsver;

/** Version of the agent code running on the hub */
extern NSString *const kAttrHubAdvancedAgentver;

/** Serial number of the hub */
extern NSString *const kAttrHubAdvancedSerialNum;

/** Manufacturing information */
extern NSString *const kAttrHubAdvancedMfgInfo;

/** Version of the bootloader running on the hub */
extern NSString *const kAttrHubAdvancedBootloaderVer;

/** Firmware group the hub belongs to */
extern NSString *const kAttrHubAdvancedFirmwareGroup;

/** A time UUID indicating the last time the hub was started in a factory fresh state. */
extern NSString *const kAttrHubAdvancedLastReset;

/** A time UUID indicating the last time a device was either added or removed from the hub. */
extern NSString *const kAttrHubAdvancedLastDeviceAddRemove;

/** The reason for the last hub restart. */
extern NSString *const kAttrHubAdvancedLastRestartReason;

/** The time of the last hub restart. */
extern NSString *const kAttrHubAdvancedLastRestartTime;

/** The last time some watchdog checks failed */
extern NSString *const kAttrHubAdvancedLastFailedWatchdogChecksTime;

/** The set of failed watchdog checks, this is provided on a best effort basis and may not accurately reflect what actually caused a watchdog reset (we might fail to persist this information if an I/O failure caused the watchdog reset). */
extern NSString *const kAttrHubAdvancedLastFailedWatchdogChecks;

/** The last time an integrity check was run on the hub db. */
extern NSString *const kAttrHubAdvancedLastDbCheck;

/** A string describing the results of the last db check. */
extern NSString *const kAttrHubAdvancedLastDbCheckResults;

/** True if the hub has ever had the dual EUI-64 problem after migration. */
extern NSString *const kAttrHubAdvancedMigrationDualEui64;

/** True if the hub has had the fix for the dual EUI-64 issue applied. */
extern NSString *const kAttrHubAdvancedMigrationDualEui64Fixed;

/** Manufacturing raw batch number */
extern NSString *const kAttrHubAdvancedMfgBatchNumber;

/** Date of manufacture */
extern NSString *const kAttrHubAdvancedMfgDate;

/** Manufacturing factory ID */
extern NSString *const kAttrHubAdvancedMfgFactoryID;

/** Size of flash, in bytes */
extern NSString *const kAttrHubAdvancedHwFlashSize;


extern NSString *const kCmdHubAdvancedRestart;

extern NSString *const kCmdHubAdvancedReboot;

extern NSString *const kCmdHubAdvancedFirmwareUpdate;

extern NSString *const kCmdHubAdvancedFactoryReset;

extern NSString *const kCmdHubAdvancedGetKnownDevices;

extern NSString *const kCmdHubAdvancedGetDeviceInfo;


extern NSString *const kEvtHubAdvancedFirmwareUpgradeProcess;

extern NSString *const kEvtHubAdvancedDeregister;

extern NSString *const kEvtHubAdvancedStartUploadingCameraPreviews;

extern NSString *const kEvtHubAdvancedStopUploadingCameraPreviews;

extern NSString *const kEvtHubAdvancedUnpairedDeviceRemoved;

extern NSString *const kEvtHubAdvancedAttention;

extern NSString *const kEnumHubAdvancedLastRestartReasonUNKNOWN;
extern NSString *const kEnumHubAdvancedLastRestartReasonFIRMWARE_UPDATE;
extern NSString *const kEnumHubAdvancedLastRestartReasonREQUESTED;
extern NSString *const kEnumHubAdvancedLastRestartReasonSOFT_RESET;
extern NSString *const kEnumHubAdvancedLastRestartReasonFACTORY_RESET;
extern NSString *const kEnumHubAdvancedLastRestartReasonGATEWAY_FAILURE;
extern NSString *const kEnumHubAdvancedLastRestartReasonMIGRATION;
extern NSString *const kEnumHubAdvancedLastRestartReasonBACKUP_RESTORE;
extern NSString *const kEnumHubAdvancedLastRestartReasonWATCHDOG;


@interface HubAdvancedCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getMacFromModel:(HubModel *)modelObj;


+ (NSString *)getHardwareverFromModel:(HubModel *)modelObj;


+ (NSString *)getOsverFromModel:(HubModel *)modelObj;


+ (NSString *)getAgentverFromModel:(HubModel *)modelObj;


+ (NSString *)getSerialNumFromModel:(HubModel *)modelObj;


+ (NSString *)getMfgInfoFromModel:(HubModel *)modelObj;


+ (NSString *)getBootloaderVerFromModel:(HubModel *)modelObj;


+ (NSString *)getFirmwareGroupFromModel:(HubModel *)modelObj;


+ (NSString *)getLastResetFromModel:(HubModel *)modelObj;


+ (NSString *)getLastDeviceAddRemoveFromModel:(HubModel *)modelObj;


+ (NSString *)getLastRestartReasonFromModel:(HubModel *)modelObj;


+ (NSDate *)getLastRestartTimeFromModel:(HubModel *)modelObj;


+ (NSDate *)getLastFailedWatchdogChecksTimeFromModel:(HubModel *)modelObj;


+ (NSArray *)getLastFailedWatchdogChecksFromModel:(HubModel *)modelObj;


+ (NSDate *)getLastDbCheckFromModel:(HubModel *)modelObj;


+ (NSString *)getLastDbCheckResultsFromModel:(HubModel *)modelObj;


+ (BOOL)getMigrationDualEui64FromModel:(HubModel *)modelObj;


+ (BOOL)getMigrationDualEui64FixedFromModel:(HubModel *)modelObj;


+ (NSString *)getMfgBatchNumberFromModel:(HubModel *)modelObj;


+ (NSDate *)getMfgDateFromModel:(HubModel *)modelObj;


+ (int)getMfgFactoryIDFromModel:(HubModel *)modelObj;


+ (long)getHwFlashSizeFromModel:(HubModel *)modelObj;





/** Restarts the Arcus Agent */
+ (PMKPromise *) restartOnModel:(Model *)modelObj;



/** Reboots the hub */
+ (PMKPromise *) rebootOnModel:(Model *)modelObj;



/** Requests that the hub update its firmware */
+ (PMKPromise *) firmwareUpdateWithUrl:(NSString *)url withPriority:(NSString *)priority withType:(NSString *)type withShowLed:(BOOL)showLed onModel:(Model *)modelObj;



/** Request to tell the hub to factory reset.  This should remove all personal data from the hub */
+ (PMKPromise *) factoryResetOnModel:(Model *)modelObj;



/** Get a list of known device protocol addresses. */
+ (PMKPromise *) getKnownDevicesWithProtocols:(NSArray *)protocols onModel:(Model *)modelObj;



/** Get a list of known device protocol addresses. */
+ (PMKPromise *) getDeviceInfoWithProtocolAddress:(NSString *)protocolAddress onModel:(Model *)modelObj;



@end
