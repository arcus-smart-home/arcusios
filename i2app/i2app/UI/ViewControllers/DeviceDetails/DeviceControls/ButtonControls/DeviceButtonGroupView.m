//
//  DeviceButtonGroupView.m
//  i2app
//
//  Created by Arcus Team on 7/20/15.
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
#import "DeviceButtonGroupView.h"
#import <PureLayout/PureLayout.h>

@implementation DeviceButtonGroupView

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)loadControl:(DeviceButtonBase *)control {
    [self loadControl:control control2:nil control3:nil];
}

- (void)loadControl:(DeviceButtonBase *)control control2:(DeviceButtonBase *)control2  {
    [self loadControl:control control2:control2 control3:nil];
}

- (void)loadControl:(DeviceButtonBase *)control control2:(DeviceButtonBase *)control2 control3:(DeviceButtonBase *)control3 {
    if (control && control2 && control3) {
        [self loadControl:control control2:control2 control3:control3 withHorizSpacing:10.0];
    } else {
        [self loadControl:control control2:control2 control3:control3 withHorizSpacing:35.0];
    }
}

- (void)loadControl:(DeviceButtonBase *)control control2:(DeviceButtonBase *)control2 control3:(DeviceButtonBase *)control3 withHorizSpacing:(CGFloat) spacing {
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    for (UIView *item in self.subviews) {
        [item removeFromSuperview];
    }
    
    if (control) {
        [self addSubview:control];
        [control initializeDisplay];
        [control autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }
    if (control2) {
        [self addSubview:control2];
        [control2 initializeDisplay];
        [control2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }
    if (control3) {
        [self addSubview:control3];
        [control3 initializeDisplay];
        [control3 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }
    
    [self applyHorizontalSpacing:control control2:control2 control3:control3 horizSpacing:spacing];
}

- (void)applyHorizontalSpacing:(DeviceButtonBase *)control control2:(DeviceButtonBase *)control2 control3:(DeviceButtonBase *)control3 horizSpacing:(CGFloat) spacing {
    
    if (control && control2 && control3) {
        [control2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
        [control autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:control2 withOffset:spacing * -1];
        [control3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:control2 withOffset:spacing];
    }
    else if (control && control2) {
        [control autoConstrainAttribute:ALAttributeTrailing toAttribute:ALAttributeVertical ofView:self withOffset:spacing * -1];
        [control2 autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeVertical ofView:self withOffset:spacing];
    }
    else if (control) {
        [control autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    }
}

- (void)loadControl:(DeviceButtonBase *)control attributeControl:(DeviceAttributeItemBaseControl *)control2 control3:(DeviceButtonBase *)control3 withHorizSpacing:(CGFloat) spacing {
    [self setBackgroundColor:[UIColor clearColor]];
    
    for (UIView *item in self.subviews) {
        [item removeFromSuperview];
    }
    
    [self addSubview:control];
    [control initializeDisplay];
    [control autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    [self addSubview:control2];
    [control2 initializeDisplay];
    [control2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self addSubview:control3];
    [control3 initializeDisplay];
    [control3 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    [control autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    [control2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    [control3 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    
    [control2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [control autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:control2 withOffset:spacing * -1];
    [control3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:control2 withOffset:spacing];
}

@end
