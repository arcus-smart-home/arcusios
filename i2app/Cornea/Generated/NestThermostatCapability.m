

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "NestThermostatCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrNestThermostatHasleaf=@"nesttherm:hasleaf";

NSString *const kAttrNestThermostatRoomname=@"nesttherm:roomname";

NSString *const kAttrNestThermostatLocked=@"nesttherm:locked";

NSString *const kAttrNestThermostatLockedtempmin=@"nesttherm:lockedtempmin";

NSString *const kAttrNestThermostatLockedtempmax=@"nesttherm:lockedtempmax";





@implementation NestThermostatCapability
+ (NSString *)namespace { return @"nesttherm"; }
+ (NSString *)name { return @"NestThermostat"; }

+ (BOOL)getHasleafFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[NestThermostatCapabilityLegacy getHasleaf:modelObj] boolValue];
  
}


+ (NSString *)getRoomnameFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [NestThermostatCapabilityLegacy getRoomname:modelObj];
  
}


+ (BOOL)getLockedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[NestThermostatCapabilityLegacy getLocked:modelObj] boolValue];
  
}


+ (double)getLockedtempminFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[NestThermostatCapabilityLegacy getLockedtempmin:modelObj] doubleValue];
  
}


+ (double)getLockedtempmaxFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[NestThermostatCapabilityLegacy getLockedtempmax:modelObj] doubleValue];
  
}



@end
