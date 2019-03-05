

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class IcstMessageModel;







/** The date the message was created */
extern NSString *const kAttrIcstMessageCreated;

/** unique id */
extern NSString *const kAttrIcstMessageId;

/** The type of message (MOTD, URGENT) */
extern NSString *const kAttrIcstMessageMessageType;

/** agent id that created the message */
extern NSString *const kAttrIcstMessageAgent;

/** The message to be shared */
extern NSString *const kAttrIcstMessageMessage;

/** The set of recipients, or empty if all should see it */
extern NSString *const kAttrIcstMessageRecipients;

/** The date the message expires (end-of-day), empty if URGENT or MOTD expires same day it was created */
extern NSString *const kAttrIcstMessageExpiration;

/** The last date the interaction was modified */
extern NSString *const kAttrIcstMessageModified;


extern NSString *const kCmdIcstMessageCreateMessage;

extern NSString *const kCmdIcstMessageListMessagesForTimeframe;




@interface IcstMessageCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getCreatedFromModel:(IcstMessageModel *)modelObj;


+ (NSString *)getIdFromModel:(IcstMessageModel *)modelObj;


+ (NSString *)getMessageTypeFromModel:(IcstMessageModel *)modelObj;

+ (NSString *)setMessageType:(NSString *)messageType onModel:(Model *)modelObj;


+ (NSString *)getAgentFromModel:(IcstMessageModel *)modelObj;


+ (NSString *)getMessageFromModel:(IcstMessageModel *)modelObj;

+ (NSString *)setMessage:(NSString *)message onModel:(Model *)modelObj;


+ (NSArray *)getRecipientsFromModel:(IcstMessageModel *)modelObj;

+ (NSArray *)setRecipients:(NSArray *)recipients onModel:(Model *)modelObj;


+ (NSDate *)getExpirationFromModel:(IcstMessageModel *)modelObj;

+ (NSDate *)setExpiration:(double)expiration onModel:(Model *)modelObj;


+ (NSDate *)getModifiedFromModel:(IcstMessageModel *)modelObj;





/** Add a message */
+ (PMKPromise *) createMessageWithId:(NSString *)id withMessageType:(NSString *)messageType withAgent:(NSString *)agent withMessage:(NSString *)message withRecipients:(NSArray *)recipients withExpiration:(double)expiration onModel:(Model *)modelObj;



/** Lists messages within a time range */
+ (PMKPromise *) listMessagesForTimeframeWithMessageType:(NSString *)messageType withAgent:(NSString *)agent withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withToken:(NSString *)token withLimit:(int)limit onModel:(Model *)modelObj;



@end
