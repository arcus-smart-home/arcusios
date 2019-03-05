

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/** The addresses of cameras defined at this place */
extern NSString *const kAttrCamerasSubsystemCameras;

/** The addresses of offline cameras defined at this place */
extern NSString *const kAttrCamerasSubsystemOfflineCameras;

/** A set of warnings about devices.  The key is the address of the device with a warning and the value is an I18N code with the description of the problem. */
extern NSString *const kAttrCamerasSubsystemWarnings;

/** Whether or not recording is enabled based on the service level */
extern NSString *const kAttrCamerasSubsystemRecordingEnabled;

/** An estimate of how many simultaneous streams can be supported.  NOTE: While this is currently r/w for testing purposes, it will likely be made read-only in the future and should not be directly exposed as a writable attribute to the end-user. */
extern NSString *const kAttrCamerasSubsystemMaxSimultaneousStreams;





@interface CamerasSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getCamerasFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getOfflineCamerasFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getWarningsFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getRecordingEnabledFromModel:(SubsystemModel *)modelObj;


+ (int)getMaxSimultaneousStreamsFromModel:(SubsystemModel *)modelObj;

+ (int)setMaxSimultaneousStreams:(int)maxSimultaneousStreams onModel:(SubsystemModel *)modelObj;





@end
