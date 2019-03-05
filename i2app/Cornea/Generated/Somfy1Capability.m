

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "Somfy1Capability.h"
#import <i2app-Swift.h>


NSString *const kAttrSomfy1Mode=@"somfy1:mode";

NSString *const kAttrSomfy1Reversed=@"somfy1:reversed";



NSString *const kEnumSomfy1ModeSHADE = @"SHADE";
NSString *const kEnumSomfy1ModeBLIND = @"BLIND";
NSString *const kEnumSomfy1ReversedNORMAL = @"NORMAL";
NSString *const kEnumSomfy1ReversedREVERSED = @"REVERSED";


@implementation Somfy1Capability
+ (NSString *)namespace { return @"somfy1"; }
+ (NSString *)name { return @"Somfy1"; }

+ (NSString *)getModeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Somfy1CapabilityLegacy getMode:modelObj];
  
}

+ (NSString *)setMode:(NSString *)mode onModel:(DeviceModel *)modelObj {
  [Somfy1CapabilityLegacy setMode:mode model:modelObj];
  
  return [Somfy1CapabilityLegacy getMode:modelObj];
  
}


+ (NSString *)getReversedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Somfy1CapabilityLegacy getReversed:modelObj];
  
}

+ (NSString *)setReversed:(NSString *)reversed onModel:(DeviceModel *)modelObj {
  [Somfy1CapabilityLegacy setReversed:reversed model:modelObj];
  
  return [Somfy1CapabilityLegacy getReversed:modelObj];
  
}



@end
