

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;

































/** The PANID in use by the Zigbee network */
extern NSString *const kAttrHubZigbeePanid;

/** The extended PANID in use by the Zigbee network */
extern NSString *const kAttrHubZigbeeExtid;

/** The channel in use by the Zigbee network */
extern NSString *const kAttrHubZigbeeChannel;

/** The transmit power in use by the Zigbee chip */
extern NSString *const kAttrHubZigbeePower;

/** The power mode used by the Zigbee chip */
extern NSString *const kAttrHubZigbeePowermode;

/** The stack profile in use by the Zigbee network */
extern NSString *const kAttrHubZigbeeProfile;

/** The security level in use by the Zigbee network */
extern NSString *const kAttrHubZigbeeSecurity;

/** The number of supported Zigbee networks */
extern NSString *const kAttrHubZigbeeSupportednwks;

/** True if the Zigbee network is allowing joins, false otherwise */
extern NSString *const kAttrHubZigbeeJoining;

/** The NWK update id in use by the Zigbee network */
extern NSString *const kAttrHubZigbeeUpdateid;

/** The EUI64 of the Zigbee chip */
extern NSString *const kAttrHubZigbeeEui64;

/** The EUI64 of the Zigbee network&#x27;s trust center */
extern NSString *const kAttrHubZigbeeTceui64;

/** The amount of time since the last Zigbee chip reset */
extern NSString *const kAttrHubZigbeeUptime;

/** The EZSP version number */
extern NSString *const kAttrHubZigbeeVersion;

/** The Zigbee manufacturer code of the Zigbee chip */
extern NSString *const kAttrHubZigbeeManufacturer;

/** The Zigbee network state */
extern NSString *const kAttrHubZigbeeState;

/** Devices that use link-keys/install codes that have NOT joined the network.  This is a super-set of the hubkit:pendingPairing. */
extern NSString *const kAttrHubZigbeePendingPairing;


extern NSString *const kCmdHubZigbeeReset;

extern NSString *const kCmdHubZigbeeScan;

extern NSString *const kCmdHubZigbeeGetConfig;

extern NSString *const kCmdHubZigbeeGetStats;

extern NSString *const kCmdHubZigbeeGetNodeDesc;

extern NSString *const kCmdHubZigbeeGetActiveEp;

extern NSString *const kCmdHubZigbeeGetSimpleDesc;

extern NSString *const kCmdHubZigbeeGetPowerDesc;

extern NSString *const kCmdHubZigbeeIdentify;

extern NSString *const kCmdHubZigbeeRemove;

extern NSString *const kCmdHubZigbeeFactoryReset;

extern NSString *const kCmdHubZigbeeFormNetwork;

extern NSString *const kCmdHubZigbeeFixMigration;

extern NSString *const kCmdHubZigbeeNetworkInformation;

extern NSString *const kCmdHubZigbeePairingLinkKey;

extern NSString *const kCmdHubZigbeePairingInstallCode;


extern NSString *const kEnumHubZigbeePowermodeDEFAULT;
extern NSString *const kEnumHubZigbeePowermodeBOOST;
extern NSString *const kEnumHubZigbeePowermodeALTERNATE;
extern NSString *const kEnumHubZigbeePowermodeBOOST_AND_ALTERNATE;
extern NSString *const kEnumHubZigbeeStateUP;
extern NSString *const kEnumHubZigbeeStateDOWN;
extern NSString *const kEnumHubZigbeeStateJOIN_FAILED;
extern NSString *const kEnumHubZigbeeStateMOVE_FAILED;


@interface HubZigbeeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getPanidFromModel:(HubModel *)modelObj;


+ (long)getExtidFromModel:(HubModel *)modelObj;


+ (int)getChannelFromModel:(HubModel *)modelObj;


+ (int)getPowerFromModel:(HubModel *)modelObj;


+ (NSString *)getPowermodeFromModel:(HubModel *)modelObj;


+ (int)getProfileFromModel:(HubModel *)modelObj;


+ (int)getSecurityFromModel:(HubModel *)modelObj;


+ (int)getSupportednwksFromModel:(HubModel *)modelObj;


+ (BOOL)getJoiningFromModel:(HubModel *)modelObj;


+ (int)getUpdateidFromModel:(HubModel *)modelObj;


+ (long)getEui64FromModel:(HubModel *)modelObj;


+ (long)getTceui64FromModel:(HubModel *)modelObj;


+ (long)getUptimeFromModel:(HubModel *)modelObj;


+ (NSString *)getVersionFromModel:(HubModel *)modelObj;


+ (int)getManufacturerFromModel:(HubModel *)modelObj;


+ (NSString *)getStateFromModel:(HubModel *)modelObj;


+ (NSArray *)getPendingPairingFromModel:(HubModel *)modelObj;





/** Perform a reset of the Zigbee chip */
+ (PMKPromise *) resetWithType:(NSString *)type onModel:(Model *)modelObj;



/** Perform an environment scan using the Zigbee chip */
+ (PMKPromise *) scanOnModel:(Model *)modelObj;



/** Get the Zigbee chip configuration information */
+ (PMKPromise *) getConfigOnModel:(Model *)modelObj;



/** Get the current low-level statistics tracked by the Zigbee chip */
+ (PMKPromise *) getStatsOnModel:(Model *)modelObj;



/** Get the node descriptor of a node in the Zigbee network */
+ (PMKPromise *) getNodeDescWithNwk:(int)nwk onModel:(Model *)modelObj;



/** Get the active endpoints of a node in the Zigbee network */
+ (PMKPromise *) getActiveEpWithNwk:(int)nwk onModel:(Model *)modelObj;



/** Get the simple descriptor of a node in the Zigbee network */
+ (PMKPromise *) getSimpleDescWithNwk:(int)nwk withEp:(int)ep onModel:(Model *)modelObj;



/** Get the power descriptor of a node in the Zigbee network */
+ (PMKPromise *) getPowerDescWithNwk:(int)nwk onModel:(Model *)modelObj;



/** Identify a node in the Zigbee network */
+ (PMKPromise *) identifyWithEui64:(long)eui64 withDuration:(int)duration onModel:(Model *)modelObj;



/** Remove a node from the Zigbee network */
+ (PMKPromise *) removeWithEui64:(long)eui64 onModel:(Model *)modelObj;



/** Factory reset the Zigbee stack, removing all paired devices in the process. */
+ (PMKPromise *) factoryResetOnModel:(Model *)modelObj;



/** Restore the Zigbee network to an exact state. */
+ (PMKPromise *) formNetworkWithEui64:(long)eui64 withPanId:(int)panId withExtPanId:(long)extPanId withChannel:(int)channel withNwkkey:(NSString *)nwkkey withNwkfc:(long)nwkfc withApsfc:(long)apsfc withUpdateid:(int)updateid onModel:(Model *)modelObj;



/** Run the migration fix proceedure */
+ (PMKPromise *) fixMigrationOnModel:(Model *)modelObj;



/** Get information about the current state of the network. */
+ (PMKPromise *) networkInformationOnModel:(Model *)modelObj;



/** Pairs a device using a pre-shared link key. */
+ (PMKPromise *) pairingLinkKeyWithEuid:(NSString *)euid withLinkkey:(NSString *)linkkey withTimeout:(long)timeout onModel:(Model *)modelObj;



/** Pairs a device using a pre-shared install code. */
+ (PMKPromise *) pairingInstallCodeWithEuid:(NSString *)euid withInstallcode:(NSString *)installcode withTimeout:(long)timeout onModel:(Model *)modelObj;



@end
