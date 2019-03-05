

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class PairingDeviceModel;











/**  The current state of pairing for the device:      PAIRING - The system has discovered a device and is in the process of configuring it. (deviceAddress will be null)     MISPAIRED - The device failed to pair properly and must be removed / factory reset and re-paired (deviceAddress will be null)     MISCONFIGURED - The system was unable to fully configure the device, but it can retry without going through a full re-pair process. (deviceAddress may be null)     PAIRED - The device successfully paired. (deviceAddress will be populated)              */
extern NSString *const kAttrPairingDevicePairingState;

/** The current pairing phase. */
extern NSString *const kAttrPairingDevicePairingPhase;

/** The percent of pairing completion the platform believes the device has made it through. */
extern NSString *const kAttrPairingDevicePairingProgress;

/** The set of customizations that have been applied to this device, this must be updated via the AddCustomization call */
extern NSString *const kAttrPairingDeviceCustomizations;

/** The address to the associated device object.  This will only be populated once the device has gone sufficiently far in the pairing process. */
extern NSString *const kAttrPairingDeviceDeviceAddress;

/** The address of the product associated with this device.  This will start out populated if StartPairing with a product is used to start the pairing process.  If at some point it is determined this device is not the product we thought we were pairing it will be cleared. */
extern NSString *const kAttrPairingDeviceProductAddress;

/** The mode of removal */
extern NSString *const kAttrPairingDeviceRemoveMode;

/** Protocol address for the device. */
extern NSString *const kAttrPairingDeviceProtocolAddress;


extern NSString *const kCmdPairingDeviceCustomize;

extern NSString *const kCmdPairingDeviceAddCustomization;

extern NSString *const kCmdPairingDeviceDismiss;

extern NSString *const kCmdPairingDeviceRemove;

extern NSString *const kCmdPairingDeviceForceRemove;


extern NSString *const kEvtPairingDeviceDiscovered;

extern NSString *const kEvtPairingDeviceConfigured;

extern NSString *const kEvtPairingDevicePairingFailed;

extern NSString *const kEnumPairingDevicePairingStatePAIRING;
extern NSString *const kEnumPairingDevicePairingStateMISPAIRED;
extern NSString *const kEnumPairingDevicePairingStateMISCONFIGURED;
extern NSString *const kEnumPairingDevicePairingStatePAIRED;
extern NSString *const kEnumPairingDevicePairingPhaseJOIN;
extern NSString *const kEnumPairingDevicePairingPhaseCONNECT;
extern NSString *const kEnumPairingDevicePairingPhaseIDENTIFY;
extern NSString *const kEnumPairingDevicePairingPhasePREPARE;
extern NSString *const kEnumPairingDevicePairingPhaseCONFIGURE;
extern NSString *const kEnumPairingDevicePairingPhaseFAILED;
extern NSString *const kEnumPairingDevicePairingPhasePAIRED;
extern NSString *const kEnumPairingDeviceRemoveModeCLOUD;
extern NSString *const kEnumPairingDeviceRemoveModeHUB_AUTOMATIC;
extern NSString *const kEnumPairingDeviceRemoveModeHUB_MANUAL;


@interface PairingDeviceCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getPairingStateFromModel:(PairingDeviceModel *)modelObj;


+ (NSString *)getPairingPhaseFromModel:(PairingDeviceModel *)modelObj;


+ (int)getPairingProgressFromModel:(PairingDeviceModel *)modelObj;


+ (NSArray *)getCustomizationsFromModel:(PairingDeviceModel *)modelObj;


+ (NSString *)getDeviceAddressFromModel:(PairingDeviceModel *)modelObj;


+ (NSString *)getProductAddressFromModel:(PairingDeviceModel *)modelObj;


+ (NSString *)getRemoveModeFromModel:(PairingDeviceModel *)modelObj;


+ (NSString *)getProtocolAddressFromModel:(PairingDeviceModel *)modelObj;





/**  Retrieves the customization steps for the given device, the deviceId should match the value from discoveredDeviceIds or PairingDevice#deviceId. If this call is successful the hub will no longer be in any pairing mode.           */
+ (PMKPromise *) customizeOnModel:(Model *)modelObj;



/** Used by the client to indicate which customizations they have applied to the device.  The set may be read from the customizations attribute. */
+ (PMKPromise *) addCustomizationWithCustomization:(NSString *)customization onModel:(Model *)modelObj;



/**  Dismisses a device from the pairing subsystem.  This should be called when customization is completed or skipped. This call is idempotent, so if the device has previously been dismissed this will not return an error, unlike Customize.           */
+ (PMKPromise *) dismissOnModel:(Model *)modelObj;



/**  Attempts to remove the given device. This call will return immediately to give the user removal steps, but the caller should watch for a base:Deleted event to be emitted from the PairingDevice. This call is safe to retry, but if a notfound error is returned that indicates a previous call already succeeded. This will take the hub out of pairing mode and may put it in unpairing mode depending on the device being removed.           */
+ (PMKPromise *) removeOnModel:(Model *)modelObj;



/**  Causes the hub to blacklist this device and treat it as if it was deleted even though it still has connectivity to the hub. This will take the hub out of pairing mode.           */
+ (PMKPromise *) forceRemoveOnModel:(Model *)modelObj;



@end
