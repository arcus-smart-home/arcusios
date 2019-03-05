

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** When true, camera&#x27;s privacy function is enabled */
extern NSString *const kAttrCameraPrivacy;

/** List of resolutions supported by the camera e.g. 160x120, 320x240, 640x480, 1280x960  */
extern NSString *const kAttrCameraResolutionssupported;

/** Current resolution of the camera. Must appear in resolutionssupported list. */
extern NSString *const kAttrCameraResolution;

/** Constant bit rate or variable bit rate */
extern NSString *const kAttrCameraBitratetype;

/** List of bitrates supported by the camera e.g. 32K, 64K, 96K, 128K, 256K, 384K, 512K, 768K, 1024K, 1280K, 2048K */
extern NSString *const kAttrCameraBitratessupported;

/** Only valid when bitrate type is cbr. Must appear in bitratessupported list. */
extern NSString *const kAttrCameraBitrate;

/** List of quality levels supported by the camera e.g Very Low, Low, Normal, High, Very High */
extern NSString *const kAttrCameraQualitiessupported;

/** Current quality of the camera. Must appear in qualitiessupported list. */
extern NSString *const kAttrCameraQuality;

/** Minimum framerate supported. */
extern NSString *const kAttrCameraMinframerate;

/** Maximum framerate supported. */
extern NSString *const kAttrCameraMaxframerate;

/** Current framerate of the camera. Must be minframerate &lt;= framerate &lt;= maxframerate */
extern NSString *const kAttrCameraFramerate;

/** When true, camera&#x27;s image is flipped vertically */
extern NSString *const kAttrCameraFlip;

/** When true, camera&#x27;s image is mirrored horizontally */
extern NSString *const kAttrCameraMirror;

/** What camera IR LED modes are supported? */
extern NSString *const kAttrCameraIrLedSupportedModes;

/** Reflects the mode of IR LED on the camera. */
extern NSString *const kAttrCameraIrLedMode;

/** Reflects the current IR LED luminance, on a scale of 1 to 5. */
extern NSString *const kAttrCameraIrLedLuminance;


extern NSString *const kCmdCameraStartStreaming;


extern NSString *const kEnumCameraBitratetypecbr;
extern NSString *const kEnumCameraBitratetypevbr;
extern NSString *const kEnumCameraIrLedModeON;
extern NSString *const kEnumCameraIrLedModeOFF;
extern NSString *const kEnumCameraIrLedModeAUTO;


@interface CameraCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getPrivacyFromModel:(DeviceModel *)modelObj;


+ (NSArray *)getResolutionssupportedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getResolutionFromModel:(DeviceModel *)modelObj;

+ (NSString *)setResolution:(NSString *)resolution onModel:(DeviceModel *)modelObj;


+ (NSString *)getBitratetypeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setBitratetype:(NSString *)bitratetype onModel:(DeviceModel *)modelObj;


+ (NSArray *)getBitratessupportedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getBitrateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setBitrate:(NSString *)bitrate onModel:(DeviceModel *)modelObj;


+ (NSArray *)getQualitiessupportedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getQualityFromModel:(DeviceModel *)modelObj;

+ (NSString *)setQuality:(NSString *)quality onModel:(DeviceModel *)modelObj;


+ (int)getMinframerateFromModel:(DeviceModel *)modelObj;


+ (int)getMaxframerateFromModel:(DeviceModel *)modelObj;


+ (int)getFramerateFromModel:(DeviceModel *)modelObj;

+ (int)setFramerate:(int)framerate onModel:(DeviceModel *)modelObj;


+ (BOOL)getFlipFromModel:(DeviceModel *)modelObj;

+ (BOOL)setFlip:(BOOL)flip onModel:(DeviceModel *)modelObj;


+ (BOOL)getMirrorFromModel:(DeviceModel *)modelObj;

+ (BOOL)setMirror:(BOOL)mirror onModel:(DeviceModel *)modelObj;


+ (NSArray *)getIrLedSupportedModesFromModel:(DeviceModel *)modelObj;


+ (NSString *)getIrLedModeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setIrLedMode:(NSString *)irLedMode onModel:(DeviceModel *)modelObj;


+ (int)getIrLedLuminanceFromModel:(DeviceModel *)modelObj;

+ (int)setIrLedLuminance:(int)irLedLuminance onModel:(DeviceModel *)modelObj;





/** Informs the camera to start streaming to some destination */
+ (PMKPromise *) startStreamingWithUrl:(NSString *)url withUsername:(NSString *)username withPassword:(NSString *)password withMaxDuration:(int)maxDuration withStream:(BOOL)stream onModel:(Model *)modelObj;



@end
