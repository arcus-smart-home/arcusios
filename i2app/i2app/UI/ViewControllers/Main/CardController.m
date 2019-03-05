// 
// CardController.m
//
// Created by Arcus Team on 3/18/16.
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
#import "CardController.h"
#import "Card.h"

@interface CardController()

@property (weak, nonatomic) id<CardControllerCallback> callback;
@property (strong, nonatomic) Card *internalCard;

@end

@implementation CardController

- (instancetype)initWithCallback:(id<CardControllerCallback>)delegate {
    self = [super init];
    if (self) {
        _callback = delegate;
    }
    return self;
}

- (id)getCard {
    return _internalCard;
}

- (void)setCard:(id)card {
    _internalCard = card;

    if (_callback != nil) {
        [_callback updateCards:self];
    }
}

- (id<CardControllerCallback>)getCallback {
    return _callback;
}

- (void)setCallback:(id<CardControllerCallback>)delegate {
    _callback = delegate;
}

- (void)removeCallback {
    _callback = nil;
}

@end
