//
//  ArcusBorderedImageView.m
//  i2app
//
//  Created by Arcus Team on 1/12/16.
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
#import "ArcusBorderedImageView.h"

@interface ArcusBorderedImageView ()

@property(nonatomic) UIImageView *imageView;

@end


@implementation ArcusBorderedImageView


#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
    
    self.backgroundColor = [UIColor clearColor];
}


#pragma mark - Setters
- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imageView setImage:image];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    [super setContentMode:contentMode];
    self.imageView.contentMode = contentMode;
}

- (void)setBorderedModeEnabled:(BOOL)borderedModeEnabled {
    _borderedModeEnabled = borderedModeEnabled;
    [self setNeedsLayout];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = MAX(borderWidth, 0);
    [self setNeedsLayout];
}


#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.width/2;
    CGFloat imageViewWidth;
    CGFloat imageViewHeight;
    
    if (self.borderedModeEnabled) {
        imageViewWidth = self.bounds.size.width - (self.borderWidth * 2) + 1;
        imageViewHeight = self.bounds.size.height - (self.borderWidth * 2) + 1;
        self.layer.borderWidth = self.borderWidth;
    } else {
        imageViewWidth = self.bounds.size.width;
        imageViewHeight = self.bounds.size.height;
        self.layer.borderWidth = 0;
    }
    
    self.imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeight);
    self.imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.width/2;
}

@end
