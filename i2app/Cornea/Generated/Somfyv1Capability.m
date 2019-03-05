

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "Somfyv1Capability.h"
#import <i2app-Swift.h>


NSString *const kAttrSomfyv1Type=@"somfyv1:type";

NSString *const kAttrSomfyv1Reversed=@"somfyv1:reversed";

NSString *const kAttrSomfyv1Channel=@"somfyv1:channel";

NSString *const kAttrSomfyv1Currentstate=@"somfyv1:currentstate";

NSString *const kAttrSomfyv1Statechanged=@"somfyv1:statechanged";


NSString *const kCmdSomfyv1GoToOpen=@"somfyv1:GoToOpen";

NSString *const kCmdSomfyv1GoToClosed=@"somfyv1:GoToClosed";

NSString *const kCmdSomfyv1GoToFavorite=@"somfyv1:GoToFavorite";


NSString *const kEnumSomfyv1TypeSHADE = @"SHADE";
NSString *const kEnumSomfyv1TypeBLIND = @"BLIND";
NSString *const kEnumSomfyv1ReversedNORMAL = @"NORMAL";
NSString *const kEnumSomfyv1ReversedREVERSED = @"REVERSED";
NSString *const kEnumSomfyv1CurrentstateOPEN = @"OPEN";
NSString *const kEnumSomfyv1CurrentstateCLOSED = @"CLOSED";


@implementation Somfyv1Capability
+ (NSString *)namespace { return @"somfyv1"; }
+ (NSString *)name { return @"Somfyv1"; }

+ (NSString *)getTypeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Somfyv1CapabilityLegacy getType:modelObj];
  
}

+ (NSString *)setType:(NSString *)type onModel:(DeviceModel *)modelObj {
  [Somfyv1CapabilityLegacy setType:type model:modelObj];
  
  return [Somfyv1CapabilityLegacy getType:modelObj];
  
}


+ (NSString *)getReversedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Somfyv1CapabilityLegacy getReversed:modelObj];
  
}

+ (NSString *)setReversed:(NSString *)reversed onModel:(DeviceModel *)modelObj {
  [Somfyv1CapabilityLegacy setReversed:reversed model:modelObj];
  
  return [Somfyv1CapabilityLegacy getReversed:modelObj];
  
}


+ (int)getChannelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[Somfyv1CapabilityLegacy getChannel:modelObj] intValue];
  
}


+ (NSString *)getCurrentstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Somfyv1CapabilityLegacy getCurrentstate:modelObj];
  
}


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [Somfyv1CapabilityLegacy getStatechanged:modelObj];
  
}




+ (PMKPromise *) goToOpenOnModel:(DeviceModel *)modelObj {
  return [Somfyv1CapabilityLegacy goToOpen:modelObj ];
}


+ (PMKPromise *) goToClosedOnModel:(DeviceModel *)modelObj {
  return [Somfyv1CapabilityLegacy goToClosed:modelObj ];
}


+ (PMKPromise *) goToFavoriteOnModel:(DeviceModel *)modelObj {
  return [Somfyv1CapabilityLegacy goToFavorite:modelObj ];
}

@end
