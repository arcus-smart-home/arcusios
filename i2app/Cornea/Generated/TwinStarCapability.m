

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "TwinStarCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrTwinStarEcomode=@"twinstar:ecomode";



NSString *const kEnumTwinStarEcomodeENABLED = @"ENABLED";
NSString *const kEnumTwinStarEcomodeDISABLED = @"DISABLED";


@implementation TwinStarCapability
+ (NSString *)namespace { return @"twinstar"; }
+ (NSString *)name { return @"TwinStar"; }

+ (NSString *)getEcomodeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [TwinStarCapabilityLegacy getEcomode:modelObj];
  
}

+ (NSString *)setEcomode:(NSString *)ecomode onModel:(DeviceModel *)modelObj {
  [TwinStarCapabilityLegacy setEcomode:ecomode model:modelObj];
  
  return [TwinStarCapabilityLegacy getEcomode:modelObj];
  
}



@end
