

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubAVCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubAVNumAvailable=@"hubav:numAvailable";

NSString *const kAttrHubAVNumPaired=@"hubav:numPaired";

NSString *const kAttrHubAVNumDisconnected=@"hubav:numDisconnected";

NSString *const kAttrHubAVAvdevs=@"hubav:avdevs";


NSString *const kCmdHubAVPair=@"hubav:pair";

NSString *const kCmdHubAVRelease=@"hubav:release";

NSString *const kCmdHubAVGetState=@"hubav:getState";

NSString *const kCmdHubAVGetIPAddress=@"hubav:getIPAddress";

NSString *const kCmdHubAVGetModel=@"hubav:getModel";

NSString *const kCmdHubAVAudioStart=@"hubav:audioStart";

NSString *const kCmdHubAVAudioStop=@"hubav:audioStop";

NSString *const kCmdHubAVAudioPause=@"hubav:audioPause";

NSString *const kCmdHubAVAudioSeekTo=@"hubav:audioSeekTo";

NSString *const kCmdHubAVSetVolume=@"hubav:setVolume";

NSString *const kCmdHubAVGetVolume=@"hubav:getVolume";

NSString *const kCmdHubAVSetMute=@"hubav:setMute";

NSString *const kCmdHubAVGetMute=@"hubav:getMute";

NSString *const kCmdHubAVAudioInfo=@"hubav:audioInfo";


NSString *const kEvtHubAVAVDevicePairingStatus=@"hubav:AVDevicePairingStatus";



@implementation HubAVCapability
+ (NSString *)namespace { return @"hubav"; }
+ (NSString *)name { return @"HubAV"; }

+ (int)getNumAvailableFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAVCapabilityLegacy getNumAvailable:modelObj] intValue];
  
}


+ (int)getNumPairedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAVCapabilityLegacy getNumPaired:modelObj] intValue];
  
}


+ (int)getNumDisconnectedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubAVCapabilityLegacy getNumDisconnected:modelObj] intValue];
  
}


+ (NSDictionary *)getAvdevsFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubAVCapabilityLegacy getAvdevs:modelObj];
  
}




+ (PMKPromise *) pairWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy pair:modelObj uuid:uuid];

}


+ (PMKPromise *) releaseWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy release:modelObj uuid:uuid];

}


+ (PMKPromise *) getStateWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy getState:modelObj uuid:uuid];

}


+ (PMKPromise *) getIPAddressWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy getIPAddress:modelObj uuid:uuid];

}


+ (PMKPromise *) getModelWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy getModel:modelObj uuid:uuid];

}


+ (PMKPromise *) audioStartWithUuid:(NSString *)uuid withUrl:(NSString *)url withMetadata:(NSString *)metadata onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy audioStart:modelObj uuid:uuid url:url metadata:metadata];

}


+ (PMKPromise *) audioStopWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy audioStop:modelObj uuid:uuid];

}


+ (PMKPromise *) audioPauseWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy audioPause:modelObj uuid:uuid];

}


+ (PMKPromise *) audioSeekToWithUuid:(NSString *)uuid withUnit:(NSString *)unit withTarget:(int)target onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy audioSeekTo:modelObj uuid:uuid unit:unit target:target];

}


+ (PMKPromise *) setVolumeWithUuid:(NSString *)uuid withVolume:(int)volume onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy setVolume:modelObj uuid:uuid volume:volume];

}


+ (PMKPromise *) getVolumeWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy getVolume:modelObj uuid:uuid];

}


+ (PMKPromise *) setMuteWithUuid:(NSString *)uuid withMute:(BOOL)mute onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy setMute:modelObj uuid:uuid mute:mute];

}


+ (PMKPromise *) getMuteWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy getMute:modelObj uuid:uuid];

}


+ (PMKPromise *) audioInfoWithUuid:(NSString *)uuid onModel:(HubModel *)modelObj {
  return [HubAVCapabilityLegacy audioInfo:modelObj uuid:uuid];

}

@end
