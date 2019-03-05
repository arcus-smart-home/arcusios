

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ButtonCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrButtonState=@"but:state";

NSString *const kAttrButtonStatechanged=@"but:statechanged";



NSString *const kEnumButtonStatePRESSED = @"PRESSED";
NSString *const kEnumButtonStateRELEASED = @"RELEASED";


@implementation ButtonCapability
+ (NSString *)namespace { return @"but"; }
+ (NSString *)name { return @"Button"; }

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ButtonCapabilityLegacy getState:modelObj];
  
}

+ (NSString *)setState:(NSString *)state onModel:(DeviceModel *)modelObj {
  [ButtonCapabilityLegacy setState:state model:modelObj];
  
  return [ButtonCapabilityLegacy getState:modelObj];
  
}


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ButtonCapabilityLegacy getStatechanged:modelObj];
  
}



@end
