

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface SubsystemService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Lists all subsystems available for a given place */
+ (PMKPromise *) listSubsystemsWithPlaceId:(NSString *)placeId;



/** Flushes and reloads all the subsystems at the active given place, intended for testing */
+ (PMKPromise *) reload;



@end
