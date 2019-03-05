

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class ProMonitoringSettingsModel;















/** The user should be notified when the service becomes available in their area. */
extern NSString *const kAttrProMonitoringSettingsNotifyWhenAvailable;

/** Indicates whether this is a member of the trial population or not.  To enable trial access send the invitation code to JoinTrial. */
extern NSString *const kAttrProMonitoringSettingsTrial;

/** The date that professional monitoring was activated at this place, or not specified if it is not active. */
extern NSString *const kAttrProMonitoringSettingsActivatedOn;

/** The set of alerts that have enough devices to be monitored at this place. */
extern NSString *const kAttrProMonitoringSettingsSupportedAlerts;

/** The set of alerts which will be forwarded to the monitoring service. */
extern NSString *const kAttrProMonitoringSettingsMonitoredAlerts;

/** Will be UNVERIFIED until UpdateAddress is invoked, which upon success will be changed to RESIDENTIAL. */
extern NSString *const kAttrProMonitoringSettingsAddressVerification;

/** Whether or not a permit is required at this location.  This will be populate appropriately after address is updated. */
extern NSString *const kAttrProMonitoringSettingsPermitRequired;

/** The permit number. */
extern NSString *const kAttrProMonitoringSettingsPermitNumber;

/** The number of adults that live in the residence. */
extern NSString *const kAttrProMonitoringSettingsAdults;

/** The number of children that live in the residence. */
extern NSString *const kAttrProMonitoringSettingsChildren;

/** The number of pets that live in the residence. */
extern NSString *const kAttrProMonitoringSettingsPets;

/** Additional directions on how to get to the house. */
extern NSString *const kAttrProMonitoringSettingsDirections;

/** The code to get onto the property, if applicable. */
extern NSString *const kAttrProMonitoringSettingsGateCode;

/** Additional instructions for emergency dispatchers. */
extern NSString *const kAttrProMonitoringSettingsInstructions;

/** The current state of a test call. */
extern NSString *const kAttrProMonitoringSettingsTestCallStatus;

/** The last time a test call was started, will not be set until a test call is invoked for the first time. */
extern NSString *const kAttrProMonitoringSettingsTestCallTime;

/** Additional text describing the current test call state. */
extern NSString *const kAttrProMonitoringSettingsTestCallMessage;

/** external id/stages id used to reference the site created in stages. */
extern NSString *const kAttrProMonitoringSettingsExternalId;

/** The fully-qualified url for the certificate. */
extern NSString *const kAttrProMonitoringSettingsCertUrl;


extern NSString *const kCmdProMonitoringSettingsCheckAvailability;

extern NSString *const kCmdProMonitoringSettingsJoinTrial;

extern NSString *const kCmdProMonitoringSettingsValidateAddress;

extern NSString *const kCmdProMonitoringSettingsUpdateAddress;

extern NSString *const kCmdProMonitoringSettingsListDepartments;

extern NSString *const kCmdProMonitoringSettingsCheckSensors;

extern NSString *const kCmdProMonitoringSettingsActivate;

extern NSString *const kCmdProMonitoringSettingsTestCall;

extern NSString *const kCmdProMonitoringSettingsReset;


extern NSString *const kEnumProMonitoringSettingsAddressVerificationUNVERIFIED;
extern NSString *const kEnumProMonitoringSettingsAddressVerificationRESIDENTIAL;
extern NSString *const kEnumProMonitoringSettingsTestCallStatusIDLE;
extern NSString *const kEnumProMonitoringSettingsTestCallStatusWAITING;
extern NSString *const kEnumProMonitoringSettingsTestCallStatusSUCCEEDED;
extern NSString *const kEnumProMonitoringSettingsTestCallStatusFAILED;


@interface ProMonitoringSettingsCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getNotifyWhenAvailableFromModel:(ProMonitoringSettingsModel *)modelObj;

+ (BOOL)setNotifyWhenAvailable:(BOOL)notifyWhenAvailable onModel:(Model *)modelObj;


+ (BOOL)getTrialFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSDate *)getActivatedOnFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSArray *)getSupportedAlertsFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSArray *)getMonitoredAlertsFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSString *)getAddressVerificationFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (BOOL)getPermitRequiredFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSString *)getPermitNumberFromModel:(ProMonitoringSettingsModel *)modelObj;

+ (NSString *)setPermitNumber:(NSString *)permitNumber onModel:(Model *)modelObj;


+ (int)getAdultsFromModel:(ProMonitoringSettingsModel *)modelObj;

+ (int)setAdults:(int)adults onModel:(Model *)modelObj;


+ (int)getChildrenFromModel:(ProMonitoringSettingsModel *)modelObj;

+ (int)setChildren:(int)children onModel:(Model *)modelObj;


+ (int)getPetsFromModel:(ProMonitoringSettingsModel *)modelObj;

+ (int)setPets:(int)pets onModel:(Model *)modelObj;


+ (NSString *)getDirectionsFromModel:(ProMonitoringSettingsModel *)modelObj;

+ (NSString *)setDirections:(NSString *)directions onModel:(Model *)modelObj;


+ (NSString *)getGateCodeFromModel:(ProMonitoringSettingsModel *)modelObj;

+ (NSString *)setGateCode:(NSString *)gateCode onModel:(Model *)modelObj;


+ (NSString *)getInstructionsFromModel:(ProMonitoringSettingsModel *)modelObj;

+ (NSString *)setInstructions:(NSString *)instructions onModel:(Model *)modelObj;


+ (NSString *)getTestCallStatusFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSDate *)getTestCallTimeFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSString *)getTestCallMessageFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSString *)getExternalIdFromModel:(ProMonitoringSettingsModel *)modelObj;


+ (NSString *)getCertUrlFromModel:(ProMonitoringSettingsModel *)modelObj;





/** Checks if the current place supports professional monitoring or not. */
+ (PMKPromise *) checkAvailabilityOnModel:(Model *)modelObj;



/** Allows the user to join the trial group by submitting a trial code. */
+ (PMKPromise *) joinTrialWithCode:(NSString *)code onModel:(Model *)modelObj;



/** Validates that the place&#x27;s address is recognized by the professional monitoring system. Usually when the address is invalid a set of suggestions may be used to prompt the user with alternatives. */
+ (PMKPromise *) validateAddressWithStreetAddress:(id)streetAddress onModel:(Model *)modelObj;



/** Validate the address with UCC, and updates the  current place&#x27;s address if it is changed.  The address is optional and if not specified will use the address of the current place. */
+ (PMKPromise *) updateAddressWithStreetAddress:(id)streetAddress withResidential:(BOOL)residential onModel:(Model *)modelObj;



/** Lists the departments which service a place, generally used to figure out where to get a permit from. */
+ (PMKPromise *) listDepartmentsOnModel:(Model *)modelObj;



/** Gets the set of professionally monitored devices which are currently offline. */
+ (PMKPromise *) checkSensorsOnModel:(Model *)modelObj;



/**           This enrolls and activates professional monitoring at the given place.  Billing will be updated and the place will be professionally monitored.          Note that if testCall is set to true this may return successfully, and then fail later if the test call fails.           */
+ (PMKPromise *) activateWithTestCall:(BOOL)testCall onModel:(Model *)modelObj;



/**              This instructs the monitoring service to place a call to the number associated with the place.  This call will return immediately, but the lastCallStatus should be watched to determine when the test call is completed.             Note that if a test call is already in progress this will return the existing testCallTime, and as such may be retried safely.           */
+ (PMKPromise *) testCallOnModel:(Model *)modelObj;



/** Downgrades the account to premium, deactivates the place and clears all promonitoring settings */
+ (PMKPromise *) resetOnModel:(Model *)modelObj;



@end
