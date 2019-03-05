

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface EasCodeService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/**  */
+ (PMKPromise *) listEasCodes;



@end
