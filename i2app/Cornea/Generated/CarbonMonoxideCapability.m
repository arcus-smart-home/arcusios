

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CarbonMonoxideCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCarbonMonoxideCo=@"co:co";

NSString *const kAttrCarbonMonoxideEol=@"co:eol";

NSString *const kAttrCarbonMonoxideCochanged=@"co:cochanged";

NSString *const kAttrCarbonMonoxideCoppm=@"co:coppm";



NSString *const kEnumCarbonMonoxideCoSAFE = @"SAFE";
NSString *const kEnumCarbonMonoxideCoDETECTED = @"DETECTED";
NSString *const kEnumCarbonMonoxideEolOK = @"OK";
NSString *const kEnumCarbonMonoxideEolEOL = @"EOL";


@implementation CarbonMonoxideCapability
+ (NSString *)namespace { return @"co"; }
+ (NSString *)name { return @"CarbonMonoxide"; }

+ (NSString *)getCoFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CarbonMonoxideCapabilityLegacy getCo:modelObj];
  
}


+ (NSString *)getEolFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CarbonMonoxideCapabilityLegacy getEol:modelObj];
  
}


+ (NSDate *)getCochangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CarbonMonoxideCapabilityLegacy getCochanged:modelObj];
  
}


+ (long)getCoppmFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CarbonMonoxideCapabilityLegacy getCoppm:modelObj] longValue];
  
}



@end
