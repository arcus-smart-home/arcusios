//
//  RuleDetailModel.h
//  i2app
//
//  Created by Arcus Team on 6/24/15.
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

typedef NS_OPTIONS(NSUInteger, RuleOccurType) {
    RuleOccurTypeMon = 1,
    RuleOccurTypeTue,
    RuleOccurTypeWed,
    RuleOccurTypeThu,
    RuleOccurTypeFri,
    RuleOccurTypeSat,
    RuleOccurTypeSun,
};

typedef NS_ENUM(NSInteger, RuleParamsType) {
    RuleParamsTypeUnknown,
    RuleParamsTypeTimeOfDay,
    RuleParamsTypeDayOfWeek,
    RuleParamsTypeDuration,
    RuleParamsTypeTimeRange,
    RuleParamsTypeText,
    RuleParamsTypeList,
};

#pragma mark - Occur model
@interface RuleOccurModel : NSObject

@property (nonatomic) RuleOccurType occurType;

@property (nonatomic) BOOL selected;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

- (instancetype)init:(RuleOccurType)type;
- (NSString *)getTypeString;
- (NSString *)getDateString;

@end


#pragma mark - Rule model
@interface RuleDetailModel : NSObject <NSCopying>

- (instancetype)initWithDictionary:(NSDictionary *)attributesDictionary;

@property (weak, nonatomic, readonly) NSString *name;
@property (weak, nonatomic, readonly) NSString *ruleDescription;
@property (atomic, readonly) BOOL satisfiable;
// [RuleOccurModel]
@property (strong, nonatomic) NSArray *occurs;

+ (RuleDetailModel *)createWithName:(NSString *)name description:(NSString *)description enable:(BOOL)enable;
+ (RuleDetailModel *)createWithName:(NSString *)name description:(NSString *)description;
- (RuleOccurModel *)getOccur:(RuleOccurType)type;
- (void)save:(RuleDetailModel *)model;

@end
