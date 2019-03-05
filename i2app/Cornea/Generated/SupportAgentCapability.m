

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SupportAgentCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSupportAgentCreated=@"supportagent:created";

NSString *const kAttrSupportAgentModified=@"supportagent:modified";

NSString *const kAttrSupportAgentState=@"supportagent:state";

NSString *const kAttrSupportAgentFirstName=@"supportagent:firstName";

NSString *const kAttrSupportAgentLastName=@"supportagent:lastName";

NSString *const kAttrSupportAgentEmail=@"supportagent:email";

NSString *const kAttrSupportAgentEmailVerified=@"supportagent:emailVerified";

NSString *const kAttrSupportAgentMobileNumber=@"supportagent:mobileNumber";

NSString *const kAttrSupportAgentMobileVerified=@"supportagent:mobileVerified";

NSString *const kAttrSupportAgentSupportTier=@"supportagent:supportTier";

NSString *const kAttrSupportAgentCurrLocation=@"supportagent:currLocation";

NSString *const kAttrSupportAgentCurrLocationTimeZone=@"supportagent:currLocationTimeZone";

NSString *const kAttrSupportAgentMobileNotificationEndpoints=@"supportagent:mobileNotificationEndpoints";

NSString *const kAttrSupportAgentPreferences=@"supportagent:preferences";

NSString *const kAttrSupportAgentNumFailedAttempts=@"supportagent:numFailedAttempts";

NSString *const kAttrSupportAgentLastFailedLoginTs=@"supportagent:lastFailedLoginTs";

NSString *const kAttrSupportAgentLocked=@"supportagent:locked";


NSString *const kCmdSupportAgentListAgents=@"supportagent:ListAgents";

NSString *const kCmdSupportAgentCreateSupportAgent=@"supportagent:CreateSupportAgent";

NSString *const kCmdSupportAgentFindAgentById=@"supportagent:FindAgentById";

NSString *const kCmdSupportAgentFindAgentByEmail=@"supportagent:FindAgentByEmail";

NSString *const kCmdSupportAgentDeleteAgent=@"supportagent:DeleteAgent";

NSString *const kCmdSupportAgentLockAgent=@"supportagent:LockAgent";

NSString *const kCmdSupportAgentUnlockAgent=@"supportagent:UnlockAgent";

NSString *const kCmdSupportAgentResetAgentPassword=@"supportagent:ResetAgentPassword";

NSString *const kCmdSupportAgentEditPreferences=@"supportagent:EditPreferences";




@implementation SupportAgentCapability
+ (NSString *)namespace { return @"supportagent"; }
+ (NSString *)name { return @"SupportAgent"; }

+ (NSDate *)getCreatedFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getCreated:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getModified:modelObj];
  
}

+ (NSDate *)setModified:(double)modified onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setModified:modified model:modelObj];
  
  return [SupportAgentCapabilityLegacy getModified:modelObj];
  
}


+ (NSString *)getStateFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getState:modelObj];
  
}

+ (NSString *)setState:(NSString *)state onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setState:state model:modelObj];
  
  return [SupportAgentCapabilityLegacy getState:modelObj];
  
}


+ (NSString *)getFirstNameFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getFirstName:modelObj];
  
}

+ (NSString *)setFirstName:(NSString *)firstName onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setFirstName:firstName model:modelObj];
  
  return [SupportAgentCapabilityLegacy getFirstName:modelObj];
  
}


+ (NSString *)getLastNameFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getLastName:modelObj];
  
}

+ (NSString *)setLastName:(NSString *)lastName onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setLastName:lastName model:modelObj];
  
  return [SupportAgentCapabilityLegacy getLastName:modelObj];
  
}


+ (NSString *)getEmailFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getEmail:modelObj];
  
}

+ (NSString *)setEmail:(NSString *)email onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setEmail:email model:modelObj];
  
  return [SupportAgentCapabilityLegacy getEmail:modelObj];
  
}


+ (NSDate *)getEmailVerifiedFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getEmailVerified:modelObj];
  
}

+ (NSDate *)setEmailVerified:(double)emailVerified onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setEmailVerified:emailVerified model:modelObj];
  
  return [SupportAgentCapabilityLegacy getEmailVerified:modelObj];
  
}


+ (NSString *)getMobileNumberFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getMobileNumber:modelObj];
  
}

+ (NSString *)setMobileNumber:(NSString *)mobileNumber onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setMobileNumber:mobileNumber model:modelObj];
  
  return [SupportAgentCapabilityLegacy getMobileNumber:modelObj];
  
}


+ (NSDate *)getMobileVerifiedFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getMobileVerified:modelObj];
  
}

+ (NSDate *)setMobileVerified:(double)mobileVerified onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setMobileVerified:mobileVerified model:modelObj];
  
  return [SupportAgentCapabilityLegacy getMobileVerified:modelObj];
  
}


+ (NSString *)getSupportTierFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getSupportTier:modelObj];
  
}

+ (NSString *)setSupportTier:(NSString *)supportTier onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setSupportTier:supportTier model:modelObj];
  
  return [SupportAgentCapabilityLegacy getSupportTier:modelObj];
  
}


+ (NSString *)getCurrLocationFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getCurrLocation:modelObj];
  
}

+ (NSString *)setCurrLocation:(NSString *)currLocation onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setCurrLocation:currLocation model:modelObj];
  
  return [SupportAgentCapabilityLegacy getCurrLocation:modelObj];
  
}


+ (NSString *)getCurrLocationTimeZoneFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getCurrLocationTimeZone:modelObj];
  
}

+ (NSString *)setCurrLocationTimeZone:(NSString *)currLocationTimeZone onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setCurrLocationTimeZone:currLocationTimeZone model:modelObj];
  
  return [SupportAgentCapabilityLegacy getCurrLocationTimeZone:modelObj];
  
}


+ (NSArray *)getMobileNotificationEndpointsFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getMobileNotificationEndpoints:modelObj];
  
}

+ (NSArray *)setMobileNotificationEndpoints:(NSArray *)mobileNotificationEndpoints onModel:(SupportAgentModel *)modelObj {
  [SupportAgentCapabilityLegacy setMobileNotificationEndpoints:mobileNotificationEndpoints model:modelObj];
  
  return [SupportAgentCapabilityLegacy getMobileNotificationEndpoints:modelObj];
  
}


+ (NSDictionary *)getPreferencesFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getPreferences:modelObj];
  
}


+ (int)getNumFailedAttemptsFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SupportAgentCapabilityLegacy getNumFailedAttempts:modelObj] intValue];
  
}


+ (NSDate *)getLastFailedLoginTsFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentCapabilityLegacy getLastFailedLoginTs:modelObj];
  
}


+ (BOOL)getLockedFromModel:(SupportAgentModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SupportAgentCapabilityLegacy getLocked:modelObj] boolValue];
  
}




+ (PMKPromise *) listAgentsOnModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy listAgents:modelObj ];
}


+ (PMKPromise *) createSupportAgentWithEmail:(NSString *)email withFirstName:(NSString *)firstName withLastName:(NSString *)lastName withSupportTier:(NSString *)supportTier withPassword:(NSString *)password withMobileNumber:(NSString *)mobileNumber withCurrLocation:(NSString *)currLocation withCurrLocationTimeZone:(NSString *)currLocationTimeZone onModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy createSupportAgent:modelObj email:email firstName:firstName lastName:lastName supportTier:supportTier password:password mobileNumber:mobileNumber currLocation:currLocation currLocationTimeZone:currLocationTimeZone];

}


+ (PMKPromise *) findAgentByIdOnModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy findAgentById:modelObj ];
}


+ (PMKPromise *) findAgentByEmailWithEmail:(NSString *)email onModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy findAgentByEmail:modelObj email:email];

}


+ (PMKPromise *) deleteAgentOnModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy deleteAgent:modelObj ];
}


+ (PMKPromise *) lockAgentOnModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy lockAgent:modelObj ];
}


+ (PMKPromise *) unlockAgentOnModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy unlockAgent:modelObj ];
}


+ (PMKPromise *) resetAgentPasswordWithEmail:(NSString *)email withNewPassword:(NSString *)newPassword onModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy resetAgentPassword:modelObj email:email newPassword:newPassword];

}


+ (PMKPromise *) editPreferencesWithEmail:(NSString *)email withPrefValues:(NSDictionary *)prefValues onModel:(SupportAgentModel *)modelObj {
  return [SupportAgentCapabilityLegacy editPreferences:modelObj email:email prefValues:prefValues];

}

@end
