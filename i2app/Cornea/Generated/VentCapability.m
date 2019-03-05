

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "VentCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrVentVentstate=@"vent:ventstate";

NSString *const kAttrVentLevel=@"vent:level";

NSString *const kAttrVentAirpressure=@"vent:airpressure";



NSString *const kEnumVentVentstateOK = @"OK";
NSString *const kEnumVentVentstateOBSTRUCTION = @"OBSTRUCTION";


@implementation VentCapability
+ (NSString *)namespace { return @"vent"; }
+ (NSString *)name { return @"Vent"; }

+ (NSString *)getVentstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [VentCapabilityLegacy getVentstate:modelObj];
  
}


+ (int)getLevelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[VentCapabilityLegacy getLevel:modelObj] intValue];
  
}

+ (int)setLevel:(int)level onModel:(DeviceModel *)modelObj {
  [VentCapabilityLegacy setLevel:level model:modelObj];
  
  return [[VentCapabilityLegacy getLevel:modelObj] intValue];
  
}


+ (double)getAirpressureFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[VentCapabilityLegacy getAirpressure:modelObj] doubleValue];
  
}



@end
