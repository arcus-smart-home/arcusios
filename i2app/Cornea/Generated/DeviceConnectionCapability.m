

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DeviceConnectionCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDeviceConnectionState=@"devconn:state";

NSString *const kAttrDeviceConnectionStatus=@"devconn:status";

NSString *const kAttrDeviceConnectionLastchange=@"devconn:lastchange";

NSString *const kAttrDeviceConnectionSignal=@"devconn:signal";


NSString *const kCmdDeviceConnectionLostDevice=@"devconn:LostDevice";


NSString *const kEnumDeviceConnectionStateONLINE = @"ONLINE";
NSString *const kEnumDeviceConnectionStateOFFLINE = @"OFFLINE";
NSString *const kEnumDeviceConnectionStatusONLINE = @"ONLINE";
NSString *const kEnumDeviceConnectionStatusFLAPPING = @"FLAPPING";
NSString *const kEnumDeviceConnectionStatusLOST = @"LOST";


@implementation DeviceConnectionCapability
+ (NSString *)namespace { return @"devconn"; }
+ (NSString *)name { return @"DeviceConnection"; }

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceConnectionCapabilityLegacy getState:modelObj];
  
}


+ (NSString *)getStatusFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceConnectionCapabilityLegacy getStatus:modelObj];
  
}


+ (NSDate *)getLastchangeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DeviceConnectionCapabilityLegacy getLastchange:modelObj];
  
}


+ (int)getSignalFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DeviceConnectionCapabilityLegacy getSignal:modelObj] intValue];
  
}




+ (PMKPromise *) lostDeviceOnModel:(DeviceModel *)modelObj {
  return [DeviceConnectionCapabilityLegacy lostDevice:modelObj ];
}

@end
