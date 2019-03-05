

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "MotionCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrMotionMotion=@"mot:motion";

NSString *const kAttrMotionMotionchanged=@"mot:motionchanged";

NSString *const kAttrMotionSensitivitiesSupported=@"mot:sensitivitiesSupported";

NSString *const kAttrMotionSensitivity=@"mot:sensitivity";



NSString *const kEnumMotionMotionNONE = @"NONE";
NSString *const kEnumMotionMotionDETECTED = @"DETECTED";
NSString *const kEnumMotionSensitivityOFF = @"OFF";
NSString *const kEnumMotionSensitivityLOW = @"LOW";
NSString *const kEnumMotionSensitivityMED = @"MED";
NSString *const kEnumMotionSensitivityHIGH = @"HIGH";
NSString *const kEnumMotionSensitivityMAX = @"MAX";


@implementation MotionCapability
+ (NSString *)namespace { return @"mot"; }
+ (NSString *)name { return @"Motion"; }

+ (NSString *)getMotionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MotionCapabilityLegacy getMotion:modelObj];
  
}


+ (NSDate *)getMotionchangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MotionCapabilityLegacy getMotionchanged:modelObj];
  
}


+ (NSArray *)getSensitivitiesSupportedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MotionCapabilityLegacy getSensitivitiesSupported:modelObj];
  
}


+ (NSString *)getSensitivityFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MotionCapabilityLegacy getSensitivity:modelObj];
  
}

+ (NSString *)setSensitivity:(NSString *)sensitivity onModel:(DeviceModel *)modelObj {
  [MotionCapabilityLegacy setSensitivity:sensitivity model:modelObj];
  
  return [MotionCapabilityLegacy getSensitivity:modelObj];
  
}



@end
