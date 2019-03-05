

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CameraCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCameraPrivacy=@"camera:privacy";

NSString *const kAttrCameraResolutionssupported=@"camera:resolutionssupported";

NSString *const kAttrCameraResolution=@"camera:resolution";

NSString *const kAttrCameraBitratetype=@"camera:bitratetype";

NSString *const kAttrCameraBitratessupported=@"camera:bitratessupported";

NSString *const kAttrCameraBitrate=@"camera:bitrate";

NSString *const kAttrCameraQualitiessupported=@"camera:qualitiessupported";

NSString *const kAttrCameraQuality=@"camera:quality";

NSString *const kAttrCameraMinframerate=@"camera:minframerate";

NSString *const kAttrCameraMaxframerate=@"camera:maxframerate";

NSString *const kAttrCameraFramerate=@"camera:framerate";

NSString *const kAttrCameraFlip=@"camera:flip";

NSString *const kAttrCameraMirror=@"camera:mirror";

NSString *const kAttrCameraIrLedSupportedModes=@"camera:irLedSupportedModes";

NSString *const kAttrCameraIrLedMode=@"camera:irLedMode";

NSString *const kAttrCameraIrLedLuminance=@"camera:irLedLuminance";


NSString *const kCmdCameraStartStreaming=@"camera:StartStreaming";


NSString *const kEnumCameraBitratetypecbr = @"cbr";
NSString *const kEnumCameraBitratetypevbr = @"vbr";
NSString *const kEnumCameraIrLedModeON = @"ON";
NSString *const kEnumCameraIrLedModeOFF = @"OFF";
NSString *const kEnumCameraIrLedModeAUTO = @"AUTO";


@implementation CameraCapability
+ (NSString *)namespace { return @"camera"; }
+ (NSString *)name { return @"Camera"; }

+ (BOOL)getPrivacyFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraCapabilityLegacy getPrivacy:modelObj] boolValue];
  
}


+ (NSArray *)getResolutionssupportedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getResolutionssupported:modelObj];
  
}


+ (NSString *)getResolutionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getResolution:modelObj];
  
}

+ (NSString *)setResolution:(NSString *)resolution onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setResolution:resolution model:modelObj];
  
  return [CameraCapabilityLegacy getResolution:modelObj];
  
}


+ (NSString *)getBitratetypeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getBitratetype:modelObj];
  
}

+ (NSString *)setBitratetype:(NSString *)bitratetype onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setBitratetype:bitratetype model:modelObj];
  
  return [CameraCapabilityLegacy getBitratetype:modelObj];
  
}


+ (NSArray *)getBitratessupportedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getBitratessupported:modelObj];
  
}


+ (NSString *)getBitrateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getBitrate:modelObj];
  
}

+ (NSString *)setBitrate:(NSString *)bitrate onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setBitrate:bitrate model:modelObj];
  
  return [CameraCapabilityLegacy getBitrate:modelObj];
  
}


+ (NSArray *)getQualitiessupportedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getQualitiessupported:modelObj];
  
}


+ (NSString *)getQualityFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getQuality:modelObj];
  
}

+ (NSString *)setQuality:(NSString *)quality onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setQuality:quality model:modelObj];
  
  return [CameraCapabilityLegacy getQuality:modelObj];
  
}


+ (int)getMinframerateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraCapabilityLegacy getMinframerate:modelObj] intValue];
  
}


+ (int)getMaxframerateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraCapabilityLegacy getMaxframerate:modelObj] intValue];
  
}


+ (int)getFramerateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraCapabilityLegacy getFramerate:modelObj] intValue];
  
}

+ (int)setFramerate:(int)framerate onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setFramerate:framerate model:modelObj];
  
  return [[CameraCapabilityLegacy getFramerate:modelObj] intValue];
  
}


+ (BOOL)getFlipFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraCapabilityLegacy getFlip:modelObj] boolValue];
  
}

+ (BOOL)setFlip:(BOOL)flip onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setFlip:flip model:modelObj];
  
  return [[CameraCapabilityLegacy getFlip:modelObj] boolValue];
  
}


+ (BOOL)getMirrorFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraCapabilityLegacy getMirror:modelObj] boolValue];
  
}

+ (BOOL)setMirror:(BOOL)mirror onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setMirror:mirror model:modelObj];
  
  return [[CameraCapabilityLegacy getMirror:modelObj] boolValue];
  
}


+ (NSArray *)getIrLedSupportedModesFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getIrLedSupportedModes:modelObj];
  
}


+ (NSString *)getIrLedModeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraCapabilityLegacy getIrLedMode:modelObj];
  
}

+ (NSString *)setIrLedMode:(NSString *)irLedMode onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setIrLedMode:irLedMode model:modelObj];
  
  return [CameraCapabilityLegacy getIrLedMode:modelObj];
  
}


+ (int)getIrLedLuminanceFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraCapabilityLegacy getIrLedLuminance:modelObj] intValue];
  
}

+ (int)setIrLedLuminance:(int)irLedLuminance onModel:(DeviceModel *)modelObj {
  [CameraCapabilityLegacy setIrLedLuminance:irLedLuminance model:modelObj];
  
  return [[CameraCapabilityLegacy getIrLedLuminance:modelObj] intValue];
  
}




+ (PMKPromise *) startStreamingWithUrl:(NSString *)url withUsername:(NSString *)username withPassword:(NSString *)password withMaxDuration:(int)maxDuration withStream:(BOOL)stream onModel:(DeviceModel *)modelObj {
  return [CameraCapabilityLegacy startStreaming:modelObj url:url username:username password:password maxDuration:maxDuration stream:stream];

}

@end
