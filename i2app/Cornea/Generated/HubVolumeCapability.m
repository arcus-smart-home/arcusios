

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubVolumeCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubVolumeVolume=@"hubvol:volume";



NSString *const kEnumHubVolumeVolumeOFF = @"OFF";
NSString *const kEnumHubVolumeVolumeLOW = @"LOW";
NSString *const kEnumHubVolumeVolumeMID = @"MID";
NSString *const kEnumHubVolumeVolumeHIGH = @"HIGH";


@implementation HubVolumeCapability
+ (NSString *)namespace { return @"hubvol"; }
+ (NSString *)name { return @"HubVolume"; }

+ (NSString *)getVolumeFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubVolumeCapabilityLegacy getVolume:modelObj];
  
}

+ (NSString *)setVolume:(NSString *)volume onModel:(HubModel *)modelObj {
  [HubVolumeCapabilityLegacy setVolume:volume model:modelObj];
  
  return [HubVolumeCapabilityLegacy getVolume:modelObj];
  
}



@end
