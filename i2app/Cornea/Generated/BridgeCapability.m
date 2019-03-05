

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "BridgeCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrBridgePairedDevices=@"bridge:pairedDevices";

NSString *const kAttrBridgeUnpairedDevices=@"bridge:unpairedDevices";

NSString *const kAttrBridgePairingState=@"bridge:pairingState";

NSString *const kAttrBridgeNumDevicesSupported=@"bridge:numDevicesSupported";


NSString *const kCmdBridgeStartPairing=@"bridge:StartPairing";

NSString *const kCmdBridgeStopPairing=@"bridge:StopPairing";


NSString *const kEnumBridgePairingStatePAIRING = @"PAIRING";
NSString *const kEnumBridgePairingStateUNPAIRING = @"UNPAIRING";
NSString *const kEnumBridgePairingStateIDLE = @"IDLE";


@implementation BridgeCapability
+ (NSString *)namespace { return @"bridge"; }
+ (NSString *)name { return @"Bridge"; }

+ (NSDictionary *)getPairedDevicesFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [BridgeCapabilityLegacy getPairedDevices:modelObj];
  
}


+ (NSArray *)getUnpairedDevicesFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [BridgeCapabilityLegacy getUnpairedDevices:modelObj];
  
}


+ (NSString *)getPairingStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [BridgeCapabilityLegacy getPairingState:modelObj];
  
}


+ (int)getNumDevicesSupportedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[BridgeCapabilityLegacy getNumDevicesSupported:modelObj] intValue];
  
}




+ (PMKPromise *) startPairingWithTimeout:(long)timeout onModel:(DeviceModel *)modelObj {
  return [BridgeCapabilityLegacy startPairing:modelObj timeout:timeout];

}


+ (PMKPromise *) stopPairingOnModel:(DeviceModel *)modelObj {
  return [BridgeCapabilityLegacy stopPairing:modelObj ];
}

@end
