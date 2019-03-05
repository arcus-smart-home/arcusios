

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** Type of kit that this hub is a part of. */
extern NSString *const kAttrHubKitType;

/** List of devices in the kit with the hub. */
extern NSString *const kAttrHubKitKit;

/** Devices that have NOT successfully paired that are part of the kit.  This is a sub-set of the hubzigbee:pendingPairing list. */
extern NSString *const kAttrHubKitPendingPairing;


extern NSString *const kCmdHubKitSetKit;


extern NSString *const kEnumHubKitTypeNONE;
extern NSString *const kEnumHubKitTypeTEST;
extern NSString *const kEnumHubKitTypePROMON;


@interface HubKitCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getTypeFromModel:(HubModel *)modelObj;


+ (NSArray *)getKitFromModel:(HubModel *)modelObj;


+ (NSArray *)getPendingPairingFromModel:(HubModel *)modelObj;





/** Set the kit items for the hub. */
+ (PMKPromise *) setKitWithType:(NSString *)type withDevices:(NSArray *)devices onModel:(Model *)modelObj;



@end
