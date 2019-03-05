

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;











/** Driver-owned globally unique identifier for the hub */
extern NSString *const kAttrHubId;

/** Driver-owned account associated with the hub */
extern NSString *const kAttrHubAccount;

/** Driver-owned place where the device is currently located */
extern NSString *const kAttrHubPlace;

/** Human readable name for the hub */
extern NSString *const kAttrHubName;

/** Media URL to image that represents the hub */
extern NSString *const kAttrHubImage;

/** Vendor name */
extern NSString *const kAttrHubVendor;

/** Model name */
extern NSString *const kAttrHubModel;

/** State of the hub */
extern NSString *const kAttrHubState;

/** The registration state of the hub */
extern NSString *const kAttrHubRegistrationState;

/** The current time on the hub. Milliseconds since Jan 1, 1970 (UTC). */
extern NSString *const kAttrHubTime;

/** The timezone for the hub. */
extern NSString *const kAttrHubTz;


extern NSString *const kCmdHubPairingRequest;

extern NSString *const kCmdHubUnpairingRequest;

extern NSString *const kCmdHubListHubs;

extern NSString *const kCmdHubResetLogLevels;

extern NSString *const kCmdHubSetLogLevel;

extern NSString *const kCmdHubGetLogs;

extern NSString *const kCmdHubStreamLogs;

extern NSString *const kCmdHubGetConfig;

extern NSString *const kCmdHubSetConfig;

extern NSString *const kCmdHubDelete;


extern NSString *const kEvtHubHubConnected;

extern NSString *const kEvtHubHubDisconnected;

extern NSString *const kEvtHubDeviceFound;

extern NSString *const kEnumHubStateNORMAL;
extern NSString *const kEnumHubStatePAIRING;
extern NSString *const kEnumHubStateUNPAIRING;
extern NSString *const kEnumHubStateDOWN;
extern NSString *const kEnumHubRegistrationStateREGISTERED;
extern NSString *const kEnumHubRegistrationStateUNREGISTERED;
extern NSString *const kEnumHubRegistrationStateORPHANED;


@interface HubCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getIdFromModel:(HubModel *)modelObj;


+ (NSString *)getAccountFromModel:(HubModel *)modelObj;


+ (NSString *)getPlaceFromModel:(HubModel *)modelObj;


+ (NSString *)getNameFromModel:(HubModel *)modelObj;

+ (NSString *)setName:(NSString *)name onModel:(Model *)modelObj;


+ (NSString *)getImageFromModel:(HubModel *)modelObj;

+ (NSString *)setImage:(NSString *)image onModel:(Model *)modelObj;


+ (NSString *)getVendorFromModel:(HubModel *)modelObj;


+ (NSString *)getModelFromModel:(HubModel *)modelObj;


+ (NSString *)getStateFromModel:(HubModel *)modelObj;


+ (NSString *)getRegistrationStateFromModel:(HubModel *)modelObj;


+ (long)getTimeFromModel:(HubModel *)modelObj;


+ (NSString *)getTzFromModel:(HubModel *)modelObj;

+ (NSString *)setTz:(NSString *)tz onModel:(Model *)modelObj;





/** Lists all devices associated with this account */
+ (PMKPromise *) pairingRequestWithActionType:(NSString *)actionType withTimeout:(long)timeout onModel:(Model *)modelObj;



/** Lists all devices associated with this account */
+ (PMKPromise *) unpairingRequestWithActionType:(NSString *)actionType withTimeout:(long)timeout withProtocol:(NSString *)protocol withProtocolId:(NSString *)protocolId withForce:(BOOL)force onModel:(Model *)modelObj;



/** Lists all hubs associated with this account */
+ (PMKPromise *) listHubsOnModel:(Model *)modelObj;



/** Resets all log levels to their normal values. */
+ (PMKPromise *) resetLogLevelsOnModel:(Model *)modelObj;



/** Sets the log level of for the specified scope, or the root log level if no scope is specified. */
+ (PMKPromise *) setLogLevelWithLevel:(NSString *)level withScope:(NSString *)scope onModel:(Model *)modelObj;



/** Gets recent logs from the hub. */
+ (PMKPromise *) getLogsOnModel:(Model *)modelObj;



/** Starts streaming logs to the platform for the specified amount of time. */
+ (PMKPromise *) streamLogsWithDuration:(long)duration withSeverity:(NSString *)severity onModel:(Model *)modelObj;



/** Gets all key/value pairs describing the hub&#x27;s configuration. */
+ (PMKPromise *) getConfigWithDefaults:(BOOL)defaults withMatching:(NSString *)matching onModel:(Model *)modelObj;



/** Gets all key/value pairs describing the hub&#x27;s configuration. */
+ (PMKPromise *) setConfigWithConfig:(NSDictionary *)config onModel:(Model *)modelObj;



/** Remove/Deactivate the hub. */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



@end
