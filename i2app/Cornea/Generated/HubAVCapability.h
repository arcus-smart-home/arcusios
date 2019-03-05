

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;























































/** Number of AV devices available for pairing */
extern NSString *const kAttrHubAVNumAvailable;

/** Number of AV devices paired to the hub */
extern NSString *const kAttrHubAVNumPaired;

/** Number of AV devices that are no longer connected */
extern NSString *const kAttrHubAVNumDisconnected;

/** List of AV devices (by UUID) with current mode */
extern NSString *const kAttrHubAVAvdevs;


extern NSString *const kCmdHubAVPair;

extern NSString *const kCmdHubAVRelease;

extern NSString *const kCmdHubAVGetState;

extern NSString *const kCmdHubAVGetIPAddress;

extern NSString *const kCmdHubAVGetModel;

extern NSString *const kCmdHubAVAudioStart;

extern NSString *const kCmdHubAVAudioStop;

extern NSString *const kCmdHubAVAudioPause;

extern NSString *const kCmdHubAVAudioSeekTo;

extern NSString *const kCmdHubAVSetVolume;

extern NSString *const kCmdHubAVGetVolume;

extern NSString *const kCmdHubAVSetMute;

extern NSString *const kCmdHubAVGetMute;

extern NSString *const kCmdHubAVAudioInfo;


extern NSString *const kEvtHubAVAVDevicePairingStatus;



@interface HubAVCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getNumAvailableFromModel:(HubModel *)modelObj;


+ (int)getNumPairedFromModel:(HubModel *)modelObj;


+ (int)getNumDisconnectedFromModel:(HubModel *)modelObj;


+ (NSDictionary *)getAvdevsFromModel:(HubModel *)modelObj;





/** Pair an AV device to the hub */
+ (PMKPromise *) pairWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Release an AV device from the hub */
+ (PMKPromise *) releaseWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Get current state of AV device */
+ (PMKPromise *) getStateWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Get IPv4 address of AV device */
+ (PMKPromise *) getIPAddressWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Get model of AV device */
+ (PMKPromise *) getModelWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Start audio on an AV device given an URL */
+ (PMKPromise *) audioStartWithUuid:(NSString *)uuid withUrl:(NSString *)url withMetadata:(NSString *)metadata onModel:(Model *)modelObj;



/** Stop audio on an AV device */
+ (PMKPromise *) audioStopWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Pause audio on an AV device */
+ (PMKPromise *) audioPauseWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Seek audio on an AV device */
+ (PMKPromise *) audioSeekToWithUuid:(NSString *)uuid withUnit:(NSString *)unit withTarget:(int)target onModel:(Model *)modelObj;



/** Set volume on an AV device */
+ (PMKPromise *) setVolumeWithUuid:(NSString *)uuid withVolume:(int)volume onModel:(Model *)modelObj;



/** Get volume on an AV device */
+ (PMKPromise *) getVolumeWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Set mute on an AV device */
+ (PMKPromise *) setMuteWithUuid:(NSString *)uuid withMute:(BOOL)mute onModel:(Model *)modelObj;



/** Get mute on an AV device */
+ (PMKPromise *) getMuteWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



/** Get information about current audio track */
+ (PMKPromise *) audioInfoWithUuid:(NSString *)uuid onModel:(Model *)modelObj;



@end
