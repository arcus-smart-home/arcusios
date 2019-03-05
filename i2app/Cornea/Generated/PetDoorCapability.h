

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;





/** Lock state of the door, to override the doorlock lockstate. */
extern NSString *const kAttrPetDoorLockstate;

/** UTC date time of last lockstate change */
extern NSString *const kAttrPetDoorLastlockstatechangedtime;

/** Holds the timestamp of the last time access through the smart pet door. */
extern NSString *const kAttrPetDoorLastaccesstime;

/** Direction a pet last passed through the smart pet door. */
extern NSString *const kAttrPetDoorDirection;

/** The number (5) of RFID tags this device supports. */
extern NSString *const kAttrPetDoorNumPetTokensSupported;


extern NSString *const kCmdPetDoorRemoveToken;


extern NSString *const kEvtPetDoorTokenAdded;

extern NSString *const kEvtPetDoorTokenRemoved;

extern NSString *const kEvtPetDoorTokenUsed;

extern NSString *const kEnumPetDoorLockstateLOCKED;
extern NSString *const kEnumPetDoorLockstateUNLOCKED;
extern NSString *const kEnumPetDoorLockstateAUTO;
extern NSString *const kEnumPetDoorDirectionIN;
extern NSString *const kEnumPetDoorDirectionOUT;


@interface PetDoorCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getLockstateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setLockstate:(NSString *)lockstate onModel:(DeviceModel *)modelObj;


+ (NSDate *)getLastlockstatechangedtimeFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getLastaccesstimeFromModel:(DeviceModel *)modelObj;


+ (NSString *)getDirectionFromModel:(DeviceModel *)modelObj;


+ (int)getNumPetTokensSupportedFromModel:(DeviceModel *)modelObj;





/** Remove a pet token from the pet door to prevent further access. */
+ (PMKPromise *) removeTokenWithTokenId:(int)tokenId onModel:(Model *)modelObj;



@end
