

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ContactCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrContactContact=@"cont:contact";

NSString *const kAttrContactContactchanged=@"cont:contactchanged";

NSString *const kAttrContactUsehint=@"cont:usehint";



NSString *const kEnumContactContactOPENED = @"OPENED";
NSString *const kEnumContactContactCLOSED = @"CLOSED";
NSString *const kEnumContactUsehintDOOR = @"DOOR";
NSString *const kEnumContactUsehintWINDOW = @"WINDOW";
NSString *const kEnumContactUsehintOTHER = @"OTHER";
NSString *const kEnumContactUsehintUNKNOWN = @"UNKNOWN";


@implementation ContactCapability
+ (NSString *)namespace { return @"cont"; }
+ (NSString *)name { return @"Contact"; }

+ (NSString *)getContactFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ContactCapabilityLegacy getContact:modelObj];
  
}


+ (NSDate *)getContactchangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ContactCapabilityLegacy getContactchanged:modelObj];
  
}


+ (NSString *)getUsehintFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ContactCapabilityLegacy getUsehint:modelObj];
  
}

+ (NSString *)setUsehint:(NSString *)usehint onModel:(DeviceModel *)modelObj {
  [ContactCapabilityLegacy setUsehint:usehint model:modelObj];
  
  return [ContactCapabilityLegacy getUsehint:modelObj];
  
}



@end
