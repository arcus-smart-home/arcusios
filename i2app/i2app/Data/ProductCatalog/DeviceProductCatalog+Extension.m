//
//  DeviceProductCatalog+Extension.m
//  i2app
//
//  Created by Arcus Team on 6/4/15.
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
#import "DeviceProductCatalog+Extension.h"
#import "ProductCapability.h"
#import "Capability.h"
#import "ImagePaths.h"

@interface DeviceProductCatalog (Extension_Private)

@property (nonatomic, strong, readonly) NSDictionary *json;

@end

@implementation DeviceProductCatalog (Extension)

#pragma mark - Getting steps properies methods
- (NSString *)getImageURLFromPairingSteps:(NSInteger)stepNumber {
    NSString *productID = [self productId];
    return [ImagePaths getPairingImage:productID forStep:(int)stepNumber];
}

#pragma mark - Image Paths
- (NSString *)getSmallProductImageFromDevTypeHint {
    return [ImagePaths getSmallProductImageFromDevTypeHint:self.productScreen];
}

- (NSString *)getLargeProductImageFromDevTypeHint {
    return [ImagePaths getLargeProductImageFromDevTypeHint:self.productScreen];
}

- (BOOL)hubRequired {
    return [self.json[kAttrProductHubRequired] boolValue];
}

@end
