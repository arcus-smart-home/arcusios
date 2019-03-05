//
//  DeviceBatteryAttributeControl.m
//  i2app
//
//  Created by Arcus Team on 7/6/15.
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
#import "DevicePercentageAttributeControl.h"

@interface DevicePercentageAttributeControl ()

@property (nonatomic) BOOL enableOKStatus;

@end

@implementation DevicePercentageAttributeControl

+ (DevicePercentageAttributeControl *)createWithPercentage:(CGFloat)percent title:(NSString *)title {
    DevicePercentageAttributeControl *control = [[DevicePercentageAttributeControl alloc] init];
    [control setTitle:[FontData getString:[title uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
    
    if (percent < 0) {
        [control setValue:[FontData getString:@"-" andString2:@" %" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
    }
    else {
        [control setValue:[FontData getString:[NSString stringWithFormat:@"%d", (int)roundf(percent)] andString2:@" %" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
    }
    return control;
}

+ (DevicePercentageAttributeControl *)createWithBatteryPercentage:(CGFloat)percent {
    NSString *titleText = NSLocalizedString(@"battery", nil);
    
    if (percent < 30) {
        DevicePercentageAttributeControl *control = [self createWithPercentage:percent title:titleText];
        control.enableOKStatus = YES;
        return control;
    }
    else {
        DevicePercentageAttributeControl *control = [[DevicePercentageAttributeControl alloc] init];
        [control setTitle:[FontData getString:[titleText uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
        [control setValue:[FontData getString:@"OK" withFont:FontDataTypeDeviceStatus]];
        control.enableOKStatus = YES;
        return control;
    }
}


- (void)setText:(NSString *)title {
    [self setTitle:[FontData getString:[title uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
}

- (void)setPercentage:(CGFloat)percent {
    if (percent == NSNotFound) {
        [self setValue:[FontData getString:@"-" andString2:@" %" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
        return;
    }
    
    float b = roundf(percent);
    
    if (self.enableOKStatus && b > 30) {
        [self setValue:[FontData getString:@"OK" withFont:FontDataTypeDeviceStatus]];
    }
    else {
        [self setValue:[FontData getString:[NSString stringWithFormat:@"%d", (int)b] andString2:@" %" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
    }
}

@end
