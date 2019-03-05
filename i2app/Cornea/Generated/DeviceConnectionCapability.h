

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the state of the connection to this device. If the device has intermediate connectivity states at the protocol level, it must be marked as offline until it can be fully controlled by the platform */
extern NSString *const kAttrDeviceConnectionState;

/** Reflects the status of the connection to this device. */
extern NSString *const kAttrDeviceConnectionStatus;

/** Time of the last change in connect.state */
extern NSString *const kAttrDeviceConnectionLastchange;

/** A projection from a protocol transport specific measurement of signal strength. For zigbee or wifi this may be the RSSI normalized to percentage. */
extern NSString *const kAttrDeviceConnectionSignal;


extern NSString *const kCmdDeviceConnectionLostDevice;


extern NSString *const kEnumDeviceConnectionStateONLINE;
extern NSString *const kEnumDeviceConnectionStateOFFLINE;
extern NSString *const kEnumDeviceConnectionStatusONLINE;
extern NSString *const kEnumDeviceConnectionStatusFLAPPING;
extern NSString *const kEnumDeviceConnectionStatusLOST;


@interface DeviceConnectionCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj;


+ (NSString *)getStatusFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getLastchangeFromModel:(DeviceModel *)modelObj;


+ (int)getSignalFromModel:(DeviceModel *)modelObj;





/** Sent when a device exists on the platform but is not reported by the hub. */
+ (PMKPromise *) lostDeviceOnModel:(Model *)modelObj;



@end
