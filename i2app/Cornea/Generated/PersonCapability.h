

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class PersonModel;

















@class AccountModel;

@class PlaceModel;





/** First name of the person */
extern NSString *const kAttrPersonFirstName;

/** Last name of the person */
extern NSString *const kAttrPersonLastName;

/** The email address for the person */
extern NSString *const kAttrPersonEmail;

/** Indicates the user has verified the current email address.  This field is reset if the user changes their email address. */
extern NSString *const kAttrPersonEmailVerified;

/** The mobile phone number for the person */
extern NSString *const kAttrPersonMobileNumber;

/** The list of mobile endpoints where notifications may be sent */
extern NSString *const kAttrPersonMobileNotificationEndpoints;

/** The ID of the current place where the person is present */
extern NSString *const kAttrPersonCurrPlace;

/** The methodology used for determining the current place */
extern NSString *const kAttrPersonCurrPlaceMethod;

/** The current location of the person */
extern NSString *const kAttrPersonCurrLocation;

/** The time that the current location was determined */
extern NSString *const kAttrPersonCurrLocationTime;

/** The methodology used for determining the current location */
extern NSString *const kAttrPersonCurrLocationMethod;

/** The date and time when this person provided consent to receive communications of offers and promotions */
extern NSString *const kAttrPersonConsentOffersPromotions;

/** The date and time where person provided consent to receive monthly statement communications */
extern NSString *const kAttrPersonConsentStatement;

/** Returns true if the person has a pin, false otherwise.  This is deprecated and only returns true if the person at a pin at currPlace, placesWithPin is preferred */
extern NSString *const kAttrPersonHasPin;

/** Returns the set of places the person has a pin assigned */
extern NSString *const kAttrPersonPlacesWithPin;

/** Returns true if the person has a login, false otherwise */
extern NSString *const kAttrPersonHasLogin;

/** The number of security answers the user has filled out */
extern NSString *const kAttrPersonSecurityAnswerCount;


extern NSString *const kCmdPersonSetSecurityAnswers;

extern NSString *const kCmdPersonGetSecurityAnswers;

extern NSString *const kCmdPersonAddMobileDevice;

extern NSString *const kCmdPersonRemoveMobileDevice;

extern NSString *const kCmdPersonListMobileDevices;

extern NSString *const kCmdPersonListHistoryEntries;

extern NSString *const kCmdPersonDelete;

extern NSString *const kCmdPersonRemoveFromPlace;

extern NSString *const kCmdPersonChangePin;

extern NSString *const kCmdPersonChangePinV2;

extern NSString *const kCmdPersonVerifyPin;

extern NSString *const kCmdPersonAcceptInvitation;

extern NSString *const kCmdPersonRejectInvitation;

extern NSString *const kCmdPersonPendingInvitations;

extern NSString *const kCmdPersonPromoteToAccount;

extern NSString *const kCmdPersonDeleteLogin;

extern NSString *const kCmdPersonListAvailablePlaces;

extern NSString *const kCmdPersonAcceptPolicy;

extern NSString *const kCmdPersonRejectPolicy;

extern NSString *const kCmdPersonSendVerificationEmail;

extern NSString *const kCmdPersonVerifyEmail;


extern NSString *const kEvtPersonPinChangedEvent;

extern NSString *const kEvtPersonInvitationPending;

extern NSString *const kEvtPersonAuthorizationRemoved;



@interface PersonCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getFirstNameFromModel:(PersonModel *)modelObj;

+ (NSString *)setFirstName:(NSString *)firstName onModel:(Model *)modelObj;


+ (NSString *)getLastNameFromModel:(PersonModel *)modelObj;

+ (NSString *)setLastName:(NSString *)lastName onModel:(Model *)modelObj;


+ (NSString *)getEmailFromModel:(PersonModel *)modelObj;

+ (NSString *)setEmail:(NSString *)email onModel:(Model *)modelObj;


+ (BOOL)getEmailVerifiedFromModel:(PersonModel *)modelObj;


+ (NSString *)getMobileNumberFromModel:(PersonModel *)modelObj;

+ (NSString *)setMobileNumber:(NSString *)mobileNumber onModel:(Model *)modelObj;


+ (NSArray *)getMobileNotificationEndpointsFromModel:(PersonModel *)modelObj;

+ (NSArray *)setMobileNotificationEndpoints:(NSArray *)mobileNotificationEndpoints onModel:(Model *)modelObj;


+ (NSString *)getCurrPlaceFromModel:(PersonModel *)modelObj;

+ (NSString *)setCurrPlace:(NSString *)currPlace onModel:(Model *)modelObj;


+ (NSString *)getCurrPlaceMethodFromModel:(PersonModel *)modelObj;

+ (NSString *)setCurrPlaceMethod:(NSString *)currPlaceMethod onModel:(Model *)modelObj;


+ (NSString *)getCurrLocationFromModel:(PersonModel *)modelObj;

+ (NSString *)setCurrLocation:(NSString *)currLocation onModel:(Model *)modelObj;


+ (NSDate *)getCurrLocationTimeFromModel:(PersonModel *)modelObj;

+ (NSDate *)setCurrLocationTime:(double)currLocationTime onModel:(Model *)modelObj;


+ (NSString *)getCurrLocationMethodFromModel:(PersonModel *)modelObj;

+ (NSString *)setCurrLocationMethod:(NSString *)currLocationMethod onModel:(Model *)modelObj;


+ (NSDate *)getConsentOffersPromotionsFromModel:(PersonModel *)modelObj;

+ (NSDate *)setConsentOffersPromotions:(double)consentOffersPromotions onModel:(Model *)modelObj;


+ (NSDate *)getConsentStatementFromModel:(PersonModel *)modelObj;

+ (NSDate *)setConsentStatement:(double)consentStatement onModel:(Model *)modelObj;


+ (BOOL)getHasPinFromModel:(PersonModel *)modelObj;


+ (NSArray *)getPlacesWithPinFromModel:(PersonModel *)modelObj;


+ (BOOL)getHasLoginFromModel:(PersonModel *)modelObj;


+ (int)getSecurityAnswerCountFromModel:(PersonModel *)modelObj;





/** Sets the security answers for the given person.  The first question and answer are required, those for the second and third are optional. */
+ (PMKPromise *) setSecurityAnswersWithSecurityQuestion1:(NSString *)securityQuestion1 withSecurityAnswer1:(NSString *)securityAnswer1 withSecurityQuestion2:(NSString *)securityQuestion2 withSecurityAnswer2:(NSString *)securityAnswer2 withSecurityQuestion3:(NSString *)securityQuestion3 withSecurityAnswer3:(NSString *)securityAnswer3 onModel:(Model *)modelObj;



/** Retrieves the security responses for the given person */
+ (PMKPromise *) getSecurityAnswersOnModel:(Model *)modelObj;



/** Adds and associates a mobile device for the given person */
+ (PMKPromise *) addMobileDeviceWithName:(NSString *)name withAppVersion:(NSString *)appVersion withOsType:(NSString *)osType withOsVersion:(NSString *)osVersion withFormFactor:(NSString *)formFactor withPhoneNumber:(NSString *)phoneNumber withDeviceIdentifier:(NSString *)deviceIdentifier withDeviceModel:(NSString *)deviceModel withDeviceVendor:(NSString *)deviceVendor withResolution:(NSString *)resolution withNotificationToken:(NSString *)notificationToken withLastLatitude:(double)lastLatitude withLastLongitude:(double)lastLongitude onModel:(Model *)modelObj;



/** Removes/disassociates a mobile device from this person */
+ (PMKPromise *) removeMobileDeviceWithDeviceIndex:(int)deviceIndex onModel:(Model *)modelObj;



/** Lists all mobile devices associated with this person */
+ (PMKPromise *) listMobileDevicesOnModel:(Model *)modelObj;



/** Returns a list of all the history log entries associated with this person */
+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(Model *)modelObj;



/** Remove/Deactivate the person record indicated. */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



/** Removes a person from a specific place.  If the person is a hobbit they will be completely deleted. */
+ (PMKPromise *) removeFromPlaceWithPlaceId:(NSString *)placeId onModel:(Model *)modelObj;



/** Changes the person&#x27;s pin at their currPlace.  Deprecated, use ChangePinV2 instead. */
+ (PMKPromise *) changePinWithCurrentPin:(NSString *)currentPin withNewPin:(NSString *)newPin onModel:(Model *)modelObj;



/** Changes the person&#x27;s pin at the specified place.  People are allowed to change their own pin or a hobbit at the specified place assuming the person invoking the call has access to the place. */
+ (PMKPromise *) changePinV2WithPlace:(NSString *)place withPin:(NSString *)pin onModel:(Model *)modelObj;



/** Verifies that the pins match and that the requester is logged in as the person that the pin is being verified for. */
+ (PMKPromise *) verifyPinWithPlace:(NSString *)place withPin:(NSString *)pin onModel:(Model *)modelObj;



/** Accepts an invitation */
+ (PMKPromise *) acceptInvitationWithCode:(NSString *)code withInviteeEmail:(NSString *)inviteeEmail onModel:(Model *)modelObj;



/** Rejects an invitation */
+ (PMKPromise *) rejectInvitationWithCode:(NSString *)code withInviteeEmail:(NSString *)inviteeEmail withReason:(NSString *)reason onModel:(Model *)modelObj;



/** Retrieves the list of pending invitations for this user */
+ (PMKPromise *) pendingInvitationsOnModel:(Model *)modelObj;



+ (PMKPromise *) promoteToAccountWithPlace:(id)place onModel:(Model *)modelObj;



/** Deletes complete the login and any associations with it */
+ (PMKPromise *) deleteLoginOnModel:(Model *)modelObj;



/** Lists the available places for a person.  Returns the same structure as the session service&#x27;s method */
+ (PMKPromise *) listAvailablePlacesOnModel:(Model *)modelObj;



/** Accept terms &amp; conditions and/or privacy policy */
+ (PMKPromise *) acceptPolicyWithType:(NSString *)type onModel:(Model *)modelObj;



/** Reject terms &amp; conditions and/or privacy policy. NOTE THIS IS GENERALLY FOR TESTING ONLY */
+ (PMKPromise *) rejectPolicyWithType:(NSString *)type onModel:(Model *)modelObj;



/** Generates an email address verification email. */
+ (PMKPromise *) sendVerificationEmailWithSource:(NSString *)source onModel:(Model *)modelObj;



/** Verifies that the user has access to their current email address by providing the token from the email. */
+ (PMKPromise *) verifyEmailWithToken:(NSString *)token onModel:(Model *)modelObj;



@end
