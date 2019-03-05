

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Holds the index of the pet token up to 5. */
extern NSString *const kAttrPetTokenTokenNum;

/** Holds the ID of the access token assoctiated with the smart pet door. */
extern NSString *const kAttrPetTokenTokenId;

/** Is a token currently paired in this slot or not */
extern NSString *const kAttrPetTokenPaired;

/** The name of the pet identified by this token. */
extern NSString *const kAttrPetTokenPetName;

/** Holds the timestamp of the last time this token was used to access the smart pet door. */
extern NSString *const kAttrPetTokenLastAccessTime;

/** Identifies the direction of traffic, in or out, the last time the smart pet door was used by this pet. */
extern NSString *const kAttrPetTokenLastAccessDirection;



extern NSString *const kEnumPetTokenLastAccessDirectionIN;
extern NSString *const kEnumPetTokenLastAccessDirectionOUT;


@interface PetTokenCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getTokenNumFromModel:(DeviceModel *)modelObj;


+ (int)getTokenIdFromModel:(DeviceModel *)modelObj;


+ (BOOL)getPairedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getPetNameFromModel:(DeviceModel *)modelObj;

+ (NSString *)setPetName:(NSString *)petName onModel:(DeviceModel *)modelObj;


+ (NSDate *)getLastAccessTimeFromModel:(DeviceModel *)modelObj;


+ (NSString *)getLastAccessDirectionFromModel:(DeviceModel *)modelObj;





@end
