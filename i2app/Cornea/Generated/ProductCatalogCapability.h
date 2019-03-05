

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class ProductCatalogModel;

























/** Product catalog filename version */
extern NSString *const kAttrProductCatalogFilenameVersion;

/** Number of brand names in catalog */
extern NSString *const kAttrProductCatalogBrandCount;

/** Number of categories in catalog */
extern NSString *const kAttrProductCatalogCategoryCount;

/** Number of products in this catalog */
extern NSString *const kAttrProductCatalogProductCount;

/** Deprecated - publisher is used or updated */
extern NSString *const kAttrProductCatalogPublisher;

/** Deprecated - Version is now pulled from the filename */
extern NSString *const kAttrProductCatalogVersion;


extern NSString *const kCmdProductCatalogGetProductCatalog;

extern NSString *const kCmdProductCatalogGetCategories;

extern NSString *const kCmdProductCatalogGetBrands;

extern NSString *const kCmdProductCatalogGetProductsByBrand;

extern NSString *const kCmdProductCatalogGetProductsByCategory;

extern NSString *const kCmdProductCatalogGetProducts;

extern NSString *const kCmdProductCatalogGetAllProducts;

extern NSString *const kCmdProductCatalogFindProducts;

extern NSString *const kCmdProductCatalogGetProduct;




@interface ProductCatalogCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getFilenameVersionFromModel:(ProductCatalogModel *)modelObj;


+ (int)getBrandCountFromModel:(ProductCatalogModel *)modelObj;


+ (int)getCategoryCountFromModel:(ProductCatalogModel *)modelObj;


+ (int)getProductCountFromModel:(ProductCatalogModel *)modelObj;


+ (NSString *)getPublisherFromModel:(ProductCatalogModel *)modelObj;


+ (NSDate *)getVersionFromModel:(ProductCatalogModel *)modelObj;





/** Returns information about the product catalog for the context population. */
+ (PMKPromise *) getProductCatalogOnModel:(Model *)modelObj;



/** Returns a list of all the categories as a structure (name, image) referenced in this catalog as well as counts by category.  Nested catagories will be returned as fully qualified forward-slash delimited paths */
+ (PMKPromise *) getCategoriesOnModel:(Model *)modelObj;



/** Returns a list of all the brands referenced in this catalog where each is a structure containing (name, image, description).  In addition the counts of products by brand name are returned. */
+ (PMKPromise *) getBrandsOnModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) getProductsByBrandWithBrand:(NSString *)brand onModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) getProductsByCategoryWithCategory:(NSString *)category onModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) getProductsOnModel:(Model *)modelObj;



/** Gets all products including those that are not browseable. */
+ (PMKPromise *) getAllProductsOnModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) findProductsWithSearch:(NSString *)search onModel:(Model *)modelObj;



/**  */
+ (PMKPromise *) getProductWithId:(NSString *)id onModel:(Model *)modelObj;



@end
