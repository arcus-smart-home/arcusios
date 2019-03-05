

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Map from bridge-owned device identifier to the protocol address of paired children devices */
extern NSString *const kAttrBridgePairedDevices;

/** Set of bridge-owned device identifiers that have been seen but not paired. */
extern NSString *const kAttrBridgeUnpairedDevices;

/** The current pairing state of the bridge device.  PAIRING indicates that any new devices seen will be paired, UNPAIRING that devices are being removed and IDLE means neither */
extern NSString *const kAttrBridgePairingState;

/** Total number of devices this bridge can support. */
extern NSString *const kAttrBridgeNumDevicesSupported;


extern NSString *const kCmdBridgeStartPairing;

extern NSString *const kCmdBridgeStopPairing;


extern NSString *const kEnumBridgePairingStatePAIRING;
extern NSString *const kEnumBridgePairingStateUNPAIRING;
extern NSString *const kEnumBridgePairingStateIDLE;


@interface BridgeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDictionary *)getPairedDevicesFromModel:(DeviceModel *)modelObj;


+ (NSArray *)getUnpairedDevicesFromModel:(DeviceModel *)modelObj;


+ (NSString *)getPairingStateFromModel:(DeviceModel *)modelObj;


+ (int)getNumDevicesSupportedFromModel:(DeviceModel *)modelObj;





/** Puts bridge into pairing mode for timeout seconds.  Any devices seen while not in pairing mode will be immediately paired as well as any new devices discovered within the timeout period */
+ (PMKPromise *) startPairingWithTimeout:(long)timeout onModel:(Model *)modelObj;



/** Removes the bridge from pairing mode. */
+ (PMKPromise *) stopPairingOnModel:(Model *)modelObj;



@end
