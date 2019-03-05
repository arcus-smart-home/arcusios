//
//  FavoriteController.h
//  Pods
//
//  Created by Arcus Team on 11/12/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const kFavoriteTag;

@class Model;

@interface FavoriteController : NSObject

+ (BOOL)modelIsFavorite:(Model *)model;
+ (void)model:(Model *)model isFavorite:(BOOL)isFavorite;
+ (void)toggleFavorite:(Model *)model;
+ (void)addFavoriteTag:(Model *)model;
+ (void)removeFavoriteTag:(Model *)model;

+ (NSMutableArray *)getAllFavoriteModels;

+ (PMKPromise *)addTag:(NSString *)tag onModel:(Model *)model;
+ (PMKPromise *)removeTag:(NSString *)tag onModel:(Model *)model;

@end
