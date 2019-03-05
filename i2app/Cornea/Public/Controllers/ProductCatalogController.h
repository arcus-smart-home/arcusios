//
//  ProductCatalogController.h
//  Pods
//
//  Created by Arcus Team on 6/2/15.
//
//

#import <Foundation/Foundation.h>

@class PMKPromise;

@interface ProductCatalogController : NSObject

+ (PMKPromise *)getProductModels;

+ (PMKPromise *)getProductsByCategoryWithCategory:(NSString *)category;

+ (PMKPromise *)getCategoriesOnModel;

+ (PMKPromise *)getBrandsOnModel;

+ (PMKPromise *)getProductsByBrandWithBrand:(NSString *)brand;

+ (PMKPromise *)findProductsWithSearch:(NSString *)search;

+ (PMKPromise *)getProductWithId:(NSString *)productId;

+ (NSString *)getProductCatalogImageBaseUrl;

@end
