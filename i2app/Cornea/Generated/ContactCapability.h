

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the state of the contact sensor (opened or closed). */
extern NSString *const kAttrContactContact;

/** UTC date time of last contact change */
extern NSString *const kAttrContactContactchanged;

/** How the device should be treated for display to the user.  UNKNOWN indicates this value hasn&#x27;t been set and the user should be queried for how it was installed.  Some devices, such as door hinges, may populate this with an initial value of DOOR or WINDOW, but most drivers will initialize it to UNKNOWN */
extern NSString *const kAttrContactUsehint;



extern NSString *const kEnumContactContactOPENED;
extern NSString *const kEnumContactContactCLOSED;
extern NSString *const kEnumContactUsehintDOOR;
extern NSString *const kEnumContactUsehintWINDOW;
extern NSString *const kEnumContactUsehintOTHER;
extern NSString *const kEnumContactUsehintUNKNOWN;


@interface ContactCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getContactFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getContactchangedFromModel:(DeviceModel *)modelObj;


+ (NSString *)getUsehintFromModel:(DeviceModel *)modelObj;

+ (NSString *)setUsehint:(NSString *)usehint onModel:(DeviceModel *)modelObj;





@end
