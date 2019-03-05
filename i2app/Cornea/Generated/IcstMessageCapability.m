

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IcstMessageCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrIcstMessageCreated=@"icstmsg:created";

NSString *const kAttrIcstMessageId=@"icstmsg:id";

NSString *const kAttrIcstMessageMessageType=@"icstmsg:messageType";

NSString *const kAttrIcstMessageAgent=@"icstmsg:agent";

NSString *const kAttrIcstMessageMessage=@"icstmsg:message";

NSString *const kAttrIcstMessageRecipients=@"icstmsg:recipients";

NSString *const kAttrIcstMessageExpiration=@"icstmsg:expiration";

NSString *const kAttrIcstMessageModified=@"icstmsg:modified";


NSString *const kCmdIcstMessageCreateMessage=@"icstmsg:CreateMessage";

NSString *const kCmdIcstMessageListMessagesForTimeframe=@"icstmsg:ListMessagesForTimeframe";




@implementation IcstMessageCapability
+ (NSString *)namespace { return @"icstmsg"; }
+ (NSString *)name { return @"IcstMessage"; }

+ (NSDate *)getCreatedFromModel:(IcstMessageModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstMessageCapabilityLegacy getCreated:modelObj];
  
}


+ (NSString *)getIdFromModel:(IcstMessageModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstMessageCapabilityLegacy getId:modelObj];
  
}


+ (NSString *)getMessageTypeFromModel:(IcstMessageModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstMessageCapabilityLegacy getMessageType:modelObj];
  
}

+ (NSString *)setMessageType:(NSString *)messageType onModel:(IcstMessageModel *)modelObj {
  [IcstMessageCapabilityLegacy setMessageType:messageType model:modelObj];
  
  return [IcstMessageCapabilityLegacy getMessageType:modelObj];
  
}


+ (NSString *)getAgentFromModel:(IcstMessageModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstMessageCapabilityLegacy getAgent:modelObj];
  
}


+ (NSString *)getMessageFromModel:(IcstMessageModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstMessageCapabilityLegacy getMessage:modelObj];
  
}

+ (NSString *)setMessage:(NSString *)message onModel:(IcstMessageModel *)modelObj {
  [IcstMessageCapabilityLegacy setMessage:message model:modelObj];
  
  return [IcstMessageCapabilityLegacy getMessage:modelObj];
  
}


+ (NSArray *)getRecipientsFromModel:(IcstMessageModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstMessageCapabilityLegacy getRecipients:modelObj];
  
}

+ (NSArray *)setRecipients:(NSArray *)recipients onModel:(IcstMessageModel *)modelObj {
  [IcstMessageCapabilityLegacy setRecipients:recipients model:modelObj];
  
  return [IcstMessageCapabilityLegacy getRecipients:modelObj];
  
}


+ (NSDate *)getExpirationFromModel:(IcstMessageModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstMessageCapabilityLegacy getExpiration:modelObj];
  
}

+ (NSDate *)setExpiration:(double)expiration onModel:(IcstMessageModel *)modelObj {
  [IcstMessageCapabilityLegacy setExpiration:expiration model:modelObj];
  
  return [IcstMessageCapabilityLegacy getExpiration:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(IcstMessageModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstMessageCapabilityLegacy getModified:modelObj];
  
}




+ (PMKPromise *) createMessageWithId:(NSString *)id withMessageType:(NSString *)messageType withAgent:(NSString *)agent withMessage:(NSString *)message withRecipients:(NSArray *)recipients withExpiration:(double)expiration onModel:(IcstMessageModel *)modelObj {
  return [IcstMessageCapabilityLegacy createMessage:modelObj id:id messageType:messageType agent:agent message:message recipients:recipients expiration:expiration];

}


+ (PMKPromise *) listMessagesForTimeframeWithMessageType:(NSString *)messageType withAgent:(NSString *)agent withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withToken:(NSString *)token withLimit:(int)limit onModel:(IcstMessageModel *)modelObj {
  return [IcstMessageCapabilityLegacy listMessagesForTimeframe:modelObj messageType:messageType agent:agent startDate:startDate endDate:endDate token:token limit:limit];

}

@end
