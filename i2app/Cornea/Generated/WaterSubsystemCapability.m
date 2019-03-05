

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WaterSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrWaterSubsystemPrimaryWaterHeater=@"subwater:primaryWaterHeater";

NSString *const kAttrWaterSubsystemPrimaryWaterSoftener=@"subwater:primaryWaterSoftener";

NSString *const kAttrWaterSubsystemClosedWaterValves=@"subwater:closedWaterValves";

NSString *const kAttrWaterSubsystemWaterDevices=@"subwater:waterDevices";

NSString *const kAttrWaterSubsystemContinuousWaterUseDevices=@"subwater:continuousWaterUseDevices";

NSString *const kAttrWaterSubsystemExcessiveWaterUseDevices=@"subwater:excessiveWaterUseDevices";

NSString *const kAttrWaterSubsystemLowSaltDevices=@"subwater:lowSaltDevices";



NSString *const kEvtWaterSubsystemContinuousWaterUse=@"subwater:ContinuousWaterUse";

NSString *const kEvtWaterSubsystemExcessiveWaterUse=@"subwater:ExcessiveWaterUse";

NSString *const kEvtWaterSubsystemLowSalt=@"subwater:LowSalt";



@implementation WaterSubsystemCapability
+ (NSString *)namespace { return @"subwater"; }
+ (NSString *)name { return @"WaterSubsystem"; }

+ (NSString *)getPrimaryWaterHeaterFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterSubsystemCapabilityLegacy getPrimaryWaterHeater:modelObj];
  
}

+ (NSString *)setPrimaryWaterHeater:(NSString *)primaryWaterHeater onModel:(SubsystemModel *)modelObj {
  [WaterSubsystemCapabilityLegacy setPrimaryWaterHeater:primaryWaterHeater model:modelObj];
  
  return [WaterSubsystemCapabilityLegacy getPrimaryWaterHeater:modelObj];
  
}


+ (NSString *)getPrimaryWaterSoftenerFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterSubsystemCapabilityLegacy getPrimaryWaterSoftener:modelObj];
  
}

+ (NSString *)setPrimaryWaterSoftener:(NSString *)primaryWaterSoftener onModel:(SubsystemModel *)modelObj {
  [WaterSubsystemCapabilityLegacy setPrimaryWaterSoftener:primaryWaterSoftener model:modelObj];
  
  return [WaterSubsystemCapabilityLegacy getPrimaryWaterSoftener:modelObj];
  
}


+ (NSArray *)getClosedWaterValvesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterSubsystemCapabilityLegacy getClosedWaterValves:modelObj];
  
}


+ (NSArray *)getWaterDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterSubsystemCapabilityLegacy getWaterDevices:modelObj];
  
}


+ (NSArray *)getContinuousWaterUseDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterSubsystemCapabilityLegacy getContinuousWaterUseDevices:modelObj];
  
}


+ (NSArray *)getExcessiveWaterUseDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterSubsystemCapabilityLegacy getExcessiveWaterUseDevices:modelObj];
  
}


+ (NSArray *)getLowSaltDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterSubsystemCapabilityLegacy getLowSaltDevices:modelObj];
  
}



@end
