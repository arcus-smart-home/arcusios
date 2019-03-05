

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "FlowCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrFlowFlow=@"flow:flow";





@implementation FlowCapability
+ (NSString *)namespace { return @"flow"; }
+ (NSString *)name { return @"Flow"; }

+ (double)getFlowFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[FlowCapabilityLegacy getFlow:modelObj] doubleValue];
  
}



@end
