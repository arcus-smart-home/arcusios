//
//  DeviceButtonFrameBtnControl.m
//  i2app
//
//  Created by Arcus Team on 1/13/16.
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
#import "DeviceButtonFrameBtnControl.h"
#import <PureLayout/PureLayout.h>

@interface DeviceButtonFrameBtnControl()

@property (assign, nonatomic) SEL selector;
@property (weak, nonatomic)   id  owner;

@end

@implementation DeviceButtonFrameBtnControl {
}

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
    
    [self autoSetDimensionsToSize:CGSizeMake(100, 40)];
    [self.button autoSetDimension:ALDimensionHeight toSize:21];
    [self.button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
    [self.button addTarget:self.owner action:self.selector forControlEvents:UIControlEventTouchUpInside];
}

+ (DeviceButtonFrameBtnControl *)create:(NSString *)text withSelector:(SEL)selector andOwner:(id)owner {
    DeviceButtonFrameBtnControl *control = [[DeviceButtonFrameBtnControl alloc] initForAutoLayout];
    control.button.layer.cornerRadius = 5.0f;
    control.button.layer.borderWidth = 1.0f;
    control.button.layer.borderColor = [UIColor whiteColor].CGColor;
    [control setText:text];
    
    control.selector = selector;
    control.owner = owner;
    
    return control;
}

- (void)setText:(NSString *)text {
    [self.button styleSet:[NSString stringWithFormat:@"  %@  ", text] andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:NO space:YES] upperCase:YES];
}

@end
