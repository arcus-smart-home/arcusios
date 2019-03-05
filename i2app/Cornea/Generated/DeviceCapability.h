

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;













/** Driver-owned account associated with the device */
extern NSString *const kAttrDeviceAccount;

/** Driver-owned place where the device is currently located */
extern NSString *const kAttrDevicePlace;

/** Device Details screen that should be used to view this device */
extern NSString *const kAttrDeviceDevtypehint;

/** Human readable name for the device */
extern NSString *const kAttrDeviceName;

/** Vendor name */
extern NSString *const kAttrDeviceVendor;

/** Model name */
extern NSString *const kAttrDeviceModel;

/** ID of the product catalog that describes this device */
extern NSString *const kAttrDeviceProductId;


extern NSString *const kCmdDeviceListHistoryEntries;

extern NSString *const kCmdDeviceRemove;

extern NSString *const kCmdDeviceForceRemove;


extern NSString *const kEvtDeviceDeviceConnected;

extern NSString *const kEvtDeviceDeviceDisconnected;

extern NSString *const kEvtDeviceDeviceRemoved;



@interface DeviceCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getAccountFromModel:(DeviceModel *)modelObj;


+ (NSString *)getPlaceFromModel:(DeviceModel *)modelObj;


+ (NSString *)getDevtypehintFromModel:(DeviceModel *)modelObj;


+ (NSString *)getNameFromModel:(DeviceModel *)modelObj;

+ (NSString *)setName:(NSString *)name onModel:(Model *)modelObj;


+ (NSString *)getVendorFromModel:(DeviceModel *)modelObj;


+ (NSString *)getModelFromModel:(DeviceModel *)modelObj;


+ (NSString *)getProductIdFromModel:(DeviceModel *)modelObj;





/** Returns a list of all the history log entries associated with this device */
+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(Model *)modelObj;



/**  Attempts to remove the given device. This call will return immediately to give the user removal steps, but the caller should watch for a base:Deleted event to be emitted from the Device. This call is safe to retry, but if a notfound error is returned that indicates a previous call already succeeded. This may put the hub in unpairing mode depending on the device being removed.           */
+ (PMKPromise *) removeWithTimeout:(long)timeout onModel:(Model *)modelObj;



/** Sent to request that a device be removed. */
+ (PMKPromise *) forceRemoveOnModel:(Model *)modelObj;



@end
