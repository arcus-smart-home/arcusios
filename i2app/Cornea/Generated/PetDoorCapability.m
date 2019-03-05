

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PetDoorCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPetDoorLockstate=@"petdoor:lockstate";

NSString *const kAttrPetDoorLastlockstatechangedtime=@"petdoor:lastlockstatechangedtime";

NSString *const kAttrPetDoorLastaccesstime=@"petdoor:lastaccesstime";

NSString *const kAttrPetDoorDirection=@"petdoor:direction";

NSString *const kAttrPetDoorNumPetTokensSupported=@"petdoor:numPetTokensSupported";


NSString *const kCmdPetDoorRemoveToken=@"petdoor:RemoveToken";


NSString *const kEvtPetDoorTokenAdded=@"petdoor:TokenAdded";

NSString *const kEvtPetDoorTokenRemoved=@"petdoor:TokenRemoved";

NSString *const kEvtPetDoorTokenUsed=@"petdoor:TokenUsed";

NSString *const kEnumPetDoorLockstateLOCKED = @"LOCKED";
NSString *const kEnumPetDoorLockstateUNLOCKED = @"UNLOCKED";
NSString *const kEnumPetDoorLockstateAUTO = @"AUTO";
NSString *const kEnumPetDoorDirectionIN = @"IN";
NSString *const kEnumPetDoorDirectionOUT = @"OUT";


@implementation PetDoorCapability
+ (NSString *)namespace { return @"petdoor"; }
+ (NSString *)name { return @"PetDoor"; }

+ (NSString *)getLockstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PetDoorCapabilityLegacy getLockstate:modelObj];
  
}

+ (NSString *)setLockstate:(NSString *)lockstate onModel:(DeviceModel *)modelObj {
  [PetDoorCapabilityLegacy setLockstate:lockstate model:modelObj];
  
  return [PetDoorCapabilityLegacy getLockstate:modelObj];
  
}


+ (NSDate *)getLastlockstatechangedtimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PetDoorCapabilityLegacy getLastlockstatechangedtime:modelObj];
  
}


+ (NSDate *)getLastaccesstimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PetDoorCapabilityLegacy getLastaccesstime:modelObj];
  
}


+ (NSString *)getDirectionFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PetDoorCapabilityLegacy getDirection:modelObj];
  
}


+ (int)getNumPetTokensSupportedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PetDoorCapabilityLegacy getNumPetTokensSupported:modelObj] intValue];
  
}




+ (PMKPromise *) removeTokenWithTokenId:(int)tokenId onModel:(DeviceModel *)modelObj {
  return [PetDoorCapabilityLegacy removeToken:modelObj tokenId:tokenId];

}

@end
