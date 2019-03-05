//
// UpdateOperation.h
//
// Created by Arcus Team on 4/1/16.
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
#import "UpdateOperation.h"

@interface UpdateOperation()

@property (nonatomic, assign) BOOL _executing;
@property (nonatomic, assign) BOOL _finished;
@property (nonatomic, strong) NSProgress *progress;

@property (nonatomic, copy) AsyncBlock block;

@end

@implementation UpdateOperation

+ (instancetype)updateOperationWithAction:(AsyncBlock)action {
    return [[UpdateOperation alloc] initWithAction:action];
}

- (instancetype)initWithAction:(AsyncBlock)action {
    self = [super init];

    if (self != nil) {
        self.block = action;
    }

    return self;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return self._executing;
}

- (BOOL)isFinished {
    return self._finished;
}

- (NSProgress *)progress {
    if (_progress == nil) {
        _progress = [NSProgress progressWithTotalUnitCount:1];
    }
    
    return _progress;
}

- (void)start {
    [self willChangeValueForKey:@"isExecuting"];
    self._executing = YES;
    [self didChangeValueForKey:@"isExecuting"];

    self.block(^{
        [self willChangeValueForKey:@"isExecuting"];
        self._executing = NO;
        [self didChangeValueForKey:@"isExecuting"];

        [self willChangeValueForKey:@"isFinished"];
        self._finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    });
}

@end

@implementation NSOperationQueue (AsyncBlockOperation)

- (void)addUpdateOperationWithAction:(AsyncBlock)action {
    [self addOperation:[UpdateOperation updateOperationWithAction:action]];
}

@end
