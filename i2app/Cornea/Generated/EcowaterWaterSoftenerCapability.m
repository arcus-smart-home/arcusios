

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "EcowaterWaterSoftenerCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrEcowaterWaterSoftenerExcessiveUse=@"ecowater:excessiveUse";

NSString *const kAttrEcowaterWaterSoftenerContinuousUse=@"ecowater:continuousUse";

NSString *const kAttrEcowaterWaterSoftenerContinuousDuration=@"ecowater:continuousDuration";

NSString *const kAttrEcowaterWaterSoftenerContinuousRate=@"ecowater:continuousRate";

NSString *const kAttrEcowaterWaterSoftenerAlertOnContinuousUse=@"ecowater:alertOnContinuousUse";

NSString *const kAttrEcowaterWaterSoftenerAlertOnExcessiveUse=@"ecowater:alertOnExcessiveUse";





@implementation EcowaterWaterSoftenerCapability
+ (NSString *)namespace { return @"ecowater"; }
+ (NSString *)name { return @"EcowaterWaterSoftener"; }

+ (BOOL)getExcessiveUseFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getExcessiveUse:modelObj] boolValue];
  
}


+ (BOOL)getContinuousUseFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getContinuousUse:modelObj] boolValue];
  
}


+ (int)getContinuousDurationFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getContinuousDuration:modelObj] intValue];
  
}

+ (int)setContinuousDuration:(int)continuousDuration onModel:(DeviceModel *)modelObj {
  [EcowaterWaterSoftenerCapabilityLegacy setContinuousDuration:continuousDuration model:modelObj];
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getContinuousDuration:modelObj] intValue];
  
}


+ (double)getContinuousRateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getContinuousRate:modelObj] doubleValue];
  
}

+ (double)setContinuousRate:(double)continuousRate onModel:(DeviceModel *)modelObj {
  [EcowaterWaterSoftenerCapabilityLegacy setContinuousRate:continuousRate model:modelObj];
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getContinuousRate:modelObj] doubleValue];
  
}


+ (BOOL)getAlertOnContinuousUseFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getAlertOnContinuousUse:modelObj] boolValue];
  
}

+ (BOOL)setAlertOnContinuousUse:(BOOL)alertOnContinuousUse onModel:(DeviceModel *)modelObj {
  [EcowaterWaterSoftenerCapabilityLegacy setAlertOnContinuousUse:alertOnContinuousUse model:modelObj];
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getAlertOnContinuousUse:modelObj] boolValue];
  
}


+ (BOOL)getAlertOnExcessiveUseFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getAlertOnExcessiveUse:modelObj] boolValue];
  
}

+ (BOOL)setAlertOnExcessiveUse:(BOOL)alertOnExcessiveUse onModel:(DeviceModel *)modelObj {
  [EcowaterWaterSoftenerCapabilityLegacy setAlertOnExcessiveUse:alertOnExcessiveUse model:modelObj];
  
  return [[EcowaterWaterSoftenerCapabilityLegacy getAlertOnExcessiveUse:modelObj] boolValue];
  
}



@end
