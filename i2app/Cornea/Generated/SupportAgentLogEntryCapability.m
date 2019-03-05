

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SupportAgentLogEntryCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSupportAgentLogEntryCreated=@"salogentry:created";

NSString *const kAttrSupportAgentLogEntryAgentId=@"salogentry:agentId";

NSString *const kAttrSupportAgentLogEntryAccountId=@"salogentry:accountId";

NSString *const kAttrSupportAgentLogEntryAction=@"salogentry:action";

NSString *const kAttrSupportAgentLogEntryParameters=@"salogentry:parameters";

NSString *const kAttrSupportAgentLogEntryUserId=@"salogentry:userId";

NSString *const kAttrSupportAgentLogEntryPlaceId=@"salogentry:placeId";

NSString *const kAttrSupportAgentLogEntryDeviceId=@"salogentry:deviceId";


NSString *const kCmdSupportAgentLogEntryCreateAgentLogEntry=@"salogentry:CreateAgentLogEntry";

NSString *const kCmdSupportAgentLogEntryListAgentLogEntries=@"salogentry:ListAgentLogEntries";




@implementation SupportAgentLogEntryCapability
+ (NSString *)namespace { return @"salogentry"; }
+ (NSString *)name { return @"SupportAgentLogEntry"; }

+ (NSDate *)getCreatedFromModel:(SupportAgentLogEntryModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentLogEntryCapabilityLegacy getCreated:modelObj];
  
}


+ (NSString *)getAgentIdFromModel:(SupportAgentLogEntryModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentLogEntryCapabilityLegacy getAgentId:modelObj];
  
}


+ (NSString *)getAccountIdFromModel:(SupportAgentLogEntryModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentLogEntryCapabilityLegacy getAccountId:modelObj];
  
}


+ (NSString *)getActionFromModel:(SupportAgentLogEntryModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentLogEntryCapabilityLegacy getAction:modelObj];
  
}


+ (NSArray *)getParametersFromModel:(SupportAgentLogEntryModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentLogEntryCapabilityLegacy getParameters:modelObj];
  
}


+ (NSString *)getUserIdFromModel:(SupportAgentLogEntryModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentLogEntryCapabilityLegacy getUserId:modelObj];
  
}


+ (NSString *)getPlaceIdFromModel:(SupportAgentLogEntryModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentLogEntryCapabilityLegacy getPlaceId:modelObj];
  
}


+ (NSString *)getDeviceIdFromModel:(SupportAgentLogEntryModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SupportAgentLogEntryCapabilityLegacy getDeviceId:modelObj];
  
}




+ (PMKPromise *) createAgentLogEntryWithAgentId:(NSString *)agentId withAccountId:(NSString *)accountId withAction:(NSString *)action withParameters:(NSArray *)parameters withUserId:(NSString *)userId withDeviceId:(NSString *)deviceId withPlaceId:(NSString *)placeId onModel:(SupportAgentLogEntryModel *)modelObj {
  return [SupportAgentLogEntryCapabilityLegacy createAgentLogEntry:modelObj agentId:agentId accountId:accountId action:action parameters:parameters userId:userId deviceId:deviceId placeId:placeId];

}


+ (PMKPromise *) listAgentLogEntriesWithAgentId:(NSString *)agentId withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate onModel:(SupportAgentLogEntryModel *)modelObj {
  return [SupportAgentLogEntryCapabilityLegacy listAgentLogEntries:modelObj agentId:agentId startDate:startDate endDate:endDate];

}

@end
