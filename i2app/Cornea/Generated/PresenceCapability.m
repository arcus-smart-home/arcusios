

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PresenceCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPresencePresence=@"pres:presence";

NSString *const kAttrPresencePresencechanged=@"pres:presencechanged";

NSString *const kAttrPresencePerson=@"pres:person";

NSString *const kAttrPresenceUsehint=@"pres:usehint";



NSString *const kEnumPresencePresencePRESENT = @"PRESENT";
NSString *const kEnumPresencePresenceABSENT = @"ABSENT";
NSString *const kEnumPresenceUsehintUNKNOWN = @"UNKNOWN";
NSString *const kEnumPresenceUsehintPERSON = @"PERSON";
NSString *const kEnumPresenceUsehintOTHER = @"OTHER";


@implementation PresenceCapability
+ (NSString *)namespace { return @"pres"; }
+ (NSString *)name { return @"Presence"; }

+ (NSString *)getPresenceFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceCapabilityLegacy getPresence:modelObj];
  
}


+ (NSDate *)getPresencechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceCapabilityLegacy getPresencechanged:modelObj];
  
}


+ (NSString *)getPersonFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceCapabilityLegacy getPerson:modelObj];
  
}

+ (NSString *)setPerson:(NSString *)person onModel:(DeviceModel *)modelObj {
  [PresenceCapabilityLegacy setPerson:person model:modelObj];
  
  return [PresenceCapabilityLegacy getPerson:modelObj];
  
}


+ (NSString *)getUsehintFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceCapabilityLegacy getUsehint:modelObj];
  
}

+ (NSString *)setUsehint:(NSString *)usehint onModel:(DeviceModel *)modelObj {
  [PresenceCapabilityLegacy setUsehint:usehint model:modelObj];
  
  return [PresenceCapabilityLegacy getUsehint:modelObj];
  
}



@end
