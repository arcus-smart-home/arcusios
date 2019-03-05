//
//  CareBehaviorTemplateModel.m
//  i2app
//
//  Created by Arcus Team on 2/5/16.
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
#import "CareBehaviorTemplateModel.h"

@implementation CareBehaviorTemplateModel

#pragma mark - Class helpers
+ (NSArray *)fieldsWithLabels:(NSDictionary *)labels
                 descriptions:(NSDictionary *)descriptions
                        units:(NSDictionary *)units
               possibleValues:(NSDictionary *)possibleValues {
    
    NSMutableArray *fields = [NSMutableArray array];
    
    for (NSString *key in labels.keyEnumerator) {
        CareBehaviorField *field = [[CareBehaviorField alloc] initWithName:labels[key]
                                                               description:descriptions[key]
                                                                      unit:units[key]
                                                            possibleValues:possibleValues[key]
                                                                       key:key];
        [fields addObject:field];
    }
    
    return fields;
}

#pragma mark - Init
- (instancetype)initWithDictionary:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.name = attributes[@"name"];
        self.templateDescription = attributes[@"description"];
        self.templateIdentifier = attributes[@"id"];
        self.fields = [[self class] fieldsWithLabels:attributes[@"fieldLabels"]
                                        descriptions:attributes[@"fieldDescriptions"]
                                               units:attributes[@"fieldUnits"]
                                      possibleValues:attributes[@"fieldValues"]];
        self.availableDevices = attributes[@"availableDevices"];
        self.type = [CareBehaviorEnums behaviorTypeForString:attributes[@"type"]];
    }
    return self;
}

@end
