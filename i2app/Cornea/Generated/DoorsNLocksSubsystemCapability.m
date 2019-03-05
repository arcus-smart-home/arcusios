

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DoorsNLocksSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrDoorsNLocksSubsystemLockDevices=@"subdoorsnlocks:lockDevices";

NSString *const kAttrDoorsNLocksSubsystemMotorizedDoorDevices=@"subdoorsnlocks:motorizedDoorDevices";

NSString *const kAttrDoorsNLocksSubsystemContactSensorDevices=@"subdoorsnlocks:contactSensorDevices";

NSString *const kAttrDoorsNLocksSubsystemPetDoorDevices=@"subdoorsnlocks:petDoorDevices";

NSString *const kAttrDoorsNLocksSubsystemWarnings=@"subdoorsnlocks:warnings";

NSString *const kAttrDoorsNLocksSubsystemUnlockedLocks=@"subdoorsnlocks:unlockedLocks";

NSString *const kAttrDoorsNLocksSubsystemOfflineLocks=@"subdoorsnlocks:offlineLocks";

NSString *const kAttrDoorsNLocksSubsystemJammedLocks=@"subdoorsnlocks:jammedLocks";

NSString *const kAttrDoorsNLocksSubsystemOpenMotorizedDoors=@"subdoorsnlocks:openMotorizedDoors";

NSString *const kAttrDoorsNLocksSubsystemOfflineMotorizedDoors=@"subdoorsnlocks:offlineMotorizedDoors";

NSString *const kAttrDoorsNLocksSubsystemObstructedMotorizedDoors=@"subdoorsnlocks:obstructedMotorizedDoors";

NSString *const kAttrDoorsNLocksSubsystemOpenContactSensors=@"subdoorsnlocks:openContactSensors";

NSString *const kAttrDoorsNLocksSubsystemOfflineContactSensors=@"subdoorsnlocks:offlineContactSensors";

NSString *const kAttrDoorsNLocksSubsystemUnlockedPetDoors=@"subdoorsnlocks:unlockedPetDoors";

NSString *const kAttrDoorsNLocksSubsystemAutoPetDoors=@"subdoorsnlocks:autoPetDoors";

NSString *const kAttrDoorsNLocksSubsystemOfflinePetDoors=@"subdoorsnlocks:offlinePetDoors";

NSString *const kAttrDoorsNLocksSubsystemAllPeople=@"subdoorsnlocks:allPeople";

NSString *const kAttrDoorsNLocksSubsystemAuthorizationByLock=@"subdoorsnlocks:authorizationByLock";

NSString *const kAttrDoorsNLocksSubsystemChimeConfig=@"subdoorsnlocks:chimeConfig";


NSString *const kCmdDoorsNLocksSubsystemAuthorizePeople=@"subdoorsnlocks:AuthorizePeople";

NSString *const kCmdDoorsNLocksSubsystemSynchAuthorization=@"subdoorsnlocks:SynchAuthorization";


NSString *const kEvtDoorsNLocksSubsystemPersonAuthorized=@"subdoorsnlocks:PersonAuthorized";

NSString *const kEvtDoorsNLocksSubsystemPersonDeauthorized=@"subdoorsnlocks:PersonDeauthorized";

NSString *const kEvtDoorsNLocksSubsystemLockJammed=@"subdoorsnlocks:LockJammed";

NSString *const kEvtDoorsNLocksSubsystemLockUnjammed=@"subdoorsnlocks:LockUnjammed";

NSString *const kEvtDoorsNLocksSubsystemMotorizedDoorObstructed=@"subdoorsnlocks:MotorizedDoorObstructed";

NSString *const kEvtDoorsNLocksSubsystemMotorizedDoorUnobstructed=@"subdoorsnlocks:MotorizedDoorUnobstructed";



@implementation DoorsNLocksSubsystemCapability
+ (NSString *)namespace { return @"subdoorsnlocks"; }
+ (NSString *)name { return @"DoorsNLocksSubsystem"; }

+ (NSArray *)getLockDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getLockDevices:modelObj];
  
}


+ (NSArray *)getMotorizedDoorDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getMotorizedDoorDevices:modelObj];
  
}


+ (NSArray *)getContactSensorDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getContactSensorDevices:modelObj];
  
}


+ (NSArray *)getPetDoorDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getPetDoorDevices:modelObj];
  
}


+ (NSDictionary *)getWarningsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getWarnings:modelObj];
  
}


+ (NSArray *)getUnlockedLocksFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getUnlockedLocks:modelObj];
  
}


+ (NSArray *)getOfflineLocksFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getOfflineLocks:modelObj];
  
}


+ (NSArray *)getJammedLocksFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getJammedLocks:modelObj];
  
}


+ (NSArray *)getOpenMotorizedDoorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getOpenMotorizedDoors:modelObj];
  
}


+ (NSArray *)getOfflineMotorizedDoorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getOfflineMotorizedDoors:modelObj];
  
}


+ (NSArray *)getObstructedMotorizedDoorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getObstructedMotorizedDoors:modelObj];
  
}


+ (NSArray *)getOpenContactSensorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getOpenContactSensors:modelObj];
  
}


+ (NSArray *)getOfflineContactSensorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getOfflineContactSensors:modelObj];
  
}


+ (NSArray *)getUnlockedPetDoorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getUnlockedPetDoors:modelObj];
  
}


+ (NSArray *)getAutoPetDoorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getAutoPetDoors:modelObj];
  
}


+ (NSArray *)getOfflinePetDoorsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getOfflinePetDoors:modelObj];
  
}


+ (NSArray *)getAllPeopleFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getAllPeople:modelObj];
  
}


+ (NSDictionary *)getAuthorizationByLockFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getAuthorizationByLock:modelObj];
  
}


+ (NSArray *)getChimeConfigFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [DoorsNLocksSubsystemCapabilityLegacy getChimeConfig:modelObj];
  
}

+ (NSArray *)setChimeConfig:(NSArray *)chimeConfig onModel:(SubsystemModel *)modelObj {
  [DoorsNLocksSubsystemCapabilityLegacy setChimeConfig:chimeConfig model:modelObj];
  
  return [DoorsNLocksSubsystemCapabilityLegacy getChimeConfig:modelObj];
  
}




+ (PMKPromise *) authorizePeopleWithDevice:(NSString *)device withOperations:(NSArray *)operations onModel:(SubsystemModel *)modelObj {
  return [DoorsNLocksSubsystemCapabilityLegacy authorizePeople:modelObj device:device operations:operations];

}


+ (PMKPromise *) synchAuthorizationWithDevice:(NSString *)device onModel:(SubsystemModel *)modelObj {
  return [DoorsNLocksSubsystemCapabilityLegacy synchAuthorization:modelObj device:device];

}

@end
