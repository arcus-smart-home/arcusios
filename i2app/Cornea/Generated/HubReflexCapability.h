

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** The number of drivers present in the hub&#x27;s current driver database. */
extern NSString *const kAttrHubReflexNumDrivers;

/** A hash value over the contents of the hub&#x27;s current driver database. */
extern NSString *const kAttrHubReflexDbHash;

/** The number of devices on the hub that are running reflexes. */
extern NSString *const kAttrHubReflexNumDevices;

/** The number of user pins on the hub that are running reflexes. */
extern NSString *const kAttrHubReflexNumPins;

/** The version of hub local reflexes currently supported by the hub. */
extern NSString *const kAttrHubReflexVersionSupported;



extern NSString *const kEvtHubReflexSyncNeeded;



@interface HubReflexCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getNumDriversFromModel:(HubModel *)modelObj;


+ (NSString *)getDbHashFromModel:(HubModel *)modelObj;


+ (int)getNumDevicesFromModel:(HubModel *)modelObj;


+ (int)getNumPinsFromModel:(HubModel *)modelObj;


+ (int)getVersionSupportedFromModel:(HubModel *)modelObj;





@end
