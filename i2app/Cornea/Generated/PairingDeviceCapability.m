

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PairingDeviceCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPairingDevicePairingState=@"pairdev:pairingState";

NSString *const kAttrPairingDevicePairingPhase=@"pairdev:pairingPhase";

NSString *const kAttrPairingDevicePairingProgress=@"pairdev:pairingProgress";

NSString *const kAttrPairingDeviceCustomizations=@"pairdev:customizations";

NSString *const kAttrPairingDeviceDeviceAddress=@"pairdev:deviceAddress";

NSString *const kAttrPairingDeviceProductAddress=@"pairdev:productAddress";

NSString *const kAttrPairingDeviceRemoveMode=@"pairdev:removeMode";

NSString *const kAttrPairingDeviceProtocolAddress=@"pairdev:protocolAddress";


NSString *const kCmdPairingDeviceCustomize=@"pairdev:Customize";

NSString *const kCmdPairingDeviceAddCustomization=@"pairdev:AddCustomization";

NSString *const kCmdPairingDeviceDismiss=@"pairdev:Dismiss";

NSString *const kCmdPairingDeviceRemove=@"pairdev:Remove";

NSString *const kCmdPairingDeviceForceRemove=@"pairdev:ForceRemove";


NSString *const kEvtPairingDeviceDiscovered=@"pairdev:Discovered";

NSString *const kEvtPairingDeviceConfigured=@"pairdev:Configured";

NSString *const kEvtPairingDevicePairingFailed=@"pairdev:PairingFailed";

NSString *const kEnumPairingDevicePairingStatePAIRING = @"PAIRING";
NSString *const kEnumPairingDevicePairingStateMISPAIRED = @"MISPAIRED";
NSString *const kEnumPairingDevicePairingStateMISCONFIGURED = @"MISCONFIGURED";
NSString *const kEnumPairingDevicePairingStatePAIRED = @"PAIRED";
NSString *const kEnumPairingDevicePairingPhaseJOIN = @"JOIN";
NSString *const kEnumPairingDevicePairingPhaseCONNECT = @"CONNECT";
NSString *const kEnumPairingDevicePairingPhaseIDENTIFY = @"IDENTIFY";
NSString *const kEnumPairingDevicePairingPhasePREPARE = @"PREPARE";
NSString *const kEnumPairingDevicePairingPhaseCONFIGURE = @"CONFIGURE";
NSString *const kEnumPairingDevicePairingPhaseFAILED = @"FAILED";
NSString *const kEnumPairingDevicePairingPhasePAIRED = @"PAIRED";
NSString *const kEnumPairingDeviceRemoveModeCLOUD = @"CLOUD";
NSString *const kEnumPairingDeviceRemoveModeHUB_AUTOMATIC = @"HUB_AUTOMATIC";
NSString *const kEnumPairingDeviceRemoveModeHUB_MANUAL = @"HUB_MANUAL";


@implementation PairingDeviceCapability
+ (NSString *)namespace { return @"pairdev"; }
+ (NSString *)name { return @"PairingDevice"; }

+ (NSString *)getPairingStateFromModel:(PairingDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingDeviceCapabilityLegacy getPairingState:modelObj];
  
}


+ (NSString *)getPairingPhaseFromModel:(PairingDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingDeviceCapabilityLegacy getPairingPhase:modelObj];
  
}


+ (int)getPairingProgressFromModel:(PairingDeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PairingDeviceCapabilityLegacy getPairingProgress:modelObj] intValue];
  
}


+ (NSArray *)getCustomizationsFromModel:(PairingDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingDeviceCapabilityLegacy getCustomizations:modelObj];
  
}


+ (NSString *)getDeviceAddressFromModel:(PairingDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingDeviceCapabilityLegacy getDeviceAddress:modelObj];
  
}


+ (NSString *)getProductAddressFromModel:(PairingDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingDeviceCapabilityLegacy getProductAddress:modelObj];
  
}


+ (NSString *)getRemoveModeFromModel:(PairingDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingDeviceCapabilityLegacy getRemoveMode:modelObj];
  
}


+ (NSString *)getProtocolAddressFromModel:(PairingDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingDeviceCapabilityLegacy getProtocolAddress:modelObj];
  
}




+ (PMKPromise *) customizeOnModel:(PairingDeviceModel *)modelObj {
  return [PairingDeviceCapabilityLegacy customize:modelObj ];
}


+ (PMKPromise *) addCustomizationWithCustomization:(NSString *)customization onModel:(PairingDeviceModel *)modelObj {
  return [PairingDeviceCapabilityLegacy addCustomization:modelObj customization:customization];

}


+ (PMKPromise *) dismissOnModel:(PairingDeviceModel *)modelObj {
  return [PairingDeviceCapabilityLegacy dismiss:modelObj ];
}


+ (PMKPromise *) removeOnModel:(PairingDeviceModel *)modelObj {
  return [PairingDeviceCapabilityLegacy remove:modelObj ];
}


+ (PMKPromise *) forceRemoveOnModel:(PairingDeviceModel *)modelObj {
  return [PairingDeviceCapabilityLegacy forceRemove:modelObj ];
}

@end
