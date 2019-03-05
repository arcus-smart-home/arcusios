//
//  UIImage+ScaleSize.m
//  i2app
//
//  Created by Arcus Team on 6/8/15.
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
#import "UIImage+ScaleSize.h"
#import <i2app-Swift.h>

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage(ScaleSize)


#pragma mark - Images from names
+ (UIImage *)getImage:(NSString *)imageName andScale:(CGSize)size {
    if (!imageName) {
        DDLogWarn(@"**** ERROR - image name is nil");
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        DDLogWarn(@"**** ERROR - cannot find the image");
        return nil;
    }
    
    return [image scaleImageToSize:size];
}

+ (UIImage *)getImageScaleToWindowSize:(NSString *)imageName {
    return [self getImage:imageName andScale:((AppDelegate *)[UIApplication sharedApplication].delegate).window.bounds.size];
}

+ (UIImage *)getImage:(NSString *)imageName cutAndScaleTo:(CGSize)size {
    if (!imageName) {
        DDLogWarn(@"**** ERROR - image name is nil");
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        DDLogWarn(@"**** ERROR - cannot find the image");
        return nil;
    }
    
    //Crop to square, assumes taller than wide
    CGRect rect = CGRectMake(0, (image.size.height-image.size.width) / 2, image.size.width, image.size.width);
    image = [image cutImage:rect];
    
    CGSize _size = CGSizeMake(size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(_size, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0, 0, _size.width, _size.height)];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

+ (UIImage *)image:(NSString *)imageName withCut:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image cutImage:rect];
}


#pragma mark - Scaling
- (UIImage *)scaleImageToSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, (self.size.height - self.size.width) / 2, self.size.width, self.size.width);
    UIImage *image = [self cutImage:rect];
    
    CGSize _size = CGSizeMake(size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(_size, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0, 0, _size.width, _size.height)];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

//Fills image
- (UIImage *)scaleImageToFillSize:(CGSize)size {
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    CGFloat rx = imageWidth/size.width;
    CGFloat ry = imageHeight/size.height;
    
    CGFloat ratio = MIN(rx, ry);

    CGSize sizeToShowAt = CGSizeMake(self.size.width / ratio, self.size.height / ratio);
    
    UIGraphicsBeginImageContextWithOptions(sizeToShowAt, NO, [[UIScreen mainScreen] scale]);
    [self drawInRect:CGRectMake(0, 0, sizeToShowAt.width, sizeToShowAt.height)];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}


#pragma mark - Cropping
- (UIImage *)cutImage:(CGRect) rect {
    CGRect fromRect = CGRectMake(rect.origin.x * self.scale,
                                 rect.origin.y * self.scale,
                                 rect.size.width * self.scale,
                                 rect.size.height * self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, fromRect);
    UIImage *crop = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return crop;
}

- (UIImage *)cutImageInCenter:(CGSize)size {
    CGRect rect = CGRectMake((self.size.width - size.width) / 2, (self.size.height - size.height) / 2, size.width, size.height);
    return [self cutImage:rect];
}


#pragma mark - Scale & Crop
- (UIImage *)exactZoomScaleAndCutSizeInCenter:(CGSize)size {
    UIImage *image;
    float verticalRatio = size.height*1.0/self.size.height;
    float horizontalRatio = size.width*1.0/self.size.width;
    
    float ratio = MIN(verticalRatio, horizontalRatio);
    CGFloat width = self.size.width*ratio;
    CGFloat height = self.size.height*ratio;
    CGSize scaledSize = CGSizeMake(width,height);
    image = [self scaleImageToSize:scaledSize];
    image = [image cutImageInCenter:size];
    
    return image;
}

- (UIImage *)backgroundZoomScaleAndCutSizeInCenter:(CGSize)size {
    
    UIImage *image;
    
    if (self.size.width > self.size.height) {
        CGFloat dashboardScale = self.size.height / size.height;
        CGSize scaledSize = CGSizeMake((size.width<self.size.width)?(self.size.width/dashboardScale):(self.size.width*dashboardScale), size.height);
        if (scaledSize.width < size.width) {
            scaledSize.width = size.width;
        }
        image = [self scaleImageToSize:scaledSize];
    }
    else {
        CGFloat dashboardScale = self.size.width / size.width;
        CGSize scaledSize = CGSizeMake(size.width, (size.height<self.size.height)?(self.size.height/dashboardScale):(self.size.height*dashboardScale));
        if (scaledSize.height < size.height) {
            scaledSize.height = size.height;
        }
        image = [self scaleImageToSize:scaledSize];
    }
    image = [image cutImageInCenter:size];
    
    return image;
}


#pragma mark - Round images
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh / 2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw / 2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh / 2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw / 2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh / 2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)roundCornerImageWithsize:(CGSize)size {
    return [self roundCornerImageWithsize:size radius:size.width / 2];
}

- (UIImage *)roundCornerImageWithsize:(CGSize)size radius:(float)radius {
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    CGRect rect = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contextRef);
    addRoundedRectToPath(contextRef, rect, radius, radius);
    CGContextClosePath(contextRef);
    CGContextClip(contextRef);
    
    [self drawInRect:rect];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

- (UIImage *)roundCornerImageNoAspectChange {
    UIImage *roundedImage = self.copy;
    
    CGFloat minSide = MIN(self.size.width, self.size.height);
    CGRect rect = CGRectMake(0, 0, minSide, minSide);
    
    UIGraphicsBeginImageContextWithOptions(roundedImage.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:minSide/2] addClip];
    [roundedImage drawInRect:rect];
    roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

- (UIImage *)setAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
