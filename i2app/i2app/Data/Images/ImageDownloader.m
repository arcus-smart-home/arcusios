//
//  ImageDownloader.m
//  i2app
//
//  Created by Arcus Team on 10/20/15.
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
#import "ImageDownloader.h"
#import "SDWebImageManager.h"
#import "UIImage+ImageEffects.h"

#import "DeviceCapability.h"

@implementation ImageDownloader

+ (PMKPromise *)downloadDeviceImage:(NSString *)productId
                      withDevTypeId:(NSString *)devTypeId
                    withPlaceHolder:(NSString *)placeholder
                            isLarge:(BOOL)isLarge
                       isBlackStyle:(BOOL)blackstyle {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject)
    {

        __block NSString *deviceProductWithHint = [NSString stringWithFormat:@"%@_%@_%@_%@", devTypeId, productId, blackstyle ? @"black" : @"white", isLarge ? @"large" : @"small"];
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:deviceProductWithHint];
        if (cachedImage) {
          fulfill(cachedImage);
          return;
        }
        __block NSString *urlString = [ImagePaths getProductImageFromProductId:productId
                                                                       isLarge:isLarge];

        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString]
                                                        options:0 progress:nil
                                                      completed:^(UIImage *image,
                                                                  NSError *error,
                                                                  SDImageCacheType cacheType,
                                                                  BOOL finished,
                                                                  NSURL *imageURL) {
            if (image) {
                if ((!isLarge && !blackstyle) || (isLarge && blackstyle)) {
                    image = [image invertColor];
                }
                [[SDImageCache sharedImageCache] storeImage:image forKey:deviceProductWithHint];
                fulfill(image);
            }
            else {
                // if there is no product image, we should get the generic category image
                urlString = [ImagePaths getProductImageFromDevTypeHint:devTypeId isLarge:isLarge];
                
                [[SDWebImageManager sharedManager]
                 downloadImageWithURL:[NSURL URLWithString:urlString]
                                                   options:0 progress:nil
                                                 completed:^(UIImage *image,
                                                              NSError *error,
                                                              SDImageCacheType cacheType,
                                                              BOOL finished,
                                                              NSURL *imageURL) {
                    if (image) {
                        if ((!isLarge && !blackstyle) || (isLarge && blackstyle)) {
                            image = [image invertColor];
                        }
                        [[SDImageCache sharedImageCache] storeImage:image forKey:deviceProductWithHint];
                        fulfill(image);
                    }
                    else {
                        reject(error);
                    }
                }];
            }
        }];
    }];
}


@end

