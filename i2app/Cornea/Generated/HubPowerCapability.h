

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** Indicates where the power from the hub is coming from. */
extern NSString *const kAttrHubPowerSource;

/** If the hub can be plugged in or not. */
extern NSString *const kAttrHubPowerMainscpable;

/** Current battery remaining, in percent */
extern NSString *const kAttrHubPowerBattery;



extern NSString *const kEvtHubPowerHubPowerSourceChanged;

extern NSString *const kEvtHubPowerHubBatteryLow;

extern NSString *const kEnumHubPowerSourceMAINS;
extern NSString *const kEnumHubPowerSourceBATTERY;


@interface HubPowerCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getSourceFromModel:(HubModel *)modelObj;


+ (BOOL)getMainscpableFromModel:(HubModel *)modelObj;


+ (int)getBatteryFromModel:(HubModel *)modelObj;





@end
