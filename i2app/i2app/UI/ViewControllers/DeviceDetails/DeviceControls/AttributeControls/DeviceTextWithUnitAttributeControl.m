//
//  DeviceTextWithUnitAttributeControl.m
//  i2app
//
//  Created by Arcus Team on 7/28/15.
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
#import "DeviceTextWithUnitAttributeControl.h"

@implementation DeviceTextWithUnitAttributeControl {
    NSString *_unit;
}

+ (DeviceTextWithUnitAttributeControl *)create:(NSString *)title withValue:(NSString *)value andUnit:(NSString *)unit {
    DeviceTextWithUnitAttributeControl *control = [[DeviceTextWithUnitAttributeControl alloc] init];
    
    [control setTitle:[FontData getString:[NSLocalizedString(title, nil) uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
    [control setValue:[FontData getString:value andString2:[NSString stringWithFormat:@" %@",unit] withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
    
    return control;
}

- (void)setTitleText:(NSString *)title {
    [self setTitle:[FontData getString:[NSLocalizedString(title, nil) uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
}

- (void)setValueText:(NSString *)value {
    if (_unit) {
        [self setValue:[FontData getString:value andString2:[NSString stringWithFormat:@" %@",_unit] withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
    }
    else {
        [self setValue:[FontData getString:value withFont:FontDataTypeDeviceStatus]];
    }
}

- (void)setValueText:(NSString *)value withUnit:(NSString *)unit {
    _unit = unit;
    [self setValue:[FontData getString:value andString2:[NSString stringWithFormat:@" %@",unit] withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];

}

@end
