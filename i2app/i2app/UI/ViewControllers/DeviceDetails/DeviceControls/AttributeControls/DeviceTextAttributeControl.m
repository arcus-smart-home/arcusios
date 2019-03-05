//
//  DeviceTextAttributeControl.m
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
#import "DeviceTextAttributeControl.h"

@implementation DeviceTextAttributeControl

+ (DeviceTextAttributeControl *)create:(NSString *)title withValue:(NSString *)value {
    DeviceTextAttributeControl *control = [[DeviceTextAttributeControl alloc] init];
    [control setTitle:[FontData getString:[NSLocalizedString(title, nil) uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
    if (value != nil) {
        [control.dividerView setHidden:NO];
        [control setValue:[FontData getString:value withFont:FontDataTypeDeviceStatus]];
        
    }
    else {
        [control.dividerView setHidden:YES];
        [control setValueText:@""];
    }

    return control;
}

- (void)setTitleText:(NSString *)title {
    [self setTitle:[FontData getString:[NSLocalizedString(title, nil) uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
}

- (void)setValueText:(NSString *)value {
    if (value != nil) {
        [self.dividerView setHidden:NO];
        [self setValue:[FontData getString:value withFont:FontDataTypeDeviceStatus]];
    }
    else {
        [self.dividerView setHidden:YES];
        [self.valueLabel setText:@""];
    }
}


@end
