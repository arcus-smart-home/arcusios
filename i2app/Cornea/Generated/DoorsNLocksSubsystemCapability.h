

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;





/** The addresses of door locks defined at this place */
extern NSString *const kAttrDoorsNLocksSubsystemLockDevices;

/** The addresses of motorized doors defined at this place */
extern NSString *const kAttrDoorsNLocksSubsystemMotorizedDoorDevices;

/** The addresses of contact sensors defined at this place */
extern NSString *const kAttrDoorsNLocksSubsystemContactSensorDevices;

/** The addresses of pet doors defined at this place */
extern NSString *const kAttrDoorsNLocksSubsystemPetDoorDevices;

/** A set of warnings about devices which have potential issues that could cause an alarm to be missed.  The key is the address of the device with a warning and the value is an I18N code with the description of the problem. */
extern NSString *const kAttrDoorsNLocksSubsystemWarnings;

/** The addresses of door locks that are currently unlocked */
extern NSString *const kAttrDoorsNLocksSubsystemUnlockedLocks;

/** The addresses of door locks that are currently offline */
extern NSString *const kAttrDoorsNLocksSubsystemOfflineLocks;

/** The addresses of door locks that are currently jammed */
extern NSString *const kAttrDoorsNLocksSubsystemJammedLocks;

/** The addresses of motorized doors that are currently open */
extern NSString *const kAttrDoorsNLocksSubsystemOpenMotorizedDoors;

/** The addresses of motorized doors that are currently offline */
extern NSString *const kAttrDoorsNLocksSubsystemOfflineMotorizedDoors;

/** The addresses of motorized doors that are currently obstructed */
extern NSString *const kAttrDoorsNLocksSubsystemObstructedMotorizedDoors;

/** The addressees of currently open contact sensors */
extern NSString *const kAttrDoorsNLocksSubsystemOpenContactSensors;

/** The addresses of currently offline contact sensors */
extern NSString *const kAttrDoorsNLocksSubsystemOfflineContactSensors;

/** The addresses of currently locked pet doors */
extern NSString *const kAttrDoorsNLocksSubsystemUnlockedPetDoors;

/** The addresses of pet doors in auto mode */
extern NSString *const kAttrDoorsNLocksSubsystemAutoPetDoors;

/** The addresses of offline pet doors */
extern NSString *const kAttrDoorsNLocksSubsystemOfflinePetDoors;

/** The set of all people at the place that could be assigned to a lock (those with access and a pin) */
extern NSString *const kAttrDoorsNLocksSubsystemAllPeople;

/** A between a door lock and the people that currently have access to that lock */
extern NSString *const kAttrDoorsNLocksSubsystemAuthorizationByLock;

/** The set of all that could have a chiming enabled/disabled. */
extern NSString *const kAttrDoorsNLocksSubsystemChimeConfig;


extern NSString *const kCmdDoorsNLocksSubsystemAuthorizePeople;

extern NSString *const kCmdDoorsNLocksSubsystemSynchAuthorization;


extern NSString *const kEvtDoorsNLocksSubsystemPersonAuthorized;

extern NSString *const kEvtDoorsNLocksSubsystemPersonDeauthorized;

extern NSString *const kEvtDoorsNLocksSubsystemLockJammed;

extern NSString *const kEvtDoorsNLocksSubsystemLockUnjammed;

extern NSString *const kEvtDoorsNLocksSubsystemMotorizedDoorObstructed;

extern NSString *const kEvtDoorsNLocksSubsystemMotorizedDoorUnobstructed;



@interface DoorsNLocksSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getLockDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getMotorizedDoorDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getContactSensorDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getPetDoorDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getWarningsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getUnlockedLocksFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getOfflineLocksFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getJammedLocksFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getOpenMotorizedDoorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getOfflineMotorizedDoorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getObstructedMotorizedDoorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getOpenContactSensorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getOfflineContactSensorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getUnlockedPetDoorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getAutoPetDoorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getOfflinePetDoorsFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getAllPeopleFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getAuthorizationByLockFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getChimeConfigFromModel:(SubsystemModel *)modelObj;

+ (NSArray *)setChimeConfig:(NSArray *)chimeConfig onModel:(SubsystemModel *)modelObj;





/** Authorizes the given people on the lock.  Any people that previously existed on the lock not in this set will be deauthorized */
+ (PMKPromise *) authorizePeopleWithDevice:(NSString *)device withOperations:(NSArray *)operations onModel:(Model *)modelObj;



/** Synchronizes the access on the device and the service, by clearing all pins and reassociating people that should have access */
+ (PMKPromise *) synchAuthorizationWithDevice:(NSString *)device onModel:(Model *)modelObj;



@end
