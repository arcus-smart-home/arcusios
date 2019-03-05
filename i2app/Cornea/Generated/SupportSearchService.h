

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface SupportSearchService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Searches the Elastic Search full text search index */
+ (PMKPromise *) supportMainSearchWithCritera:(NSString *)critera withFrom:(id)from withSize:(id)size;



@end
