

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IrrigationControllerCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrIrrigationControllerNumZones=@"irrcont:numZones";

NSString *const kAttrIrrigationControllerControllerState=@"irrcont:controllerState";

NSString *const kAttrIrrigationControllerRainDelayStart=@"irrcont:rainDelayStart";

NSString *const kAttrIrrigationControllerRainDelayDuration=@"irrcont:rainDelayDuration";

NSString *const kAttrIrrigationControllerMaxtransitions=@"irrcont:maxtransitions";

NSString *const kAttrIrrigationControllerMaxdailytransitions=@"irrcont:maxdailytransitions";

NSString *const kAttrIrrigationControllerMinirrigationtime=@"irrcont:minirrigationtime";

NSString *const kAttrIrrigationControllerMaxirrigationtime=@"irrcont:maxirrigationtime";

NSString *const kAttrIrrigationControllerBudget=@"irrcont:budget";

NSString *const kAttrIrrigationControllerZonesinfault=@"irrcont:zonesinfault";

NSString *const kAttrIrrigationControllerRainDelay=@"irrcont:rainDelay";


NSString *const kCmdIrrigationControllerWaterNowV2=@"irrcont:WaterNowV2";

NSString *const kCmdIrrigationControllerCancelV2=@"irrcont:CancelV2";

NSString *const kCmdIrrigationControllerWaterNow=@"irrcont:WaterNow";

NSString *const kCmdIrrigationControllerCancel=@"irrcont:Cancel";


NSString *const kEnumIrrigationControllerControllerStateOFF = @"OFF";
NSString *const kEnumIrrigationControllerControllerStateWATERING = @"WATERING";
NSString *const kEnumIrrigationControllerControllerStateNOT_WATERING = @"NOT_WATERING";
NSString *const kEnumIrrigationControllerControllerStateRAIN_DELAY = @"RAIN_DELAY";


@implementation IrrigationControllerCapability
+ (NSString *)namespace { return @"irrcont"; }
+ (NSString *)name { return @"IrrigationController"; }

+ (int)getNumZonesFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationControllerCapabilityLegacy getNumZones:modelObj] intValue];
  
}


+ (NSString *)getControllerStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IrrigationControllerCapabilityLegacy getControllerState:modelObj];
  
}


+ (NSDate *)getRainDelayStartFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IrrigationControllerCapabilityLegacy getRainDelayStart:modelObj];
  
}


+ (int)getRainDelayDurationFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationControllerCapabilityLegacy getRainDelayDuration:modelObj] intValue];
  
}


+ (int)getMaxtransitionsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationControllerCapabilityLegacy getMaxtransitions:modelObj] intValue];
  
}


+ (int)getMaxdailytransitionsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationControllerCapabilityLegacy getMaxdailytransitions:modelObj] intValue];
  
}


+ (int)getMinirrigationtimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationControllerCapabilityLegacy getMinirrigationtime:modelObj] intValue];
  
}


+ (int)getMaxirrigationtimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationControllerCapabilityLegacy getMaxirrigationtime:modelObj] intValue];
  
}


+ (int)getBudgetFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationControllerCapabilityLegacy getBudget:modelObj] intValue];
  
}

+ (int)setBudget:(int)budget onModel:(DeviceModel *)modelObj {
  [IrrigationControllerCapabilityLegacy setBudget:budget model:modelObj];
  
  return [[IrrigationControllerCapabilityLegacy getBudget:modelObj] intValue];
  
}


+ (NSArray *)getZonesinfaultFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IrrigationControllerCapabilityLegacy getZonesinfault:modelObj];
  
}


+ (int)getRainDelayFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationControllerCapabilityLegacy getRainDelay:modelObj] intValue];
  
}

+ (int)setRainDelay:(int)rainDelay onModel:(DeviceModel *)modelObj {
  [IrrigationControllerCapabilityLegacy setRainDelay:rainDelay model:modelObj];
  
  return [[IrrigationControllerCapabilityLegacy getRainDelay:modelObj] intValue];
  
}




+ (PMKPromise *) waterNowV2WithZone:(NSString *)zone withDuration:(int)duration onModel:(DeviceModel *)modelObj {
  return [IrrigationControllerCapabilityLegacy waterNowV2:modelObj zone:zone duration:duration];

}


+ (PMKPromise *) cancelV2WithZone:(NSString *)zone onModel:(DeviceModel *)modelObj {
  return [IrrigationControllerCapabilityLegacy cancelV2:modelObj zone:zone];

}


+ (PMKPromise *) waterNowWithZonenum:(int)zonenum withDuration:(int)duration onModel:(DeviceModel *)modelObj {
  return [IrrigationControllerCapabilityLegacy waterNow:modelObj zonenum:zonenum duration:duration];

}


+ (PMKPromise *) cancelWithZonenum:(int)zonenum onModel:(DeviceModel *)modelObj {
  return [IrrigationControllerCapabilityLegacy cancel:modelObj zonenum:zonenum];

}

@end
