

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SupportCustomerSessionCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSupportCustomerSessionCreated=@"suppcustsession:created";

NSString *const kAttrSupportCustomerSessionModified=@"suppcustsession:modified";

NSString *const kAttrSupportCustomerSessionEnd=@"suppcustsession:end";

NSString *const kAttrSupportCustomerSessionAgent=@"suppcustsession:agent";

NSString *const kAttrSupportCustomerSessionAccount=@"suppcustsession:account";

NSString *const kAttrSupportCustomerSessionCaller=@"suppcustsession:caller";

NSString *const kAttrSupportCustomerSessionOrigin=@"suppcustsession:origin";

NSString *const kAttrSupportCustomerSessionUrl=@"suppcustsession:url";

NSString *const kAttrSupportCustomerSessionPlace=@"suppcustsession:place";

NSString *const kAttrSupportCustomerSessionNotes=@"suppcustsession:notes";


NSString *const kCmdSupportCustomerSessionStartSession=@"suppcustsession:StartSession";

NSString *const kCmdSupportCustomerSessionFindActiveSession=@"suppcustsession:FindActiveSession";

NSString *const kCmdSupportCustomerSessionListSessions=@"suppcustsession:ListSessions";

NSString *const kCmdSupportCustomerSessionCloseSession=@"suppcustsession:CloseSession";




@implementation SupportCustomerSessionCapability
+ (NSString *)namespace { return @"suppcustsession"; }
+ (NSString *)name { return @"SupportCustomerSession"; }

+ (NSDate *)getCreatedFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getCreated:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getModified:modelObj];
  
}


+ (NSDate *)getEndFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getEnd:modelObj];
  
}


+ (NSString *)getAgentFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getAgent:modelObj];
  
}


+ (NSString *)getAccountFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getAccount:modelObj];
  
}


+ (NSString *)getCallerFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getCaller:modelObj];
  
}


+ (NSString *)getOriginFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getOrigin:modelObj];
  
}


+ (NSString *)getUrlFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getUrl:modelObj];
  
}

+ (NSString *)setUrl:(NSString *)url onModel:(SupportCustomerSessionModel *)modelObj {
  [SupportCustomerSessionCapabilityLegacy setUrl:url model:modelObj];
  
  return [SupportCustomerSessionCapabilityLegacy getUrl:modelObj];
  
}


+ (NSString *)getPlaceFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getPlace:modelObj];
  
}

+ (NSString *)setPlace:(NSString *)place onModel:(SupportCustomerSessionModel *)modelObj {
  [SupportCustomerSessionCapabilityLegacy setPlace:place model:modelObj];
  
  return [SupportCustomerSessionCapabilityLegacy getPlace:modelObj];
  
}


+ (NSArray *)getNotesFromModel:(SupportCustomerSessionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportCustomerSessionCapabilityLegacy getNotes:modelObj];
  
}

+ (NSArray *)setNotes:(NSArray *)notes onModel:(SupportCustomerSessionModel *)modelObj {
  [SupportCustomerSessionCapabilityLegacy setNotes:notes model:modelObj];
  
  return [SupportCustomerSessionCapabilityLegacy getNotes:modelObj];
  
}




+ (PMKPromise *) startSessionWithAgent:(NSString *)agent withAccount:(NSString *)account withCaller:(NSString *)caller withOrigin:(NSString *)origin onModel:(SupportCustomerSessionModel *)modelObj {
  return [SupportCustomerSessionCapabilityLegacy startSession:modelObj agent:agent account:account caller:caller origin:origin];

}


+ (PMKPromise *) findActiveSessionWithAgent:(NSString *)agent withAccount:(NSString *)account onModel:(SupportCustomerSessionModel *)modelObj {
  return [SupportCustomerSessionCapabilityLegacy findActiveSession:modelObj agent:agent account:account];

}


+ (PMKPromise *) listSessionsWithAccount:(NSString *)account onModel:(SupportCustomerSessionModel *)modelObj {
  return [SupportCustomerSessionCapabilityLegacy listSessions:modelObj account:account];

}


+ (PMKPromise *) closeSessionOnModel:(SupportCustomerSessionModel *)modelObj {
  return [SupportCustomerSessionCapabilityLegacy closeSession:modelObj ];
}

@end
