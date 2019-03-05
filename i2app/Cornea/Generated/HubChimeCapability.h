

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;




extern NSString *const kCmdHubChimeChime;




@interface HubChimeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;




/** Causes the hub to play the chime sound. */
+ (PMKPromise *) chimeOnModel:(Model *)modelObj;



@end
