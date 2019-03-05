

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SupportAgentModel;





/** The date the agent was created */
extern NSString *const kAttrSupportAgentCreated;

/** The date the agent was last modified */
extern NSString *const kAttrSupportAgentModified;

/** The state of the agent */
extern NSString *const kAttrSupportAgentState;

/** First name of the agent */
extern NSString *const kAttrSupportAgentFirstName;

/** Last name of the agent */
extern NSString *const kAttrSupportAgentLastName;

/** The email address for the agent */
extern NSString *const kAttrSupportAgentEmail;

/** The date the email was verified */
extern NSString *const kAttrSupportAgentEmailVerified;

/** The mobile phone number for the agent */
extern NSString *const kAttrSupportAgentMobileNumber;

/** The date the mobile phone number was verified */
extern NSString *const kAttrSupportAgentMobileVerified;

/** The support tier for the agent */
extern NSString *const kAttrSupportAgentSupportTier;

/** The support center the agent belongs to */
extern NSString *const kAttrSupportAgentCurrLocation;

/** The time zone the support center is located in */
extern NSString *const kAttrSupportAgentCurrLocationTimeZone;

/** The list of mobile endpoints where notifications may be sent */
extern NSString *const kAttrSupportAgentMobileNotificationEndpoints;

/** maps preferences by name to value  */
extern NSString *const kAttrSupportAgentPreferences;

/** The number of consecutive failed login attempts. Zero after agent is unlocked. Cannot be changed by setattributes */
extern NSString *const kAttrSupportAgentNumFailedAttempts;

/** The date the agent last had a failed login. Null after agent is unlocked. Cannot be changed by setattributes */
extern NSString *const kAttrSupportAgentLastFailedLoginTs;

/** True if the agent is locked out from logging in. False after agent is unlocked. Cannot be changed by setattributes */
extern NSString *const kAttrSupportAgentLocked;


extern NSString *const kCmdSupportAgentListAgents;

extern NSString *const kCmdSupportAgentCreateSupportAgent;

extern NSString *const kCmdSupportAgentFindAgentById;

extern NSString *const kCmdSupportAgentFindAgentByEmail;

extern NSString *const kCmdSupportAgentDeleteAgent;

extern NSString *const kCmdSupportAgentLockAgent;

extern NSString *const kCmdSupportAgentUnlockAgent;

extern NSString *const kCmdSupportAgentResetAgentPassword;

extern NSString *const kCmdSupportAgentEditPreferences;




@interface SupportAgentCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getCreatedFromModel:(SupportAgentModel *)modelObj;


+ (NSDate *)getModifiedFromModel:(SupportAgentModel *)modelObj;

+ (NSDate *)setModified:(double)modified onModel:(Model *)modelObj;


+ (NSString *)getStateFromModel:(SupportAgentModel *)modelObj;

+ (NSString *)setState:(NSString *)state onModel:(Model *)modelObj;


+ (NSString *)getFirstNameFromModel:(SupportAgentModel *)modelObj;

+ (NSString *)setFirstName:(NSString *)firstName onModel:(Model *)modelObj;


+ (NSString *)getLastNameFromModel:(SupportAgentModel *)modelObj;

+ (NSString *)setLastName:(NSString *)lastName onModel:(Model *)modelObj;


+ (NSString *)getEmailFromModel:(SupportAgentModel *)modelObj;

+ (NSString *)setEmail:(NSString *)email onModel:(Model *)modelObj;


+ (NSDate *)getEmailVerifiedFromModel:(SupportAgentModel *)modelObj;

+ (NSDate *)setEmailVerified:(double)emailVerified onModel:(Model *)modelObj;


+ (NSString *)getMobileNumberFromModel:(SupportAgentModel *)modelObj;

+ (NSString *)setMobileNumber:(NSString *)mobileNumber onModel:(Model *)modelObj;


+ (NSDate *)getMobileVerifiedFromModel:(SupportAgentModel *)modelObj;

+ (NSDate *)setMobileVerified:(double)mobileVerified onModel:(Model *)modelObj;


+ (NSString *)getSupportTierFromModel:(SupportAgentModel *)modelObj;

+ (NSString *)setSupportTier:(NSString *)supportTier onModel:(Model *)modelObj;


+ (NSString *)getCurrLocationFromModel:(SupportAgentModel *)modelObj;

+ (NSString *)setCurrLocation:(NSString *)currLocation onModel:(Model *)modelObj;


+ (NSString *)getCurrLocationTimeZoneFromModel:(SupportAgentModel *)modelObj;

+ (NSString *)setCurrLocationTimeZone:(NSString *)currLocationTimeZone onModel:(Model *)modelObj;


+ (NSArray *)getMobileNotificationEndpointsFromModel:(SupportAgentModel *)modelObj;

+ (NSArray *)setMobileNotificationEndpoints:(NSArray *)mobileNotificationEndpoints onModel:(Model *)modelObj;


+ (NSDictionary *)getPreferencesFromModel:(SupportAgentModel *)modelObj;


+ (int)getNumFailedAttemptsFromModel:(SupportAgentModel *)modelObj;


+ (NSDate *)getLastFailedLoginTsFromModel:(SupportAgentModel *)modelObj;


+ (BOOL)getLockedFromModel:(SupportAgentModel *)modelObj;





/** Lists all agents */
+ (PMKPromise *) listAgentsOnModel:(Model *)modelObj;



/** Create a support agent */
+ (PMKPromise *) createSupportAgentWithEmail:(NSString *)email withFirstName:(NSString *)firstName withLastName:(NSString *)lastName withSupportTier:(NSString *)supportTier withPassword:(NSString *)password withMobileNumber:(NSString *)mobileNumber withCurrLocation:(NSString *)currLocation withCurrLocationTimeZone:(NSString *)currLocationTimeZone onModel:(Model *)modelObj;



/** Find a support agent by their id */
+ (PMKPromise *) findAgentByIdOnModel:(Model *)modelObj;



/** Find a support agent by their email address */
+ (PMKPromise *) findAgentByEmailWithEmail:(NSString *)email onModel:(Model *)modelObj;



/** Removes an agent */
+ (PMKPromise *) deleteAgentOnModel:(Model *)modelObj;



/** Manually locks an agent, keeping them from logging in */
+ (PMKPromise *) lockAgentOnModel:(Model *)modelObj;



/** Unlocks an agent, allowing them to login */
+ (PMKPromise *) unlockAgentOnModel:(Model *)modelObj;



/** Resets an agent&#x27;s password */
+ (PMKPromise *) resetAgentPasswordWithEmail:(NSString *)email withNewPassword:(NSString *)newPassword onModel:(Model *)modelObj;



/** allows inserts and updates of user preferences */
+ (PMKPromise *) editPreferencesWithEmail:(NSString *)email withPrefValues:(NSDictionary *)prefValues onModel:(Model *)modelObj;



@end
