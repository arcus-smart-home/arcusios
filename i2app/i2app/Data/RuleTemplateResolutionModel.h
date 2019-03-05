//
//  RuleTemplateResolutionModel.h
//  i2app
//
//  Created by Arcus Team on 9/9/15.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

#import <Foundation/Foundation.h>

@interface RuleTemplateResolutionModel : NSObject

@property (nonatomic, strong) NSString *ruleName;
@property (nonatomic, strong) NSString *ruleDescription;
@property (nonatomic, strong) NSString *templateSentence;
@property (nonatomic, strong, readonly) NSString *cleanSentence;
@property (nonatomic, strong) NSArray *sentenceSelectors;
@property (nonatomic, strong) NSDictionary *selectorDictionary;
@property (nonatomic, strong) NSMutableDictionary *selectedKeyDictionary;
@property (nonatomic, strong) NSMutableDictionary *selectedValueDictionary;

- (NSArray *)cleanSentenceSelectors; // Array of sentenceSelectors with spaces replacing underscores.
- (NSArray *)editSentenceSelectors;
- (NSArray *)cleanEditSentenceSelectors; // Array of editSentenceSelectors with spaces replacing underscores.
- (NSArray *)optionsArrayForSelectorKey:(NSString *)selectorKey;
- (NSString *)optionsTypeForSelectorKey:(NSString *)selectorKey;
- (void)configurSelectionDictionariesForExistinRuleContext:(NSDictionary *)contextDictionary;

@end
