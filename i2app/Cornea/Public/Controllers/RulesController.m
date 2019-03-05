//
//  RulesController.m
//  Pods
//
//  Created by Arcus Team on 6/29/15.
//
//

#import <i2app-Swift.h>
#import "RulesController.h"
#import "RuleCapability.h"
#import "RuleService.h"
#import "RuleTemplateCapability.h"
#import <PromiseKit/PromiseKit.h>


#import "Capability.h"
#import "ClientMessage.h"



NSString *const kCentraLiteArmOnTemplateId = @"smartfob-arm-on";
NSString *const kCentraLiteDisarmTeplateId = @"smartfob-disarm";
NSString *const kCentraLiteArmPartialTemplateId = @"smartfob-arm-partial";
NSString *const kCentraLiteChimeTemplateId = @"smartfob-chime";

NSString *const kGen3FourButtonFob = @"4fcccc";
NSString *const kGen2FourButtonFob = @"4fccbb";
NSString *const kGen1TwoButtonFob = @"486390";
NSString *const kGen1SmartButton = @"bca135";
NSString *const kGen2SmartButton = @"bbf1cf";


// Both CentraLite and AlertMe
NSString *const kCarePendantPanicTemplateId = @"pendant-panic";

// Both CentraLite and AlertMe
NSString *const kButtonPanicTemplateId = @"button-panic";


@implementation RulesController

/** Lists all rule templates available for a given place */
+ (PMKPromise *)listRulesTemlatesWithPlaceId:(NSString *)placeId {
    return [RuleService listRuleTemplatesWithPlaceId:placeId].thenInBackground(^(RuleServiceListRuleTemplatesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([response attributes][@"ruleTemplates"]);
        }];
    });
}


/** Lists all rules defined for a given place */
+ (PMKPromise *)listRulesWithPlaceId:(NSString *)placeId {
    return [RuleService listRulesWithPlaceId:placeId].thenInBackground(^(RuleServiceListRulesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([response attributes][@"rules"]);
        }];
    });
}

+ (PMKPromise *)listRulesWithPlaceId:(NSString *)placeId forDevice:(DeviceModel *)device {
    return [RuleService listRulesWithPlaceId:placeId].thenInBackground(^(RuleServiceListRulesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSMutableArray *deviceRules = [NSMutableArray new];          // TODO
            for (RuleModel *rule in [[[CorneaHolder shared] modelCache] fetchModels:[RuleCapability namespace]]) {
                NSArray *context = ((NSDictionary *)[RuleCapability getContextFromModel:rule]).allValues;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", device.address];
                NSArray *rules = [context filteredArrayUsingPredicate:predicate];
                if (rules.count > 0) {
                    [deviceRules addObject:rule];
                }
            }
            fulfill(deviceRules);
        }];
    });
}

+ (PMKPromise *)listRulesWithPlaceId:(NSString *)placeId forDevice:(DeviceModel *)device forButton:(NSString *)button {
    return [RuleService listRulesWithPlaceId:placeId].thenInBackground(^(RuleServiceListRulesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSMutableArray *deviceRules = [NSMutableArray new];
            if (button != nil) {
                for (RuleModel *rule in [[[CorneaHolder shared] modelCache] fetchModels:[RuleCapability namespace]]) {
                    NSDictionary *context = ((NSDictionary *)[RuleCapability getContextFromModel:rule]);
                    
                    if ([[context objectForKey:@"button"] isEqualToString:button]
                        && [context.allValues containsObject:device.address]) {
                        [deviceRules addObject:rule];
                    }
                }
            } else {
                // For smart buttons with only one button there is no need to query for the button name
                for (RuleModel *rule in [[[CorneaHolder shared] modelCache] fetchModels:[RuleCapability namespace]]) {
                    NSDictionary *context = ((NSDictionary *)[RuleCapability getContextFromModel:rule]);
                    
                    if ([context.allValues containsObject:device.address]) {
                        [deviceRules addObject:rule];
                    }
                }
            }
            fulfill(deviceRules);
        }];
    });
}

/** Lists all rule categories for a given place */
+ (PMKPromise *)listRuleCategoriesWithPlaceId:(NSString *)placeId {
    return [RuleService getCategoriesWithPlaceId:placeId].thenInBackground(^(RuleServiceGetCategoriesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *categoryData = [response attributes][@"categories"];
            NSMutableDictionary *mutableCategoryData = [[NSMutableDictionary alloc] initWithCapacity:categoryData.count];
            for (NSString *key in categoryData.allKeys) {
                if ([categoryData[key] intValue] > 0) {
                    [mutableCategoryData setObject:[categoryData objectForKey:key] forKey:key];
                }
            }
            
            fulfill(mutableCategoryData.copy);
        }];
    });
}

+ (PMKPromise *)categoryNamesListForPlace:(NSString *)placeId {
    return [RuleService getCategoriesWithPlaceId:placeId].thenInBackground(^(RuleServiceGetCategoriesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *categoryData = [response attributes][@"categories"];

            NSArray *categoryNames = categoryData.allKeys;

            fulfill(categoryNames);
        }];
    });
}

/** Lists all rule templates for a given category & placeId */
+ (PMKPromise *)listRulesForCategory:(NSString *)category
                         withPlaceId:(NSString *)placeId {
    return [RuleService getRuleTemplatesByCategoryWithPlaceId:placeId
                                                 withCategory:category].thenInBackground(^(RuleServiceGetRuleTemplatesByCategoryResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([response attributes][@"ruleTemplates"]);
        }];
    });
}

/** Creates a rule instance from a given rule template */
+ (PMKPromise *)createRuleWithPlaceId:(NSString *)placeId
                             withName:(NSString *)name
                      withDescription:(NSString *)description
                          withContext:(id)context
                              onModel:(RuleTemplateModel *)modelObj {
    return [RuleTemplateCapability createRuleWithPlaceId:placeId
                                                withName:name
                                         withDescription:description
                                             withContext:context
                                                 onModel:modelObj].thenInBackground(^(RuleTemplateCreateRuleResponse *event) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([event attributes][@"success"]);
        }];
    });
}

/** Resolves the parameters for the template at a given place */
+ (PMKPromise *)resolveWithPlaceId:(NSString *)placeId
                           onModel:(RuleTemplateModel *)modelObj {
    return [RuleTemplateCapability resolveWithPlaceId:placeId
                                              onModel:modelObj].thenInBackground(^(RuleTemplateResolveResponse *event) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([event attributes]);
        }];
    });
}

/** Returns RuleTemplateModel for received identifier */
+ (PMKPromise *)getRuleTemplateModelForTemplateId:(NSString *)templateId placeId:(NSString *)placeId {
    return [RuleService listRuleTemplatesWithPlaceId:placeId].thenInBackground(^(RuleServiceListRuleTemplatesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            for (NSDictionary *templateDictionary in [response getRuleTemplates]) {
                RuleTemplateModel *templateModel = [[RuleTemplateModel alloc] initWithAttributes:templateDictionary];
                // DDLogWarn(@"ModelID: %@", templateModel.modelId);
                if ([templateModel.modelId isEqualToString:templateId]) {
                    fulfill(templateModel);
                    break;
                }
            }
        }];
    });
}

// A utility method to fast retrieve the template model from the template ID
+ (NSDictionary *)getRuleTemplateModelForTemplateId:(NSString *)templateId templatesList:(NSArray *)templatesList {
    NSMutableArray *templates = [NSMutableArray arrayWithArray:templatesList];
    [templates filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        return [[object objectForKey:kAttrId] isEqualToString:templateId];
    }]];
    if (templates.count > 0) {
        return templates[0];
    }
    return nil;
}

+ (PMKPromise *)updateRuleWithName:(NSString *)name
                   withDescription:(NSString *)description
                       withContext:(id)context
                           onModel:(RuleModel *)modelObj {
    [RuleCapability setName:name onModel:modelObj];
    [RuleCapability setDescription:description onModel:modelObj];
    [RuleCapability updateContextWithContext:context withTemplate:@"" onModel:modelObj];

    return [modelObj commit];
}

#pragma mark - Delete Rule
+ (PMKPromise *)deleteRule:(RuleModel *)rule {
    return [RuleCapability deleteOnModel:rule].thenInBackground(^(RuleDeleteResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(response);
        }];
    });
}

//
+ (PMKPromise *)deleteRules:(NSArray *)rules {
    __block int deletedRulesErrorCount = 0;
    __block int deletedRulesSuccessCount = 0;
    
    dispatch_semaphore_t semaphor = dispatch_semaphore_create(0);
    for (RuleModel *rule in rules) {
        return [self deleteRule:rule].thenInBackground(^{
            deletedRulesSuccessCount++;
            if (deletedRulesErrorCount + deletedRulesSuccessCount == rules.count) {
                dispatch_semaphore_signal(semaphor);
            }
        }).catch(^(NSError *error) {
            deletedRulesErrorCount++;
            if (deletedRulesErrorCount + deletedRulesSuccessCount == rules.count) {
                dispatch_semaphore_signal(semaphor);
            }
        });
    }
    dispatch_semaphore_wait(semaphor, dispatch_time(DISPATCH_TIME_NOW, (30 * NSEC_PER_SEC)));
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        if (deletedRulesSuccessCount == rules.count) {
            fulfill(self);
        }
        else if (deletedRulesSuccessCount + deletedRulesErrorCount == rules.count) {
            fulfill(self);
        }
        else if (deletedRulesErrorCount == rules.count) {
            reject(nil);
        }
    }];
}

#pragma mark - Key Fob / Button Templates
+ (PMKPromise *)createRuleWithTemplateId:(NSString *)ruleTempateId
                             withPlaceId:(NSString *)placeId
                             withContext:(NSDictionary *)templateContext {
    return [self getRuleTemplateModelForTemplateId:ruleTempateId placeId:placeId].thenInBackground(^(RuleTemplateModel *ruleTemplateModel) {
        if (ruleTemplateModel) {
            return [self createRuleWithPlaceId:placeId
                                      withName:[RuleTemplateCapability getNameFromModel:ruleTemplateModel]
                               withDescription:[RuleTemplateCapability getDescriptionFromModel:ruleTemplateModel]
                                   withContext:templateContext
                                       onModel:ruleTemplateModel];
        }
        else {
            return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
                reject(nil);
            }];
        }
    });
}
@end
