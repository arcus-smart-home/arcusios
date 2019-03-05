

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SupportAgentLogEntryModel;





/** The date the entry was created */
extern NSString *const kAttrSupportAgentLogEntryCreated;

/** Id of the agent */
extern NSString *const kAttrSupportAgentLogEntryAgentId;

/** Account id in the log entry */
extern NSString *const kAttrSupportAgentLogEntryAccountId;

/** The action that happened */
extern NSString *const kAttrSupportAgentLogEntryAction;

/** The parameters used in the action */
extern NSString *const kAttrSupportAgentLogEntryParameters;

/** Id of the user this log is associated with (if any) */
extern NSString *const kAttrSupportAgentLogEntryUserId;

/** The place id in the log entry, if any */
extern NSString *const kAttrSupportAgentLogEntryPlaceId;

/** The device id in the log entry, if any */
extern NSString *const kAttrSupportAgentLogEntryDeviceId;


extern NSString *const kCmdSupportAgentLogEntryCreateAgentLogEntry;

extern NSString *const kCmdSupportAgentLogEntryListAgentLogEntries;




@interface SupportAgentLogEntryCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getCreatedFromModel:(SupportAgentLogEntryModel *)modelObj;


+ (NSString *)getAgentIdFromModel:(SupportAgentLogEntryModel *)modelObj;


+ (NSString *)getAccountIdFromModel:(SupportAgentLogEntryModel *)modelObj;


+ (NSString *)getActionFromModel:(SupportAgentLogEntryModel *)modelObj;


+ (NSArray *)getParametersFromModel:(SupportAgentLogEntryModel *)modelObj;


+ (NSString *)getUserIdFromModel:(SupportAgentLogEntryModel *)modelObj;


+ (NSString *)getPlaceIdFromModel:(SupportAgentLogEntryModel *)modelObj;


+ (NSString *)getDeviceIdFromModel:(SupportAgentLogEntryModel *)modelObj;





/** Log something an agent did */
+ (PMKPromise *) createAgentLogEntryWithAgentId:(NSString *)agentId withAccountId:(NSString *)accountId withAction:(NSString *)action withParameters:(NSArray *)parameters withUserId:(NSString *)userId withDeviceId:(NSString *)deviceId withPlaceId:(NSString *)placeId onModel:(Model *)modelObj;



/** Lists audit logs within a time range */
+ (PMKPromise *) listAgentLogEntriesWithAgentId:(NSString *)agentId withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate onModel:(Model *)modelObj;



@end
