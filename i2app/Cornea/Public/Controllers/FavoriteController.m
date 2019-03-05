//
//  FavoriteController.m
//  Pods
//
//  Created by Arcus Team on 11/12/15.
//
//

#import <i2app-Swift.h>
#import "FavoriteController.h"
#import "Capability.h"



#import "ClientRequest.h"
#import "ClientEvent.h"

#import <PromiseKit/PromiseKit.h>

NSString *const kFavoriteTag = @"FAVORITE";

@implementation FavoriteController

#pragma mark - Favorite

+ (BOOL)modelIsFavorite:(Model *)model {
    BOOL isFavorite = NO;
    
    for (NSString *tag in model.tags) {
        if ([tag isEqualToString:kFavoriteTag]) {
            isFavorite = YES;
            break;
        }
    }
    
    return isFavorite;
}

+ (void)model:(Model *)model isFavorite:(BOOL)isFavorite {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (isFavorite) {
            if (![self modelIsFavorite:model]) {
                [self addTag:kFavoriteTag onModel:model];
            }
        }
        else {
            if ([self modelIsFavorite:model]) {
                [self removeTag:kFavoriteTag onModel:model];
            }
        }
    });
}

+ (void)toggleFavorite:(Model *)model {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self modelIsFavorite:model]) {
            [self removeTag:kFavoriteTag onModel:model];
        }
        else {
            [self addTag:kFavoriteTag onModel:model];
        }
    });
}

+ (void)addFavoriteTag:(Model *)model {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self addTag:kFavoriteTag onModel:model];
  });
}

+ (void)removeFavoriteTag:(Model *)model {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self removeTag:kFavoriteTag onModel:model];
  });
}


+ (NSMutableArray *)getAllFavoriteModels {
    NSMutableArray *favoriteModels = [[NSMutableArray alloc] init];
    for (Model *device in [[[CorneaHolder shared] modelCache] fetchModels:[DeviceCapability namespace]]) {
        if ([self modelIsFavorite:device]) {
            [favoriteModels addObject:device];
        }
    }
    for (Model *scene in [[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]]) {
        if ([self modelIsFavorite:scene]) {
            [favoriteModels addObject:scene];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[Model tagChangedNotification:kFavoriteTag] object:favoriteModels];
    
    return favoriteModels;
}

#pragma mark - Add/Remove Tag
+ (PMKPromise *)addTag:(NSString *)tag onModel:(Model *)model {
    if (model) {
        NSMutableArray *tags = model.tags.mutableCopy;
        [tags addObject:tag];
        
        return [model addTags:tags.copy].thenInBackground(^(ClientEvent *event) {
            return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
                fulfill(event);
            }];
        });
    }
    else {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) { }];
    }
}

+ (PMKPromise *)removeTag:(NSString *)tag onModel:(Model *)model {
    return [model removeTags:@{ @"tags": @[tag] }].thenInBackground(^(ClientEvent *event) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(event);
        }];
    });
}



@end
