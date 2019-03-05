

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IrrigationZoneCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrIrrigationZoneZoneState=@"irr:zoneState";

NSString *const kAttrIrrigationZoneWateringStart=@"irr:wateringStart";

NSString *const kAttrIrrigationZoneWateringDuration=@"irr:wateringDuration";

NSString *const kAttrIrrigationZoneWateringTrigger=@"irr:wateringTrigger";

NSString *const kAttrIrrigationZoneDefaultDuration=@"irr:defaultDuration";

NSString *const kAttrIrrigationZoneZonenum=@"irr:zonenum";

NSString *const kAttrIrrigationZoneZonename=@"irr:zonename";

NSString *const kAttrIrrigationZoneZonecolor=@"irr:zonecolor";

NSString *const kAttrIrrigationZoneWateringRemainingTime=@"irr:wateringRemainingTime";



NSString *const kEnumIrrigationZoneZoneStateWATERING = @"WATERING";
NSString *const kEnumIrrigationZoneZoneStateNOT_WATERING = @"NOT_WATERING";
NSString *const kEnumIrrigationZoneWateringTriggerMANUAL = @"MANUAL";
NSString *const kEnumIrrigationZoneWateringTriggerSCHEDULED = @"SCHEDULED";
NSString *const kEnumIrrigationZoneZonecolorLIGHTRED = @"LIGHTRED";
NSString *const kEnumIrrigationZoneZonecolorDARKRED = @"DARKRED";
NSString *const kEnumIrrigationZoneZonecolorORANGE = @"ORANGE";
NSString *const kEnumIrrigationZoneZonecolorYELLOW = @"YELLOW";
NSString *const kEnumIrrigationZoneZonecolorLIGHTGREEN = @"LIGHTGREEN";
NSString *const kEnumIrrigationZoneZonecolorDARKGREEN = @"DARKGREEN";
NSString *const kEnumIrrigationZoneZonecolorLIGHTBLUE = @"LIGHTBLUE";
NSString *const kEnumIrrigationZoneZonecolorDARKBLUE = @"DARKBLUE";
NSString *const kEnumIrrigationZoneZonecolorVIOLET = @"VIOLET";
NSString *const kEnumIrrigationZoneZonecolorWHITE = @"WHITE";
NSString *const kEnumIrrigationZoneZonecolorGREY = @"GREY";
NSString *const kEnumIrrigationZoneZonecolorBLACK = @"BLACK";


@implementation IrrigationZoneCapability
+ (NSString *)namespace { return @"irr"; }
+ (NSString *)name { return @"IrrigationZone"; }

+ (NSString *)getZoneStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IrrigationZoneCapabilityLegacy getZoneState:modelObj];
  
}


+ (NSDate *)getWateringStartFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IrrigationZoneCapabilityLegacy getWateringStart:modelObj];
  
}


+ (int)getWateringDurationFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationZoneCapabilityLegacy getWateringDuration:modelObj] intValue];
  
}


+ (NSString *)getWateringTriggerFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IrrigationZoneCapabilityLegacy getWateringTrigger:modelObj];
  
}


+ (int)getDefaultDurationFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationZoneCapabilityLegacy getDefaultDuration:modelObj] intValue];
  
}

+ (int)setDefaultDuration:(int)defaultDuration onModel:(DeviceModel *)modelObj {
  [IrrigationZoneCapabilityLegacy setDefaultDuration:defaultDuration model:modelObj];
  
  return [[IrrigationZoneCapabilityLegacy getDefaultDuration:modelObj] intValue];
  
}


+ (int)getZonenumFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationZoneCapabilityLegacy getZonenum:modelObj] intValue];
  
}


+ (NSString *)getZonenameFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IrrigationZoneCapabilityLegacy getZonename:modelObj];
  
}

+ (NSString *)setZonename:(NSString *)zonename onModel:(DeviceModel *)modelObj {
  [IrrigationZoneCapabilityLegacy setZonename:zonename model:modelObj];
  
  return [IrrigationZoneCapabilityLegacy getZonename:modelObj];
  
}


+ (NSString *)getZonecolorFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IrrigationZoneCapabilityLegacy getZonecolor:modelObj];
  
}

+ (NSString *)setZonecolor:(NSString *)zonecolor onModel:(DeviceModel *)modelObj {
  [IrrigationZoneCapabilityLegacy setZonecolor:zonecolor model:modelObj];
  
  return [IrrigationZoneCapabilityLegacy getZonecolor:modelObj];
  
}


+ (int)getWateringRemainingTimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationZoneCapabilityLegacy getWateringRemainingTime:modelObj] intValue];
  
}



@end
