

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WaterSoftenerCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrWaterSoftenerRechargeStatus=@"watersoftener:rechargeStatus";

NSString *const kAttrWaterSoftenerCurrentSaltLevel=@"watersoftener:currentSaltLevel";

NSString *const kAttrWaterSoftenerMaxSaltLevel=@"watersoftener:maxSaltLevel";

NSString *const kAttrWaterSoftenerSaltLevelEnabled=@"watersoftener:saltLevelEnabled";

NSString *const kAttrWaterSoftenerRechargeStartTime=@"watersoftener:rechargeStartTime";

NSString *const kAttrWaterSoftenerRechargeTimeRemaining=@"watersoftener:rechargeTimeRemaining";

NSString *const kAttrWaterSoftenerDaysPoweredUp=@"watersoftener:daysPoweredUp";

NSString *const kAttrWaterSoftenerTotalRecharges=@"watersoftener:totalRecharges";


NSString *const kCmdWaterSoftenerRechargeNow=@"watersoftener:rechargeNow";


NSString *const kEnumWaterSoftenerRechargeStatusREADY = @"READY";
NSString *const kEnumWaterSoftenerRechargeStatusRECHARGING = @"RECHARGING";
NSString *const kEnumWaterSoftenerRechargeStatusRECHARGE_SCHEDULED = @"RECHARGE_SCHEDULED";


@implementation WaterSoftenerCapability
+ (NSString *)namespace { return @"watersoftener"; }
+ (NSString *)name { return @"WaterSoftener"; }

+ (NSString *)getRechargeStatusFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WaterSoftenerCapabilityLegacy getRechargeStatus:modelObj];
  
}


+ (int)getCurrentSaltLevelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterSoftenerCapabilityLegacy getCurrentSaltLevel:modelObj] intValue];
  
}


+ (int)getMaxSaltLevelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterSoftenerCapabilityLegacy getMaxSaltLevel:modelObj] intValue];
  
}


+ (BOOL)getSaltLevelEnabledFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterSoftenerCapabilityLegacy getSaltLevelEnabled:modelObj] boolValue];
  
}


+ (int)getRechargeStartTimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterSoftenerCapabilityLegacy getRechargeStartTime:modelObj] intValue];
  
}

+ (int)setRechargeStartTime:(int)rechargeStartTime onModel:(DeviceModel *)modelObj {
  [WaterSoftenerCapabilityLegacy setRechargeStartTime:rechargeStartTime model:modelObj];
  
  return [[WaterSoftenerCapabilityLegacy getRechargeStartTime:modelObj] intValue];
  
}


+ (int)getRechargeTimeRemainingFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterSoftenerCapabilityLegacy getRechargeTimeRemaining:modelObj] intValue];
  
}


+ (int)getDaysPoweredUpFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterSoftenerCapabilityLegacy getDaysPoweredUp:modelObj] intValue];
  
}


+ (int)getTotalRechargesFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WaterSoftenerCapabilityLegacy getTotalRecharges:modelObj] intValue];
  
}




+ (PMKPromise *) rechargeNowOnModel:(DeviceModel *)modelObj {
  return [WaterSoftenerCapabilityLegacy rechargeNow:modelObj ];
}

@end
