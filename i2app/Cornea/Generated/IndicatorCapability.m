

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IndicatorCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrIndicatorIndicator=@"indicator:indicator";

NSString *const kAttrIndicatorEnabled=@"indicator:enabled";

NSString *const kAttrIndicatorEnableSupported=@"indicator:enableSupported";

NSString *const kAttrIndicatorInverted=@"indicator:inverted";



NSString *const kEnumIndicatorIndicatorON = @"ON";
NSString *const kEnumIndicatorIndicatorOFF = @"OFF";
NSString *const kEnumIndicatorIndicatorDISABLED = @"DISABLED";


@implementation IndicatorCapability
+ (NSString *)namespace { return @"indicator"; }
+ (NSString *)name { return @"Indicator"; }

+ (NSString *)getIndicatorFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IndicatorCapabilityLegacy getIndicator:modelObj];
  
}


+ (BOOL)getEnabledFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IndicatorCapabilityLegacy getEnabled:modelObj] boolValue];
  
}

+ (BOOL)setEnabled:(BOOL)enabled onModel:(DeviceModel *)modelObj {
  [IndicatorCapabilityLegacy setEnabled:enabled model:modelObj];
  
  return [[IndicatorCapabilityLegacy getEnabled:modelObj] boolValue];
  
}


+ (BOOL)getEnableSupportedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IndicatorCapabilityLegacy getEnableSupported:modelObj] boolValue];
  
}


+ (BOOL)getInvertedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IndicatorCapabilityLegacy getInverted:modelObj] boolValue];
  
}

+ (BOOL)setInverted:(BOOL)inverted onModel:(DeviceModel *)modelObj {
  [IndicatorCapabilityLegacy setInverted:inverted model:modelObj];
  
  return [[IndicatorCapabilityLegacy getInverted:modelObj] boolValue];
  
}



@end
