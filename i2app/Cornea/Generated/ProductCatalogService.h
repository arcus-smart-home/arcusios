

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface ProductCatalogService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Returns information about the product catalog for the context population. */
+ (PMKPromise *) getProductCatalogWithPlace:(NSString *)place;



/** Returns a list of all the categories as a structure (name, image) referenced in this catalog as well as counts by category.  Nested catagories will be returned as fully qualified forward-slash delimited paths */
+ (PMKPromise *) getCategoriesWithPlace:(NSString *)place;



/** Returns a list of all the brands referenced in this catalog where each is a structure containing (name, image, description).  In addition the counts of products by brand name are returned. */
+ (PMKPromise *) getBrandsWithPlace:(NSString *)place;



/**  */
+ (PMKPromise *) getProductsByBrandWithPlace:(NSString *)place withBrand:(NSString *)brand withHubrequired:(BOOL)hubrequired;



/**  */
+ (PMKPromise *) getProductsByCategoryWithPlace:(NSString *)place withCategory:(NSString *)category;



/**  */
+ (PMKPromise *) getProductsWithPlace:(NSString *)place withInclude:(NSString *)include withHubRequired:(BOOL)hubRequired;



/**  */
+ (PMKPromise *) findProductsWithPlace:(NSString *)place withSearch:(NSString *)search;



/**  */
+ (PMKPromise *) getProductWithPlace:(NSString *)place withId:(NSString *)id;



@end
