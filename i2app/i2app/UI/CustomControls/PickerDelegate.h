//
//  PickerDelegate.h
//  i2app
//
//  Created by Arcus Team on 12/18/15.
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

#import <Foundation/Foundation.h>
#import "ArcusDateTime.h"

@protocol PickerDelegate <NSObject>

@required
- (void)initializePicker;
- (NSObject *)getSelectedValue;

@end


@protocol CustomTimePicker

@required

- (void)initialize;
- (void)showDate;
- (void)showDate:(NSObject *)date;
- (void)valueChanged;

@optional
- (NSString *)getString;
- (NSNumber *)valueInSeconds;
- (NSNumber *)valueInMins;
- (NSNumber *)valueInHours;

@property (nonatomic, strong, readonly) NSDate *date;

// Same as the above NSDate *date, but it is used
// by the schedulers that support sunrise/sunset
@property (nonatomic, strong, readonly) ArcusDateTime *eventDateTime;

@property (nonatomic, assign) BOOL pickupHoursOnly;

@end

