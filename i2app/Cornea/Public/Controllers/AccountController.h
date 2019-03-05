//
//  AccountController.h
//  Pods
//
//  Created by Tonya Momchev on 5/6/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned int, AccountState) {
    AccountStateNone,
    AccountStateSignUp1,
    AccountStateSignUpAboutYou,
    AccountStateSignUpAboutYourHome,
    AccountStateSignUpTimeZone,
    AccountStateSignUpPinCode,
    AccountStateSignUpSecurityQuestions,
    AccountStateSignUpNotifications,
    AccountStateSignUpPremiumPlan,
    AccountStateSignUpBillingInformation,
    AccountStateSignUpComplete
};

#define AccountStatesStringArray [@"NONE", @"SIGNUP1", @"ABOUT_YOU", @"ABOUT_YOUR_HOME", @"TIME_ZONE", @"PIN_CODE", @"SECURITY_QUESTIONS", @"NOTIFICATIONS", @"PREMIUM_PLAN", @"BILLING_INFO", @"COMPLETE"]
#define AccountStateToString(enum) [@AccountStatesStringArray objectAtIndex:enum]
#define AccountStateStringToType(str) (AccountState)[@AccountStatesStringArray indexOfObject:[str uppercaseString]]

extern NSString *const kUserLoginRequiredNotification;
extern NSString *const kUserLogInStartedNotification;
extern NSString *const kUserLoggedInNotification;

extern NSString *const kAllUserStatesClearedNotification;
extern NSString *const kNetworkActivityChangedNotification;

extern NSString *const kConnectionEstablishedNotification;
extern NSString *const kSocketClosedNotification;

extern NSString *const kNetworkConnectionAvailableNotification;
extern NSString *const kNetworkConnectionNotAvailableNotification;
extern NSString *const kActivePlaceClearedNotification;
extern NSString *const kSwannPairingAttemptNotification;

extern NSString *const kPasswordPlaceholder;


@class PMKPromise;
@class Model;
@class AccountModel;
@class PersonModel;
@class PlaceModel;
@class OrderedDictionary;

@interface AccountController : NSObject

+ (void)setPlatformUrlToType:(BOOL)isDev;
+ (BOOL)isPlatformUrlDev;
+ (void)saveDeviceToken:(NSString *)deviceToken;

+ (NSDate *)getSessionStartTime;

+ (PMKPromise *)loginUser:(NSString *)email
             withPassword:(NSString *)password;

+ (void)disconnectAndResetLastUser;

//The person model for the user logged in
+ (PersonModel *)getCurrentPerson;
//The place active with the session
+ (PlaceModel *)getCurrentPlace;
//The account which owns the active place
+ (AccountModel *)getCurrentAccount;

+ (void)startAllNetworkActivities;
+ (void)stopAllNetworkActivities;

+ (PMKPromise *)logoutUser;
+ (PMKPromise *)createAccountWithEmail:(NSString *)email
                          withPassword:(NSString *)password
                             withOptin:(NSString *)optin;

+ (PMKPromise *)completedAccountStep:(AccountState)stepCompleted
                             onModel:(Model *)model
                    withAccountModel:(AccountModel *)accountModel;

+ (PMKPromise *)setPersonDetails:(NSString *)firstName
                        lastName:(NSString *)lastName
                     phoneNumber:(NSString *)phoneNumber
                         onModel:(PersonModel *)personModel
                withAccountModel:(AccountModel *)accountModel;

+ (PMKPromise *)setPersonDetailsAndCompleteStep:(NSString *)firstName
                                       lastName:(NSString *)lastName
                                    phoneNumber:(NSString *)phoneNumber
                                        onModel:(PersonModel *)personModel
                               withAccountModel:(AccountModel *)accountModel;

+ (PMKPromise *)setPlaceDetails:(NSString *)nickName
                       address1:(NSString *)address1
                       address2:(NSString *)address2
                           city:(NSString *)city
                          state:(NSString *)state
                     postalCode:(NSString *)postalCode
                        country:(NSString *)country
                        onModel:(PlaceModel *)placeModel
               withAccountModel:(AccountModel *)accountModel
       validatedBySmartyStreets:(NSDictionary *)smartyStreetsDetails;

+ (PMKPromise *)setPin:(NSString *)pin onModel:(PersonModel *)personModel withPlaceModel:(PlaceModel *)placeModel withAccountModel:(AccountModel *)accountModel;

+ (PMKPromise *)setSecurityAnswersWithSecurityQuestions:(NSString *)securityQuestion1
                                    withSecurityAnswer1:(NSString *)securityAnswer1
                                  withSecurityQuestion2:(NSString *)securityQuestion2
                                    withSecurityAnswer2:(NSString *)securityAnswer2
                                  withSecurityQuestion3:(NSString *)securityQuestion3
                                    withSecurityAnswer3:(NSString *)securityAnswer3
                                                onModel:(PersonModel *)personModel
                                       withAccountModel:(AccountModel *)accountModel;

+ (PMKPromise *)setSecurityAnswersWithSecurityQuestionsAndCompleteStep:(NSString *)securityQuestion1
                                    withSecurityAnswer1:(NSString *)securityAnswer1
                                  withSecurityQuestion2:(NSString *)securityQuestion2
                                    withSecurityAnswer2:(NSString *)securityAnswer2
                                  withSecurityQuestion3:(NSString *)securityQuestion3
                                    withSecurityAnswer3:(NSString *)securityAnswer3
                                                onModel:(PersonModel *)personModel
                                       withAccountModel:(AccountModel *)accountModel;

+ (PMKPromise *)skipPremiumTrial:(AccountModel *)accountModel;
+ (PMKPromise *)setBillingInfo:(NSString *)cardNumber
                         month:(NSString *)month
                          year:(NSString *)year
                     firstName:(NSString *)firstName
                      lastName:(NSString *)lastName
             verificationValue:(NSString *)cvv
                      address1:(NSString *)address1
                      address2:(NSString *)address2
                          city:(NSString *)city
                         state:(NSString *)state
                    postalCode:(NSString *)postalCode
                       country:(NSString *)country
                     vatNumber:(NSString *)vatNumber
                       placeId:(NSString *)placeId
                  accountModel:(AccountModel *)accountModel;

+ (PMKPromise *)updateBillingInfo:(NSString *)cardNumber
                            month:(NSString *)month
                             year:(NSString *)year
                        firstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                verificationValue:(NSString *)cvv
                         address1:(NSString *)address1
                         address2:(NSString *)address2
                             city:(NSString *)city
                            state:(NSString *)state
                       postalCode:(NSString *)postalCode
                          country:(NSString *)country
                        vatNumber:(NSString *)vatNumber
                     accountModel:(AccountModel *)accountModel;

+ (NSString *)getDeviceUDID;

+ (PMKPromise *)sendPasswordReset:(NSString *)email;
+ (PMKPromise *)resetPassword:(NSString *)email resetToken:(NSString *)token password:(NSString *)password;
+ (PMKPromise *)changePassword:(NSString *)email currentPassword:(NSString *)currentPassword newPassword:(NSString *)newPassword;

+ (void)clearCurrentUserStates;
+ (PMKPromise *)deleteAccount:(AccountModel *)account;
+ (BOOL)accountDeletionInProgress;

+ (PMKPromise *)getPlaceTimezones;

+ (PMKPromise *)setTzCoordinates:(PlaceModel *)placeModel
                    withLatitude:(double)latitude
                   withLongitude:(double)longitude
                      withTzName:(NSString *)tzName
                    withTzOffset:(double)tzOffset
                         withDST:(BOOL)tzDST;
+ (PMKPromise *)setTimeZone:(PlaceModel *)placeModel
           withAccountModel:(AccountModel *)accountModel
                 withTzName:(NSString *)tzName
                   withTzId:(NSString *)tzId;

+ (NSArray *)getStates;
+ (OrderedDictionary *)getStatesOrderedDictionary;
+ (NSArray *)getStatesFullname;
+ (NSArray *)getCreditCardYears;
+ (NSArray *)getMonths;

+ (void)configureAccountClientAgentInfo:(NSString *)clientAgentInfo clientVersionInfo:(NSString *)clientVersion;

#pragma mark - Add a place
+ (PMKPromise *)addPlace:(PlaceModel *)place withPopulation:(NSString *)population withServiceLevel:(NSString *)serviceLevel withAddons:(id)addons onAccount:(AccountModel *)account;
+ (NSString *)newPlaceServiceLevelFrom:(NSString*) currentLevel;

#pragma mark - Places
+ (PMKPromise *)getOwnedPlacesOnModel:(AccountModel *)account;
+ (NSString *)getLastKnownPlaceIdForPersonId:(NSString *)personId;
+ (void)setLastKnownPlaceId:(NSString *)placeId
                forPersonId:(NSString *)personId;
+ (PMKPromise *)changeToPlaceId:(NSString *)placeId withPerson:(PersonModel *)person;

@end
