

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SoilMoistureCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSoilMoistureWatercontent=@"soilmoisture:watercontent";

NSString *const kAttrSoilMoistureSoiltype=@"soilmoisture:soiltype";

NSString *const kAttrSoilMoistureWatercontentupdated=@"soilmoisture:watercontentupdated";



NSString *const kEnumSoilMoistureSoiltypeNORMAL = @"NORMAL";
NSString *const kEnumSoilMoistureSoiltypeSANDY = @"SANDY";
NSString *const kEnumSoilMoistureSoiltypeCLAY = @"CLAY";


@implementation SoilMoistureCapability
+ (NSString *)namespace { return @"soilmoisture"; }
+ (NSString *)name { return @"SoilMoisture"; }

+ (double)getWatercontentFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SoilMoistureCapabilityLegacy getWatercontent:modelObj] doubleValue];
  
}


+ (NSString *)getSoiltypeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SoilMoistureCapabilityLegacy getSoiltype:modelObj];
  
}

+ (NSString *)setSoiltype:(NSString *)soiltype onModel:(DeviceModel *)modelObj {
  [SoilMoistureCapabilityLegacy setSoiltype:soiltype model:modelObj];
  
  return [SoilMoistureCapabilityLegacy getSoiltype:modelObj];
  
}


+ (NSDate *)getWatercontentupdatedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SoilMoistureCapabilityLegacy getWatercontentupdated:modelObj];
  
}



@end
