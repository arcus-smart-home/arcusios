

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ProductCatalogService.h"
#import <i2app-Swift.h>

@implementation ProductCatalogService
+ (NSString *)name { return @"ProductCatalogService"; }
+ (NSString *)address { return @"SERV:prodcat:"; }


+ (PMKPromise *) getProductCatalogWithPlace:(NSString *)place {
  return [ProductCatalogServiceLegacy getProductCatalog:place];

}


+ (PMKPromise *) getCategoriesWithPlace:(NSString *)place {
  return [ProductCatalogServiceLegacy getCategories:place];

}


+ (PMKPromise *) getBrandsWithPlace:(NSString *)place {
  return [ProductCatalogServiceLegacy getBrands:place];

}


+ (PMKPromise *) getProductsByBrandWithPlace:(NSString *)place withBrand:(NSString *)brand withHubrequired:(BOOL)hubrequired {
  return [ProductCatalogServiceLegacy getProductsByBrand:place brand:brand hubrequired:hubrequired];

}

+ (PMKPromise *) getProductsByBrandWithPlace:(NSString *)place withBrand:(NSString *)brand {
  return [ProductCatalogServiceLegacy getProductsByBrand:place brand:brand];
  
}


+ (PMKPromise *) getProductsByCategoryWithPlace:(NSString *)place withCategory:(NSString *)category {
  return [ProductCatalogServiceLegacy getProductsByCategory:place category:category];

}


+ (PMKPromise *) getProductsWithPlace:(NSString *)place withInclude:(NSString *)include withHubRequired:(BOOL)hubRequired {
  return [ProductCatalogServiceLegacy getProducts:place include:include hubRequired:hubRequired];

}

+ (PMKPromise *) getProductsWithPlace:(NSString *)place withInclude:(NSString *)include {
  return [ProductCatalogServiceLegacy getProducts:place include:include];
  
}


+ (PMKPromise *) findProductsWithPlace:(NSString *)place withSearch:(NSString *)search {
  return [ProductCatalogServiceLegacy findProducts:place search:search];

}


+ (PMKPromise *) getProductWithPlace:(NSString *)place withId:(NSString *)id {
  return [ProductCatalogServiceLegacy getProduct:place id:id];

}

@end
