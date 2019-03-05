

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class CustomerInteractionModel;









/** The date the interaction was created */
extern NSString *const kAttrCustomerInteractionCreated;

/** unique id */
extern NSString *const kAttrCustomerInteractionId;

/** Account id of the interaction */
extern NSString *const kAttrCustomerInteractionAccount;

/** The place id of the interaction */
extern NSString *const kAttrCustomerInteractionPlace;

/** The customer of in the interaction */
extern NSString *const kAttrCustomerInteractionCustomer;

/** Id of the agent that created the interaction */
extern NSString *const kAttrCustomerInteractionAgent;

/** The action that happened */
extern NSString *const kAttrCustomerInteractionAction;

/** The comment entered about the interaction */
extern NSString *const kAttrCustomerInteractionComment;

/** The concessions that were given */
extern NSString *const kAttrCustomerInteractionConcessions;

/** The incident number entered about the interaction */
extern NSString *const kAttrCustomerInteractionIncidentNumber;

/** The last date the interaction was modified */
extern NSString *const kAttrCustomerInteractionModified;


extern NSString *const kCmdCustomerInteractionCreateInteraction;

extern NSString *const kCmdCustomerInteractionUpdateInteraction;

extern NSString *const kCmdCustomerInteractionListInteractions;

extern NSString *const kCmdCustomerInteractionListInteractionsForTimeframe;




@interface CustomerInteractionCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getCreatedFromModel:(CustomerInteractionModel *)modelObj;


+ (NSString *)getIdFromModel:(CustomerInteractionModel *)modelObj;


+ (NSString *)getAccountFromModel:(CustomerInteractionModel *)modelObj;


+ (NSString *)getPlaceFromModel:(CustomerInteractionModel *)modelObj;


+ (NSString *)getCustomerFromModel:(CustomerInteractionModel *)modelObj;


+ (NSString *)getAgentFromModel:(CustomerInteractionModel *)modelObj;


+ (NSString *)getActionFromModel:(CustomerInteractionModel *)modelObj;

+ (NSString *)setAction:(NSString *)action onModel:(Model *)modelObj;


+ (NSString *)getCommentFromModel:(CustomerInteractionModel *)modelObj;

+ (NSString *)setComment:(NSString *)comment onModel:(Model *)modelObj;


+ (NSString *)getConcessionsFromModel:(CustomerInteractionModel *)modelObj;

+ (NSString *)setConcessions:(NSString *)concessions onModel:(Model *)modelObj;


+ (NSString *)getIncidentNumberFromModel:(CustomerInteractionModel *)modelObj;

+ (NSString *)setIncidentNumber:(NSString *)incidentNumber onModel:(Model *)modelObj;


+ (NSDate *)getModifiedFromModel:(CustomerInteractionModel *)modelObj;





/** Add an interaction */
+ (PMKPromise *) createInteractionWithId:(NSString *)id withAccount:(NSString *)account withPlace:(NSString *)place withCustomer:(NSString *)customer withAgent:(NSString *)agent withAction:(NSString *)action withComment:(NSString *)comment withConcessions:(NSString *)concessions withIncidentNumber:(NSString *)incidentNumber withProblemDevices:(NSArray *)problemDevices onModel:(Model *)modelObj;



/** update an interaction */
+ (PMKPromise *) updateInteractionWithId:(NSString *)id withAccount:(NSString *)account withPlace:(NSString *)place withCustomer:(NSString *)customer withAgent:(NSString *)agent withAction:(NSString *)action withComment:(NSString *)comment withConcessions:(NSString *)concessions withIncidentNumber:(NSString *)incidentNumber withCreated:(double)created onModel:(Model *)modelObj;



/** Lists interactions within a time range */
+ (PMKPromise *) listInteractionsWithAccount:(NSString *)account withPlace:(NSString *)place withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate onModel:(Model *)modelObj;



/** Lists interactions within a time range across accounts and places */
+ (PMKPromise *) listInteractionsForTimeframeWithFilter:(NSArray *)filter withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withToken:(NSString *)token withLimit:(int)limit onModel:(Model *)modelObj;



@end
