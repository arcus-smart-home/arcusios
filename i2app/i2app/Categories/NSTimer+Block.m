//
// Created by Arcus Team on 2/7/16.
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
#import "NSTimer+Block.h"


@implementation NSTimer (Block)

- (instancetype)arcus_initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(void))block
{
    return [self initWithFireDate:date interval:seconds target:self.class selector:@selector(arcus_runBlock:) userInfo:block repeats:repeats];
}

+ (NSTimer *)arcus_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(void))block
{
    return [self scheduledTimerWithTimeInterval:seconds target:self selector:@selector(arcus_runBlock:) userInfo:block repeats:repeats];
}

+ (NSTimer *)arcus_timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(void))block
{
    return [self timerWithTimeInterval:seconds target:self selector:@selector(arcus_runBlock:) userInfo:block repeats:repeats];
}

+ (void)arcus_runBlock:(NSTimer *)timer
{
    if ([timer.userInfo isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        void (^block)(void) = timer.userInfo;
        block();
    }
}

@end
