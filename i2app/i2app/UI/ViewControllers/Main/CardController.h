// 
// CardController.h
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

#import <Foundation/Foundation.h>

@class CardController;
@class Card;

@protocol CardControllerCallback

- (void)updateCards:(nonnull CardController *)controller;

@end

@interface CardController: NSObject

- (nonnull instancetype)initWithCallback:(nullable id<CardControllerCallback>)delegate;
- (nullable Card*)getCard;
- (void)setCard:(nonnull Card *)card;
- (nullable id<CardControllerCallback>)getCallback;
- (void)setCallback:(nullable id<CardControllerCallback>)delegate;
- (void)removeCallback;

@end
