

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "LeakGasCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrLeakGasState=@"gas:state";

NSString *const kAttrLeakGasStatechanged=@"gas:statechanged";



NSString *const kEnumLeakGasStateSAFE = @"SAFE";
NSString *const kEnumLeakGasStateLEAK = @"LEAK";


@implementation LeakGasCapability
+ (NSString *)namespace { return @"gas"; }
+ (NSString *)name { return @"LeakGas"; }

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LeakGasCapabilityLegacy getState:modelObj];
  
}


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LeakGasCapabilityLegacy getStatechanged:modelObj];
  
}



@end
