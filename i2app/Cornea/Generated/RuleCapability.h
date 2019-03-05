

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class RuleModel;







/** The name of the rule */
extern NSString *const kAttrRuleName;

/** User provided description of the rule */
extern NSString *const kAttrRuleDescription;

/** Timestamp that the rule was created */
extern NSString *const kAttrRuleCreated;

/** Timestamp that the rule was last modified */
extern NSString *const kAttrRuleModified;

/** The current state of the rule */
extern NSString *const kAttrRuleState;

/** The platform-owned identifier for the template this rule was created from (if a template based rule) */
extern NSString *const kAttrRuleTemplate;

/** The context for rule evaluation, if no user defined context is required this is may be null or empty */
extern NSString *const kAttrRuleContext;


extern NSString *const kCmdRuleEnable;

extern NSString *const kCmdRuleDisable;

extern NSString *const kCmdRuleUpdateContext;

extern NSString *const kCmdRuleDelete;

extern NSString *const kCmdRuleListHistoryEntries;


extern NSString *const kEnumRuleStateENABLED;
extern NSString *const kEnumRuleStateDISABLED;


@interface RuleCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getNameFromModel:(RuleModel *)modelObj;

+ (NSString *)setName:(NSString *)name onModel:(Model *)modelObj;


+ (NSString *)getDescriptionFromModel:(RuleModel *)modelObj;

+ (NSString *)setDescription:(NSString *)description onModel:(Model *)modelObj;


+ (NSDate *)getCreatedFromModel:(RuleModel *)modelObj;


+ (NSDate *)getModifiedFromModel:(RuleModel *)modelObj;


+ (NSString *)getStateFromModel:(RuleModel *)modelObj;


+ (NSString *)getTemplateFromModel:(RuleModel *)modelObj;


+ (id)getContextFromModel:(RuleModel *)modelObj;





/** Enables the rule if it is disabled */
+ (PMKPromise *) enableOnModel:(Model *)modelObj;



/** Disables the rule if it is enabled */
+ (PMKPromise *) disableOnModel:(Model *)modelObj;



/** Updates the context for the rule */
+ (PMKPromise *) updateContextWithContext:(id)context withTemplate:(NSString *)template onModel:(Model *)modelObj;



/** Deletes the rule */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



/** Returns a list of all the history log entries associated with this rule */
+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(Model *)modelObj;



@end
