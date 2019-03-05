

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface SupportSessionService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Find all active support customer sessions (if any) */
+ (PMKPromise *) listAllActiveSessionsWithLimit:(int)limit withToken:(NSString *)token;



@end
