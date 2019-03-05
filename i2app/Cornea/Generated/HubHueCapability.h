

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** Mapping of UUIDs to models of bridges that have been seen and are online but not paired */
extern NSString *const kAttrHubHueBridgesAvailable;

/** Mapping of UUIDs to models of birdges that have been paired */
extern NSString *const kAttrHubHueBridgesPaired;

/** The lights available for pairing where the key is the light&#x27;s identifier and the value is the uuid of bridge the light is behind */
extern NSString *const kAttrHubHueLightsAvailable;

/** The lights paired where the key is the light&#x27;s identifier and the value is the bridge the uuid of the bridge the light is behind */
extern NSString *const kAttrHubHueLightsPaired;


extern NSString *const kCmdHubHueReset;




@interface HubHueCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDictionary *)getBridgesAvailableFromModel:(HubModel *)modelObj;


+ (NSDictionary *)getBridgesPairedFromModel:(HubModel *)modelObj;


+ (NSDictionary *)getLightsAvailableFromModel:(HubModel *)modelObj;


+ (NSDictionary *)getLightsPairedFromModel:(HubModel *)modelObj;





/** Clears the hue devices from the local memory and database on the hub. */
+ (PMKPromise *) resetOnModel:(Model *)modelObj;



@end
