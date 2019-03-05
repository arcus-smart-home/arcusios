//
//  FavoriteOrderedManager.m
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
#import "FavoriteOrderedManager.h"


#import "Capability.h"

#import "FavoriteController.h"
#import <i2app-Swift.h>

@interface FavoriteSettingModel()

@property (strong, nonatomic) Model *model;

@end

@implementation FavoriteSettingModel

- (instancetype)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        _model = nil;
        _address = address;
    }
    return self;
}

- (instancetype)initWithModel:(Model *)model {
    self = [super init];
    if (self) {
        _model = model;
        _address = model.address;
    }
    return self;
}

- (Model *)getModel {
    if (_model) {
        return _model;
    }
    else {
        if (self.address) {
            return [[[CorneaHolder shared] modelCache] fetchModel:self.address];
        }
        else {
            return nil;
        }
    }
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_address forKey:@"modelId"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [self init]) {
        self.address = [decoder decodeObjectForKey:@"modelId"];
    }
    return self;
}

@end

@implementation FavoriteOrderedManager {
    NSMutableArray *_favorites;
}

+ (FavoriteOrderedManager *) shareInstance {
    static dispatch_once_t pred = 0;
    __strong static FavoriteOrderedManager *_dictionary = nil;
    dispatch_once(&pred, ^{
        _dictionary = [[FavoriteOrderedManager alloc] init];
    });
    
    return _dictionary;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _favorites = [[NSMutableArray alloc] init];
        NSArray *favoriteModels = [self getSavedModels];
        NSMutableArray *favorites = [[NSMutableArray alloc] initWithArray:[FavoriteController getAllFavoriteModels]];

        for (FavoriteSettingModel *settingModel in favoriteModels) {
            for (Model *model in favorites) {
                if ([model.address isEqualToString:settingModel.address]) {
                    [_favorites addObject:[[FavoriteSettingModel alloc] initWithModel:model]];
                    [favorites removeObject:model];
                    break;
                }
            }
        }
        for (DeviceModel *model in favorites) {
            [_favorites addObject:[[FavoriteSettingModel alloc] initWithModel:model]];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatedFavorites:)
                                                     name:[Model tagChangedNotification:kFavoriteTag]
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removedDevice:)
                                                     name:Constants.kModelRemovedNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCaches:)
                                                     name:Constants.kAllUserStatesClearedNotification
                                                   object:nil];
    }
    return self;
}

- (void)save {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_favorites];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:@"favoriteOrderedArray"];
    [userDefaults synchronize];
}

- (NSArray *)getSavedModels {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:@"favoriteOrderedArray"];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return [NSArray new];
}

- (void)listenNotification:(id)owner selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:owner selector:selector name:Constants.kModelRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:owner selector:selector name:[Model tagChangedNotification:kFavoriteTag] object:nil];
}

- (void)listenBlockNotification:(void (^)(NSNotification *note))block {
    [[NSNotificationCenter defaultCenter] addObserverForName:Constants.kModelRemovedNotification object:nil queue:nil usingBlock:block];
    [[NSNotificationCenter defaultCenter] addObserverForName:[Model tagChangedNotification:kFavoriteTag] object:nil queue:nil usingBlock:block];
}

- (void)removeNotification:(id)owner {
    [[NSNotificationCenter defaultCenter] removeObserver:owner forKeyPath:Constants.kModelRemovedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:owner forKeyPath:[Model tagChangedNotification:kFavoriteTag]];
}

- (void)updatedFavorites:(NSNotification *)note {
    if ([note.object isKindOfClass:[NSMutableArray class]]) {
        [_favorites removeAllObjects];
        NSMutableArray *favorites = [[NSMutableArray alloc] initWithArray: note.object];
        
        // Put device to _favorites by order
        NSArray *favoriteModels = [self getSavedModels];
        for (FavoriteSettingModel *settingModel in favoriteModels) {
            for (Model *model in favorites) {
                if ([model.address isEqualToString:settingModel.address]) {
                    [_favorites addObject:[[FavoriteSettingModel alloc] initWithModel:model]];
                    [favorites removeObject:model];
                    break;
                }
            }
        }
        
        // Put rest devices to _favorites
        for (DeviceModel *model in favorites) {
            [_favorites addObject:[[FavoriteSettingModel alloc] initWithModel:model]];
        }
        
    }
    else if ([note.userInfo objectForKey:@"Model"] && [note.userInfo[@"Model"] isKindOfClass:[DeviceModel class]]) {
      DeviceModel *device = note.userInfo[@"Model"];
      
      if ([FavoriteController modelIsFavorite:device]) {
        if ([self isFavoriteContains:device]) {
          for (FavoriteSettingModel *settingModel in _favorites) {
            if ([settingModel.address isEqualToString:device.address]) {
              [_favorites removeObject:settingModel];
              return;
            }
          }
        }
      } else {
        if  (![self isFavoriteContains:device]) {
          [_favorites addObject:[[FavoriteSettingModel alloc] initWithModel:device]];
        }
        
      }
    }
    else if ([note.userInfo objectForKey:@"Model"] && [note.userInfo[@"Model"] isKindOfClass:[SceneModel class]]) {
        SceneModel *scene = note.userInfo[@"Model"];
        
        if ([FavoriteController modelIsFavorite:scene]) {
            if  (![self isFavoriteContains:scene]) {
                [_favorites addObject:[[FavoriteSettingModel alloc] initWithModel:scene]];
            }
        }
        else {
            if  ([self isFavoriteContains:scene]) {
                for (FavoriteSettingModel *settingModel in _favorites) {
                    if ([settingModel.address isEqualToString:scene.address]) {
                        [_favorites removeObject:settingModel];
                        return;
                    }
                }
            }
        }
    }
}

- (void)removedDevice:(NSNotification *)notification {
    NSString *removedAddr = [(Model*)[notification object] address];
  
    for (FavoriteSettingModel *settingModel in _favorites) {
        if ([settingModel.address isEqualToString:removedAddr]) {
            [_favorites removeObject:settingModel];
            [self save];
            break;
        }
    }
}

- (void)clearCaches:(NSNotification *)notification {
  dispatch_sync(dispatch_get_main_queue(), ^{
    [_favorites removeAllObjects];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"favoriteOrderedArray"];
    [userDefaults synchronize];
  });
}

- (BOOL)isFavoriteContains:(Model *)model {
    for (FavoriteSettingModel *settingModel in _favorites) {
        if ([settingModel.address isEqualToString:model.address]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)switchCardOrder:(NSInteger)originalLocation to:(NSInteger)newLocation {
    NSString *modelAddress;
    if (_favorites.count > originalLocation && _favorites.count > newLocation) {
        FavoriteSettingModel *item = _favorites[originalLocation];
        [_favorites removeObjectAtIndex:originalLocation];
        [_favorites insertObject:item atIndex:newLocation];
        modelAddress = [item getModel].address;
    }
    else {
        modelAddress  = @"";
        DDLogWarn(@"Switch card error");
    }
    return modelAddress;
}

- (FavoriteSettingModel *)getModelByIndex:(NSInteger)index {
    if (_favorites.count > index) {
        return [_favorites objectAtIndex:index];
    }
    else {
        return nil;
    }
}

- (void)removeFavoriteByIndex:(NSInteger)index {
    if (_favorites.count > index) {
        FavoriteSettingModel *settingModel = [_favorites objectAtIndex:index];
        __block DeviceModel *model = (DeviceModel *)[settingModel getModel];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [FavoriteController removeTag:kFavoriteTag onModel:model].thenInBackground(^{

                [ArcusAnalytics tag:AnalyticsTags.DashboardSettingsFavoritesEditRemove attributes:@{ AnalyticsTags.TargetAddressKey : [model address] }];
            });
        });
        [_favorites removeObject:settingModel];
    }
}

- (NSArray <Model *>*)getCurrentFavorites {
    return _favorites.copy;
}

- (NSInteger)getCount {
    return _favorites.count;
}

@end
