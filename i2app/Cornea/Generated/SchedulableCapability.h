

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The type of scheduling that is possible on this device. NOT_SUPPORTED:  No scheduling is possible either via Arcus or the physical device DEVICE_ONLY:  Scheduling is not possible via Arcus, but can be configured on the physical device DRIVER_READ_ONLY:  Arcus may read scheduling information via a driver specific implementation but cannot write schedule information DRIVER_WRITE_ONLY:  Arcus may write scheduling information via a driver specific implementation but cnnot read schedule information SUPPORTED_DRIVER:  Arcus may completely control scheduling of the device via a driver specific implementation (i.e. schedule is likely read and pushed to the device) SUPPORTED_CLOUD:  Arcus may completely control scheduling of the device via an internal mechanism (i.e. cloud or hub based)  */
extern NSString *const kAttrSchedulableType;

/** Whether or not a schedule is currently enabled for this device */
extern NSString *const kAttrSchedulableScheduleEnabled;


extern NSString *const kCmdSchedulableEnableSchedule;

extern NSString *const kCmdSchedulableDisableSchedule;


extern NSString *const kEnumSchedulableTypeNOT_SUPPORTED;
extern NSString *const kEnumSchedulableTypeDEVICE_ONLY;
extern NSString *const kEnumSchedulableTypeDRIVER_READ_ONLY;
extern NSString *const kEnumSchedulableTypeDRIVER_WRITE_ONLY;
extern NSString *const kEnumSchedulableTypeSUPPORTED_DRIVER;
extern NSString *const kEnumSchedulableTypeSUPPORTED_CLOUD;


@interface SchedulableCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getTypeFromModel:(DeviceModel *)modelObj;


+ (BOOL)getScheduleEnabledFromModel:(DeviceModel *)modelObj;





/** Enables scheduling for this device */
+ (PMKPromise *) enableScheduleOnModel:(Model *)modelObj;



/** Disables scheduling for this device */
+ (PMKPromise *) disableScheduleOnModel:(Model *)modelObj;



@end
