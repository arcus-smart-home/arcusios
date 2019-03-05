

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface ProMonitoringService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Gets the promonitoring settings for the specified place. */
+ (PMKPromise *) getSettingsWithPlace:(NSString *)place;



/** Gets the promonitoring metadata that represents UCC caller id data for each area as a list of phone numbers */
+ (PMKPromise *) getMetaData;



/** Check promonitoring availability for the given zipcode and state */
+ (PMKPromise *) checkAvailabilityWithZipcode:(NSString *)zipcode withState:(NSString *)state;



@end
