

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CameraStatusCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCameraStatusCamera=@"camerastatus:camera";

NSString *const kAttrCameraStatusState=@"camerastatus:state";

NSString *const kAttrCameraStatusLastRecording=@"camerastatus:lastRecording";

NSString *const kAttrCameraStatusLastRecordingTime=@"camerastatus:lastRecordingTime";

NSString *const kAttrCameraStatusActiveRecording=@"camerastatus:activeRecording";



NSString *const kEnumCameraStatusStateOFFLINE = @"OFFLINE";
NSString *const kEnumCameraStatusStateIDLE = @"IDLE";
NSString *const kEnumCameraStatusStateRECORDING = @"RECORDING";
NSString *const kEnumCameraStatusStateSTREAMING = @"STREAMING";


@implementation CameraStatusCapability
+ (NSString *)namespace { return @"camerastatus"; }
+ (NSString *)name { return @"CameraStatus"; }

+ (NSString *)getCameraFromModel:(CameraStatusModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraStatusCapabilityLegacy getCamera:modelObj];
  
}


+ (NSString *)getStateFromModel:(CameraStatusModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraStatusCapabilityLegacy getState:modelObj];
  
}


+ (NSString *)getLastRecordingFromModel:(CameraStatusModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraStatusCapabilityLegacy getLastRecording:modelObj];
  
}


+ (NSDate *)getLastRecordingTimeFromModel:(CameraStatusModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraStatusCapabilityLegacy getLastRecordingTime:modelObj];
  
}


+ (NSString *)getActiveRecordingFromModel:(CameraStatusModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CameraStatusCapabilityLegacy getActiveRecording:modelObj];
  
}



@end
