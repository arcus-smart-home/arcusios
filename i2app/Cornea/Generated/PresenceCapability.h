

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the state of a presence device. */
extern NSString *const kAttrPresencePresence;

/** UTC date time of last presence change */
extern NSString *const kAttrPresencePresencechanged;

/** The address of the person currently associated with this presence detector */
extern NSString *const kAttrPresencePerson;

/** What this presence detector is used for.  PERSON detects presence/absence of a person, OTHER something else (pet for example), UNKNOWN is unassigned. */
extern NSString *const kAttrPresenceUsehint;



extern NSString *const kEnumPresencePresencePRESENT;
extern NSString *const kEnumPresencePresenceABSENT;
extern NSString *const kEnumPresenceUsehintUNKNOWN;
extern NSString *const kEnumPresenceUsehintPERSON;
extern NSString *const kEnumPresenceUsehintOTHER;


@interface PresenceCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getPresenceFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getPresencechangedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getPersonFromModel:(DeviceModel *)modelObj;

+ (NSString *)setPerson:(NSString *)person onModel:(DeviceModel *)modelObj;


+ (NSString *)getUsehintFromModel:(DeviceModel *)modelObj;

+ (NSString *)setUsehint:(NSString *)usehint onModel:(DeviceModel *)modelObj;





@end
