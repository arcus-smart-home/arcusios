//
//  RulesController.h
//  Pods
//
//  Created by Arcus Team on 6/29/15.
//
//

#import <Foundation/Foundation.h>

@class PMKPromise;

@class RuleModel;
@class RuleTemplateModel;

extern NSString *const kCentraLiteArmOnTemplateId;
extern NSString *const kCentraLiteDisarmTeplateId;
extern NSString *const kCentraLiteArmPartialTemplateId;
extern NSString *const kCentraLiteChimeTemplateId;

extern NSString *const kAlertMeArmOnTemplateId;
extern NSString *const kAlertMeDisarmTeplateId;
extern NSString *const kAlertMeArmPartialTemplateId;
extern NSString *const kAlertMeChimeTemplateId;

extern NSString *const kCarePendantPanicTemplateId;
extern NSString *const kButtonPanicTemplateId;

extern NSString *const kGen3FourButtonFob;
extern NSString *const kGen2FourButtonFob;
extern NSString *const kGen1TwoButtonFob;
extern NSString *const kGen1SmartButton;
extern NSString *const kGen2SmartButton;

#define kGen3FourButtonFobRuleTemplateIds @[@"smartfobgen3-arm-on", @"smartfobgen3-disarm", @"smartfobgen3-arm-partial", @"smartfobgen3-chime"]
#define kGen2FourButtonFobRuleTemplateIds @[@"smartfob-arm-on", @"smartfob-disarm", @"smartfob-arm-partial", @"smartfob-chime"]
#define kGen1TwoButtonFobRuleTemplateIds @[@"smartfobgen1-arm-on", @"smartfobgen1-disarm", @"smartfobgen1-arm-partial", @"smartfobgen1-chime"]
#define kSmartButtonRuleTemplateIds @[@"button-panic", @"button-chime"]

@interface RulesController : NSObject

+ (PMKPromise *)listRulesTemlatesWithPlaceId:(NSString *)placeId;

+ (PMKPromise *)listRulesWithPlaceId:(NSString *)placeId;
+ (PMKPromise *)listRulesWithPlaceId:(NSString *)placeId forDevice:(DeviceModel *)device;
+ (PMKPromise *)listRulesWithPlaceId:(NSString *)placeId forDevice:(DeviceModel *)device forButton:(NSString *)button;

+ (PMKPromise *)listRuleCategoriesWithPlaceId:(NSString *)placeId;

+ (PMKPromise *)listRulesForCategory:(NSString *)category
                         withPlaceId:(NSString *)placeId;
+ (PMKPromise *)categoryNamesListForPlace:(NSString *)placeId;
+ (PMKPromise *)createRuleWithPlaceId:(NSString *)placeId
                             withName:(NSString *)name
                      withDescription:(NSString *)description
                          withContext:(id)context
                              onModel:(RuleTemplateModel *)modelObj;
+ (PMKPromise *)resolveWithPlaceId:(NSString *)placeId
                           onModel:(RuleTemplateModel *)modelObj;
+ (PMKPromise *)getRuleTemplateModelForTemplateId:(NSString *)templateId
                                          placeId:(NSString *)placeId;
+ (NSDictionary *)getRuleTemplateModelForTemplateId:(NSString *)templateId templatesList:(NSArray *)templatesList;

+ (PMKPromise *)updateRuleWithName:(NSString *)name
                   withDescription:(NSString *)description
                       withContext:(id)context
                           onModel:(RuleModel *)modelObj;

+ (PMKPromise *)deleteRule:(RuleModel *)rule;
+ (PMKPromise *)deleteRules:(NSArray *)rules;

+ (PMKPromise *)createRuleWithTemplateId:(NSString *)ruleTempateId
                             withPlaceId:(NSString *)placeId
                             withContext:(NSDictionary *)templateContext;
@end
