

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "RuleTemplateCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrRuleTemplateKeywords=@"ruletmpl:keywords";

NSString *const kAttrRuleTemplateAdded=@"ruletmpl:added";

NSString *const kAttrRuleTemplateLastModified=@"ruletmpl:lastModified";

NSString *const kAttrRuleTemplateTemplate=@"ruletmpl:template";

NSString *const kAttrRuleTemplateSatisfiable=@"ruletmpl:satisfiable";

NSString *const kAttrRuleTemplateName=@"ruletmpl:name";

NSString *const kAttrRuleTemplateDescription=@"ruletmpl:description";

NSString *const kAttrRuleTemplateCategories=@"ruletmpl:categories";

NSString *const kAttrRuleTemplatePremium=@"ruletmpl:premium";

NSString *const kAttrRuleTemplateExtra=@"ruletmpl:extra";


NSString *const kCmdRuleTemplateCreateRule=@"ruletmpl:CreateRule";

NSString *const kCmdRuleTemplateResolve=@"ruletmpl:Resolve";




@implementation RuleTemplateCapability
+ (NSString *)namespace { return @"ruletmpl"; }
+ (NSString *)name { return @"RuleTemplate"; }

+ (NSArray *)getKeywordsFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleTemplateCapabilityLegacy getKeywords:modelObj];
  
}


+ (NSDate *)getAddedFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleTemplateCapabilityLegacy getAdded:modelObj];
  
}


+ (NSDate *)getLastModifiedFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleTemplateCapabilityLegacy getLastModified:modelObj];
  
}


+ (NSString *)getTemplateFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleTemplateCapabilityLegacy getTemplate:modelObj];
  
}


+ (BOOL)getSatisfiableFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RuleTemplateCapabilityLegacy getSatisfiable:modelObj] boolValue];
  
}


+ (NSString *)getNameFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleTemplateCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getDescriptionFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleTemplateCapabilityLegacy getDescription:modelObj];
  
}


+ (NSArray *)getCategoriesFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleTemplateCapabilityLegacy getCategories:modelObj];
  
}


+ (BOOL)getPremiumFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RuleTemplateCapabilityLegacy getPremium:modelObj] boolValue];
  
}


+ (NSString *)getExtraFromModel:(RuleTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleTemplateCapabilityLegacy getExtra:modelObj];
  
}




+ (PMKPromise *) createRuleWithPlaceId:(NSString *)placeId withName:(NSString *)name withDescription:(NSString *)description withContext:(id)context onModel:(RuleTemplateModel *)modelObj {
  return [RuleTemplateCapabilityLegacy createRule:modelObj placeId:placeId name:name description:description context:context];

}


+ (PMKPromise *) resolveWithPlaceId:(NSString *)placeId onModel:(RuleTemplateModel *)modelObj {
  return [RuleTemplateCapabilityLegacy resolve:modelObj placeId:placeId];

}

@end
