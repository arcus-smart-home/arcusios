

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ProductCatalogCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrProductCatalogFilenameVersion=@"prodcat:filenameVersion";

NSString *const kAttrProductCatalogBrandCount=@"prodcat:brandCount";

NSString *const kAttrProductCatalogCategoryCount=@"prodcat:categoryCount";

NSString *const kAttrProductCatalogProductCount=@"prodcat:productCount";

NSString *const kAttrProductCatalogPublisher=@"prodcat:publisher";

NSString *const kAttrProductCatalogVersion=@"prodcat:version";


NSString *const kCmdProductCatalogGetProductCatalog=@"prodcat:GetProductCatalog";

NSString *const kCmdProductCatalogGetCategories=@"prodcat:GetCategories";

NSString *const kCmdProductCatalogGetBrands=@"prodcat:GetBrands";

NSString *const kCmdProductCatalogGetProductsByBrand=@"prodcat:GetProductsByBrand";

NSString *const kCmdProductCatalogGetProductsByCategory=@"prodcat:GetProductsByCategory";

NSString *const kCmdProductCatalogGetProducts=@"prodcat:GetProducts";

NSString *const kCmdProductCatalogGetAllProducts=@"prodcat:GetAllProducts";

NSString *const kCmdProductCatalogFindProducts=@"prodcat:FindProducts";

NSString *const kCmdProductCatalogGetProduct=@"prodcat:GetProduct";




@implementation ProductCatalogCapability
+ (NSString *)namespace { return @"prodcat"; }
+ (NSString *)name { return @"ProductCatalog"; }

+ (int)getFilenameVersionFromModel:(ProductCatalogModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCatalogCapabilityLegacy getFilenameVersion:modelObj] intValue];
  
}


+ (int)getBrandCountFromModel:(ProductCatalogModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCatalogCapabilityLegacy getBrandCount:modelObj] intValue];
  
}


+ (int)getCategoryCountFromModel:(ProductCatalogModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCatalogCapabilityLegacy getCategoryCount:modelObj] intValue];
  
}


+ (int)getProductCountFromModel:(ProductCatalogModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCatalogCapabilityLegacy getProductCount:modelObj] intValue];
  
}


+ (NSString *)getPublisherFromModel:(ProductCatalogModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCatalogCapabilityLegacy getPublisher:modelObj];
  
}


+ (NSDate *)getVersionFromModel:(ProductCatalogModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCatalogCapabilityLegacy getVersion:modelObj];
  
}




+ (PMKPromise *) getProductCatalogOnModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy getProductCatalog:modelObj ];
}


+ (PMKPromise *) getCategoriesOnModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy getCategories:modelObj ];
}


+ (PMKPromise *) getBrandsOnModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy getBrands:modelObj ];
}


+ (PMKPromise *) getProductsByBrandWithBrand:(NSString *)brand onModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy getProductsByBrand:modelObj brand:brand];

}


+ (PMKPromise *) getProductsByCategoryWithCategory:(NSString *)category onModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy getProductsByCategory:modelObj category:category];

}


+ (PMKPromise *) getProductsOnModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy getProducts:modelObj ];
}


+ (PMKPromise *) getAllProductsOnModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy getAllProducts:modelObj ];
}


+ (PMKPromise *) findProductsWithSearch:(NSString *)search onModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy findProducts:modelObj search:search];

}


+ (PMKPromise *) getProductWithId:(NSString *)id onModel:(ProductCatalogModel *)modelObj {
  return [ProductCatalogCapabilityLegacy getProduct:modelObj id:id];

}

@end
