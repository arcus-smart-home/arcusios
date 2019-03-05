

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubZwaveModel;

















/** hardware version of the chip */
extern NSString *const kAttrHubZwaveHardware;

/** Current firmware version loaded on the chip. */
extern NSString *const kAttrHubZwaveFirmware;

/** Version of the ZDK protocol used. */
extern NSString *const kAttrHubZwaveProtocol;

/** Home Id of the Z-wave controller. */
extern NSString *const kAttrHubZwaveHomeId;

/** Number of devices currently paired to the z-wave chip. */
extern NSString *const kAttrHubZwaveNumDevices;

/** If this is a secondary controller. */
extern NSString *const kAttrHubZwaveIsSecondary;

/** If this is on another network. */
extern NSString *const kAttrHubZwaveIsOnOtherNetwork;

/** If this is a SUC. */
extern NSString *const kAttrHubZwaveIsSUC;

/** Current state of the network. */
extern NSString *const kAttrHubZwaveState;

/** The amount of time since the last Z-Wave chip reset */
extern NSString *const kAttrHubZwaveUptime;

/** True if the Z-Wave controller is in the process of healing the network. */
extern NSString *const kAttrHubZwaveHealInProgress;

/** Timestamp for the last time a Z-Wave network heal was started. */
extern NSString *const kAttrHubZwaveHealLastStart;

/** Timestamp for the last time a Z-Wave network heal was finished. */
extern NSString *const kAttrHubZwaveHealLastFinish;

/** An indication of the reason the last Z-Wave network heal was finished. */
extern NSString *const kAttrHubZwaveHealFinishReason;

/** The total number of nodes that an in-progress Z-Wave network heal is optimizing. */
extern NSString *const kAttrHubZwaveHealTotal;

/** The number of nodes that the Z-Wave network heal has completed optimizing. */
extern NSString *const kAttrHubZwaveHealCompleted;

/** The number of nodes that the Z-Wave network heal has successfully optimized. */
extern NSString *const kAttrHubZwaveHealSuccessful;

/** True if the Z-Wave network heal process is currently blocking control of Z-Wave devices. */
extern NSString *const kAttrHubZwaveHealBlockingControl;

/** The estimated time that the heal will finish. */
extern NSString *const kAttrHubZwaveHealEstimatedFinish;

/** The percentage complete of the Z-Wave network heal. */
extern NSString *const kAttrHubZwaveHealPercent;

/** The next scheduled execution for a network heal (Java epoch mean no scheduled heal). */
extern NSString *const kAttrHubZwaveHealNextScheduled;

/** True if a heal should be run on the network to restore proper operation. */
extern NSString *const kAttrHubZwaveHealRecommended;


extern NSString *const kCmdHubZwaveFactoryReset;

extern NSString *const kCmdHubZwaveReset;

extern NSString *const kCmdHubZwaveForcePrimary;

extern NSString *const kCmdHubZwaveForceSecondary;

extern NSString *const kCmdHubZwaveNetworkInformation;

extern NSString *const kCmdHubZwaveHeal;

extern NSString *const kCmdHubZwaveCancelHeal;

extern NSString *const kCmdHubZwaveRemoveZombie;

extern NSString *const kCmdHubZwaveAssociate;

extern NSString *const kCmdHubZwaveAssignReturnRoutes;


extern NSString *const kEvtHubZwaveHealComplete;

extern NSString *const kEnumHubZwaveStateINIT;
extern NSString *const kEnumHubZwaveStateNORMAL;
extern NSString *const kEnumHubZwaveStatePAIRING;
extern NSString *const kEnumHubZwaveStateUNPAIRING;
extern NSString *const kEnumHubZwaveHealFinishReasonSUCCESS;
extern NSString *const kEnumHubZwaveHealFinishReasonCANCEL;
extern NSString *const kEnumHubZwaveHealFinishReasonTERMINATED;


@interface HubZwaveCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getHardwareFromModel:(HubZwaveModel *)modelObj;


+ (NSString *)getFirmwareFromModel:(HubZwaveModel *)modelObj;


+ (NSString *)getProtocolFromModel:(HubZwaveModel *)modelObj;


+ (NSString *)getHomeIdFromModel:(HubZwaveModel *)modelObj;


+ (int)getNumDevicesFromModel:(HubZwaveModel *)modelObj;


+ (BOOL)getIsSecondaryFromModel:(HubZwaveModel *)modelObj;


+ (BOOL)getIsOnOtherNetworkFromModel:(HubZwaveModel *)modelObj;


+ (BOOL)getIsSUCFromModel:(HubZwaveModel *)modelObj;


+ (NSString *)getStateFromModel:(HubZwaveModel *)modelObj;


+ (long)getUptimeFromModel:(HubZwaveModel *)modelObj;


+ (BOOL)getHealInProgressFromModel:(HubZwaveModel *)modelObj;


+ (NSDate *)getHealLastStartFromModel:(HubZwaveModel *)modelObj;


+ (NSDate *)getHealLastFinishFromModel:(HubZwaveModel *)modelObj;


+ (NSString *)getHealFinishReasonFromModel:(HubZwaveModel *)modelObj;


+ (int)getHealTotalFromModel:(HubZwaveModel *)modelObj;


+ (int)getHealCompletedFromModel:(HubZwaveModel *)modelObj;


+ (int)getHealSuccessfulFromModel:(HubZwaveModel *)modelObj;


+ (BOOL)getHealBlockingControlFromModel:(HubZwaveModel *)modelObj;


+ (NSDate *)getHealEstimatedFinishFromModel:(HubZwaveModel *)modelObj;


+ (double)getHealPercentFromModel:(HubZwaveModel *)modelObj;


+ (NSDate *)getHealNextScheduledFromModel:(HubZwaveModel *)modelObj;


+ (BOOL)getHealRecommendedFromModel:(HubZwaveModel *)modelObj;

+ (BOOL)setHealRecommended:(BOOL)healRecommended onModel:(Model *)modelObj;





/** Clears out the ZWave controller, effectively unpairing all devices.  Will also change the zwave chip&#x27;s home id. */
+ (PMKPromise *) factoryResetOnModel:(Model *)modelObj;



/** Perform a reset of the Z-Wave chip */
+ (PMKPromise *) resetWithType:(NSString *)type onModel:(Model *)modelObj;



/** Forces the Z-Wave chip into the primary controller role. */
+ (PMKPromise *) forcePrimaryOnModel:(Model *)modelObj;



/** Forces the Z-Wave chip into the secondary controller role. */
+ (PMKPromise *) forceSecondaryOnModel:(Model *)modelObj;



/** Get information about the current state of the network. */
+ (PMKPromise *) networkInformationOnModel:(Model *)modelObj;



/** Performs a network wide heal of the Z-Wave network. WARNING: This interferes with normal operation of the Z-Wave controller for the duration of the healing process. */
+ (PMKPromise *) healWithBlock:(BOOL)block withTime:(double)time onModel:(Model *)modelObj;



/** Cancels any Z-Wave network heal that might be in progress. */
+ (PMKPromise *) cancelHealOnModel:(Model *)modelObj;



/** Attempts to remove a zombie node from the Z-Wave chip&#x27;s node list. */
+ (PMKPromise *) removeZombieWithNode:(int)node onModel:(Model *)modelObj;



/** Attempts to associate with a node using the given groups. */
+ (PMKPromise *) associateWithNode:(int)node withGroups:(NSArray *)groups onModel:(Model *)modelObj;



/** Attempts to re-assign return routes to a node. */
+ (PMKPromise *) assignReturnRoutesWithNode:(int)node onModel:(Model *)modelObj;



@end
