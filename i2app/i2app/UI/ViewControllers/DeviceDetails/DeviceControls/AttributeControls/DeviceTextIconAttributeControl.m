//
//  DeviceTextIconAttributeControl.m
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
#import "DeviceTextIconAttributeControl.h"
#import <PureLayout/PureLayout.h>

@interface DeviceTextIconAttributeControl()

@property (strong, nonatomic) UIImageView *iconView;

@end

@implementation DeviceTextIconAttributeControl {
}

+ (DeviceTextIconAttributeControl *)create:(NSString *)title withValue:(NSString *)value andIcon:(UIImage *)icon {
    DeviceTextIconAttributeControl *control = [[DeviceTextIconAttributeControl alloc] init];
    [control setTitle:[FontData getString:[NSLocalizedString(title, nil) uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
    [control setValue:[FontData getString:value withFont:FontDataTypeDeviceStatus]];
    control.iconView = [[UIImageView alloc] initWithImage:icon];
    
    return control;
}

- (void)initializeDisplay {
    [super initializeDisplay];
    
    [self addSubview:_iconView];

    if (self.valueLabel.text.length > 0) {
      [self.iconView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.valueLabel withOffset:-40];
      [self.iconView autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self.valueLabel withOffset:-5];
    } else {
      [self.iconView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.valueLabel withOffset:47];
      [self.iconView autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self.valueLabel withOffset:0];
    }
}

- (void)setTitleText:(NSString *)title {
    [self setTitle:[FontData getString:[NSLocalizedString(title, nil) uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
}

- (void)setValueText:(NSString *)value {
    [self setValue:[FontData getString:value withFont:FontDataTypeDeviceStatus]];
}

- (void)setValue:(NSString *)value withIcon:(UIImage *)icon {
    [self setValue:[FontData getString:value withFont:FontDataTypeDeviceStatus]];
    [self.iconView setImage:icon];
}


@end
