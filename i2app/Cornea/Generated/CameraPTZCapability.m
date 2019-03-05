

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CameraPTZCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCameraPTZCurrentPan=@"cameraptz:currentPan";

NSString *const kAttrCameraPTZCurrentTilt=@"cameraptz:currentTilt";

NSString *const kAttrCameraPTZCurrentZoom=@"cameraptz:currentZoom";

NSString *const kAttrCameraPTZMaximumPan=@"cameraptz:maximumPan";

NSString *const kAttrCameraPTZMinimumPan=@"cameraptz:minimumPan";

NSString *const kAttrCameraPTZMaximumTilt=@"cameraptz:maximumTilt";

NSString *const kAttrCameraPTZMinimumTilt=@"cameraptz:minimumTilt";

NSString *const kAttrCameraPTZMaximumZoom=@"cameraptz:maximumZoom";

NSString *const kAttrCameraPTZMinimumZoom=@"cameraptz:minimumZoom";


NSString *const kCmdCameraPTZGotoHome=@"cameraptz:GotoHome";

NSString *const kCmdCameraPTZGotoAbsolute=@"cameraptz:GotoAbsolute";

NSString *const kCmdCameraPTZGotoRelative=@"cameraptz:GotoRelative";




@implementation CameraPTZCapability
+ (NSString *)namespace { return @"cameraptz"; }
+ (NSString *)name { return @"CameraPTZ"; }

+ (int)getCurrentPanFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getCurrentPan:modelObj] intValue];
  
}


+ (int)getCurrentTiltFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getCurrentTilt:modelObj] intValue];
  
}


+ (int)getCurrentZoomFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getCurrentZoom:modelObj] intValue];
  
}


+ (int)getMaximumPanFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getMaximumPan:modelObj] intValue];
  
}


+ (int)getMinimumPanFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getMinimumPan:modelObj] intValue];
  
}


+ (int)getMaximumTiltFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getMaximumTilt:modelObj] intValue];
  
}


+ (int)getMinimumTiltFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getMinimumTilt:modelObj] intValue];
  
}


+ (int)getMaximumZoomFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getMaximumZoom:modelObj] intValue];
  
}


+ (int)getMinimumZoomFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[CameraPTZCapabilityLegacy getMinimumZoom:modelObj] intValue];
  
}




+ (PMKPromise *) gotoHomeOnModel:(DeviceModel *)modelObj {
  return [CameraPTZCapabilityLegacy gotoHome:modelObj ];
}


+ (PMKPromise *) gotoAbsoluteWithPan:(int)pan withTilt:(int)tilt withZoom:(int)zoom onModel:(DeviceModel *)modelObj {
  return [CameraPTZCapabilityLegacy gotoAbsolute:modelObj pan:pan tilt:tilt zoom:zoom];

}


+ (PMKPromise *) gotoRelativeWithDeltaPan:(int)deltaPan withDeltaTilt:(int)deltaTilt withDeltaZoom:(int)deltaZoom onModel:(DeviceModel *)modelObj {
  return [CameraPTZCapabilityLegacy gotoRelative:modelObj deltaPan:deltaPan deltaTilt:deltaTilt deltaZoom:deltaZoom];

}

@end
