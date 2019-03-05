

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SwitchCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSwitchState=@"swit:state";

NSString *const kAttrSwitchInverted=@"swit:inverted";

NSString *const kAttrSwitchStatechanged=@"swit:statechanged";



NSString *const kEnumSwitchStateON = @"ON";
NSString *const kEnumSwitchStateOFF = @"OFF";


@implementation SwitchCapability
+ (NSString *)namespace { return @"swit"; }
+ (NSString *)name { return @"Switch"; }

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SwitchCapabilityLegacy getState:modelObj];
  
}

+ (NSString *)setState:(NSString *)state onModel:(DeviceModel *)modelObj {
  [SwitchCapabilityLegacy setState:state model:modelObj];
  
  return [SwitchCapabilityLegacy getState:modelObj];
  
}


+ (BOOL)getInvertedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SwitchCapabilityLegacy getInverted:modelObj] boolValue];
  
}

+ (BOOL)setInverted:(BOOL)inverted onModel:(DeviceModel *)modelObj {
  [SwitchCapabilityLegacy setInverted:inverted model:modelObj];
  
  return [[SwitchCapabilityLegacy getInverted:modelObj] boolValue];
  
}


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SwitchCapabilityLegacy getStatechanged:modelObj];
  
}



@end
