

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface RuleService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Lists all rule templates available for a given place */
+ (PMKPromise *) listRuleTemplatesWithPlaceId:(NSString *)placeId;



/** Lists all rules defined for a given place */
+ (PMKPromise *) listRulesWithPlaceId:(NSString *)placeId;



/** Returns a map containing the names of the categories and counts of available rules */
+ (PMKPromise *) getCategoriesWithPlaceId:(NSString *)placeId;



/**  */
+ (PMKPromise *) getRuleTemplatesByCategoryWithPlaceId:(NSString *)placeId withCategory:(NSString *)category;



@end
