

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "LeakH2OCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrLeakH2OState=@"leakh2o:state";

NSString *const kAttrLeakH2OStatechanged=@"leakh2o:statechanged";


NSString *const kCmdLeakH2OLeakh2o=@"leakh2o:leakh2o";


NSString *const kEnumLeakH2OStateSAFE = @"SAFE";
NSString *const kEnumLeakH2OStateLEAK = @"LEAK";


@implementation LeakH2OCapability
+ (NSString *)namespace { return @"leakh2o"; }
+ (NSString *)name { return @"LeakH2O"; }

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LeakH2OCapabilityLegacy getState:modelObj];
  
}

+ (NSString *)setState:(NSString *)state onModel:(DeviceModel *)modelObj {
  [LeakH2OCapabilityLegacy setState:state model:modelObj];
  
  return [LeakH2OCapabilityLegacy getState:modelObj];
  
}


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LeakH2OCapabilityLegacy getStatechanged:modelObj];
  
}




+ (PMKPromise *) leakh2oWithState:(NSString *)state onModel:(DeviceModel *)modelObj {
  return [LeakH2OCapabilityLegacy leakh2o:modelObj state:state];

}

@end
