

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PairingDeviceMockCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPairingDeviceMockTargetProductAddress=@"pairdevmock:targetProductAddress";


NSString *const kCmdPairingDeviceMockUpdatePairingPhase=@"pairdevmock:UpdatePairingPhase";




@implementation PairingDeviceMockCapability
+ (NSString *)namespace { return @"pairdevmock"; }
+ (NSString *)name { return @"PairingDeviceMock"; }

+ (NSString *)getTargetProductAddressFromModel:(PairingDeviceMockModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PairingDeviceMockCapabilityLegacy getTargetProductAddress:modelObj];
  
}




+ (PMKPromise *) updatePairingPhaseWithPhase:(NSString *)phase onModel:(PairingDeviceMockModel *)modelObj {
  return [PairingDeviceMockCapabilityLegacy updatePairingPhase:modelObj phase:phase];

}

@end
