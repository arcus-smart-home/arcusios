//
//  RuleDetailModel.m
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

#import <i2app-Swift.h>
#import "RuleDetailModel.h"
#import "NSDate+Convert.h"

#pragma mark - Occur model
@implementation RuleOccurModel

- (instancetype)init:(RuleOccurType)type {
    if (self = [super init]) {
        self.occurType = type;
        self.selected = YES;
    }
    return self;
}

- (NSString *)getTypeString {
    switch (self.occurType) {
        case RuleOccurTypeMon:
            return @"MONDAY";
        case RuleOccurTypeTue:
            return @"TUESDAY";
        case RuleOccurTypeWed:
            return @"WEDNESDAY";
        case RuleOccurTypeThu:
            return @"THURSDAY";
        case RuleOccurTypeFri:
            return @"FRIDAY";
        case RuleOccurTypeSat:
            return @"SATURDAY";
        case RuleOccurTypeSun:
            return @"SUNDAY";
        default:
            break;
    }
}

- (NSString *)getDateString {
    if (!self.startTime && !self.endTime) return @"All Day";
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *start = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self.startTime?self.startTime:[NSDate date2000Year]];
    NSDateComponents *end = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self.endTime?self.endTime:[NSDate date2000Year]];
    
    if (start.hour == end.hour && start.minute == end.minute) {
        return @"All Day";
    }
    else {
        NSString *startStr = [NSString stringWithFormat:@"%ld",(long)(start.hour % 12)];
        if (start.minute > 0) {
            startStr = [startStr stringByAppendingFormat:@":%02ld", (long)start.minute];
        }
        startStr = [startStr stringByAppendingString:((start.hour < 12)?@"AM":@"PM")];
        
        NSString *endStr = [NSString stringWithFormat:@"%ld",(long)(end.hour % 12)];
        if (end.minute > 0) {
            endStr = [endStr stringByAppendingFormat:@":%02ld", (long)end.minute];
        }
        endStr = [endStr stringByAppendingString:((end.hour < 12)?@"AM":@"PM")];
        
        return [NSString stringWithFormat:@"%@-%@",startStr,endStr];
    }
}
@end


#pragma mark - Rule model
@interface RuleDetailModel ()

@property (strong, nonatomic) NSDictionary *attributesDictionary;

@end

@implementation RuleDetailModel {
    NSString *_defaultName;
    NSString *_defaultDescription;
    BOOL _defaultSatisfiable;
}

@dynamic name;
@dynamic ruleDescription;
@dynamic satisfiable;

+ (RuleDetailModel *)createWithName:(NSString *)name description:(NSString *)description enable:(BOOL)enable {
    RuleDetailModel *model = [[RuleDetailModel alloc] initWithName:name description:description statisfiable:enable];
    return model;
}

+ (RuleDetailModel *)createWithName:(NSString *)name description:(NSString *)description {
    RuleDetailModel *model = [[RuleDetailModel alloc] initWithName:name description:description statisfiable:YES];
    return model;
}

- (instancetype)initWithName:(NSString *)name description:(NSString *)description statisfiable:(BOOL)staticsfiable {
    if (self = [super init]) {
        _defaultName = name;
        _defaultDescription = description;
        _defaultSatisfiable = staticsfiable;
        
        self.occurs = @[[[RuleOccurModel alloc] init:RuleOccurTypeMon],
                        [[RuleOccurModel alloc] init:RuleOccurTypeTue],
                        [[RuleOccurModel alloc] init:RuleOccurTypeWed],
                        [[RuleOccurModel alloc] init:RuleOccurTypeThu],
                        [[RuleOccurModel alloc] init:RuleOccurTypeFri],
                        [[RuleOccurModel alloc] init:RuleOccurTypeSat],
                        [[RuleOccurModel alloc] init:RuleOccurTypeSun]];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)attributesDictionary {
    if (self = [super init]) {
        self.attributesDictionary = attributesDictionary;
        
        self.occurs = @[ [[RuleOccurModel alloc] init:RuleOccurTypeMon],
                         [[RuleOccurModel alloc] init:RuleOccurTypeTue],
                         [[RuleOccurModel alloc] init:RuleOccurTypeWed],
                         [[RuleOccurModel alloc] init:RuleOccurTypeThu],
                         [[RuleOccurModel alloc] init:RuleOccurTypeFri],
                         [[RuleOccurModel alloc] init:RuleOccurTypeSat],
                         [[RuleOccurModel alloc] init:RuleOccurTypeSun]];
    }
    return self;
}

#pragma mark - dynamic properties
- (NSString *)name {
    if (_defaultName) return _defaultName;
    else return @"Not available yet in platform";
}

- (NSString *)ruleDescription {
    if (self.attributesDictionary[@"ruletmpl:template"]) return self.attributesDictionary[@"ruletmpl:template"];
    else return _defaultDescription;
}

- (BOOL)satisfiable {
    if (self.attributesDictionary[@"ruletmpl:satisfiable"]) return [self.attributesDictionary[@"ruletmpl:template"] boolValue];
    else return  _defaultSatisfiable;
}

- (RuleOccurModel *)getOccur:(RuleOccurType)type {
    for (RuleOccurModel *item in self.occurs) {
        if (item.occurType == type) return item;
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    RuleDetailModel *another;
    if (self.attributesDictionary) {
        another = [[RuleDetailModel alloc] initWithDictionary:self.attributesDictionary];
    }
    else {
        another = [[RuleDetailModel alloc] initWithName:_defaultName description:_defaultDescription statisfiable:_defaultSatisfiable];
    }
//    another.name = [self.name copyWithZone: zone];
//    another.ruleDescription = [self.ruleDescription copyWithZone: zone];
//    another.satisfiable = self.satisfiable;
    another.occurs = [self.occurs copyWithZone: zone];
    
    return another;
}

- (void)save:(RuleDetailModel *)model {
    //TODO:
//    self.name = model.name;
//    self.ruleDescription = model.ruleDescription;
//    self.satisfiable = model.satisfiable;
    self.occurs = model.occurs;
}


@end




