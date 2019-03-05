

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** Determines if the connected state of the hub, if it is online or offline. */
extern NSString *const kAttrHubConnectionState;

/** Time of the last change in connect.state. */
extern NSString *const kAttrHubConnectionLastchange;

/** Determines if the connected state of the hub, if it is online or offline. */
extern NSString *const kAttrHubConnectionConnQuality;

/** A measure of the hub to hub bridge ping time. */
extern NSString *const kAttrHubConnectionPingTime;

/** Percent number of pongs recevied for pongs sent over X period of time. */
extern NSString *const kAttrHubConnectionPingResponse;



extern NSString *const kEnumHubConnectionStateONLINE;
extern NSString *const kEnumHubConnectionStateHANDSHAKE;
extern NSString *const kEnumHubConnectionStateOFFLINE;


@interface HubConnectionCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(HubModel *)modelObj;


+ (NSDate *)getLastchangeFromModel:(HubModel *)modelObj;


+ (int)getConnQualityFromModel:(HubModel *)modelObj;


+ (int)getPingTimeFromModel:(HubModel *)modelObj;


+ (int)getPingResponseFromModel:(HubModel *)modelObj;





@end
