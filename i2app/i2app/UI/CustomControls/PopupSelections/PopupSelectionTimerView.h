//
//  PopupSelectionTimerView.h
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

#import "PopupSelectionBaseContainer.h"

typedef enum {
    TimerStyleHoursAndMinutes       = 0,
    TimerStyleHoursOnly             = 3,
    TimerStyle4HoursOnly            = 5,
    TimerStyleDayHoursAndMinutes    = 7,
    TimerStyleSunrise               = 11,
    TimerStyleSunset                = 22,
    TimerStyleNone
    
} TimerStyleType;

@interface PopupSelectionTimerView : PopupSelectionBaseContainer

+ (PopupSelectionTimerView *)create:(NSString *)title;
+ (PopupSelectionTimerView *)create:(NSString *)title withTimerStyle:(TimerStyleType)style;
+ (PopupSelectionTimerView *)create:(NSString *)title withDate:(NSDate *)date;
+ (PopupSelectionTimerView *)create:(NSString *)title withDate:(NSDate *)date timerStyle:(TimerStyleType)style;

@property (strong, nonatomic) NSDate *initialDate;

@property (nonatomic) TimerStyleType timerStyle;

// Used by derived classes
- (void)initializeCurrentPicker:(TimerStyleType)style;
- (void)initializeCurrentPicker;

@property (nonatomic, strong) UIView<CustomTimePicker> *picker;

@end
