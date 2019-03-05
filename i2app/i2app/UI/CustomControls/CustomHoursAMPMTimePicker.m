//
//  CustomHoursAMPMTimePicker.m
//
//  Created by Arcus Team on 6/19/15.
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
#import "CustomHoursAMPMTimePicker.h"
#import "NSDate+Convert.h"
#import "ALView+PureLayout.h"

@interface CustomHoursAMPMTimePicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic) BOOL showOnlyValidDates;

@property (nonatomic, strong) NSDate *date;

@end


@implementation CustomHoursAMPMTimePicker {
    NSDictionary *_attributes;
    NSDictionary *_APPMattributes;
    
    BOOL         _pickupHoursOnly;
}

@dynamic pickupHoursOnly;

- (instancetype)init {
    if (self = [super init]) {
        self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.picker.translatesAutoresizingMaskIntoConstraints = NO;
        self.calendar = [NSCalendar currentCalendar];
        
        self.date = [NSDate date];
        
        _attributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)};
        _APPMattributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:10.0f], NSKernAttributeName: @(2.0f)};
        
        [self addSubview:self.picker];

        [_picker autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [_picker autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [_picker autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [_picker autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    }
    return self;
}

- (void)initialize {
    [self showDate];
    [self.picker reloadAllComponents];
    
    UILabel *separator = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / (IS_IPHONE_6P ? 2.65 : 3.2), self.bounds.size.height / 3.1, 10, 60)];
    separator.attributedText = [[NSAttributedString alloc] initWithString:@":" attributes:_attributes];
    [self addSubview:separator];
}

- (BOOL)pickupHoursOnly {
    return _pickupHoursOnly;
}

- (void)setPickupHoursOnly:(BOOL)pickupHoursOnly {
    _pickupHoursOnly = pickupHoursOnly;
}

- (void)showDate:(NSDate *)date {
    self.date = date;
    [self showDate];
}

- (void)showDate {
    NSDateComponents *components = [self.calendar
                                    components:NSCalendarUnitHour|NSCalendarUnitMinute
                                    fromDate:self.date];
    [self.picker selectRow:(components.hour > 12 ? ([components hour] - 12) - 1 : ([components hour] - 1)) inComponent:0 animated:YES];
    [self.picker selectRow:[components minute] inComponent:1 animated:YES];
    [self.picker selectRow:([components hour] >= 12 ? 1 : 0)  inComponent:2 animated:YES];
}

- (void)valueChanged {
    int hour = (int)[self.picker selectedRowInComponent:0];
    int minute = (int)[self.picker selectedRowInComponent:1];
    int APM = (int)[self.picker selectedRowInComponent:2];
    
    NSString *dateString = (APM > 0 ? @"PM":@"AM");
    dateString = [NSString stringWithFormat:@"%d:%d %@", hour + 1, minute, dateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    
    self.date = [dateFormatter dateFromString:dateString];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 12; //Hours
    }
    if (component == 1) {
        if (self.pickupHoursOnly)
            return 1;
        else
            return 60; //Mins
    }
    if (component == 2) {
        return 2;  //AM/PM
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (component == 2) {
        return 15;
    }
    return 55;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    if (component == 0) {
        // Hours
        [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%01ld", (long)row + 1] attributes:_attributes]];
        lblDate.textAlignment = NSTextAlignmentRight;
    }
    else if (component == 1) {
        // Mins
        [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld", (long)row] attributes:_attributes]];
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    else if (component == 2) {
        // Am/Pm
        if (row == 0) {
            [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:@"AM" attributes:_APPMattributes]];
        }
        if (row == 1) {
            [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:@"PM" attributes:_APPMattributes]];
        }
        lblDate.textAlignment = NSTextAlignmentCenter;
        lblDate.layer.cornerRadius = 2.0f;
        lblDate.layer.borderColor = [UIColor blackColor].CGColor;
        lblDate.layer.borderWidth = 1.0f;
        lblDate.frame = CGRectMake(0, 20, 30, 15);
        
        UIView *view = [[UIView alloc] init];
        [view addSubview:lblDate];
        return view;
    }
    
    return lblDate;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self valueChanged];
}

@end
