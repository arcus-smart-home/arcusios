//
//  DeviceButtonSwitch.m
//  i2app
//
//  Created by Arcus Team on 7/22/15.
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
#import "DeviceButtonSwitchControl.h"
#import <PureLayout/PureLayout.h>

@implementation DeviceButtonSwitchControl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return self;
}

- (void)initializeDisplay {
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.button];
    
    [self autoSetDimensionsToSize:CGSizeMake(85, 34)];
    [self.button autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.button autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.button autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

+ (DeviceButtonSwitchControl *)create:(buttonSwitchEventBlock)selectBlock withUnselect:(buttonSwitchEventBlock)unselectBlock {
    
    DeviceButtonSwitchControl *control = [[DeviceButtonSwitchControl alloc] initForAutoLayout];
    [control.button setImage:[UIImage imageNamed:@"switchButtonWhiteOff"] forState:UIControlStateNormal];
    [control.button setImage:[UIImage imageNamed:@"switchButtonWhiteOn"] forState:UIControlStateSelected];
    [control setButtonSelectEvent:selectBlock];
    [control setButtonUnselectEvent:unselectBlock];
    
    return control;
}

- (void)buttonPressed:(id)sender {
    if (self.button.selected) {
        if (self.buttonUnselectEvent) {
            if (self.buttonUnselectEvent(sender)) {
                [self.button setSelected:NO];
            }
        }
        else {
            [self.button setSelected:NO];
        }
    }
    else {
        if (self.buttonSelectEvent) {
            if (self.buttonSelectEvent(sender)) {
                [self.button setSelected:YES];
            }
        }
        else {
            [self.button setSelected:YES];
        }
    }
}

@end
