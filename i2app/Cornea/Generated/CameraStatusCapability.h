

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class CameraStatusModel;



/** The address of the associated camera. */
extern NSString *const kAttrCameraStatusCamera;

/** An *estimate* of the current state of the camera.  This should be used for displaying metadata not as a guarantee that prevents new recordings / streams from being attempted. */
extern NSString *const kAttrCameraStatusState;

/**  Address of the last recording completed by the camera. This will be the empty string in the following cases:  - Camera has never completed a recording  - The most recent recording has been deleted by the user            */
extern NSString *const kAttrCameraStatusLastRecording;

/**  Start time of the last recording that has completed for this camera. Note it will not be updated until the current recording completes.  Also it may contain a time for a non-existent recording if the user has deleted the most recent recording.           */
extern NSString *const kAttrCameraStatusLastRecordingTime;

/** The address of the video that the camera is currently streaming / recording. */
extern NSString *const kAttrCameraStatusActiveRecording;



extern NSString *const kEnumCameraStatusStateOFFLINE;
extern NSString *const kEnumCameraStatusStateIDLE;
extern NSString *const kEnumCameraStatusStateRECORDING;
extern NSString *const kEnumCameraStatusStateSTREAMING;


@interface CameraStatusCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getCameraFromModel:(CameraStatusModel *)modelObj;


+ (NSString *)getStateFromModel:(CameraStatusModel *)modelObj;


+ (NSString *)getLastRecordingFromModel:(CameraStatusModel *)modelObj;


+ (NSDate *)getLastRecordingTimeFromModel:(CameraStatusModel *)modelObj;


+ (NSString *)getActiveRecordingFromModel:(CameraStatusModel *)modelObj;





@end
