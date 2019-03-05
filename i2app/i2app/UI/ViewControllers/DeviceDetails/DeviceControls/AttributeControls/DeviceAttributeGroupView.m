//
//  DeviceAttributeGroupView.m
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
#import "DeviceAttributeGroupView.h"
#import "DeviceAttributeItemBaseControl.h"
#import <PureLayout/PureLayout.h>

@implementation DeviceAttributeGroupView

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) loadControl:(DeviceAttributeItemBaseControl *)control {
    [self loadControl:control control2:nil control3:nil];
}

- (void) loadControl:(DeviceAttributeItemBaseControl *)control control2:(DeviceAttributeItemBaseControl *)control2 {
    [self loadControl:control control2:control2 control3:nil];
}

- (void) loadControl:(DeviceAttributeItemBaseControl *)control control2:(DeviceAttributeItemBaseControl *)control2 control3:(DeviceAttributeItemBaseControl *)control3 {
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self removeAllSubViews];
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
    if (control && control2 && control3) {
        if (IS_IPHONE_5) {
            [control setWidth:110.0f];
            [control2 setWidth:110.0f];
            [control3 setWidth:110.0f];
        }
        else {
            [control setWidth:120.0f];
            [control2 setWidth:120.0f];
            [control3 setWidth:120.0f];
        }
        [control2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
        [control autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:control2 withOffset:.0f];
        [control3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:control2 withOffset:.0f];
    }
    else if (control && control2) {
        [control autoConstrainAttribute:ALAttributeTrailing toAttribute:ALAttributeVertical ofView:self withOffset:-5];
        [control2 autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeVertical ofView:self withOffset:5];
    }
    else if (control) {
        [control autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
        [control setWidth:self.bounds.size.width];
    }
}

- (void)removeAllSubViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
