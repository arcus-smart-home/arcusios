//
//  DeviceRunningAttributeControl.m
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
#import "DeviceRunningAttributeControl.h"

@implementation DeviceRunningAttributeControl

+ (DeviceRunningAttributeControl *)createWithContinueMins:(NSInteger)mins power:(double)power {
    DeviceRunningAttributeControl *control = [[DeviceRunningAttributeControl alloc] init];
    
    [control setMins:mins];
    [control setPower:power];
    
    return control;
}

// For now, the time is not available
- (void)setMins:(NSInteger)mins {
    // For now, the time is not supported, so we are just going to display "ENERGY" instead
    //[self setTitle:[FontData getString:[NSString stringWithFormat:@"%ld MIN",(long)mins] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
    [self setTitle:[FontData getString:NSLocalizedString(@"ENERGY", nil) withFont:FontDataType_DemiBold_12_WhiteAlpha]];
}

- (void)setPower:(double)power {
    [self setValue:[FontData getString:[NSString stringWithFormat:@"%.1lf", power] andString2:@" W" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
}

@end
