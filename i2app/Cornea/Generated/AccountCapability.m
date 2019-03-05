

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AccountCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrAccountState=@"account:state";

NSString *const kAttrAccountTaxExempt=@"account:taxExempt";

NSString *const kAttrAccountBillingFirstName=@"account:billingFirstName";

NSString *const kAttrAccountBillingLastName=@"account:billingLastName";

NSString *const kAttrAccountBillingCCType=@"account:billingCCType";

NSString *const kAttrAccountBillingCCLast4=@"account:billingCCLast4";

NSString *const kAttrAccountBillingStreet1=@"account:billingStreet1";

NSString *const kAttrAccountBillingStreet2=@"account:billingStreet2";

NSString *const kAttrAccountBillingCity=@"account:billingCity";

NSString *const kAttrAccountBillingState=@"account:billingState";

NSString *const kAttrAccountBillingZip=@"account:billingZip";

NSString *const kAttrAccountBillingZipPlusFour=@"account:billingZipPlusFour";

NSString *const kAttrAccountOwner=@"account:owner";

NSString *const kAttrAccountMyArcusEmail=@"account:myArcusEmail";

NSString *const kAttrAccountCreated=@"account:created";

NSString *const kAttrAccountModified=@"account:modified";


NSString *const kCmdAccountListDevices=@"account:ListDevices";

NSString *const kCmdAccountListHubs=@"account:ListHubs";

NSString *const kCmdAccountListPlaces=@"account:ListPlaces";

NSString *const kCmdAccountListInvoices=@"account:ListInvoices";

NSString *const kCmdAccountListAdjustments=@"account:ListAdjustments";

NSString *const kCmdAccountSignupTransition=@"account:SignupTransition";

NSString *const kCmdAccountUpdateBillingInfoCC=@"account:UpdateBillingInfoCC";

NSString *const kCmdAccountSkipPremiumTrial=@"account:SkipPremiumTrial";

NSString *const kCmdAccountCreateBillingAccount=@"account:CreateBillingAccount";

NSString *const kCmdAccountUpdateServicePlan=@"account:UpdateServicePlan";

NSString *const kCmdAccountAddPlace=@"account:AddPlace";

NSString *const kCmdAccountDelete=@"account:Delete";

NSString *const kCmdAccountDelinquentAccountEvent=@"account:DelinquentAccountEvent";

NSString *const kCmdAccountIssueCredit=@"account:IssueCredit";

NSString *const kCmdAccountIssueInvoiceRefund=@"account:IssueInvoiceRefund";

NSString *const kCmdAccountActivate=@"account:Activate";

NSString *const kCmdAccountApplyMyArcusDiscount=@"account:ApplyMyArcusDiscount";

NSString *const kCmdAccountRemoveMyArcusDiscount=@"account:RemoveMyArcusDiscount";




@implementation AccountCapability
+ (NSString *)namespace { return @"account"; }
+ (NSString *)name { return @"Account"; }

+ (NSString *)getStateFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getState:modelObj];
  
}

+ (NSString *)setState:(NSString *)state onModel:(AccountModel *)modelObj {
  [AccountCapabilityLegacy setState:state model:modelObj];
  
  return [AccountCapabilityLegacy getState:modelObj];
  
}


+ (BOOL)getTaxExemptFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AccountCapabilityLegacy getTaxExempt:modelObj] boolValue];
  
}


+ (NSString *)getBillingFirstNameFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingFirstName:modelObj];
  
}


+ (NSString *)getBillingLastNameFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingLastName:modelObj];
  
}


+ (NSString *)getBillingCCTypeFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingCCType:modelObj];
  
}


+ (NSString *)getBillingCCLast4FromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingCCLast4:modelObj];
  
}


+ (NSString *)getBillingStreet1FromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingStreet1:modelObj];
  
}


+ (NSString *)getBillingStreet2FromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingStreet2:modelObj];
  
}


+ (NSString *)getBillingCityFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingCity:modelObj];
  
}


+ (NSString *)getBillingStateFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingState:modelObj];
  
}


+ (NSString *)getBillingZipFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingZip:modelObj];
  
}


+ (NSString *)getBillingZipPlusFourFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getBillingZipPlusFour:modelObj];
  
}


+ (NSString *)getOwnerFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getOwner:modelObj];
  
}


+ (NSString *)getMyArcusEmailFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getMyArcusEmail:modelObj];
  
}


+ (NSDate *)getCreatedFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getCreated:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(AccountModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AccountCapabilityLegacy getModified:modelObj];
  
}




+ (PMKPromise *) listDevicesOnModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy listDevices:modelObj ];
}


+ (PMKPromise *) listHubsOnModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy listHubs:modelObj ];
}


+ (PMKPromise *) listPlacesOnModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy listPlaces:modelObj ];
}


+ (PMKPromise *) listInvoicesOnModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy listInvoices:modelObj ];
}


+ (PMKPromise *) listAdjustmentsOnModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy listAdjustments:modelObj ];
}


+ (PMKPromise *) signupTransitionWithStepcompleted:(NSString *)stepcompleted onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy signupTransition:modelObj stepcompleted:stepcompleted];

}


+ (PMKPromise *) updateBillingInfoCCWithBillingToken:(NSString *)billingToken onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy updateBillingInfoCC:modelObj billingToken:billingToken];

}


+ (PMKPromise *) skipPremiumTrialOnModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy skipPremiumTrial:modelObj ];
}


+ (PMKPromise *) createBillingAccountWithBillingToken:(NSString *)billingToken withPlaceID:(NSString *)placeID onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy createBillingAccount:modelObj billingToken:billingToken placeID:placeID];

}


+ (PMKPromise *) updateServicePlanWithPlaceID:(NSString *)placeID withServiceLevel:(NSString *)serviceLevel withAddons:(id)addons onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy updateServicePlan:modelObj placeID:placeID serviceLevel:serviceLevel addons:addons];

}


+ (PMKPromise *) addPlaceWithPlace:(id)place withPopulation:(NSString *)population withServiceLevel:(NSString *)serviceLevel withAddons:(id)addons onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy addPlace:modelObj place:place population:population serviceLevel:serviceLevel addons:addons];

}


+ (PMKPromise *) deleteWithDeleteOwnerLogin:(BOOL)deleteOwnerLogin onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy delete:modelObj deleteOwnerLogin:deleteOwnerLogin];

}


+ (PMKPromise *) delinquentAccountEventWithAccountId:(NSString *)accountId onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy delinquentAccountEvent:modelObj accountId:accountId];

}


+ (PMKPromise *) issueCreditWithAmountInCents:(NSString *)amountInCents withDescription:(NSString *)description onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy issueCredit:modelObj amountInCents:amountInCents description:description];

}


+ (PMKPromise *) issueInvoiceRefundWithInvoiceNumber:(NSString *)invoiceNumber onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy issueInvoiceRefund:modelObj invoiceNumber:invoiceNumber];

}


+ (PMKPromise *) activateOnModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy activate:modelObj ];
}


+ (PMKPromise *) applyMyArcusDiscountWithMyArcusEmail:(NSString *)myArcusEmail withMyArcusPassword:(NSString *)myArcusPassword onModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy applyMyArcusDiscount:modelObj myArcusEmail:myArcusEmail myArcusPassword:myArcusPassword];

}


+ (PMKPromise *) removeMyArcusDiscountOnModel:(AccountModel *)modelObj {
  return [AccountCapabilityLegacy removeMyArcusDiscount:modelObj ];
}

@end
