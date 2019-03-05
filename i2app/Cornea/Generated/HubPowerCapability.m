

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubPowerCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubPowerSource=@"hubpow:source";

NSString *const kAttrHubPowerMainscpable=@"hubpow:mainscpable";

NSString *const kAttrHubPowerBattery=@"hubpow:Battery";



NSString *const kEvtHubPowerHubPowerSourceChanged=@"hubpow:HubPowerSourceChanged";

NSString *const kEvtHubPowerHubBatteryLow=@"hubpow:HubBatteryLow";

NSString *const kEnumHubPowerSourceMAINS = @"MAINS";
NSString *const kEnumHubPowerSourceBATTERY = @"BATTERY";


@implementation HubPowerCapability
+ (NSString *)namespace { return @"hubpow"; }
+ (NSString *)name { return @"HubPower"; }

+ (NSString *)getSourceFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubPowerCapabilityLegacy getSource:modelObj];
  
}


+ (BOOL)getMainscpableFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubPowerCapabilityLegacy getMainscpable:modelObj] boolValue];
  
}


+ (int)getBatteryFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubPowerCapabilityLegacy getBattery:modelObj] intValue];
  
}



@end
