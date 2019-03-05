

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "RuleCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrRuleName=@"rule:name";

NSString *const kAttrRuleDescription=@"rule:description";

NSString *const kAttrRuleCreated=@"rule:created";

NSString *const kAttrRuleModified=@"rule:modified";

NSString *const kAttrRuleState=@"rule:state";

NSString *const kAttrRuleTemplate=@"rule:template";

NSString *const kAttrRuleContext=@"rule:context";


NSString *const kCmdRuleEnable=@"rule:Enable";

NSString *const kCmdRuleDisable=@"rule:Disable";

NSString *const kCmdRuleUpdateContext=@"rule:UpdateContext";

NSString *const kCmdRuleDelete=@"rule:Delete";

NSString *const kCmdRuleListHistoryEntries=@"rule:ListHistoryEntries";


NSString *const kEnumRuleStateENABLED = @"ENABLED";
NSString *const kEnumRuleStateDISABLED = @"DISABLED";


@implementation RuleCapability
+ (NSString *)namespace { return @"rule"; }
+ (NSString *)name { return @"Rule"; }

+ (NSString *)getNameFromModel:(RuleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleCapabilityLegacy getName:modelObj];
  
}

+ (NSString *)setName:(NSString *)name onModel:(RuleModel *)modelObj {
  [RuleCapabilityLegacy setName:name model:modelObj];
  
  return [RuleCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getDescriptionFromModel:(RuleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleCapabilityLegacy getDescription:modelObj];
  
}

+ (NSString *)setDescription:(NSString *)description onModel:(RuleModel *)modelObj {
  [RuleCapabilityLegacy setDescription:description model:modelObj];
  
  return [RuleCapabilityLegacy getDescription:modelObj];
  
}


+ (NSDate *)getCreatedFromModel:(RuleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleCapabilityLegacy getCreated:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(RuleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleCapabilityLegacy getModified:modelObj];
  
}


+ (NSString *)getStateFromModel:(RuleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleCapabilityLegacy getState:modelObj];
  
}


+ (NSString *)getTemplateFromModel:(RuleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleCapabilityLegacy getTemplate:modelObj];
  
}


+ (id)getContextFromModel:(RuleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RuleCapabilityLegacy getContext:modelObj];
  
}




+ (PMKPromise *) enableOnModel:(RuleModel *)modelObj {
  return [RuleCapabilityLegacy enable:modelObj ];
}


+ (PMKPromise *) disableOnModel:(RuleModel *)modelObj {
  return [RuleCapabilityLegacy disable:modelObj ];
}


+ (PMKPromise *) updateContextWithContext:(id)context withTemplate:(NSString *)template onModel:(RuleModel *)modelObj {
  return [RuleCapabilityLegacy updateContext:modelObj context:context template:template];

}


+ (PMKPromise *) deleteOnModel:(RuleModel *)modelObj {
  return [RuleCapabilityLegacy delete:modelObj ];
}


+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(RuleModel *)modelObj {
  return [RuleCapabilityLegacy listHistoryEntries:modelObj limit:limit token:token];

}

@end
