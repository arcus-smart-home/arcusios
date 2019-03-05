

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;





























/** The current pairing state of the associated place. Note that unlike subplacemonitor:pairingState this represents the state the system is attempting to enforce, not the current state of the hub. */
extern NSString *const kAttrPairingSubsystemPairingMode;

/** The last time the pairing mode changed. */
extern NSString *const kAttrPairingSubsystemPairingModeChanged;

/** The addresses of any new devices discovered.  These will persist until the device state is (1) PAIRED and (2) Dismiss or DismissAll is invoked. */
extern NSString *const kAttrPairingSubsystemPairingDevices;

/** The Address of the product that the end user is currently trying to pair.  This will be cleared / replaced when the device is successfully paired or the system leaves pairing mode. */
extern NSString *const kAttrPairingSubsystemSearchProductAddress;

/** Whether or not a device has been found during the most recent search flow.  When this is set to true searchIdle will be set to false and searchIdleTimeout will be cleared. */
extern NSString *const kAttrPairingSubsystemSearchDeviceFound;

/** Indicates a new device has not been found within the searchIdleTimeout and the user should be prompted for help. */
extern NSString *const kAttrPairingSubsystemSearchIdle;

/** The time that the current search operation will set searchIdle to true. */
extern NSString *const kAttrPairingSubsystemSearchIdleTimeout;

/** The time that the system will stop searching for devices unless an additional &#x27;Search&#x27; operation is invoked. */
extern NSString *const kAttrPairingSubsystemSearchTimeout;


extern NSString *const kCmdPairingSubsystemListPairingDevices;

extern NSString *const kCmdPairingSubsystemStartPairing;

extern NSString *const kCmdPairingSubsystemSearch;

extern NSString *const kCmdPairingSubsystemListHelpSteps;

extern NSString *const kCmdPairingSubsystemDismissAll;

extern NSString *const kCmdPairingSubsystemStopSearching;

extern NSString *const kCmdPairingSubsystemFactoryReset;

extern NSString *const kCmdPairingSubsystemGetKitInformation;


extern NSString *const kEvtPairingSubsystemPairingIdleTimeout;

extern NSString *const kEvtPairingSubsystemPairingTimeout;

extern NSString *const kEvtPairingSubsystemPairingFailed;

extern NSString *const kEnumPairingSubsystemPairingModeIDLE;
extern NSString *const kEnumPairingSubsystemPairingModeHUB;
extern NSString *const kEnumPairingSubsystemPairingModeCLOUD;
extern NSString *const kEnumPairingSubsystemPairingModeOAUTH;
extern NSString *const kEnumPairingSubsystemPairingModeHUB_UNPAIRING;


@interface PairingSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getPairingModeFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getPairingModeChangedFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getPairingDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getSearchProductAddressFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getSearchDeviceFoundFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getSearchIdleFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getSearchIdleTimeoutFromModel:(SubsystemModel *)modelObj;


+ (NSDate *)getSearchTimeoutFromModel:(SubsystemModel *)modelObj;





/** Gets all the PairingDevices from the pairingDevices attribute. */
+ (PMKPromise *) listPairingDevicesOnModel:(Model *)modelObj;



/** Attempts to pair the requested type of device. If the requested product is a hub connected device then the hub will enter pairing mode with the appropriate radios listening. If the requested product is not a hub connected device then the hub will not be put in pairing mode. */
+ (PMKPromise *) startPairingWithProductAddress:(NSString *)productAddress withMock:(BOOL)mock onModel:(Model *)modelObj;



/**  Attempts to pair the requested device. This will also start / reset the IdlePairing timer. If the requested product is a hub connected device then the hub will enter pairing mode with the appropriate radios listening. If the requested product is a cloud connected device then the system will enter pairing mode for the given device. If the requested product is an OAuth connected device, an error will be returned. If no productId is specified this will turn all hub radios into pairing mode and search for all types of devices.           */
+ (PMKPromise *) searchWithProductAddress:(NSString *)productAddress withForm:(NSDictionary *)form onModel:(Model *)modelObj;



/** Retrieves the help steps for the product currently being search for, or steps specific to the active pairing protocols. */
+ (PMKPromise *) listHelpStepsOnModel:(Model *)modelObj;



/**  Dismisses all devices from pairingDevices that are in the PAIRED state. This should be invoked when cancelling / exiting pairing. This will take the hub out of pairing mode. This will take the hub out of unpairing mode.  */
+ (PMKPromise *) dismissAllOnModel:(Model *)modelObj;



/** This clears all timeouts, takes the place/hub out of pairing or unpairing mode, and takes the state back to IDLE. */
+ (PMKPromise *) stopSearchingOnModel:(Model *)modelObj;



/**  Retrieves the factory reset steps for the product currently being search for, or steps specific to the active pairing protocols. This will take the hub out of pairing mode.           */
+ (PMKPromise *) factoryResetOnModel:(Model *)modelObj;



/** Gets the information about a kit.  This is a pair of product id, and the protocoladdress of that device.  Protocol address can be used to determine the state of the kitted device. */
+ (PMKPromise *) getKitInformationOnModel:(Model *)modelObj;



@end
