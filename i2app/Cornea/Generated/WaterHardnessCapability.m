

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WaterHardnessCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrWaterHardnessHardness=@"waterhardness:hardness";





@implementation WaterHardnessCapability
+ (NSString *)namespace { return @"waterhardness"; }
+ (NSString *)name { return @"WaterHardness"; }

+ (double)getHardnessFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterHardnessCapabilityLegacy getHardness:modelObj] doubleValue];
  
}



@end
