

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PairingSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPairingSubsystemPairingMode=@"subpairing:pairingMode";

NSString *const kAttrPairingSubsystemPairingModeChanged=@"subpairing:pairingModeChanged";

NSString *const kAttrPairingSubsystemPairingDevices=@"subpairing:pairingDevices";

NSString *const kAttrPairingSubsystemSearchProductAddress=@"subpairing:searchProductAddress";

NSString *const kAttrPairingSubsystemSearchDeviceFound=@"subpairing:searchDeviceFound";

NSString *const kAttrPairingSubsystemSearchIdle=@"subpairing:searchIdle";

NSString *const kAttrPairingSubsystemSearchIdleTimeout=@"subpairing:searchIdleTimeout";

NSString *const kAttrPairingSubsystemSearchTimeout=@"subpairing:searchTimeout";


NSString *const kCmdPairingSubsystemListPairingDevices=@"subpairing:ListPairingDevices";

NSString *const kCmdPairingSubsystemStartPairing=@"subpairing:StartPairing";

NSString *const kCmdPairingSubsystemSearch=@"subpairing:Search";

NSString *const kCmdPairingSubsystemListHelpSteps=@"subpairing:ListHelpSteps";

NSString *const kCmdPairingSubsystemDismissAll=@"subpairing:DismissAll";

NSString *const kCmdPairingSubsystemStopSearching=@"subpairing:StopSearching";

NSString *const kCmdPairingSubsystemFactoryReset=@"subpairing:FactoryReset";

NSString *const kCmdPairingSubsystemGetKitInformation=@"subpairing:GetKitInformation";


NSString *const kEvtPairingSubsystemPairingIdleTimeout=@"subpairing:PairingIdleTimeout";

NSString *const kEvtPairingSubsystemPairingTimeout=@"subpairing:PairingTimeout";

NSString *const kEvtPairingSubsystemPairingFailed=@"subpairing:PairingFailed";

NSString *const kEnumPairingSubsystemPairingModeIDLE = @"IDLE";
NSString *const kEnumPairingSubsystemPairingModeHUB = @"HUB";
NSString *const kEnumPairingSubsystemPairingModeCLOUD = @"CLOUD";
NSString *const kEnumPairingSubsystemPairingModeOAUTH = @"OAUTH";
NSString *const kEnumPairingSubsystemPairingModeHUB_UNPAIRING = @"HUB_UNPAIRING";


@implementation PairingSubsystemCapability
+ (NSString *)namespace { return @"subpairing"; }
+ (NSString *)name { return @"PairingSubsystem"; }

+ (NSString *)getPairingModeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingSubsystemCapabilityLegacy getPairingMode:modelObj];
  
}


+ (NSDate *)getPairingModeChangedFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingSubsystemCapabilityLegacy getPairingModeChanged:modelObj];
  
}


+ (NSArray *)getPairingDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingSubsystemCapabilityLegacy getPairingDevices:modelObj];
  
}


+ (NSString *)getSearchProductAddressFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingSubsystemCapabilityLegacy getSearchProductAddress:modelObj];
  
}


+ (BOOL)getSearchDeviceFoundFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PairingSubsystemCapabilityLegacy getSearchDeviceFound:modelObj] boolValue];
  
}


+ (BOOL)getSearchIdleFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PairingSubsystemCapabilityLegacy getSearchIdle:modelObj] boolValue];
  
}


+ (NSDate *)getSearchIdleTimeoutFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingSubsystemCapabilityLegacy getSearchIdleTimeout:modelObj];
  
}


+ (NSDate *)getSearchTimeoutFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingSubsystemCapabilityLegacy getSearchTimeout:modelObj];
  
}




+ (PMKPromise *) listPairingDevicesOnModel:(SubsystemModel *)modelObj {
  return [PairingSubsystemCapabilityLegacy listPairingDevices:modelObj ];
}


+ (PMKPromise *) startPairingWithProductAddress:(NSString *)productAddress withMock:(BOOL)mock onModel:(SubsystemModel *)modelObj {
  return [PairingSubsystemCapabilityLegacy startPairing:modelObj productAddress:productAddress mock:mock];

}


+ (PMKPromise *) searchWithProductAddress:(NSString *)productAddress withForm:(NSDictionary *)form onModel:(SubsystemModel *)modelObj {
  return [PairingSubsystemCapabilityLegacy search:modelObj productAddress:productAddress form:form];

}


+ (PMKPromise *) listHelpStepsOnModel:(SubsystemModel *)modelObj {
  return [PairingSubsystemCapabilityLegacy listHelpSteps:modelObj ];
}


+ (PMKPromise *) dismissAllOnModel:(SubsystemModel *)modelObj {
  return [PairingSubsystemCapabilityLegacy dismissAll:modelObj ];
}


+ (PMKPromise *) stopSearchingOnModel:(SubsystemModel *)modelObj {
  return [PairingSubsystemCapabilityLegacy stopSearching:modelObj ];
}


+ (PMKPromise *) factoryResetOnModel:(SubsystemModel *)modelObj {
  return [PairingSubsystemCapabilityLegacy factoryReset:modelObj ];
}


+ (PMKPromise *) getKitInformationOnModel:(SubsystemModel *)modelObj {
  return [PairingSubsystemCapabilityLegacy getKitInformation:modelObj ];
}

@end
