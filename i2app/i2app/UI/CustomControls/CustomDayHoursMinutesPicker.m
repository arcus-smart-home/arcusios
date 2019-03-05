//
//  CustomDayHoursMinutesPicker.m
//  i2app
//
//  Created by Arcus Team on 3/1/16.
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
#import "CustomDayHoursMinutesPicker.h"
#import <PureLayout/PureLayout.h>

#define NUMBER_OF_DAYS 7
#define NUMBER_OF_HOURS 12
#define NUMBER_OF_MINUTES 60

#define DAY_COMPONENT_WIDTH 85
#define OTHER_COMPONENT_WIDTH 70
#define COLON_COMPONENT_WIDTH 10
#define AMPM_COMPONENT_WIDTH 30

#define AMPM_COMPONENT_HEIGHT 15
#define OTHER_COMPONENT_HEIGHT 55

typedef NS_ENUM(NSInteger, CustomDaysHoursMinutesComponent) {
    CustomDaysHoursMinutesComponentDay = 0,
    CustomDaysHoursMinutesComponentHour = 1,
    CustomDaysHoursMinutesComponentColon = 2,
    CustomDaysHoursMinutesComponentMinute = 3,
    CustomDaysHoursMinutesComponentAMPM = 4
};

@interface CustomDayHoursMinutesPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) NSCalendar *calendar;

@property (nonatomic, strong) NSDate *date;

@end


@implementation CustomDayHoursMinutesPicker {
    NSDictionary *_attributes;
    NSDictionary *_AMPMattributes;
}

- (instancetype)init {
    if (self = [super init]) {
        self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.calendar = [NSCalendar currentCalendar];
        
        self.date = [NSDate date];
        
        _attributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)};
        _AMPMattributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:10.0f], NSKernAttributeName: @(2.0f)};
        
        [self addSubview:self.picker];
        [_picker autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [_picker autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [_picker autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [_picker autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [_picker autoCenterInSuperview];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Picker methods
- (void)initialize {
    [self showDate];
    [self.picker reloadAllComponents];
}

- (void)showDate {
    NSDateComponents *components = [self.calendar
                                    components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekday
                                    fromDate:self.date];
    NSInteger selectedWeekdayRow = components.weekday - 2 % 7;
    if (selectedWeekdayRow < 0) {
        selectedWeekdayRow += 7;
    }
    [self.picker selectRow:selectedWeekdayRow inComponent:CustomDaysHoursMinutesComponentDay animated:YES];
    [self.picker selectRow:(components.hour > 12 ? ([components hour] - 12) - 1 : ([components hour] - 1)) inComponent:CustomDaysHoursMinutesComponentHour animated:YES];
    [self.picker selectRow:[components minute] inComponent:CustomDaysHoursMinutesComponentMinute animated:YES];
    [self.picker selectRow:([components hour] >= 12 ? 1 : 0)  inComponent:CustomDaysHoursMinutesComponentAMPM animated:YES];
}

- (void)showDate:(NSDate *)date {
    self.date = date;
    [self showDate];
}

- (void)valueChanged {
    int hour = (int)[self.picker selectedRowInComponent:CustomDaysHoursMinutesComponentHour] + 1;
    int minute = (int)[self.picker selectedRowInComponent:CustomDaysHoursMinutesComponentMinute];
    int APM = (int)[self.picker selectedRowInComponent:CustomDaysHoursMinutesComponentAMPM];
    
    NSString *apmString = (APM > 0 ? @"PM":@"AM");
    NSString *dateString = [NSString stringWithFormat:@"%@ %d:%d %@", [self dayStringForDay:[self.picker selectedRowInComponent:CustomDaysHoursMinutesComponentDay]] ,hour, minute, apmString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"ccc hh:mm a";
    
    self.date = [dateFormatter dateFromString:dateString];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case CustomDaysHoursMinutesComponentDay:
            return NUMBER_OF_DAYS;
            break;
        
        case CustomDaysHoursMinutesComponentHour:
            return NUMBER_OF_HOURS;
            break;
        
        case CustomDaysHoursMinutesComponentMinute:
            return NUMBER_OF_MINUTES;
            break;
        
        case CustomDaysHoursMinutesComponentColon:
            return 1;
            break;
            
        default:
            return 2;
            break;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width;
    switch (component) {
        case CustomDaysHoursMinutesComponentDay:
            width = DAY_COMPONENT_WIDTH;
            break;
        
        case CustomDaysHoursMinutesComponentColon:
            width = COLON_COMPONENT_WIDTH;
            break;
            
        case CustomDaysHoursMinutesComponentAMPM:
            width = AMPM_COMPONENT_WIDTH;
            break;
            
        default:
            width = OTHER_COMPONENT_WIDTH;
            break;
    }
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    CGFloat height;
    switch (component) {
        case CustomDaysHoursMinutesComponentAMPM:
            height = AMPM_COMPONENT_HEIGHT;
            break;
            
        default:
            height = OTHER_COMPONENT_HEIGHT;
            break;
    }
    return height;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    switch (component) {
        case CustomDaysHoursMinutesComponentDay:
            [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [self dayStringForDay:row]] attributes:_attributes]];
            lblDate.textAlignment = NSTextAlignmentRight;
            [lblDate sizeToFit];
            break;
        
        case CustomDaysHoursMinutesComponentHour:
            [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%01ld", (long)row + 1] attributes:_attributes]];
            lblDate.textAlignment = NSTextAlignmentRight;
            break;
        
        case CustomDaysHoursMinutesComponentMinute:
            [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld", (long)row] attributes:_attributes]];
            lblDate.textAlignment = NSTextAlignmentCenter;
            break;
            
        case CustomDaysHoursMinutesComponentColon:
            lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, COLON_COMPONENT_WIDTH, 60)];
            lblDate.attributedText = [[NSAttributedString alloc] initWithString:@":" attributes:_attributes];
            break;
            
        default://AM/PM
            if (row == 0) {
                [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:@"AM" attributes:_AMPMattributes]];
            }
            if (row == 1) {
                [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:@"PM" attributes:_AMPMattributes]];
            }
            lblDate.textAlignment = NSTextAlignmentCenter;
            lblDate.layer.cornerRadius = 2.0f;
            lblDate.layer.borderColor = [UIColor blackColor].CGColor;
            lblDate.layer.borderWidth = 1.0f;
            lblDate.frame = CGRectMake(0, 0, AMPM_COMPONENT_WIDTH, AMPM_COMPONENT_HEIGHT);
            break;
    }
    
    return lblDate;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self valueChanged];
}

- (NSString *)dayStringForDay:(NSInteger)dayNumber {
    NSString *dayString;
    
    switch (dayNumber) {
        case 0:
            dayString = @"Mon";
            break;
            
        case 1:
            dayString = @"Tue";
            break;
            
        case 2:
            dayString = @"Wed";
            break;
            
        case 3:
            dayString = @"Thu";
            break;
            
        case 4:
            dayString = @"Fri";
            break;
            
        case 5:
            dayString = @"Sat";
            break;
            
        default:
            dayString = @"Sun";
            break;
    }
    
    return dayString;
}

@end
