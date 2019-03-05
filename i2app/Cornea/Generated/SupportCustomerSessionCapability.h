

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SupportCustomerSessionModel;



/** The date the session was started */
extern NSString *const kAttrSupportCustomerSessionCreated;

/** The date the session was last updated */
extern NSString *const kAttrSupportCustomerSessionModified;

/** The date the session was closed */
extern NSString *const kAttrSupportCustomerSessionEnd;

/** The id of the agent */
extern NSString *const kAttrSupportCustomerSessionAgent;

/** The id of the account */
extern NSString *const kAttrSupportCustomerSessionAccount;

/** The id of the caller */
extern NSString *const kAttrSupportCustomerSessionCaller;

/** What started this session */
extern NSString *const kAttrSupportCustomerSessionOrigin;

/** The last known URL for the session. */
extern NSString *const kAttrSupportCustomerSessionUrl;

/** The current place in the session */
extern NSString *const kAttrSupportCustomerSessionPlace;

/** Notes taken by the agent during the session */
extern NSString *const kAttrSupportCustomerSessionNotes;


extern NSString *const kCmdSupportCustomerSessionStartSession;

extern NSString *const kCmdSupportCustomerSessionFindActiveSession;

extern NSString *const kCmdSupportCustomerSessionListSessions;

extern NSString *const kCmdSupportCustomerSessionCloseSession;




@interface SupportCustomerSessionCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getCreatedFromModel:(SupportCustomerSessionModel *)modelObj;


+ (NSDate *)getModifiedFromModel:(SupportCustomerSessionModel *)modelObj;


+ (NSDate *)getEndFromModel:(SupportCustomerSessionModel *)modelObj;


+ (NSString *)getAgentFromModel:(SupportCustomerSessionModel *)modelObj;


+ (NSString *)getAccountFromModel:(SupportCustomerSessionModel *)modelObj;


+ (NSString *)getCallerFromModel:(SupportCustomerSessionModel *)modelObj;


+ (NSString *)getOriginFromModel:(SupportCustomerSessionModel *)modelObj;


+ (NSString *)getUrlFromModel:(SupportCustomerSessionModel *)modelObj;

+ (NSString *)setUrl:(NSString *)url onModel:(Model *)modelObj;


+ (NSString *)getPlaceFromModel:(SupportCustomerSessionModel *)modelObj;

+ (NSString *)setPlace:(NSString *)place onModel:(Model *)modelObj;


+ (NSArray *)getNotesFromModel:(SupportCustomerSessionModel *)modelObj;

+ (NSArray *)setNotes:(NSArray *)notes onModel:(Model *)modelObj;





/** Create a support customer session */
+ (PMKPromise *) startSessionWithAgent:(NSString *)agent withAccount:(NSString *)account withCaller:(NSString *)caller withOrigin:(NSString *)origin onModel:(Model *)modelObj;



/** Find the active support customer session (if any) by account id and agent id */
+ (PMKPromise *) findActiveSessionWithAgent:(NSString *)agent withAccount:(NSString *)account onModel:(Model *)modelObj;



/** Find all support customer sessions for an account (active and closed) by account id */
+ (PMKPromise *) listSessionsWithAccount:(NSString *)account onModel:(Model *)modelObj;



/** Closes a session */
+ (PMKPromise *) closeSessionOnModel:(Model *)modelObj;



@end
