//
//  PopupSelectionTimerView.m
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
#import "PopupSelectionTimerView.h"
#import "CustomHoursTimePicker.h"
#import "CustomHoursAMPMTimePicker.h"
#import "CustomHoursOnlyPicker.h"
#import "CustomDayHoursMinutesPicker.h"
#import <PureLayout/PureLayout.h>

@interface PopupSelectionTimerView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *titleString;

@property (atomic, assign) BOOL is24HourTime;

@end

@implementation PopupSelectionTimerView

+ (PopupSelectionTimerView *)create:(NSString *)title {
    PopupSelectionTimerView *selection = [[PopupSelectionTimerView alloc] initWithNibName:@"PopupSelectionTimerView" bundle:nil];
    selection.titleString = title;
    
    return selection;
}

+ (PopupSelectionTimerView *)create:(NSString *)title withTimerStyle:(TimerStyleType) style {
    PopupSelectionTimerView *selection = [[PopupSelectionTimerView alloc] initWithNibName:@"PopupSelectionTimerView" bundle:nil];
    selection.titleString = title;
    selection.timerStyle = style;
    
    return selection; 
}

+ (PopupSelectionTimerView *)create:(NSString *)title withDate:(NSDate *)date {
    PopupSelectionTimerView *selection = [[PopupSelectionTimerView alloc] initWithNibName:@"PopupSelectionTimerView" bundle:nil];
    selection.titleString = title;
    selection.initialDate = date;
    selection.timerStyle = TimerStyleNone;
    
    return selection;
}

+ (PopupSelectionTimerView *)create:(NSString *)title withDate:(NSDate *)date timerStyle:(TimerStyleType) style {
    PopupSelectionTimerView *selection = [[PopupSelectionTimerView alloc] initWithNibName:@"PopupSelectionTimerView" bundle:nil];
    selection.titleString = title;
    selection.initialDate = date;
    selection.timerStyle = style;
    
    return selection;
}

- (instancetype)init {
    if (self = [super init]) {
        self.timerStyle = TimerStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeTime];
   
    [self initializeCurrentPicker];
}

- (void)initializeCurrentPicker {
    [self.titleLabel styleSetWithSpace:_titleString andFontSize:14 bold:YES upperCase:YES];
    
    switch (self.timerStyle) {
        case TimerStyleHoursAndMinutes:
            if (_is24HourTime) {
                _picker = [CustomHoursTimePicker new];
            }
            else {
                _picker = [CustomHoursAMPMTimePicker new];
            }
            break;
            
        case TimerStyleHoursOnly:
            if (_is24HourTime) {
                _picker = [CustomHoursOnlyPicker new];
            }
            else {
                _picker = [CustomHoursAMPMTimePicker new];
                [_picker setPickupHoursOnly:YES];
            }
            break;
            
        case TimerStyle4HoursOnly:
            _picker = [CustomHoursTimePicker new];
            break;
            
        case TimerStyleDayHoursAndMinutes: 
            _picker = [CustomDayHoursMinutesPicker new];
            break;
            
        default:
            break;
    }
    [self.view addSubview:_picker];
    
    [_picker autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:76];
    [_picker autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_picker autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_picker autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    if (_initialDate) {
        [_picker showDate:_initialDate];
    }
    [self.view layoutIfNeeded];
    [_picker initialize];
}

- (void)initializeCurrentPicker:(TimerStyleType)style {
    self.timerStyle = style;
    [_picker removeFromSuperview];
    
    [self initializeCurrentPicker];
}

- (void)initializeTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *dateString = [formatter stringFromDate:self.initialDate];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    
    _is24HourTime = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
}


#pragma mark - PickerDelegate
- (void)initializePicker {
    [_picker showDate];
}

- (NSObject *)getSelectedValue {
    return _picker.date;
}

@end
