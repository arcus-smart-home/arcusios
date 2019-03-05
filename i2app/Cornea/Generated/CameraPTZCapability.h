

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Curent camera pan position, in degrees */
extern NSString *const kAttrCameraPTZCurrentPan;

/** Curent camera tilt position, in degrees */
extern NSString *const kAttrCameraPTZCurrentTilt;

/** Curent camera zoom value */
extern NSString *const kAttrCameraPTZCurrentZoom;

/** Maximum camera pan position, in degrees */
extern NSString *const kAttrCameraPTZMaximumPan;

/** Minimum camera pan position, in degrees */
extern NSString *const kAttrCameraPTZMinimumPan;

/** Maximum camera tilt position, in degrees */
extern NSString *const kAttrCameraPTZMaximumTilt;

/** Minimum camera tilt position, in degrees */
extern NSString *const kAttrCameraPTZMinimumTilt;

/** Maximum camera zoom value */
extern NSString *const kAttrCameraPTZMaximumZoom;

/** Minimum camera zoom value */
extern NSString *const kAttrCameraPTZMinimumZoom;


extern NSString *const kCmdCameraPTZGotoHome;

extern NSString *const kCmdCameraPTZGotoAbsolute;

extern NSString *const kCmdCameraPTZGotoRelative;




@interface CameraPTZCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getCurrentPanFromModel:(DeviceModel *)modelObj;


+ (int)getCurrentTiltFromModel:(DeviceModel *)modelObj;


+ (int)getCurrentZoomFromModel:(DeviceModel *)modelObj;


+ (int)getMaximumPanFromModel:(DeviceModel *)modelObj;


+ (int)getMinimumPanFromModel:(DeviceModel *)modelObj;


+ (int)getMaximumTiltFromModel:(DeviceModel *)modelObj;


+ (int)getMinimumTiltFromModel:(DeviceModel *)modelObj;


+ (int)getMaximumZoomFromModel:(DeviceModel *)modelObj;


+ (int)getMinimumZoomFromModel:(DeviceModel *)modelObj;





/** Moves the camera to its home position */
+ (PMKPromise *) gotoHomeOnModel:(Model *)modelObj;



/** Moves the camera to an absolute position */
+ (PMKPromise *) gotoAbsoluteWithPan:(int)pan withTilt:(int)tilt withZoom:(int)zoom onModel:(Model *)modelObj;



/** Moves the camera to a relative position */
+ (PMKPromise *) gotoRelativeWithDeltaPan:(int)deltaPan withDeltaTilt:(int)deltaTilt withDeltaZoom:(int)deltaZoom onModel:(Model *)modelObj;



@end
