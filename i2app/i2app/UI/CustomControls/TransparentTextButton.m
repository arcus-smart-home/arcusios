//
//  TransparentTextButton.m
//
//  Created by Arcus Team on 2/17/16.
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
#import "TransparentTextButton.h"
#import <QuartzCore/QuartzCore.h>

@interface TransparentTextButton () {
    UIColor     *_buttonColor;
}
@end

@implementation TransparentTextButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initForAutoLayout {
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults {
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self refreshMask];
}

#pragma mark - Dynamic Properties
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:[UIColor clearColor] forState:state];
}

- (void)setTitleLabelText:(NSString *)titleLabelText withFontSize:(float)fontSize {
    self.titleLabel.text = titleLabelText.uppercaseString;
    self.titleLabel.font = [UIFont fontWithName:kAvenirNextDemiBold size:fontSize];
    [self setNeedsLayout];
}

- (void)refreshMask {
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    CGSize buttonSize = self.bounds.size;    
    NSDictionary *attribs = @{NSFontAttributeName : self.titleLabel.font, NSKernAttributeName: @(2.0f)};
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:attribs];
    
    UIGraphicsBeginImageContextWithOptions(buttonSize, NO, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGPoint center = CGPointMake(buttonSize.width / 2 - textSize.width / 2, buttonSize.height / 2 - textSize.height / 2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, buttonSize.width, buttonSize.height + 3)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
    
    [self.titleLabel.text drawAtPoint:center withAttributes:attribs];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (__bridge id)(viewImage.CGImage);
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
}

@end
