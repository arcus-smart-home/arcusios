//
//  CustomHoursOnlyPicker.m
//  i2app
//
//  Created by Arcus Team on 10/14/15.
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
#import "CustomHoursOnlyPicker.h"
#import "NSDate+Convert.h"
#import <PureLayout/PureLayout.h>

@interface CustomHoursOnlyPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic) BOOL showOnlyValidDates;

@property (nonatomic, strong) NSDate *date;

@end

@implementation CustomHoursOnlyPicker {
    NSDictionary *_attributes;
}


- (instancetype)init {
    if (self = [super init]) {
        self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.calendar = [NSCalendar currentCalendar];
        
        self.date = [NSDate date];
        
        _attributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)};
        
        [self addSubview:self.picker];
    }
    return self;
}

- (void)initialize {
    [self showDate];
    [self.picker reloadAllComponents];
    
    [self.picker autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.picker autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.picker autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.picker autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    UILabel *_separatorHrs = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/1.5f, self.bounds.size.height/2.8f, 80, 60)];
    [_separatorHrs styleSet:@"hrs" andButtonType:FontDataType_Medium_12_Black upperCase:YES];
    [self addSubview:_separatorHrs];
    
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
                                    components:NSCalendarUnitHour|NSCalendarUnitMinute
                                    fromDate:self.date];
    
    [self.picker selectRow:([components hour] % 24) inComponent:0 animated:YES];
}

- (void)valueChanged {
    NSInteger hour = [self.picker selectedRowInComponent:0];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:0]];
    
    components.hour = hour;
    self.date = [self.calendar dateFromComponents:components];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (NSString *)getString {
    NSInteger hour = [self.picker selectedRowInComponent:0];
    
    return [NSString stringWithFormat:@"%ld hours",(long)hour];
}

- (NSNumber *)valueInMins {
    NSInteger hour = [self.picker selectedRowInComponent:0];
    
    return @(hour * 60);
}
- (NSNumber *)valueInHours {
    NSInteger hour = [self.picker selectedRowInComponent:0];
    
    return @(hour);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24; //Hours
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
    
    return lblDate;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self valueChanged];
}

@end
