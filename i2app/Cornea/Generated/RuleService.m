

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "RuleService.h"
#import <i2app-Swift.h>

@implementation RuleService
+ (NSString *)name { return @"RuleService"; }
+ (NSString *)address { return @"SERV:rule:"; }


+ (PMKPromise *) listRuleTemplatesWithPlaceId:(NSString *)placeId {
  return [RuleServiceLegacy listRuleTemplates:placeId];

}


+ (PMKPromise *) listRulesWithPlaceId:(NSString *)placeId {
  return [RuleServiceLegacy listRules:placeId];

}


+ (PMKPromise *) getCategoriesWithPlaceId:(NSString *)placeId {
  return [RuleServiceLegacy getCategories:placeId];

}


+ (PMKPromise *) getRuleTemplatesByCategoryWithPlaceId:(NSString *)placeId withCategory:(NSString *)category {
  return [RuleServiceLegacy getRuleTemplatesByCategory:placeId category:category];

}

@end
