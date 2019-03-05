

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class RecordingModel;



















/** Human readable name for the device */
extern NSString *const kAttrRecordingName;

/** The place that the recording is associated with. */
extern NSString *const kAttrRecordingAccountid;

/** The place that the recording is associated with. */
extern NSString *const kAttrRecordingPlaceid;

/** The camera that the recording is associated with. */
extern NSString *const kAttrRecordingCameraid;

/** The person that the recording is associated with. */
extern NSString *const kAttrRecordingPersonid;

/** A timestamp identifying when the recording was made. */
extern NSString *const kAttrRecordingTimestamp;

/** The width of the recording in pixels. */
extern NSString *const kAttrRecordingWidth;

/** The height of the recording in pixels. */
extern NSString *const kAttrRecordingHeight;

/** The target bandwidth of the video in bps. */
extern NSString *const kAttrRecordingBandwidth;

/** The frame rate of the video in fps. */
extern NSString *const kAttrRecordingFramerate;

/** The precapture time in seconds, or 0 if no precaptured video is present. */
extern NSString *const kAttrRecordingPrecapture;

/** The recording type. STREAM indicates a live streaming session. */
extern NSString *const kAttrRecordingType;

/** The duration of the recording in seconds */
extern NSString *const kAttrRecordingDuration;

/** The side of the recording in bytes. */
extern NSString *const kAttrRecordingSize;

/** If true then the recording has been scheduled for deletion. */
extern NSString *const kAttrRecordingDeleted;

/** If the recording has been scheduled for deletion then this represents the time at which the recording will be permanently removed. */
extern NSString *const kAttrRecordingDeleteTime;

/** If the recording has been completed. */
extern NSString *const kAttrRecordingCompleted;

/** The recordings video codec */
extern NSString *const kAttrRecordingVideoCodec;

/** The recordings audio codec */
extern NSString *const kAttrRecordingAudioCodec;


extern NSString *const kCmdRecordingView;

extern NSString *const kCmdRecordingDownload;

extern NSString *const kCmdRecordingDelete;

extern NSString *const kCmdRecordingResurrect;


extern NSString *const kEnumRecordingTypeSTREAM;
extern NSString *const kEnumRecordingTypeRECORDING;


@interface RecordingCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getNameFromModel:(RecordingModel *)modelObj;

+ (NSString *)setName:(NSString *)name onModel:(Model *)modelObj;


+ (NSString *)getAccountidFromModel:(RecordingModel *)modelObj;


+ (NSString *)getPlaceidFromModel:(RecordingModel *)modelObj;


+ (NSString *)getCameraidFromModel:(RecordingModel *)modelObj;


+ (NSString *)getPersonidFromModel:(RecordingModel *)modelObj;


+ (NSDate *)getTimestampFromModel:(RecordingModel *)modelObj;


+ (int)getWidthFromModel:(RecordingModel *)modelObj;


+ (int)getHeightFromModel:(RecordingModel *)modelObj;


+ (int)getBandwidthFromModel:(RecordingModel *)modelObj;


+ (double)getFramerateFromModel:(RecordingModel *)modelObj;


+ (double)getPrecaptureFromModel:(RecordingModel *)modelObj;


+ (NSString *)getTypeFromModel:(RecordingModel *)modelObj;


+ (double)getDurationFromModel:(RecordingModel *)modelObj;


+ (long)getSizeFromModel:(RecordingModel *)modelObj;


+ (BOOL)getDeletedFromModel:(RecordingModel *)modelObj;


+ (NSDate *)getDeleteTimeFromModel:(RecordingModel *)modelObj;


+ (BOOL)getCompletedFromModel:(RecordingModel *)modelObj;


+ (NSString *)getVideoCodecFromModel:(RecordingModel *)modelObj;


+ (NSString *)getAudioCodecFromModel:(RecordingModel *)modelObj;





/** Used to retrieve URLs that can be used for viewing this recording. */
+ (PMKPromise *) viewOnModel:(Model *)modelObj;



/** Used to retrieve URLs that can be used for viewing this recording. */
+ (PMKPromise *) downloadOnModel:(Model *)modelObj;



/** Marks this recording for deletion. */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



/** Resurrects this recording if possible. */
+ (PMKPromise *) resurrectOnModel:(Model *)modelObj;



@end
