//
//  FavoriteOrderedManager.h
//  i2app
//
//  Created by Arcus Team on 7/31/15.
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

@class Model;

@interface FavoriteSettingModel: NSObject<NSCoding>

@property (strong, nonatomic) NSString *address;

- (Model *)getModel;

@end

@interface FavoriteOrderedManager : NSObject

+ (FavoriteOrderedManager *) shareInstance;

- (void)listenNotification:(id)owner selector:(SEL)selector;
- (void)listenBlockNotification:(void (^)(NSNotification *note))block;
- (void)removeNotification:(id)owner;

- (NSString *)switchCardOrder:(NSInteger)originalLocation to:(NSInteger)newLocation;

- (NSArray <Model *>*)getCurrentFavorites;

- (NSInteger)getCount;

- (void)save;

- (FavoriteSettingModel *)getModelByIndex:(NSInteger)index;

- (void)removeFavoriteByIndex:(NSInteger)index;

@end
