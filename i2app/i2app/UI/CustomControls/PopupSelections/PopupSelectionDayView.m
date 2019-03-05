//
//  PopupSelectionDayView.m
//  i2app
//
//  Created by Arcus Team on 8/18/15.
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
#import "PopupSelectionDayView.h"
#import "NSDate+Convert.h"

@interface PopupSelectionDayView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *dataPicker;
@property (nonatomic, strong) NSCalendar *calendar;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *titleString;
@property (nonatomic) NSInteger numberOfDay;

@end

@implementation PopupSelectionDayView {
    NSInteger _defaultDayOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleLabel styleSetWithSpace:_titleString andFontSize:14 bold:YES upperCase:YES];
    self.calendar = [NSCalendar currentCalendar];
    
}

+ (PopupSelectionDayView *)create:(NSString *)title withNumberOfDay:(NSInteger)days {
    PopupSelectionDayView *selection = [[PopupSelectionDayView alloc] initWithNibName:@"PopupSelectionDayView" bundle:nil];
    selection.titleString = title;
    selection.numberOfDay = days;
    
    return selection;
}


- (PopupSelectionDayView *)setDefaultDayFromNow:(NSInteger)numberOfDay {
    _defaultDayOffset = numberOfDay;
    return self;
}

#pragma mark - Auxiliary Functions
- (NSDate *)getDate:(NSInteger)addDays {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    components.day += addDays;
    NSDate *date = [self.calendar dateFromComponents:components];
    return date;
}

- (NSString *)getDateStr:(NSInteger)addDays {
    NSDate *date = [self getDate:addDays];
    return [date formatDate:@"EEE MMM d"];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _numberOfDay;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    NSString *date;
    if (row == 0) {
        date = @"Today";
    }
    else if (row == 1) {
        date = @"Yesterday";
    }
    else {
        date = [self getDateStr:-row];
    }
    
    [lblDate setAttributedText:
        [[NSAttributedString alloc] initWithString:date attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)} ]];
    
    lblDate.textAlignment = NSTextAlignmentCenter;
    
    return lblDate;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}


#pragma mark - PickerDelegate
- (void)initializePicker {
    if (_defaultDayOffset < _numberOfDay) {
        [_dataPicker selectRow:_defaultDayOffset inComponent:0 animated:YES];
    }
}

- (NSObject *)getSelectedValue {
    NSInteger selectedRow = [_dataPicker selectedRowInComponent:0];
    return [self getDate:-selectedRow];
}


@end
