//
//  SettablePromise.m
//  PromisePlay
//
//  Created by Arcus Team on 5/5/15.
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
#import "SettablePromise.h"

@interface PromiseHolder : NSObject

@property (nonatomic,strong) PMKFulfiller fulfiller;
@property (nonatomic,strong) PMKRejecter rejecter;

@end

@implementation PromiseHolder

@end

@interface SettablePromise()

@property (nonatomic, strong) PromiseHolder *holder;

@end

@implementation SettablePromise

+ (instancetype)new {
    PromiseHolder *holder = [[PromiseHolder alloc] init];
    __block SettablePromise *this = [SettablePromise new:^(PMKFulfiller fulfiller, PMKRejecter rejecter) {
        holder.fulfiller = fulfiller;
        holder.rejecter = rejecter;
    }];
    
    this.holder = holder;
    return this;
}

- (void) setValue:(id)value {
    if (self.holder.fulfiller) {
        @synchronized(self) {
            self.holder.fulfiller(value);
            self.holder.fulfiller = nil;
        }
    }
}

- (void) setError:(NSError *)err {
    self.holder.rejecter(err);
}

@end
