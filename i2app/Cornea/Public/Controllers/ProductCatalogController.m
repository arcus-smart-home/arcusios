//
//  ProductCatalogController.m
//  Pods
//
//  Created by Arcus Team on 6/2/15.
//
//

#import <i2app-Swift.h>
#import "ProductCatalogController.h"
#import "ProductCatalogService.h"

#import "Capability.h"
#import "DeviceController.h"
#import "DeviceProductCatalog.h"



#import <i2app-Swift.h>

@implementation ProductCatalogController

static NSMutableDictionary *_productsByCategory;
static NSMutableDictionary *_productsByBrand;


+ (void)initialize {
    _productsByCategory = [NSMutableDictionary new];
    _productsByBrand = [NSMutableDictionary new];
}

+ (PMKPromise *)getProductModels {
    return [ProductCatalogService getProductsWithPlace:[[[[CorneaHolder shared] settings] currentPlace] address]
                                           withInclude:@"ALL" withHubRequired:false]
    .thenInBackground(^(ProductCatalogServiceGetProductCatalogResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSArray *products = [response attributes][@"products"];
            if (products.count > 0) {
                for (NSDictionary *attribs in products) {
                    if (attribs.count > 0) {
                        ProductModel *product = [[ProductModel alloc] initWithAttributes:attribs];
                        [[[CorneaHolder shared] modelCache] addModel:product];
                    }
                }
                fulfill([[[CorneaHolder shared] modelCache] fetchModels:[ProductCapability namespace]]);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"Arcus" code:301 userInfo:@{NSLocalizedDescriptionKey : @"No attributes"}];
                reject(error);
            }
        }];
    });
}

+ (PMKPromise *)getProductsByCategoryWithCategory:(NSString *)category {
    // First check if they have already been retrieved and cached
    NSDictionary *products = _productsByCategory[category];
    if (products.count > 0) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(products);
        }];
    }

    return [ProductCatalogService getProductsByCategoryWithPlace:[[[[CorneaHolder shared] settings] currentPlace] address]
                                                    withCategory:category]
    .thenInBackground(^(ProductCatalogServiceGetProductsByCategoryResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *products = [response attributes][@"products"];
            if (products.count > 0) {
                NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:products.count];
                for (NSDictionary *deviceDict in products) {
                    DeviceProductCatalog *device = [[DeviceProductCatalog alloc] initWithJson:deviceDict];
                    [mutArray addObject:device];
                }
                [_productsByCategory setObject:mutArray.copy forKey:category];
                fulfill(mutArray.copy);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"Arcus" code:302 userInfo:@{NSLocalizedDescriptionKey : @"No attributes"}];
                reject(error);
            }
        }];
    });
}

+ (PMKPromise *)getCategoriesOnModel  {
    
    return [ProductCatalogService getCategoriesWithPlace:[[[[CorneaHolder shared] settings] currentPlace] address]]
    .thenInBackground(^(ProductCatalogServiceGetCategoriesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *attributes = [response attributes];
            if (attributes.count > 0) {
                fulfill(attributes);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"Arcus" code:303 userInfo:@{NSLocalizedDescriptionKey : @"No attributes"}];
                reject(error);
            }
        }];
    });
}

+ (PMKPromise *)getBrandsOnModel {
    return [ProductCatalogService getBrandsWithPlace:[[[[CorneaHolder shared] settings] currentPlace] address]]
    .thenInBackground(^(ProductCatalogServiceGetBrandsResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *attributes = [response attributes];
            if (attributes.count > 0) {
                fulfill(attributes);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"Arcus" code:304 userInfo:@{NSLocalizedDescriptionKey : @"No attributes"}];
                reject(error);
            }
        }];
    });
}

+ (PMKPromise *)getProductsByBrandWithBrand:(NSString *)brand {
    // First check if they have already been retrieved and cached
    NSDictionary *products = _productsByBrand[brand];
    if (products.count > 0) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(products);
        }];
    }

    return [ProductCatalogService getProductsByBrandWithPlace:[[[[CorneaHolder shared] settings] currentPlace] address]
                                                    withBrand:brand withHubrequired:false]
    .thenInBackground(^(ProductCatalogServiceGetProductsByBrandResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *products = [response attributes][@"products"];
            if (products.count > 0) {
                NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:products.count];
                for (NSDictionary *deviceDict in products) {
                    DeviceProductCatalog *device = [[DeviceProductCatalog alloc] initWithJson:deviceDict];
                    [mutArray addObject:device];
                }
                [_productsByBrand setObject:mutArray.copy forKey:brand];
                fulfill(mutArray.copy);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"Arcus" code:305 userInfo:@{NSLocalizedDescriptionKey : @"No attributes"}];
                reject(error);
            }
        }];
    });
}

+ (PMKPromise *)findProductsWithSearch:(NSString *)search {
    
    return [ProductCatalogService findProductsWithPlace:[[[[CorneaHolder shared] settings] currentPlace] address]
                                             withSearch:search].thenInBackground(^(ProductCatalogServiceFindProductsResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *categories = [response attributes][@"products"];
            if (categories.count > 0) {
                fulfill(categories);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"Arcus" code:306 userInfo:@{NSLocalizedDescriptionKey : @"No attributes"}];
                reject(error);
            }
        }];
    });
}

+ (PMKPromise *)getProductWithId:(NSString *)productId {
    
    return [ProductCatalogService getProductWithPlace:[[[[CorneaHolder shared] settings] currentPlace] address]
                                               withId:productId].thenInBackground(^(ProductCatalogServiceGetProductResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSDictionary *categories = [response attributes][@"product"];
            
            if (categories.count > 0) {
                // Create ProductModel
                fulfill([[ProductModel alloc] initWithAttributes:[response attributes][@"product"]]);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"Arcus" code:307 userInfo:@{NSLocalizedDescriptionKey : @"No attributes"}];
                reject(error);
            }
        }];
    });
}

+ (NSString *)getProductCatalogImageBaseUrl {
    return [[CorneaHolder shared] session].sessionInfo.staticResourceBaseUrl;
}

@end
