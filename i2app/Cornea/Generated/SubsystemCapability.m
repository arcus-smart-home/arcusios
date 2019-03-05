

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSubsystemName=@"subs:name";

NSString *const kAttrSubsystemVersion=@"subs:version";

NSString *const kAttrSubsystemHash=@"subs:hash";

NSString *const kAttrSubsystemAccount=@"subs:account";

NSString *const kAttrSubsystemPlace=@"subs:place";

NSString *const kAttrSubsystemAvailable=@"subs:available";

NSString *const kAttrSubsystemState=@"subs:state";


NSString *const kCmdSubsystemActivate=@"subs:Activate";

NSString *const kCmdSubsystemSuspend=@"subs:Suspend";

NSString *const kCmdSubsystemDelete=@"subs:Delete";

NSString *const kCmdSubsystemListHistoryEntries=@"subs:ListHistoryEntries";


NSString *const kEnumSubsystemStateACTIVE = @"ACTIVE";
NSString *const kEnumSubsystemStateSUSPENDED = @"SUSPENDED";


@implementation SubsystemCapability
+ (NSString *)namespace { return @"subs"; }
+ (NSString *)name { return @"Subsystem"; }

+ (NSString *)getNameFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SubsystemCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getVersionFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SubsystemCapabilityLegacy getVersion:modelObj];
  
}


+ (NSString *)getHashFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SubsystemCapabilityLegacy getHash:modelObj];
  
}


+ (NSString *)getAccountFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SubsystemCapabilityLegacy getAccount:modelObj];
  
}


+ (NSString *)getPlaceFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SubsystemCapabilityLegacy getPlace:modelObj];
  
}


+ (BOOL)getAvailableFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SubsystemCapabilityLegacy getAvailable:modelObj] boolValue];
  
}


+ (NSString *)getStateFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SubsystemCapabilityLegacy getState:modelObj];
  
}




+ (PMKPromise *) activateOnModel:(SubsystemModel *)modelObj {
  return [SubsystemCapabilityLegacy activate:modelObj ];
}


+ (PMKPromise *) suspendOnModel:(SubsystemModel *)modelObj {
  return [SubsystemCapabilityLegacy suspend:modelObj ];
}


+ (PMKPromise *) deleteOnModel:(SubsystemModel *)modelObj {
  return [SubsystemCapabilityLegacy delete:modelObj ];
}


+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token withIncludeIncidents:(BOOL)includeIncidents onModel:(SubsystemModel *)modelObj {
  return [SubsystemCapabilityLegacy listHistoryEntries:modelObj limit:limit token:token includeIncidents:includeIncidents];

}

@end
