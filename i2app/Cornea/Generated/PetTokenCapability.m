

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PetTokenCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPetTokenTokenNum=@"pettoken:tokenNum";

NSString *const kAttrPetTokenTokenId=@"pettoken:tokenId";

NSString *const kAttrPetTokenPaired=@"pettoken:paired";

NSString *const kAttrPetTokenPetName=@"pettoken:petName";

NSString *const kAttrPetTokenLastAccessTime=@"pettoken:lastAccessTime";

NSString *const kAttrPetTokenLastAccessDirection=@"pettoken:lastAccessDirection";



NSString *const kEnumPetTokenLastAccessDirectionIN = @"IN";
NSString *const kEnumPetTokenLastAccessDirectionOUT = @"OUT";


@implementation PetTokenCapability
+ (NSString *)namespace { return @"pettoken"; }
+ (NSString *)name { return @"PetToken"; }

+ (int)getTokenNumFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PetTokenCapabilityLegacy getTokenNum:modelObj] intValue];
  
}


+ (int)getTokenIdFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PetTokenCapabilityLegacy getTokenId:modelObj] intValue];
  
}


+ (BOOL)getPairedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PetTokenCapabilityLegacy getPaired:modelObj] boolValue];
  
}


+ (NSString *)getPetNameFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PetTokenCapabilityLegacy getPetName:modelObj];
  
}

+ (NSString *)setPetName:(NSString *)petName onModel:(DeviceModel *)modelObj {
  [PetTokenCapabilityLegacy setPetName:petName model:modelObj];
  
  return [PetTokenCapabilityLegacy getPetName:modelObj];
  
}


+ (NSDate *)getLastAccessTimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PetTokenCapabilityLegacy getLastAccessTime:modelObj];
  
}


+ (NSString *)getLastAccessDirectionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PetTokenCapabilityLegacy getLastAccessDirection:modelObj];
  
}



@end
