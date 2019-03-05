

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AtmosCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrAtmosPressure=@"atmos:pressure";





@implementation AtmosCapability
+ (NSString *)namespace { return @"atmos"; }
+ (NSString *)name { return @"Atmos"; }

+ (double)getPressureFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AtmosCapabilityLegacy getPressure:modelObj] doubleValue];
  
}



@end
