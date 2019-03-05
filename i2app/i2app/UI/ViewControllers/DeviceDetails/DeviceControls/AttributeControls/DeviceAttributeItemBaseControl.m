//
//  DisplayAttributeItemBaseControl.m
//  i2app
//
//  Created by Arcus Team on 7/2/15.
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
#import "DeviceAttributeItemBaseControl.h"
#import <PureLayout/PureLayout.h>

@interface DeviceAttributeItemBaseControl()

@end

@implementation DeviceAttributeItemBaseControl {
    NSLayoutConstraint *_widthConstraint;
    NSLayoutConstraint *_heightConstraint;
    
    UIView *divider;
}

@dynamic dividerView;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] initForAutoLayout];
        self.valueLabel = [[UILabel alloc] initForAutoLayout];
    }
    return self;
}

- (void)initializeDisplay {
    [self addSubview:self.titleLabel];
    [self addSubview:self.valueLabel];
    
    _widthConstraint = [self autoSetDimension:ALDimensionWidth toSize:120];
    _heightConstraint = [self autoSetDimension:ALDimensionHeight toSize:50];
    
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.titleLabel autoSetDimension:ALDimensionHeight toSize:21];
    
    divider = [[UIView alloc] initForAutoLayout];
    [divider setBackgroundColor:[UIColor whiteColor]];
    [divider setAlpha:0.4f];
    [divider setOpaque:YES];
    [self addSubview:divider];
    [divider autoSetDimensionsToSize:CGSizeMake(62, 1)];
    [divider autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    
    [divider setHidden:(!self.valueLabel.text)];
    
    if (IS_IPHONE_5) {
        [divider autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:3];
    }
    else {
        [divider autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:6];
    }
    
    [self.valueLabel setTextAlignment:NSTextAlignmentCenter];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    if (IS_IPHONE_5) {
        [self.valueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:divider withOffset:4];
    }
    else {
        [self.valueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:divider withOffset:8];
    }
    [self.valueLabel autoSetDimension:ALDimensionHeight toSize:21];
}

- (UIView *)dividerView {
    return divider;
}

- (void)setWidth:(CGFloat)width {
    _widthConstraint.constant = width;
}

- (void)setTitle:(NSAttributedString *)string {
    [self.titleLabel setAttributedText:string];
}

- (void)setValue:(NSAttributedString *)string {
    [self.valueLabel setAttributedText:string];
}


@end



