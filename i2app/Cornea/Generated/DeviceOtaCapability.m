

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DeviceOtaCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDeviceOtaCurrentVersion=@"devota:currentVersion";

NSString *const kAttrDeviceOtaTargetVersion=@"devota:targetVersion";

NSString *const kAttrDeviceOtaStatus=@"devota:status";

NSString *const kAttrDeviceOtaRetryCount=@"devota:retryCount";

NSString *const kAttrDeviceOtaLastAttempt=@"devota:lastAttempt";

NSString *const kAttrDeviceOtaProgressPercent=@"devota:progressPercent";

NSString *const kAttrDeviceOtaLastFailReason=@"devota:lastFailReason";


NSString *const kCmdDeviceOtaFirmwareUpdate=@"devota:FirmwareUpdate";

NSString *const kCmdDeviceOtaFirmwareUpdateCancel=@"devota:FirmwareUpdateCancel";


NSString *const kEvtDeviceOtaFirmwareUpdateProgress=@"devota:FirmwareUpdateProgress";

NSString *const kEnumDeviceOtaStatusIDLE = @"IDLE";
NSString *const kEnumDeviceOtaStatusINPROGRESS = @"INPROGRESS";
NSString *const kEnumDeviceOtaStatusCOMPLETED = @"COMPLETED";
NSString *const kEnumDeviceOtaStatusFAILED = @"FAILED";


@implementation DeviceOtaCapability
+ (NSString *)namespace { return @"devota"; }
+ (NSString *)name { return @"DeviceOta"; }

+ (NSString *)getCurrentVersionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceOtaCapabilityLegacy getCurrentVersion:modelObj];
  
}


+ (NSString *)getTargetVersionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceOtaCapabilityLegacy getTargetVersion:modelObj];
  
}


+ (NSString *)getStatusFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceOtaCapabilityLegacy getStatus:modelObj];
  
}


+ (int)getRetryCountFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DeviceOtaCapabilityLegacy getRetryCount:modelObj] intValue];
  
}


+ (NSDate *)getLastAttemptFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceOtaCapabilityLegacy getLastAttempt:modelObj];
  
}


+ (double)getProgressPercentFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DeviceOtaCapabilityLegacy getProgressPercent:modelObj] doubleValue];
  
}


+ (NSString *)getLastFailReasonFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceOtaCapabilityLegacy getLastFailReason:modelObj];
  
}




+ (PMKPromise *) firmwareUpdateWithUrl:(NSString *)url withPriority:(NSString *)priority withMd5:(NSString *)md5 onModel:(DeviceModel *)modelObj {
  return [DeviceOtaCapabilityLegacy firmwareUpdate:modelObj url:url priority:priority md5:md5];

}


+ (PMKPromise *) firmwareUpdateCancelOnModel:(DeviceModel *)modelObj {
  return [DeviceOtaCapabilityLegacy firmwareUpdateCancel:modelObj ];
}

@end
