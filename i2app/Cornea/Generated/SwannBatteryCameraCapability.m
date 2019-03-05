

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SwannBatteryCameraCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSwannBatteryCameraSn=@"swannbatterycamera:sn";

NSString *const kAttrSwannBatteryCameraMode=@"swannbatterycamera:mode";

NSString *const kAttrSwannBatteryCameraTimeZone=@"swannbatterycamera:timeZone";

NSString *const kAttrSwannBatteryCameraMotionDetectSleep=@"swannbatterycamera:motionDetectSleep";

NSString *const kAttrSwannBatteryCameraStopUpload=@"swannbatterycamera:stopUpload";


NSString *const kCmdSwannBatteryCameraKeepAwake=@"swannbatterycamera:KeepAwake";


NSString *const kEnumSwannBatteryCameraModeWLAN_CONFIGURE = @"WLAN_CONFIGURE";
NSString *const kEnumSwannBatteryCameraModeWLAN_RECONNECT = @"WLAN_RECONNECT";
NSString *const kEnumSwannBatteryCameraModeNOTIFY = @"NOTIFY";
NSString *const kEnumSwannBatteryCameraModeSOFTAP = @"SOFTAP";
NSString *const kEnumSwannBatteryCameraModeRECORDING = @"RECORDING";
NSString *const kEnumSwannBatteryCameraModeSTREAMING = @"STREAMING";
NSString *const kEnumSwannBatteryCameraModeUPGRADE = @"UPGRADE";
NSString *const kEnumSwannBatteryCameraModeRESET = @"RESET";
NSString *const kEnumSwannBatteryCameraModeUNCONFIG = @"UNCONFIG";
NSString *const kEnumSwannBatteryCameraModeASLEEP = @"ASLEEP";
NSString *const kEnumSwannBatteryCameraModeUNKNOWN = @"UNKNOWN";
NSString *const kEnumSwannBatteryCameraMotionDetectSleepMin = @"Min";
NSString *const kEnumSwannBatteryCameraMotionDetectSleep30s = @"30s";
NSString *const kEnumSwannBatteryCameraMotionDetectSleep1m = @"1m";
NSString *const kEnumSwannBatteryCameraMotionDetectSleep3m = @"3m";
NSString *const kEnumSwannBatteryCameraMotionDetectSleep5m = @"5m";


@implementation SwannBatteryCameraCapability
+ (NSString *)namespace { return @"swannbatterycamera"; }
+ (NSString *)name { return @"SwannBatteryCamera"; }

+ (NSString *)getSnFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SwannBatteryCameraCapabilityLegacy getSn:modelObj];
  
}


+ (NSString *)getModeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SwannBatteryCameraCapabilityLegacy getMode:modelObj];
  
}


+ (int)getTimeZoneFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SwannBatteryCameraCapabilityLegacy getTimeZone:modelObj] intValue];
  
}

+ (int)setTimeZone:(int)timeZone onModel:(DeviceModel *)modelObj {
  [SwannBatteryCameraCapabilityLegacy setTimeZone:timeZone model:modelObj];
  
  return [[SwannBatteryCameraCapabilityLegacy getTimeZone:modelObj] intValue];
  
}


+ (NSString *)getMotionDetectSleepFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SwannBatteryCameraCapabilityLegacy getMotionDetectSleep:modelObj];
  
}

+ (NSString *)setMotionDetectSleep:(NSString *)motionDetectSleep onModel:(DeviceModel *)modelObj {
  [SwannBatteryCameraCapabilityLegacy setMotionDetectSleep:motionDetectSleep model:modelObj];
  
  return [SwannBatteryCameraCapabilityLegacy getMotionDetectSleep:modelObj];
  
}


+ (BOOL)getStopUploadFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SwannBatteryCameraCapabilityLegacy getStopUpload:modelObj] boolValue];
  
}

+ (BOOL)setStopUpload:(BOOL)stopUpload onModel:(DeviceModel *)modelObj {
  [SwannBatteryCameraCapabilityLegacy setStopUpload:stopUpload model:modelObj];
  
  return [[SwannBatteryCameraCapabilityLegacy getStopUpload:modelObj] boolValue];
  
}




+ (PMKPromise *) keepAwakeWithSeconds:(int)seconds onModel:(DeviceModel *)modelObj {
  return [SwannBatteryCameraCapabilityLegacy keepAwake:modelObj seconds:seconds];

}

@end
