//
//  CustomSunriseSunsetTimePicker.m
//  i2app
//
//  Created by Arcus Team on 4/7/16.
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
#import "CustomSunriseSunsetTimePicker.h"
#import "NSDate+Convert.h"
#import "ALView+PureLayout.h"

@interface CustomSunriseSunsetTimePicker() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation CustomSunriseSunsetTimePicker  {
    NSDictionary *_attributes;
    NSDictionary *_sunriseSunsetAttributes;
}

- (instancetype)initWithDateTime:(ArcusDateTime *)time {
    if (self = [self init]) {
         self.eventDateTime = time;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.picker.translatesAutoresizingMaskIntoConstraints = NO;
        self.calendar = [NSCalendar currentCalendar];
        
        _attributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)};
        _sunriseSunsetAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:10.0f], NSKernAttributeName: @(2.0f)};
        
        [self addSubview:self.picker];
        
        [_picker autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:-20];
        [_picker autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [_picker autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [_picker autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    }
    return self;
}

- (void)initialize {
    [self showDate];
    [self.picker reloadAllComponents];
}

- (void)showDate:(NSDate *)date {
    [self showDate];
}

- (void)showDate {
    [self.picker selectRow:abs(self.eventDateTime.offsetMinutes) inComponent:0 animated:YES];
    
    [self.picker selectRow:self.eventDateTime.beforeSunriseSunset ? 0 : 1 inComponent:1 animated:YES];
}

- (void)valueChanged {
    int mins = (int)[self.picker selectedRowInComponent:0];
    int typeIndex = (int)[self.picker selectedRowInComponent:1];
    
    if (_eventDateTime.currentTimeType == DateTimeSunrise) {
        _eventDateTime.offsetMinutes = typeIndex == 0 ? -mins : mins;
    }
    else if (_eventDateTime.currentTimeType == DateTimeSunset) {
        _eventDateTime.offsetMinutes = typeIndex == 0 ? -mins : mins;
    }
    else {
        _eventDateTime = [ArcusDateTime new];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (NSString *)getString {
    NSInteger minute = [self.picker selectedRowInComponent:0];
    NSInteger second = [self.picker selectedRowInComponent:1];
    
    return [NSString stringWithFormat:@"%@%@ ", (minute > 0 ? [NSString stringWithFormat:@"%ld minutes", (long)minute] : @""), (second > 0 ? [NSString stringWithFormat:@" %ld seconds",(long)second]:@"") ];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 61; //Mins
    }
    if (component == 1) {
        return 2; // "Mins before"/"Mins after"
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 55;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    
    if (component == 0) {
        if (row == 0) {
            [label setAttributedText:[[NSAttributedString alloc] initWithString:@"0" attributes:_attributes]];
        }
        else if  (row < 10) {
            [label setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%01ld", (long)row] attributes:_attributes]];
        }
        else {
            [label setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%01ld", (long)row] attributes:_attributes]];
        }
        label.textAlignment = NSTextAlignmentCenter;
    }
    else if (component == 1) {
        label.textAlignment = NSTextAlignmentLeft;
        // "mins before"/"mins after"
        [label setAttributedText:[[NSAttributedString alloc] initWithString:SunsetSunriseTypeToString(row) attributes:_sunriseSunsetAttributes]];

        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 2.0f;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 1.0f;
        label.frame = CGRectMake(0, 20, 150, 30);

        return label;
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self valueChanged];
}

@end
