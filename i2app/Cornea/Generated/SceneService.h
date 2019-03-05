

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface SceneService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Lists all scenes defined for a given place */
+ (PMKPromise *) listScenesWithPlaceId:(NSString *)placeId;



/** Lists all the scene templates available for a given place */
+ (PMKPromise *) listSceneTemplatesWithPlaceId:(NSString *)placeId;



@end
