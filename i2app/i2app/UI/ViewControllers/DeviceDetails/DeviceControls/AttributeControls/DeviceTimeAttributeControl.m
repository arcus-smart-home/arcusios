//
//  DeviceTimeAttributeControl.m
//  i2app
//
//  Created by Arcus Team on 7/19/15.
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
#import "DeviceTimeAttributeControl.h"
#import "NSDate+Convert.h"

@implementation DeviceTimeAttributeControl

+ (DeviceTimeAttributeControl *)create {
    
    DeviceTimeAttributeControl *control = [[DeviceTimeAttributeControl alloc] init];
    [control setTitle:[FontData getString:@"-" withFont:FontDataType_DemiBold_12_WhiteAlpha]];
    [control setDateTime:nil andState:@"-"];
    
    return control;
}


+ (DeviceTimeAttributeControl *)createWithDate:(NSDate *)date withState:(NSString *)state {
    
    DeviceTimeAttributeControl *control = [[DeviceTimeAttributeControl alloc] init];
    [control setTitle:[FontData getString:[NSLocalizedString(state, nil) uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
    [control setDateTime:date andState:state];
    
    return control;
}

- (void)setDateTime:(NSDate *)date andState:(NSString *)state {
    [self setTitle:[FontData getString:[NSLocalizedString(state, nil) uppercaseString] withFont:FontDataType_DemiBold_12_WhiteAlpha]];
    
    if (date && date.timeIntervalSince1970 > NSTimeIntervalSince1970) {
        // calculate whether to display days since last state change or time
        if ([[NSCalendar currentCalendar] isDateInToday:date]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh:mm"];
            
            NSDateFormatter *checkDate = [[NSDateFormatter alloc] init];
            [checkDate setDateFormat:@"HH"];
            
            NSString *check = [checkDate stringFromDate:date];
            NSString *time = [dateFormatter stringFromDate:date];
            
            if ([check integerValue] >= 12) {
                [self setValue:[FontData getString:time andString2:@" PM" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
            }
            else {
                [self setValue:[FontData getString:time andString2:@" AM"  withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
            }
        }
        else if ([[NSCalendar currentCalendar] isDateInYesterday:date]) {
            [self setValue:[FontData getString:@"YESTERDAY" withFont:FontDataTypeDeviceStatus]];
        }
        else {
            [self setValue:[FontData getString:[date formatDateStampWithYear] withFont:FontDataTypeDeviceStatus]];
        }
    }
    else {
        [self setValue:[FontData getString:@"-" withFont:FontDataTypeDeviceStatus]];
    }
}

@end
