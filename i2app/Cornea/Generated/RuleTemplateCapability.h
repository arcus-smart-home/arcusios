

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class RuleTemplateModel;







/** Set of keywords for the template */
extern NSString *const kAttrRuleTemplateKeywords;

/** Timestamp that the rule template was added to the catalog */
extern NSString *const kAttrRuleTemplateAdded;

/** Timestamp that the rule template was last modified */
extern NSString *const kAttrRuleTemplateLastModified;

/** The textual template */
extern NSString *const kAttrRuleTemplateTemplate;

/** True if the rule template is satisfiable for the specific place for which they have been loaded. */
extern NSString *const kAttrRuleTemplateSatisfiable;

/** The name of the rule template */
extern NSString *const kAttrRuleTemplateName;

/** A description of the rule template */
extern NSString *const kAttrRuleTemplateDescription;

/** The set of categories that this rule template is part of */
extern NSString *const kAttrRuleTemplateCategories;

/** Indicates if the rule is available only for premium plans. */
extern NSString *const kAttrRuleTemplatePremium;

/** Extra text associated with the rule. */
extern NSString *const kAttrRuleTemplateExtra;


extern NSString *const kCmdRuleTemplateCreateRule;

extern NSString *const kCmdRuleTemplateResolve;




@interface RuleTemplateCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getKeywordsFromModel:(RuleTemplateModel *)modelObj;


+ (NSDate *)getAddedFromModel:(RuleTemplateModel *)modelObj;


+ (NSDate *)getLastModifiedFromModel:(RuleTemplateModel *)modelObj;


+ (NSString *)getTemplateFromModel:(RuleTemplateModel *)modelObj;


+ (BOOL)getSatisfiableFromModel:(RuleTemplateModel *)modelObj;


+ (NSString *)getNameFromModel:(RuleTemplateModel *)modelObj;


+ (NSString *)getDescriptionFromModel:(RuleTemplateModel *)modelObj;


+ (NSArray *)getCategoriesFromModel:(RuleTemplateModel *)modelObj;


+ (BOOL)getPremiumFromModel:(RuleTemplateModel *)modelObj;


+ (NSString *)getExtraFromModel:(RuleTemplateModel *)modelObj;





/** Creates a rule instance from a given rule template */
+ (PMKPromise *) createRuleWithPlaceId:(NSString *)placeId withName:(NSString *)name withDescription:(NSString *)description withContext:(id)context onModel:(Model *)modelObj;



/** Resolves the parameters for the template at a given place */
+ (PMKPromise *) resolveWithPlaceId:(NSString *)placeId onModel:(Model *)modelObj;



@end
