

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The serial number of the camera */
extern NSString *const kAttrSwannBatteryCameraSn;

/** Current resolution of the camera. Must appear in resolutionssupported list. */
extern NSString *const kAttrSwannBatteryCameraMode;

/** Offset from GMT in 30m increments */
extern NSString *const kAttrSwannBatteryCameraTimeZone;

/** How long to sleep between motion detection. */
extern NSString *const kAttrSwannBatteryCameraMotionDetectSleep;

/** true to prevent the camera from upload clips, false otherwise. */
extern NSString *const kAttrSwannBatteryCameraStopUpload;


extern NSString *const kCmdSwannBatteryCameraKeepAwake;


extern NSString *const kEnumSwannBatteryCameraModeWLAN_CONFIGURE;
extern NSString *const kEnumSwannBatteryCameraModeWLAN_RECONNECT;
extern NSString *const kEnumSwannBatteryCameraModeNOTIFY;
extern NSString *const kEnumSwannBatteryCameraModeSOFTAP;
extern NSString *const kEnumSwannBatteryCameraModeRECORDING;
extern NSString *const kEnumSwannBatteryCameraModeSTREAMING;
extern NSString *const kEnumSwannBatteryCameraModeUPGRADE;
extern NSString *const kEnumSwannBatteryCameraModeRESET;
extern NSString *const kEnumSwannBatteryCameraModeUNCONFIG;
extern NSString *const kEnumSwannBatteryCameraModeASLEEP;
extern NSString *const kEnumSwannBatteryCameraModeUNKNOWN;
extern NSString *const kEnumSwannBatteryCameraMotionDetectSleepMin;
extern NSString *const kEnumSwannBatteryCameraMotionDetectSleep30s;
extern NSString *const kEnumSwannBatteryCameraMotionDetectSleep1m;
extern NSString *const kEnumSwannBatteryCameraMotionDetectSleep3m;
extern NSString *const kEnumSwannBatteryCameraMotionDetectSleep5m;


@interface SwannBatteryCameraCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getSnFromModel:(DeviceModel *)modelObj;


+ (NSString *)getModeFromModel:(DeviceModel *)modelObj;


+ (int)getTimeZoneFromModel:(DeviceModel *)modelObj;

+ (int)setTimeZone:(int)timeZone onModel:(DeviceModel *)modelObj;


+ (NSString *)getMotionDetectSleepFromModel:(DeviceModel *)modelObj;

+ (NSString *)setMotionDetectSleep:(NSString *)motionDetectSleep onModel:(DeviceModel *)modelObj;


+ (BOOL)getStopUploadFromModel:(DeviceModel *)modelObj;

+ (BOOL)setStopUpload:(BOOL)stopUpload onModel:(DeviceModel *)modelObj;





/** Wakes up the battery camera if it is asleep and tell it to stay awake for the given number of seconds.  If the camera is already awake, this will tell the camera to stay awake for the given number of seconds */
+ (PMKPromise *) keepAwakeWithSeconds:(int)seconds onModel:(Model *)modelObj;



@end
