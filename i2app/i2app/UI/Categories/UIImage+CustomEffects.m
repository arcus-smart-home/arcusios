//
//  UIImage+CustomEffects.m
//  i2app
//
//  Created by Arcus Team on 10/6/19.
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

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import "UIImage+CustomEffects.h"
@implementation UIImage (CustomEffects)

- (UIImage *)invertColor {
    @autoreleasepool {
        // UIImage is not guarenteed to have a CIImage representation, convert it.
        CIImage *coreImage = [CIImage imageWithCGImage:self.CGImage];

        CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
        [filter setValue:coreImage forKey:kCIInputImageKey];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        UIImage *outputImg = [UIImage imageWithCIImage:result];

        return outputImg;
    }
}

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    return nil;
}

- (CGImageRef)imageRotatedByDegrees:(CGFloat)degrees {
    return nil;
}

+ (UIImage *)imageFromLayer:(CALayer *)layer {
    return nil;
}

- (UIImage *)convertImageToGrayScale {
    return nil;
}

- (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage {
    return nil;
}

@end
