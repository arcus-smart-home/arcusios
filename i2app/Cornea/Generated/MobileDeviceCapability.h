

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class MobileDeviceModel;



/** Platform-owned identifier of the person that owns this device. */
extern NSString *const kAttrMobileDevicePersonId;

/** Platform-owned index for the device that uniquely identifies it within the context of the person */
extern NSString *const kAttrMobileDeviceDeviceIndex;

/** Platform-owned timestamp of when it associated this mobile device with the person. */
extern NSString *const kAttrMobileDeviceAssociated;

/** The type of operating system the mobile device is running (iOS, Android for example). */
extern NSString *const kAttrMobileDeviceOsType;

/** The version of the operating system running on the mobile device. */
extern NSString *const kAttrMobileDeviceOsVersion;

/** The form factor of the device (phone, tablet for example). */
extern NSString *const kAttrMobileDeviceFormFactor;

/** The phone number of the device if present. */
extern NSString *const kAttrMobileDevicePhoneNumber;

/** The mobile device provided unique identifier */
extern NSString *const kAttrMobileDeviceDeviceIdentifier;

/** The model of the device if known. */
extern NSString *const kAttrMobileDeviceDeviceModel;

/** The vendor of the device if known. */
extern NSString *const kAttrMobileDeviceDeviceVendor;

/** The screen resolution of the device (ex. xhdpi) */
extern NSString *const kAttrMobileDeviceResolution;

/** The token for sending push notifications to this device if it is registered to do so. */
extern NSString *const kAttrMobileDeviceNotificationToken;

/** The last measured latitude if collected. */
extern NSString *const kAttrMobileDeviceLastLatitude;

/** The last measured longitude if collected. */
extern NSString *const kAttrMobileDeviceLastLongitude;

/** The timestamp that the latitude and longitude were last collected. */
extern NSString *const kAttrMobileDeviceLastLocationTime;

/** A friendly name for the device. */
extern NSString *const kAttrMobileDeviceName;

/** The version of the Arcus app installed on this device. */
extern NSString *const kAttrMobileDeviceAppVersion;





@interface MobileDeviceCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getPersonIdFromModel:(MobileDeviceModel *)modelObj;


+ (int)getDeviceIndexFromModel:(MobileDeviceModel *)modelObj;


+ (NSDate *)getAssociatedFromModel:(MobileDeviceModel *)modelObj;


+ (NSString *)getOsTypeFromModel:(MobileDeviceModel *)modelObj;


+ (NSString *)getOsVersionFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setOsVersion:(NSString *)osVersion onModel:(Model *)modelObj;


+ (NSString *)getFormFactorFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setFormFactor:(NSString *)formFactor onModel:(Model *)modelObj;


+ (NSString *)getPhoneNumberFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setPhoneNumber:(NSString *)phoneNumber onModel:(Model *)modelObj;


+ (NSString *)getDeviceIdentifierFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setDeviceIdentifier:(NSString *)deviceIdentifier onModel:(Model *)modelObj;


+ (NSString *)getDeviceModelFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setDeviceModel:(NSString *)deviceModel onModel:(Model *)modelObj;


+ (NSString *)getDeviceVendorFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setDeviceVendor:(NSString *)deviceVendor onModel:(Model *)modelObj;


+ (NSString *)getResolutionFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setResolution:(NSString *)resolution onModel:(Model *)modelObj;


+ (NSString *)getNotificationTokenFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setNotificationToken:(NSString *)notificationToken onModel:(Model *)modelObj;


+ (double)getLastLatitudeFromModel:(MobileDeviceModel *)modelObj;

+ (double)setLastLatitude:(double)lastLatitude onModel:(Model *)modelObj;


+ (double)getLastLongitudeFromModel:(MobileDeviceModel *)modelObj;

+ (double)setLastLongitude:(double)lastLongitude onModel:(Model *)modelObj;


+ (NSDate *)getLastLocationTimeFromModel:(MobileDeviceModel *)modelObj;


+ (NSString *)getNameFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setName:(NSString *)name onModel:(Model *)modelObj;


+ (NSString *)getAppVersionFromModel:(MobileDeviceModel *)modelObj;

+ (NSString *)setAppVersion:(NSString *)appVersion onModel:(Model *)modelObj;





@end
