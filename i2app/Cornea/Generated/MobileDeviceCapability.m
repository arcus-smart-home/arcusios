

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "MobileDeviceCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrMobileDevicePersonId=@"mobiledevice:personId";

NSString *const kAttrMobileDeviceDeviceIndex=@"mobiledevice:deviceIndex";

NSString *const kAttrMobileDeviceAssociated=@"mobiledevice:associated";

NSString *const kAttrMobileDeviceOsType=@"mobiledevice:osType";

NSString *const kAttrMobileDeviceOsVersion=@"mobiledevice:osVersion";

NSString *const kAttrMobileDeviceFormFactor=@"mobiledevice:formFactor";

NSString *const kAttrMobileDevicePhoneNumber=@"mobiledevice:phoneNumber";

NSString *const kAttrMobileDeviceDeviceIdentifier=@"mobiledevice:deviceIdentifier";

NSString *const kAttrMobileDeviceDeviceModel=@"mobiledevice:deviceModel";

NSString *const kAttrMobileDeviceDeviceVendor=@"mobiledevice:deviceVendor";

NSString *const kAttrMobileDeviceResolution=@"mobiledevice:resolution";

NSString *const kAttrMobileDeviceNotificationToken=@"mobiledevice:notificationToken";

NSString *const kAttrMobileDeviceLastLatitude=@"mobiledevice:lastLatitude";

NSString *const kAttrMobileDeviceLastLongitude=@"mobiledevice:lastLongitude";

NSString *const kAttrMobileDeviceLastLocationTime=@"mobiledevice:lastLocationTime";

NSString *const kAttrMobileDeviceName=@"mobiledevice:name";

NSString *const kAttrMobileDeviceAppVersion=@"mobiledevice:appVersion";





@implementation MobileDeviceCapability
+ (NSString *)namespace { return @"mobiledevice"; }
+ (NSString *)name { return @"MobileDevice"; }

+ (NSString *)getPersonIdFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getPersonId:modelObj];
  
}


+ (int)getDeviceIndexFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[MobileDeviceCapabilityLegacy getDeviceIndex:modelObj] intValue];
  
}


+ (NSDate *)getAssociatedFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getAssociated:modelObj];
  
}


+ (NSString *)getOsTypeFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getOsType:modelObj];
  
}


+ (NSString *)getOsVersionFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getOsVersion:modelObj];
  
}

+ (NSString *)setOsVersion:(NSString *)osVersion onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setOsVersion:osVersion model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getOsVersion:modelObj];
  
}


+ (NSString *)getFormFactorFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getFormFactor:modelObj];
  
}

+ (NSString *)setFormFactor:(NSString *)formFactor onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setFormFactor:formFactor model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getFormFactor:modelObj];
  
}


+ (NSString *)getPhoneNumberFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getPhoneNumber:modelObj];
  
}

+ (NSString *)setPhoneNumber:(NSString *)phoneNumber onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setPhoneNumber:phoneNumber model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getPhoneNumber:modelObj];
  
}


+ (NSString *)getDeviceIdentifierFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getDeviceIdentifier:modelObj];
  
}

+ (NSString *)setDeviceIdentifier:(NSString *)deviceIdentifier onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setDeviceIdentifier:deviceIdentifier model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getDeviceIdentifier:modelObj];
  
}


+ (NSString *)getDeviceModelFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getDeviceModel:modelObj];
  
}

+ (NSString *)setDeviceModel:(NSString *)deviceModel onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setDeviceModel:deviceModel model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getDeviceModel:modelObj];
  
}


+ (NSString *)getDeviceVendorFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getDeviceVendor:modelObj];
  
}

+ (NSString *)setDeviceVendor:(NSString *)deviceVendor onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setDeviceVendor:deviceVendor model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getDeviceVendor:modelObj];
  
}


+ (NSString *)getResolutionFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getResolution:modelObj];
  
}

+ (NSString *)setResolution:(NSString *)resolution onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setResolution:resolution model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getResolution:modelObj];
  
}


+ (NSString *)getNotificationTokenFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getNotificationToken:modelObj];
  
}

+ (NSString *)setNotificationToken:(NSString *)notificationToken onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setNotificationToken:notificationToken model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getNotificationToken:modelObj];
  
}


+ (double)getLastLatitudeFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[MobileDeviceCapabilityLegacy getLastLatitude:modelObj] doubleValue];
  
}

+ (double)setLastLatitude:(double)lastLatitude onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setLastLatitude:lastLatitude model:modelObj];
  
  return [[MobileDeviceCapabilityLegacy getLastLatitude:modelObj] doubleValue];
  
}


+ (double)getLastLongitudeFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[MobileDeviceCapabilityLegacy getLastLongitude:modelObj] doubleValue];
  
}

+ (double)setLastLongitude:(double)lastLongitude onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setLastLongitude:lastLongitude model:modelObj];
  
  return [[MobileDeviceCapabilityLegacy getLastLongitude:modelObj] doubleValue];
  
}


+ (NSDate *)getLastLocationTimeFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getLastLocationTime:modelObj];
  
}


+ (NSString *)getNameFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getName:modelObj];
  
}

+ (NSString *)setName:(NSString *)name onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setName:name model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getAppVersionFromModel:(MobileDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [MobileDeviceCapabilityLegacy getAppVersion:modelObj];
  
}

+ (NSString *)setAppVersion:(NSString *)appVersion onModel:(MobileDeviceModel *)modelObj {
  [MobileDeviceCapabilityLegacy setAppVersion:appVersion model:modelObj];
  
  return [MobileDeviceCapabilityLegacy getAppVersion:modelObj];
  
}



@end
