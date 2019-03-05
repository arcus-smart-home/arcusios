

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** How loud is the speaker on the hub. */
extern NSString *const kAttrHubVolumeVolume;



extern NSString *const kEnumHubVolumeVolumeOFF;
extern NSString *const kEnumHubVolumeVolumeLOW;
extern NSString *const kEnumHubVolumeVolumeMID;
extern NSString *const kEnumHubVolumeVolumeHIGH;


@interface HubVolumeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getVolumeFromModel:(HubModel *)modelObj;

+ (NSString *)setVolume:(NSString *)volume onModel:(HubModel *)modelObj;





@end
