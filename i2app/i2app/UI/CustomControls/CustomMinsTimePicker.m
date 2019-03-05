//
//  CustomMinsTimePicker.m
//  i2app
//
//  Created by Arcus Team on 9/1/15.
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
#import "CustomMinsTimePicker.h"
#import "NSDate+Convert.h"

@interface CustomMinsTimePicker() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation CustomMinsTimePicker  {
    NSDictionary *_attributes;
}

- (instancetype)init {
    if (self = [super init]) {
        self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.calendar = [NSCalendar currentCalendar];
        
        self.date = [NSDate date];
        self.maxMinutes = 60;
        self.maxSeconds = 60;
        
        _attributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)};
        
        [self addSubview:self.picker];
    }
    return self;
}

- (void)initialize {
    [self showDate];
    [self.picker reloadAllComponents];
    
    UILabel *_separatorMins = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/3.0f, self.bounds.size.height/2.8f, 80, 60)];
    [_separatorMins styleSet:@"min" andButtonType:FontDataType_Medium_12_Black upperCase:YES];
    [self addSubview:_separatorMins];
    
    UILabel *_separatorSecs = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/1.5f, self.bounds.size.height/2.8f, 80, 60)];
    [_separatorSecs styleSet:@"sec" andButtonType:FontDataType_Medium_12_Black upperCase:YES];
    [self addSubview:_separatorSecs];
}

- (void)showDate:(NSDate *)date {
    if (date) {
        self.date = date;
    }
    else {
        self.date = [NSDate date2000Year];
    }
    [self showDate];
}

- (void)showDate {
    NSDateComponents *components = [self.calendar
                                    components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                    fromDate:self.date];
    
    [self.picker selectRow:[components minute] inComponent:0 animated:YES];
    [self.picker selectRow:[components second] inComponent:1 animated:YES];
}

- (void)valueChanged {
    NSInteger minute = [self.picker selectedRowInComponent:0];
    NSInteger second = [self.picker selectedRowInComponent:1];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:0]];
    
    components.minute = minute;
    components.second = second;
    self.date = [self.calendar dateFromComponents:components];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (NSString *)getString {
    NSInteger minute = [self.picker selectedRowInComponent:0];
    NSInteger second = [self.picker selectedRowInComponent:1];
    
    if (minute == 0 && second == 0) return @"0 second";
    
    return [NSString stringWithFormat:@"%@%@ ", (minute > 0? [NSString stringWithFormat:@"%ld minutes",(long)minute]:@""), (second > 0? [NSString stringWithFormat:@" %ld seconds",(long)second]:@"") ];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _maxMinutes; //Mins
    }
    if (component == 1) {
        return _maxSeconds; //Sec
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 55;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    if (component == 0) {
        [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%01ld",(long)row] attributes:_attributes]];
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    else if (component == 1) {
        [lblDate setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld",(long)row] attributes:_attributes]];
        lblDate.textAlignment = NSTextAlignmentLeft;
    }
    
    return lblDate;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self valueChanged];
}

@end
