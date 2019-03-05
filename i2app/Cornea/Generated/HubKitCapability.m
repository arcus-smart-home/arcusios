

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubKitCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubKitType=@"hubkit:type";

NSString *const kAttrHubKitKit=@"hubkit:kit";

NSString *const kAttrHubKitPendingPairing=@"hubkit:pendingPairing";


NSString *const kCmdHubKitSetKit=@"hubkit:SetKit";


NSString *const kEnumHubKitTypeNONE = @"NONE";
NSString *const kEnumHubKitTypeTEST = @"TEST";
NSString *const kEnumHubKitTypePROMON = @"PROMON";


@implementation HubKitCapability
+ (NSString *)namespace { return @"hubkit"; }
+ (NSString *)name { return @"HubKit"; }

+ (NSString *)getTypeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubKitCapabilityLegacy getType:modelObj];
  
}


+ (NSArray *)getKitFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubKitCapabilityLegacy getKit:modelObj];
  
}


+ (NSArray *)getPendingPairingFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubKitCapabilityLegacy getPendingPairing:modelObj];
  
}




+ (PMKPromise *) setKitWithType:(NSString *)type withDevices:(NSArray *)devices onModel:(HubModel *)modelObj {
  return [HubKitCapabilityLegacy setKit:modelObj type:type devices:devices];

}

@end
