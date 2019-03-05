

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "TiltCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrTiltTiltstate=@"tilt:tiltstate";

NSString *const kAttrTiltTiltstatechanged=@"tilt:tiltstatechanged";



NSString *const kEnumTiltTiltstateFLAT = @"FLAT";
NSString *const kEnumTiltTiltstateUPRIGHT = @"UPRIGHT";


@implementation TiltCapability
+ (NSString *)namespace { return @"tilt"; }
+ (NSString *)name { return @"Tilt"; }

+ (NSString *)getTiltstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [TiltCapabilityLegacy getTiltstate:modelObj];
  
}

+ (NSString *)setTiltstate:(NSString *)tiltstate onModel:(DeviceModel *)modelObj {
  [TiltCapabilityLegacy setTiltstate:tiltstate model:modelObj];
  
  return [TiltCapabilityLegacy getTiltstate:modelObj];
  
}


+ (NSDate *)getTiltstatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [TiltCapabilityLegacy getTiltstatechanged:modelObj];
  
}



@end
