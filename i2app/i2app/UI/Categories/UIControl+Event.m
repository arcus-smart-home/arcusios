//
//  UIControl+Event.m
//  i2app
//
//  Created by Arcus Team on 7/11/15.
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
#import <objc/runtime.h>
#import "UIControl+Event.h"

@interface BlockWrapper : NSObject

@property (readwrite, nonatomic) void *block;
@property (strong, nonatomic) id arg;

- (BlockWrapper *)init:(void *)block;
- (BlockWrapper *)init:(void *)block withObj:(id)obj;

- (void)execute;
- (void)execute:(id)obj;

@end

@implementation UIControl (A_Extension)

static char _associatedObjectKey;

- (void)eventAdd:(void (^)(id sender, id param))handler withObj:(id)arg forControlEvents:(UIControlEvents)controlEvents {
    NSParameterAssert(handler);
    
    NSMutableDictionary *events = objc_getAssociatedObject(self, &_associatedObjectKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &_associatedObjectKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    
    BlockWrapper *block = [[BlockWrapper alloc] init:(__bridge void *)(handler) withObj:arg];
    [handlers addObject:block];
    [self addTarget:block action:@selector(execute:) forControlEvents:controlEvents];
}

- (void)eventAdd:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents {
    NSParameterAssert(handler);
    
    NSMutableDictionary *events = objc_getAssociatedObject(self, &_associatedObjectKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &_associatedObjectKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    
    BlockWrapper *block = [[BlockWrapper alloc] init:(__bridge void *)(handler)];
    
    [handlers addObject:block];
    [self addTarget:block action:@selector(execute:) forControlEvents:controlEvents];
}

- (void)eventRemove:(UIControlEvents)controlEvent {
    NSMutableDictionary *events = objc_getAssociatedObject(self, &_associatedObjectKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &_associatedObjectKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvent);
    NSSet *handlers = events[key];
    
    if (!handlers)
        return;
    
    [handlers enumerateObjectsUsingBlock:^(id sender, BOOL *stop) {
        [self removeTarget:sender action:NULL forControlEvents:controlEvent];
    }];
    
    [events removeObjectForKey:key];
}

- (void)eventOnClick:(void (^)(id sender, id param))event withObj:(id)arg {
    [self eventAdd:event withObj:arg forControlEvents:UIControlEventTouchUpInside];
}

- (void)eventOnClick:(void (^)(id sender))event {
    [self eventAdd:event forControlEvents:UIControlEventTouchUpInside];
}

- (void)eventRemoveClick {
    [self eventRemove:UIControlEventTouchUpInside];
}

- (void)dealloc {
    NSMutableDictionary *events = objc_getAssociatedObject(self, &_associatedObjectKey);
    if (events) {
        events = nil;
    }
}

@end

@implementation BlockWrapper

- (BlockWrapper *) init:(void *)block {
    if ((self = [super init])) {
        self.block = block;
    }
    return self;
}

- (BlockWrapper *)init:(void *)block withObj:(id)obj {
    if ((self = [super init])) {
        self.block = block;
        self.arg = obj;
    }
    return self;
}

- (void)execute {
    if (self.block) {
        @synchronized(self) {
            ((void (^)(id arg))self.block)(self.arg);
        }
    }
}

- (void)execute:(id)obj {
    if (self.block) {
        @synchronized(self) {
            ((void (^)(id obj,id arg))self.block)(obj, self.arg);
        }
    }
}

- (void)dealloc {
    [self setBlock:nil];
    [self setArg:nil];
}

@end
