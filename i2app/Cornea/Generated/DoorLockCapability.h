

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;









/** Reflects the state of the lock mechanism. */
extern NSString *const kAttrDoorLockLockstate;

/** Reflects the type of door lock. */
extern NSString *const kAttrDoorLockType;

/** Reflects the mapping between slots and people */
extern NSString *const kAttrDoorLockSlots;

/** The number of pins that this device supports */
extern NSString *const kAttrDoorLockNumPinsSupported;

/** True if this driver will fire an event when an invalid pin is used */
extern NSString *const kAttrDoorLockSupportsInvalidPin;

/** Indicates whether or not the driver supports the BuzzIn method. */
extern NSString *const kAttrDoorLockSupportsBuzzIn;

/** UTC date time of last lockstate change */
extern NSString *const kAttrDoorLockLockstatechanged;


extern NSString *const kCmdDoorLockAuthorizePerson;

extern NSString *const kCmdDoorLockDeauthorizePerson;

extern NSString *const kCmdDoorLockBuzzIn;

extern NSString *const kCmdDoorLockClearAllPins;


extern NSString *const kEvtDoorLockInvalidPin;

extern NSString *const kEvtDoorLockPinUsed;

extern NSString *const kEvtDoorLockPinAddedAtLock;

extern NSString *const kEvtDoorLockPinRemovedAtLock;

extern NSString *const kEvtDoorLockPinChangedAtLock;

extern NSString *const kEvtDoorLockPersonAuthorized;

extern NSString *const kEvtDoorLockPersonDeauthorized;

extern NSString *const kEvtDoorLockPinOperationFailed;

extern NSString *const kEvtDoorLockAllPinsCleared;

extern NSString *const kEvtDoorLockClearAllPinsFailed;

extern NSString *const kEnumDoorLockLockstateLOCKED;
extern NSString *const kEnumDoorLockLockstateUNLOCKED;
extern NSString *const kEnumDoorLockLockstateLOCKING;
extern NSString *const kEnumDoorLockLockstateUNLOCKING;
extern NSString *const kEnumDoorLockTypeDEADBOLT;
extern NSString *const kEnumDoorLockTypeLEVERLOCK;
extern NSString *const kEnumDoorLockTypeOTHER;


@interface DoorLockCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getLockstateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setLockstate:(NSString *)lockstate onModel:(DeviceModel *)modelObj;


+ (NSString *)getTypeFromModel:(DeviceModel *)modelObj;


+ (NSDictionary *)getSlotsFromModel:(DeviceModel *)modelObj;


+ (int)getNumPinsSupportedFromModel:(DeviceModel *)modelObj;


+ (BOOL)getSupportsInvalidPinFromModel:(DeviceModel *)modelObj;


+ (BOOL)getSupportsBuzzInFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getLockstatechangedFromModel:(DeviceModel *)modelObj;





/** Authorizes a person on this lock by adding the person&#x27;s pin on the lock and returns the slot ID used */
+ (PMKPromise *) authorizePersonWithPersonId:(NSString *)personId onModel:(Model *)modelObj;



/** Remove the pin for the given user from the lock and sets the slot state to UNUSED */
+ (PMKPromise *) deauthorizePersonWithPersonId:(NSString *)personId onModel:(Model *)modelObj;



/** Temporarily unlock the lock if locked.  Automatically relock in 30 seconds. */
+ (PMKPromise *) buzzInOnModel:(Model *)modelObj;



/** Clear all the pins currently set in the lock. */
+ (PMKPromise *) clearAllPinsOnModel:(Model *)modelObj;



@end
