

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CustomerInteractionCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCustomerInteractionCreated=@"suppcustinteraction:created";

NSString *const kAttrCustomerInteractionId=@"suppcustinteraction:id";

NSString *const kAttrCustomerInteractionAccount=@"suppcustinteraction:account";

NSString *const kAttrCustomerInteractionPlace=@"suppcustinteraction:place";

NSString *const kAttrCustomerInteractionCustomer=@"suppcustinteraction:customer";

NSString *const kAttrCustomerInteractionAgent=@"suppcustinteraction:agent";

NSString *const kAttrCustomerInteractionAction=@"suppcustinteraction:action";

NSString *const kAttrCustomerInteractionComment=@"suppcustinteraction:comment";

NSString *const kAttrCustomerInteractionConcessions=@"suppcustinteraction:concessions";

NSString *const kAttrCustomerInteractionIncidentNumber=@"suppcustinteraction:incidentNumber";

NSString *const kAttrCustomerInteractionModified=@"suppcustinteraction:modified";


NSString *const kCmdCustomerInteractionCreateInteraction=@"suppcustinteraction:CreateInteraction";

NSString *const kCmdCustomerInteractionUpdateInteraction=@"suppcustinteraction:UpdateInteraction";

NSString *const kCmdCustomerInteractionListInteractions=@"suppcustinteraction:ListInteractions";

NSString *const kCmdCustomerInteractionListInteractionsForTimeframe=@"suppcustinteraction:ListInteractionsForTimeframe";




@implementation CustomerInteractionCapability
+ (NSString *)namespace { return @"suppcustinteraction"; }
+ (NSString *)name { return @"CustomerInteraction"; }

+ (NSDate *)getCreatedFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getCreated:modelObj];
  
}


+ (NSString *)getIdFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getId:modelObj];
  
}


+ (NSString *)getAccountFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getAccount:modelObj];
  
}


+ (NSString *)getPlaceFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getPlace:modelObj];
  
}


+ (NSString *)getCustomerFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getCustomer:modelObj];
  
}


+ (NSString *)getAgentFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getAgent:modelObj];
  
}


+ (NSString *)getActionFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getAction:modelObj];
  
}

+ (NSString *)setAction:(NSString *)action onModel:(CustomerInteractionModel *)modelObj {
  [CustomerInteractionCapabilityLegacy setAction:action model:modelObj];
  
  return [CustomerInteractionCapabilityLegacy getAction:modelObj];
  
}


+ (NSString *)getCommentFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getComment:modelObj];
  
}

+ (NSString *)setComment:(NSString *)comment onModel:(CustomerInteractionModel *)modelObj {
  [CustomerInteractionCapabilityLegacy setComment:comment model:modelObj];
  
  return [CustomerInteractionCapabilityLegacy getComment:modelObj];
  
}


+ (NSString *)getConcessionsFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getConcessions:modelObj];
  
}

+ (NSString *)setConcessions:(NSString *)concessions onModel:(CustomerInteractionModel *)modelObj {
  [CustomerInteractionCapabilityLegacy setConcessions:concessions model:modelObj];
  
  return [CustomerInteractionCapabilityLegacy getConcessions:modelObj];
  
}


+ (NSString *)getIncidentNumberFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getIncidentNumber:modelObj];
  
}

+ (NSString *)setIncidentNumber:(NSString *)incidentNumber onModel:(CustomerInteractionModel *)modelObj {
  [CustomerInteractionCapabilityLegacy setIncidentNumber:incidentNumber model:modelObj];
  
  return [CustomerInteractionCapabilityLegacy getIncidentNumber:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(CustomerInteractionModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CustomerInteractionCapabilityLegacy getModified:modelObj];
  
}




+ (PMKPromise *) createInteractionWithId:(NSString *)id withAccount:(NSString *)account withPlace:(NSString *)place withCustomer:(NSString *)customer withAgent:(NSString *)agent withAction:(NSString *)action withComment:(NSString *)comment withConcessions:(NSString *)concessions withIncidentNumber:(NSString *)incidentNumber withProblemDevices:(NSArray *)problemDevices onModel:(CustomerInteractionModel *)modelObj {
  return [CustomerInteractionCapabilityLegacy createInteraction:modelObj id:id account:account place:place customer:customer agent:agent action:action comment:comment concessions:concessions incidentNumber:incidentNumber problemDevices:problemDevices];

}


+ (PMKPromise *) updateInteractionWithId:(NSString *)id withAccount:(NSString *)account withPlace:(NSString *)place withCustomer:(NSString *)customer withAgent:(NSString *)agent withAction:(NSString *)action withComment:(NSString *)comment withConcessions:(NSString *)concessions withIncidentNumber:(NSString *)incidentNumber withCreated:(double)created onModel:(CustomerInteractionModel *)modelObj {
  return [CustomerInteractionCapabilityLegacy updateInteraction:modelObj id:id account:account place:place customer:customer agent:agent action:action comment:comment concessions:concessions incidentNumber:incidentNumber created:created];

}


+ (PMKPromise *) listInteractionsWithAccount:(NSString *)account withPlace:(NSString *)place withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate onModel:(CustomerInteractionModel *)modelObj {
  return [CustomerInteractionCapabilityLegacy listInteractions:modelObj account:account place:place startDate:startDate endDate:endDate];

}


+ (PMKPromise *) listInteractionsForTimeframeWithFilter:(NSArray *)filter withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withToken:(NSString *)token withLimit:(int)limit onModel:(CustomerInteractionModel *)modelObj {
  return [CustomerInteractionCapabilityLegacy listInteractionsForTimeframe:modelObj filter:filter startDate:startDate endDate:endDate token:token limit:limit];

}

@end
