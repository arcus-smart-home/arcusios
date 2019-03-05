

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "LightsNSwitchesSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrLightsNSwitchesSubsystemSwitchDevices=@"sublightsnswitches:switchDevices";

NSString *const kAttrLightsNSwitchesSubsystemDeviceGroups=@"sublightsnswitches:deviceGroups";

NSString *const kAttrLightsNSwitchesSubsystemOnDeviceCounts=@"sublightsnswitches:onDeviceCounts";





@implementation LightsNSwitchesSubsystemCapability
+ (NSString *)namespace { return @"sublightsnswitches"; }
+ (NSString *)name { return @"LightsNSwitchesSubsystem"; }

+ (NSArray *)getSwitchDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LightsNSwitchesSubsystemCapabilityLegacy getSwitchDevices:modelObj];
  
}


+ (NSArray *)getDeviceGroupsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LightsNSwitchesSubsystemCapabilityLegacy getDeviceGroups:modelObj];
  
}


+ (NSDictionary *)getOnDeviceCountsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LightsNSwitchesSubsystemCapabilityLegacy getOnDeviceCounts:modelObj];
  
}



@end
