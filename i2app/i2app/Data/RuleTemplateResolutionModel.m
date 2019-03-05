//
//  RuleTemplateResolutionModel.m
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

#import <i2app-Swift.h>
#import "RuleTemplateResolutionModel.h"
#import "NSDate+Convert.h"


#import "PersonService.h"

@interface RuleTemplateResolutionModel ()

@property (nonatomic, strong, readwrite) NSString *cleanSentence;

@end

@implementation RuleTemplateResolutionModel

#pragma mark - Getters & Setters 

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.ruleName, self.ruleDescription, self.templateSentence, self.cleanSentence];
}

- (NSString *)cleanSentence {
    NSString *sentence = self.templateSentence;
    
    for (NSString *selectorKey in self.sentenceSelectors) {
        sentence = [sentence stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"${%@}", selectorKey]
                                                       withString:@"%@"];
        
    }
    return _cleanSentence = sentence;
}

- (NSString *)ruleDescription  {
    NSString *sentence = self.templateSentence;
    
    for (NSString *selectorKey in self.sentenceSelectors) {
        if ([self.selectedKeyDictionary objectForKey:selectorKey]) {
            sentence = [sentence stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"${%@}", selectorKey]
                                                           withString:[self.selectedKeyDictionary objectForKey:selectorKey]];

        }
    }
    return _ruleDescription = sentence;
}

- (NSArray *)sentenceSelectors {
    if (!_sentenceSelectors) {
        _sentenceSelectors = [self selectorKeysFromTemplateSentence];
    }
    return _sentenceSelectors;
}

- (NSArray *)cleanSentenceSelectors {
    NSMutableArray *cleanSelectors = [[NSMutableArray alloc] init];

    for (NSString *selectorKey in self.sentenceSelectors) {
        NSString *key = [selectorKey stringByReplacingOccurrencesOfString:@"_"
                                                               withString:@" "];
        
        if ([self optionsArrayForSelectorKey:key].count == 1) {
            NSArray *selection = [self optionsArrayForSelectorKey:key].firstObject;
            
            [cleanSelectors addObject:selection.firstObject];
            
            [self.selectedKeyDictionary setObject:selection.firstObject forKey:key];
            [self.selectedValueDictionary setObject:selection[1] forKey:key];
            
        }else {
            [cleanSelectors addObject:key];
        }
    }
    
    return [NSArray arrayWithArray:cleanSelectors];
}

- (NSArray *)editSentenceSelectors {
    NSMutableArray *editSelectors = [[NSMutableArray alloc] init];
    for (NSString *selectorKey in self.sentenceSelectors) {
        if (self.selectedKeyDictionary[selectorKey]) {
            [editSelectors addObject:self.selectedKeyDictionary[selectorKey]];
        }
        else {
            [editSelectors addObject:selectorKey];
        }
    }
    return [NSArray arrayWithArray:editSelectors];
}

- (NSArray *)cleanEditSentenceSelectors {
    NSMutableArray *editSelectors = [[NSMutableArray alloc] init];
    for (NSString *selectorKey in [self editSentenceSelectors]) {
        NSString *key = [selectorKey stringByReplacingOccurrencesOfString:@"_"
                                                               withString:@" "];
        [editSelectors addObject:key];
    }
    return [NSArray arrayWithArray:editSelectors];
}

- (NSMutableDictionary *)selectedKeyDictionary {
    if (!_selectedKeyDictionary) {
        _selectedKeyDictionary = [[NSMutableDictionary alloc] init];
    }
    return _selectedKeyDictionary;
}

- (NSMutableDictionary *)selectedValueDictionary {
    if (!_selectedValueDictionary) {
        _selectedValueDictionary = [[NSMutableDictionary alloc] init];
    }
    return _selectedValueDictionary;
}

- (NSArray *)selectorKeysFromTemplateSentence {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray *splitArray = [self.templateSentence componentsSeparatedByString:@"${"];
    for (NSString *splitString in splitArray) {
        if ([splitString containsString:@"}"]) {
            NSArray *subSplitArray = [splitString componentsSeparatedByString:@"}"];
            if (subSplitArray.count > 0) {
                [result addObject:subSplitArray[0]];
            }
        }
    }
    
    return (NSArray *)result;
}

- (NSArray *)optionsArrayForSelectorKey:(NSString *)selectorKey {
    NSArray *options = [[NSMutableArray alloc] initWithArray: self.selectorDictionary[selectorKey][@"options"]];
    
    options = [options sortedArrayUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
        if ([obj1[0] intValue] == 0) {
            return [[obj1[0] lowercaseString] compare:[obj2[0] lowercaseString]];
        }
        else if ([obj1[1] intValue] > 0) {
            if ([obj1[1] intValue]==[obj2[1] intValue])
                return NSOrderedSame;
            else if ([obj1[1] intValue]<[obj2[1] intValue])
                return NSOrderedAscending;
            else
                return NSOrderedDescending;
        }
        else {
            if ([obj1[0] intValue]==[obj2[0] intValue])
                return NSOrderedSame;
            else if ([obj1[0] intValue]<[obj2[0] intValue])
                return NSOrderedAscending;
            else
                return NSOrderedDescending;
        }
    }];
    
    return options;
}

- (NSString *)optionsTypeForSelectorKey:(NSString *)selectorKey {
    return self.selectorDictionary[selectorKey][@"type"];
}

- (void)configurSelectionDictionariesForExistinRuleContext:(NSDictionary *)contextDictionary {
    if (contextDictionary) {
        self.selectedValueDictionary = [NSMutableDictionary dictionaryWithDictionary:contextDictionary];
        
        for (NSString *selectorKey in self.selectedValueDictionary.allKeys) {
            NSString *selectedOptionValue = self.selectedValueDictionary[selectorKey];
            NSArray *optionsArray = [self optionsArrayForSelectorKey:selectorKey];
            if (optionsArray.count > 0) {
                for (NSArray *optionValues in [self optionsArrayForSelectorKey:selectorKey]) {
                    if (optionValues.count >= 2) {
                        if ([optionValues[1] isEqualToString:selectedOptionValue]) {
                            [self.selectedKeyDictionary setObject:optionValues[0]
                                                           forKey:selectorKey];
                            break;
                        }
                    }
                }
            }
            else if ([selectorKey isEqualToString:@"timerange"]) {
                [self.selectedKeyDictionary setObject:[self timeRangeKeyForValue:selectedOptionValue]
                                               forKey:selectorKey];
            }
            else {
                if ([selectedOptionValue isKindOfClass:[NSString class]]) {
                    if ([self optionValueIsDevice:selectedOptionValue]) {
                        DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:selectedOptionValue];
                        
                        if (deviceModel) {
                            NSString *deviceName = [deviceModel getName];
                            if (deviceName) {
                                [self.selectedKeyDictionary setObject:deviceName
                                                               forKey:selectorKey];
                            }
                        }
                    }
                    else if ([self optionValueIsPerson:selectedOptionValue]) {
                        PersonModel *personModel = (PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:selectedOptionValue];
                        
                        if (personModel) {
                            NSString *personName = personModel.fullName;
                            if (personName) {
                                [self.selectedKeyDictionary setObject:personName
                                                               forKey:selectorKey];
                            }
                        }
                    }
                    else {
                        [self.selectedKeyDictionary setObject:selectedOptionValue
                                                       forKey:selectorKey];
                    }
                }
                else {
                    [self.selectedKeyDictionary setObject:selectedOptionValue forKey:selectorKey];
                }
            }
        }
    }
}

- (BOOL)optionValueIsDevice:(NSString *)optionValue {
    BOOL isDevice = NO;
    
    if ([optionValue containsString:DeviceCapability.namespace]) {
        isDevice = YES;
    }
    
    return isDevice;
}

- (BOOL)optionValueIsPerson:(NSString *)optionValue {
    BOOL isPerson = NO;
    
    if ([optionValue containsString:[PersonService address]]) {
        isPerson = YES;
    }
    
    return isPerson;
}

- (NSString *)timeRangeKeyForValue:(NSString *)timeRange {
    NSString *result;
    
    if (timeRange) {
        if ([timeRange isEqualToString:@"00:00:00 - 23:59:59"]) {
            result = NSLocalizedString(@"All Day", nil);
        }
        else {
            NSArray *startEndComponents = [timeRange componentsSeparatedByString:@" - "];
            if (startEndComponents.count == 2) {
                NSString *startString;
                NSString *endString;
                
                NSArray *startComponents = [startEndComponents[0] componentsSeparatedByString:@":"];
                if (startComponents.count >= 2) {
                    NSDate *startDate = [NSDate dateWithTimeInHour:[startComponents[0] intValue]
                                                          withMins:[startComponents[1] intValue]];
                    startString = [startDate formatDateTimeStamp];
                }
                
                NSArray *endComponents = [startEndComponents[1] componentsSeparatedByString:@":"];
                if (endComponents.count >= 2) {
                    NSDate *endDate = [NSDate dateWithTimeInHour:[endComponents[0] intValue]
                                                        withMins:[endComponents[1] intValue]];
                    endString = [endDate formatDateTimeStamp];
                }
                
                if (startString && endString) {
                    result = [NSString stringWithFormat:@"%@ - %@", startString, endString];
                }
            }
        }
    }
    
    return result;
}

@end
