

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface NwsSameCodeService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/**  */
+ (PMKPromise *) listSameCountiesWithStateCode:(NSString *)stateCode;



/**  */
+ (PMKPromise *) listSameStates;



/**  */
+ (PMKPromise *) getSameCodeWithStateCode:(NSString *)stateCode withCounty:(NSString *)county;



@end
