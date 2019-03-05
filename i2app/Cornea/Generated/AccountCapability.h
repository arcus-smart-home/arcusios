

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class AccountModel;











@class PlaceModel;



/** Platform-owned state of the account */
extern NSString *const kAttrAccountState;

/** Platform-owned indicator of whether or not the billing account is tax-exempt.  If not present it implies that it is not */
extern NSString *const kAttrAccountTaxExempt;

/** Platform-owned first name on the billing account. */
extern NSString *const kAttrAccountBillingFirstName;

/** Platfrom-owned last name on the billing account. */
extern NSString *const kAttrAccountBillingLastName;

/** Platform-owned type of CC on the billing account. */
extern NSString *const kAttrAccountBillingCCType;

/** Platform-owned last 4 digits of the CC on the billing account */
extern NSString *const kAttrAccountBillingCCLast4;

/** Platform-owned street address on the billing account */
extern NSString *const kAttrAccountBillingStreet1;

/** Platform-owned street address on the billing account */
extern NSString *const kAttrAccountBillingStreet2;

/** Platform-owned city on the billing account&#x27;s address */
extern NSString *const kAttrAccountBillingCity;

/** Platform-owned state on the billing account&#x27;s address */
extern NSString *const kAttrAccountBillingState;

/** Platform-owned zip code on the billing account&#x27;s address */
extern NSString *const kAttrAccountBillingZip;

/** Platform-owned digits of the zip code after the plus sign on the billing account&#x27;s address */
extern NSString *const kAttrAccountBillingZipPlusFour;

/** The person ID of the account owner */
extern NSString *const kAttrAccountOwner;

extern NSString *const kAttrAccountMyArcusEmail;

/** Date of creation of the account. */
extern NSString *const kAttrAccountCreated;

/** Last time that something was changed on the account. */
extern NSString *const kAttrAccountModified;


extern NSString *const kCmdAccountListDevices;

extern NSString *const kCmdAccountListHubs;

extern NSString *const kCmdAccountListPlaces;

extern NSString *const kCmdAccountListInvoices;

extern NSString *const kCmdAccountListAdjustments;

extern NSString *const kCmdAccountSignupTransition;

extern NSString *const kCmdAccountUpdateBillingInfoCC;

extern NSString *const kCmdAccountSkipPremiumTrial;

extern NSString *const kCmdAccountCreateBillingAccount;

extern NSString *const kCmdAccountUpdateServicePlan;

extern NSString *const kCmdAccountAddPlace;

extern NSString *const kCmdAccountDelete;

extern NSString *const kCmdAccountDelinquentAccountEvent;

extern NSString *const kCmdAccountIssueCredit;

extern NSString *const kCmdAccountIssueInvoiceRefund;

extern NSString *const kCmdAccountActivate;

extern NSString *const kCmdAccountApplyMyArcusDiscount;

extern NSString *const kCmdAccountRemoveMyArcusDiscount;




@interface AccountCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(AccountModel *)modelObj;

+ (NSString *)setState:(NSString *)state onModel:(Model *)modelObj;


+ (BOOL)getTaxExemptFromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingFirstNameFromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingLastNameFromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingCCTypeFromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingCCLast4FromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingStreet1FromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingStreet2FromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingCityFromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingStateFromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingZipFromModel:(AccountModel *)modelObj;


+ (NSString *)getBillingZipPlusFourFromModel:(AccountModel *)modelObj;


+ (NSString *)getOwnerFromModel:(AccountModel *)modelObj;


+ (NSString *)getMyArcusEmailFromModel:(AccountModel *)modelObj;


+ (NSDate *)getCreatedFromModel:(AccountModel *)modelObj;


+ (NSDate *)getModifiedFromModel:(AccountModel *)modelObj;





/** Lists all devices associated with this account */
+ (PMKPromise *) listDevicesOnModel:(Model *)modelObj;



/** Lists all hubs associated with this account */
+ (PMKPromise *) listHubsOnModel:(Model *)modelObj;



/** Lists all the places associated with this account */
+ (PMKPromise *) listPlacesOnModel:(Model *)modelObj;



/** Lists all Recurly invoices associated with this account */
+ (PMKPromise *) listInvoicesOnModel:(Model *)modelObj;



/** Lists all adjustments associated with this account */
+ (PMKPromise *) listAdjustmentsOnModel:(Model *)modelObj;



/** Send a state transition to indicate where in the sign-up process the account is */
+ (PMKPromise *) signupTransitionWithStepcompleted:(NSString *)stepcompleted onModel:(Model *)modelObj;



/** Updates billing info that contains Credit Card information using a token from ReCurly. */
+ (PMKPromise *) updateBillingInfoCCWithBillingToken:(NSString *)billingToken onModel:(Model *)modelObj;



/** Method invoked to inform the platform that the user has explicitly decided to skip the premium trial. */
+ (PMKPromise *) skipPremiumTrialOnModel:(Model *)modelObj;



/** Create a users billing account and sets up the initial subscription */
+ (PMKPromise *) createBillingAccountWithBillingToken:(NSString *)billingToken withPlaceID:(NSString *)placeID onModel:(Model *)modelObj;



/** Updates the subscription level and addons for the specified place ID. */
+ (PMKPromise *) updateServicePlanWithPlaceID:(NSString *)placeID withServiceLevel:(NSString *)serviceLevel withAddons:(id)addons onModel:(Model *)modelObj;



/** Adds a place for this account */
+ (PMKPromise *) addPlaceWithPlace:(id)place withPopulation:(NSString *)population withServiceLevel:(NSString *)serviceLevel withAddons:(id)addons onModel:(Model *)modelObj;



/** Deletes an account with optional removal of the login */
+ (PMKPromise *) deleteWithDeleteOwnerLogin:(BOOL)deleteOwnerLogin onModel:(Model *)modelObj;



/** An account has be marked Delinquent */
+ (PMKPromise *) delinquentAccountEventWithAccountId:(NSString *)accountId onModel:(Model *)modelObj;



/** Creates a credit adjustment using ReCurly. */
+ (PMKPromise *) issueCreditWithAmountInCents:(NSString *)amountInCents withDescription:(NSString *)description onModel:(Model *)modelObj;



/** Creates a refund of an entire invoice using ReCurly. */
+ (PMKPromise *) issueInvoiceRefundWithInvoiceNumber:(NSString *)invoiceNumber onModel:(Model *)modelObj;



/** Method invoked to signal that account signup is complete. */
+ (PMKPromise *) activateOnModel:(Model *)modelObj;


+ (PMKPromise *) applyMyArcusDiscountWithMyArcusEmail:(NSString *)myArcusEmail withMyArcusPassword:(NSString *)myArcusPassword onModel:(Model *)modelObj;



+ (PMKPromise *) removeMyArcusDiscountOnModel:(Model *)modelObj;



@end
