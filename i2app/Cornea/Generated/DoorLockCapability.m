

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DoorLockCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDoorLockLockstate=@"doorlock:lockstate";

NSString *const kAttrDoorLockType=@"doorlock:type";

NSString *const kAttrDoorLockSlots=@"doorlock:slots";

NSString *const kAttrDoorLockNumPinsSupported=@"doorlock:numPinsSupported";

NSString *const kAttrDoorLockSupportsInvalidPin=@"doorlock:supportsInvalidPin";

NSString *const kAttrDoorLockSupportsBuzzIn=@"doorlock:supportsBuzzIn";

NSString *const kAttrDoorLockLockstatechanged=@"doorlock:lockstatechanged";


NSString *const kCmdDoorLockAuthorizePerson=@"doorlock:AuthorizePerson";

NSString *const kCmdDoorLockDeauthorizePerson=@"doorlock:DeauthorizePerson";

NSString *const kCmdDoorLockBuzzIn=@"doorlock:BuzzIn";

NSString *const kCmdDoorLockClearAllPins=@"doorlock:ClearAllPins";


NSString *const kEvtDoorLockInvalidPin=@"doorlock:InvalidPin";

NSString *const kEvtDoorLockPinUsed=@"doorlock:PinUsed";

NSString *const kEvtDoorLockPinAddedAtLock=@"doorlock:PinAddedAtLock";

NSString *const kEvtDoorLockPinRemovedAtLock=@"doorlock:PinRemovedAtLock";

NSString *const kEvtDoorLockPinChangedAtLock=@"doorlock:PinChangedAtLock";

NSString *const kEvtDoorLockPersonAuthorized=@"doorlock:PersonAuthorized";

NSString *const kEvtDoorLockPersonDeauthorized=@"doorlock:PersonDeauthorized";

NSString *const kEvtDoorLockPinOperationFailed=@"doorlock:PinOperationFailed";

NSString *const kEvtDoorLockAllPinsCleared=@"doorlock:AllPinsCleared";

NSString *const kEvtDoorLockClearAllPinsFailed=@"doorlock:ClearAllPinsFailed";

NSString *const kEnumDoorLockLockstateLOCKED = @"LOCKED";
NSString *const kEnumDoorLockLockstateUNLOCKED = @"UNLOCKED";
NSString *const kEnumDoorLockLockstateLOCKING = @"LOCKING";
NSString *const kEnumDoorLockLockstateUNLOCKING = @"UNLOCKING";
NSString *const kEnumDoorLockTypeDEADBOLT = @"DEADBOLT";
NSString *const kEnumDoorLockTypeLEVERLOCK = @"LEVERLOCK";
NSString *const kEnumDoorLockTypeOTHER = @"OTHER";


@implementation DoorLockCapability
+ (NSString *)namespace { return @"doorlock"; }
+ (NSString *)name { return @"DoorLock"; }

+ (NSString *)getLockstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorLockCapabilityLegacy getLockstate:modelObj];
  
}

+ (NSString *)setLockstate:(NSString *)lockstate onModel:(DeviceModel *)modelObj {
  [DoorLockCapabilityLegacy setLockstate:lockstate model:modelObj];
  
  return [DoorLockCapabilityLegacy getLockstate:modelObj];
  
}


+ (NSString *)getTypeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorLockCapabilityLegacy getType:modelObj];
  
}


+ (NSDictionary *)getSlotsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorLockCapabilityLegacy getSlots:modelObj];
  
}


+ (int)getNumPinsSupportedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DoorLockCapabilityLegacy getNumPinsSupported:modelObj] intValue];
  
}


+ (BOOL)getSupportsInvalidPinFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DoorLockCapabilityLegacy getSupportsInvalidPin:modelObj] boolValue];
  
}


+ (BOOL)getSupportsBuzzInFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[DoorLockCapabilityLegacy getSupportsBuzzIn:modelObj] boolValue];
  
}


+ (NSDate *)getLockstatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorLockCapabilityLegacy getLockstatechanged:modelObj];
  
}




+ (PMKPromise *) authorizePersonWithPersonId:(NSString *)personId onModel:(DeviceModel *)modelObj {
  return [DoorLockCapabilityLegacy authorizePerson:modelObj personId:personId];

}


+ (PMKPromise *) deauthorizePersonWithPersonId:(NSString *)personId onModel:(DeviceModel *)modelObj {
  return [DoorLockCapabilityLegacy deauthorizePerson:modelObj personId:personId];

}


+ (PMKPromise *) buzzInOnModel:(DeviceModel *)modelObj {
  return [DoorLockCapabilityLegacy buzzIn:modelObj ];
}


+ (PMKPromise *) clearAllPinsOnModel:(DeviceModel *)modelObj {
  return [DoorLockCapabilityLegacy clearAllPins:modelObj ];
}

@end
