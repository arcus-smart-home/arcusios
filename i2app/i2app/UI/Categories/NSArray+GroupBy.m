//
//  NSArray+GroupBy.m
//  i2app
//
//  Created by Arcus Team on 6/3/15.
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
#import "NSArray+GroupBy.h"

@implementation NSArray (GroupBy)

/// Return a dictionary of NSMutableArrays
- (NSDictionary *)groupArrayIntoDictionary:(id<NSCopying>(^)(id object))keyFromObjectCallback {
    NSParameterAssert(keyFromObjectCallback);
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    id keyType = (NSArray<NSCopying> *)keyFromObjectCallback(self[0]);
    
    if ([keyType isKindOfClass:[NSArray class]]) {
        // Keys are in an array
        for (id object in self) {
            NSArray<NSCopying> *keys = (NSArray<NSCopying> *)keyFromObjectCallback(object);
            for (NSString *key in keys) {
                NSMutableArray *array = [result objectForKey:key];
                if (array == nil) {
                    array = [NSMutableArray new];
                    [result setObject:array forKey:key];
                }
                [array addObject:object];
            }
        }
    }
    else if ([keyType isKindOfClass:[NSString class]]) {
        // There is only one key
        for (id object in self) {
            id<NSCopying> key = keyFromObjectCallback(object);
            NSMutableArray *array = [result objectForKey:key];
            if (array == nil) {
                array = [NSMutableArray new];
                [result setObject:array forKey:key];
            }
            [array addObject:object];
        }
    }
    return [result copy];
}

- (id) getFirstOrNil: (bool (^)(id x))block {
    id element;
    for (element in self) {
        if (block(element)) {
            return element;
        }
    }
    return nil;
}

@end
