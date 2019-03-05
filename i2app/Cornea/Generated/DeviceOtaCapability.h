

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;











/** Version of the currently installed firmware. */
extern NSString *const kAttrDeviceOtaCurrentVersion;

/** Version of the target firmware. */
extern NSString *const kAttrDeviceOtaTargetVersion;

/** Status of the current firmware update process. */
extern NSString *const kAttrDeviceOtaStatus;

/** Current firmware update retry count. */
extern NSString *const kAttrDeviceOtaRetryCount;

/** UTC date time of last retry attempt. */
extern NSString *const kAttrDeviceOtaLastAttempt;

/** Progress of the current firmware download. */
extern NSString *const kAttrDeviceOtaProgressPercent;

/** Reason for failure of the OTA (offline, timeout, refused, etc.). */
extern NSString *const kAttrDeviceOtaLastFailReason;


extern NSString *const kCmdDeviceOtaFirmwareUpdate;

extern NSString *const kCmdDeviceOtaFirmwareUpdateCancel;


extern NSString *const kEvtDeviceOtaFirmwareUpdateProgress;

extern NSString *const kEnumDeviceOtaStatusIDLE;
extern NSString *const kEnumDeviceOtaStatusINPROGRESS;
extern NSString *const kEnumDeviceOtaStatusCOMPLETED;
extern NSString *const kEnumDeviceOtaStatusFAILED;


@interface DeviceOtaCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getCurrentVersionFromModel:(DeviceModel *)modelObj;


+ (NSString *)getTargetVersionFromModel:(DeviceModel *)modelObj;


+ (NSString *)getStatusFromModel:(DeviceModel *)modelObj;


+ (int)getRetryCountFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getLastAttemptFromModel:(DeviceModel *)modelObj;


+ (double)getProgressPercentFromModel:(DeviceModel *)modelObj;


+ (NSString *)getLastFailReasonFromModel:(DeviceModel *)modelObj;





/** Requests that the hub update its firmware */
+ (PMKPromise *) firmwareUpdateWithUrl:(NSString *)url withPriority:(NSString *)priority withMd5:(NSString *)md5 onModel:(Model *)modelObj;



/** Requests that the hub cancel an existing firmware update */
+ (PMKPromise *) firmwareUpdateCancelOnModel:(Model *)modelObj;



@end
