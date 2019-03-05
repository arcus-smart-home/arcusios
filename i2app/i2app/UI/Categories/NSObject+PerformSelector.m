//
//  NSObject+PerformSelector.m
//  i2app
//
//  Created by Arcus Team on 2/29/16.
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
#import "NSObject+PerformSelector.h"

@implementation NSObject (PerformSelector)

- (void)performSelector:(SEL)selector withTarget:(NSObject *)target withObject:(id)arg1 withObject:(id)arg2;
 {
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation *delegateInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    [delegateInvocation setSelector:selector];
    [delegateInvocation setTarget:target];
    
    // remember the first two parameter are cmd and self
    if (arg1) {
        [delegateInvocation setArgument:&arg1 atIndex:2];
        
        if (arg2) {
            [delegateInvocation setArgument:&arg2 atIndex:3];
        }
    }
    [delegateInvocation invoke];
}
@end
