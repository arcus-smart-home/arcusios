

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CamerasSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCamerasSubsystemCameras=@"subcameras:cameras";

NSString *const kAttrCamerasSubsystemOfflineCameras=@"subcameras:offlineCameras";

NSString *const kAttrCamerasSubsystemWarnings=@"subcameras:warnings";

NSString *const kAttrCamerasSubsystemRecordingEnabled=@"subcameras:recordingEnabled";

NSString *const kAttrCamerasSubsystemMaxSimultaneousStreams=@"subcameras:maxSimultaneousStreams";





@implementation CamerasSubsystemCapability
+ (NSString *)namespace { return @"subcameras"; }
+ (NSString *)name { return @"CamerasSubsystem"; }

+ (NSArray *)getCamerasFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CamerasSubsystemCapabilityLegacy getCameras:modelObj];
  
}


+ (NSArray *)getOfflineCamerasFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CamerasSubsystemCapabilityLegacy getOfflineCameras:modelObj];
  
}


+ (NSDictionary *)getWarningsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CamerasSubsystemCapabilityLegacy getWarnings:modelObj];
  
}


+ (BOOL)getRecordingEnabledFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CamerasSubsystemCapabilityLegacy getRecordingEnabled:modelObj] boolValue];
  
}


+ (int)getMaxSimultaneousStreamsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CamerasSubsystemCapabilityLegacy getMaxSimultaneousStreams:modelObj] intValue];
  
}

+ (int)setMaxSimultaneousStreams:(int)maxSimultaneousStreams onModel:(SubsystemModel *)modelObj {
  [CamerasSubsystemCapabilityLegacy setMaxSimultaneousStreams:maxSimultaneousStreams model:modelObj];
  
  return [[CamerasSubsystemCapabilityLegacy getMaxSimultaneousStreams:modelObj] intValue];
  
}



@end
