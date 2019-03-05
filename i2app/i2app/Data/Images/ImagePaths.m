//
//  ImagePaths.m
//  i2app
//
//  Created by Arcus Team on 7/14/15.
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

#import <i2app-Swift.h>
#import "ImagePaths.h"

#import "ProductCapability.h"

@implementation ImagePaths

static NSString *_formFactor;

+ (void)initialize {
    _formFactor = IS_IPHONE_6P ? @"3x" : @"2x";
}

+ (NSString *)devTypeHintToImageName:(NSString *)devTypeHint {
    return [[[devTypeHint stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] lowercaseString];
}

+ (NSString *)getProductImageFromProductId:(NSString *)productId isLarge:(BOOL)isLarge {
    return [NSString stringWithFormat:@"%@/o/products/%@/product_%@-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], productId, isLarge ? @"large" : @"small", _formFactor];
}

+ (NSString *)getSmallProductImageFromProductId:(NSString *)productId {
    // /products/{product_id}/product_small-{platform}-{density/resolution}.png
    return [NSString stringWithFormat:@"%@/o/products/%@/product_small-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], productId, _formFactor];
}

+ (NSString *)getLargeProductImageFromProductId:(NSString *)productId {
    // /products/{product_id}/product_large-{platform}-{density/resolution}.png
    return [NSString stringWithFormat:@"%@/o/products/%@/product_large-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], productId, _formFactor];
}

+ (NSString *)getProductImageFromDevTypeHint:(NSString *)devTypeHint isLarge:(BOOL)isLarge {
    //"/o/dtypes/{devTypeHint}/type_small-ios-2x.png"
    return [NSString stringWithFormat:@"%@/o/dtypes/%@/type_%@-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], [ImagePaths devTypeHintToImageName:devTypeHint], isLarge ? @"large" : @"small", _formFactor];
}


+ (NSString *)getSmallProductImageFromDevTypeHint:(NSString *)devTypeHint {
    //"/o/dtypes/{devTypeHint}/type_small-ios-2x.png"
    return [NSString stringWithFormat:@"%@/o/dtypes/%@/type_small-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], [ImagePaths devTypeHintToImageName:devTypeHint], _formFactor];
}

+ (NSString *)getLargeProductImageFromDevTypeHint:(NSString *)devTypeHint {
    return [NSString stringWithFormat:@"%@/o/dtypes/%@/type_large-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], [ImagePaths devTypeHintToImageName:devTypeHint], _formFactor];
}

+ (NSString *)getSmallBrandImage:(NSString *)brandName {
    brandName = [[brandName stringByTrimmingCharactersInSet:[NSCharacterSet alphanumericCharacterSet].invertedSet] lowercaseString];
    return [NSString stringWithFormat:@"%@/o/brands/%@/brand_small-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], brandName, _formFactor];
}

// Used in the footer of the Device Detail page
+ (NSString *)getDeviceBrandImage:(Model *)model {
    if (!model) {
        return [NSString stringWithFormat:@"%@/o/brands/uncertified/brand_small-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], _formFactor];
    }
    NSString *address = [(DeviceModel *)model address];
    ProductModel *product = (ProductModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    NSString *cert = [ProductCapability getCertFromModel:product];
    if ([model isKindOfClass:[HubModel class]] || (![cert isEqualToString:kEnumProductCertNONE] && product != nil)) {
        NSString *brandName = [[DeviceCapability getVendorFromModel:(DeviceModel *)product] stringByReplacingOccurrencesOfString:@" " withString:@""];
        brandName = [brandName stringByTrimmingCharactersInSet:[NSCharacterSet alphanumericCharacterSet].invertedSet].lowercaseString;
        return [NSString stringWithFormat:@"%@/o/brands/%@/brand_small-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], brandName, _formFactor];
    }
    else {
        return [NSString stringWithFormat:@"%@/o/brands/uncertified/brand_small-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], _formFactor];
    }
}

+ (NSString *)getPairingImage:(NSString *)productId forStep:(int)stepNumber {
    return [NSString stringWithFormat:@"%@/o/products/%@/pair/pair%d_large-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], productId, stepNumber, _formFactor];
}

+ (NSString *)getSceneActionImageUrl:(NSString *)actionHint {
    // return [NSString stringWithFormat:@"%@/o/products/%@/pair/pair%d_large-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], productId, stepNumber, _formFactor];
    return [NSString stringWithFormat:@"%@/o/actions/%@/%@_small-ios-%@.png", [ProductCatalogController getProductCatalogImageBaseUrl], actionHint, actionHint, _formFactor];
}


@end
