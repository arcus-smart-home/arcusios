

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "MotorizedDoorCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrMotorizedDoorDoorstate=@"motdoor:doorstate";

NSString *const kAttrMotorizedDoorDoorlevel=@"motdoor:doorlevel";

NSString *const kAttrMotorizedDoorDoorstatechanged=@"motdoor:doorstatechanged";



NSString *const kEnumMotorizedDoorDoorstateCLOSED = @"CLOSED";
NSString *const kEnumMotorizedDoorDoorstateCLOSING = @"CLOSING";
NSString *const kEnumMotorizedDoorDoorstateOBSTRUCTION = @"OBSTRUCTION";
NSString *const kEnumMotorizedDoorDoorstateOPENING = @"OPENING";
NSString *const kEnumMotorizedDoorDoorstateOPEN = @"OPEN";


@implementation MotorizedDoorCapability
+ (NSString *)namespace { return @"motdoor"; }
+ (NSString *)name { return @"MotorizedDoor"; }

+ (NSString *)getDoorstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MotorizedDoorCapabilityLegacy getDoorstate:modelObj];
  
}

+ (NSString *)setDoorstate:(NSString *)doorstate onModel:(DeviceModel *)modelObj {
  [MotorizedDoorCapabilityLegacy setDoorstate:doorstate model:modelObj];
  
  return [MotorizedDoorCapabilityLegacy getDoorstate:modelObj];
  
}


+ (int)getDoorlevelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[MotorizedDoorCapabilityLegacy getDoorlevel:modelObj] intValue];
  
}

+ (int)setDoorlevel:(int)doorlevel onModel:(DeviceModel *)modelObj {
  [MotorizedDoorCapabilityLegacy setDoorlevel:doorlevel model:modelObj];
  
  return [[MotorizedDoorCapabilityLegacy getDoorlevel:modelObj] intValue];
  
}


+ (NSDate *)getDoorstatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MotorizedDoorCapabilityLegacy getDoorstatechanged:modelObj];
  
}



@end
