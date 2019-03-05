//
//  PopupSelectionSchedulerTimeView.m
//  i2app
//
//  Created by Arcus Team on 4/6/16.
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
#import "PopupSelectionSchedulerTimeView.h"
#import <PureLayout/PureLayout.h>
#import "PopupSelectionCells.h"
#import "NSDate+Convert.h"
#import "IrrigationZoneModel.h"
#import "CustomSunriseSunsetTimePicker.h"

#import "CustomHoursAMPMTimePicker.h"
#import "CustomHoursTimePicker.h"

@interface PopupSelectionSchedulerTimeView ()

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *sunriseButton;
@property (weak, nonatomic) IBOutlet UIButton *sunsetButton;

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (atomic, assign) BOOL showJustDate;

- (IBAction)timeButtonPressed:(id)sender;
- (IBAction)sunriseButtonPressed:(id)sender;
- (IBAction)sunsetButtonPressed:(id)sender;

@end

@implementation PopupSelectionSchedulerTimeView {
}

+ (PopupSelectionSchedulerTimeView *)create {
    PopupSelectionSchedulerTimeView *selection = [[PopupSelectionSchedulerTimeView alloc] initWithNibName:@"PopupSelectionSchedulerTimeView" bundle:nil];
    return selection;
}


+ (PopupSelectionSchedulerTimeView *)createWithDateTime:(ArcusDateTime *)dateTime showJustDate:(BOOL)showJustDate {
    PopupSelectionSchedulerTimeView *selection = [[PopupSelectionSchedulerTimeView alloc] initWithNibName:@"PopupSelectionSchedulerTimeView" bundle:nil];
    selection.currentDateTime = dateTime;
    selection.initialDate = dateTime.date;
    selection.showJustDate = showJustDate;
    
    return selection;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.messageView.hidden = YES;
    
    [_timeButton styleSet:@"time" andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
    [_sunriseButton styleSet:@"sunrise" andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
    [_sunsetButton styleSet:@"sunset" andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
    
    if (!self.showJustDate) {
        _startTimeLabel.hidden = YES;
        _timeButton.layer.cornerRadius = 4.0f;
        _timeButton.layer.borderColor = [UIColor blackColor].CGColor;
        _sunriseButton.layer.cornerRadius = 4.0f;
        _sunriseButton.layer.borderColor = [UIColor blackColor].CGColor;
        _sunsetButton.layer.cornerRadius = 4.0f;
        _sunsetButton.layer.borderColor = [UIColor blackColor].CGColor;
        
        if (self.currentDateTime.currentTimeType == DateTimeAbsolute) {
            _timeButton.layer.borderWidth = 1.0f;
            
            [super initializeCurrentPicker:TimerStyleHoursAndMinutes];
        }
        else if (self.currentDateTime.currentTimeType == DateTimeSunrise) {
            _sunriseButton.layer.borderWidth = 1.0f;
            
            [self initializeCurrentPicker:TimerStyleSunrise];
        }
        else if (self.currentDateTime.currentTimeType == DateTimeSunset) {
            _sunsetButton.layer.borderWidth = 1.0f;
            
            [self initializeCurrentPicker:TimerStyleSunset];
        }
    }
    else {
        // For Lawn & Garden
        _startTimeLabel.hidden = NO;
        _timeButton.hidden = YES;
        _sunriseButton.hidden = YES;
        _sunsetButton.hidden = YES;
    }
}

- (void)initializeCurrentPicker {
    switch (self.timerStyle) {
        case TimerStyleSunrise:
            self.currentDateTime.currentTimeType = DateTimeSunrise;
            self.picker = [[CustomSunriseSunsetTimePicker alloc] initWithDateTime:self.currentDateTime];
            break;
            
        case TimerStyleSunset:
            self.currentDateTime.currentTimeType = DateTimeSunset;
            self.picker = [[CustomSunriseSunsetTimePicker alloc] initWithDateTime:self.currentDateTime];
            break;
            
        default:
            break;
    }
    [super initializeCurrentPicker];
}

- (void)initializeCurrentPicker:(TimerStyleType)style {
    if (style == TimerStyleSunrise ||
        style == TimerStyleSunset) {
        if (![[CorneaHolder shared] settings].isAddressGeoPrecisionEnabled) {
            self.messageView.hidden = NO;
            self.picker.hidden = YES;
            
            self.titleLabel.text = NSLocalizedString(@"Update Your Address", nil);
            self.textLabel.text = NSLocalizedString(@"Update your address text", nil);
            return;
        }
    }
    self.messageView.hidden = YES;
    self.picker.hidden = NO;

    [super initializeCurrentPicker:style];

    if ([self.picker isKindOfClass:[CustomHoursAMPMTimePicker class]] ||
        [self.picker isKindOfClass:[CustomHoursTimePicker class]]) {
        [self.picker showDate:_currentDateTime.date];
    }
    else {
        [self.picker showDate:_currentDateTime];
    }
    [self.view layoutIfNeeded];
    [self.picker initialize];
}

#pragma mark - switch buttons
- (IBAction)timeButtonPressed:(id)sender {
    _timeButton.layer.borderWidth = 1.0f;
    _sunriseButton.layer.borderWidth = 0.0f;
    _sunsetButton.layer.borderWidth = 0.0f;
    
    [self initializeCurrentPicker:TimerStyleHoursAndMinutes];
}

- (IBAction)sunriseButtonPressed:(id)sender {
    _timeButton.layer.borderWidth = 0.0f;
    _sunriseButton.layer.borderWidth = 1.0f;
    _sunsetButton.layer.borderWidth = 0.0f;
    
    [self initializeCurrentPicker:TimerStyleSunrise];
}

- (IBAction)sunsetButtonPressed:(id)sender {
    _timeButton.layer.borderWidth = 0.0f;
    _sunriseButton.layer.borderWidth = 0.0f;
    _sunsetButton.layer.borderWidth = 1.0f;

    [self initializeCurrentPicker:TimerStyleSunset];
}

#pragma mark - PickerDelegate
- (void)initializePicker {
    if (self.currentDateTime.currentTimeType == DateTimeAbsolute) {
        [super.picker showDate];
    }
    else if ([super.picker isKindOfClass:[CustomSunriseSunsetTimePicker class]])  {
        ((CustomSunriseSunsetTimePicker *)super.picker).eventDateTime = self.currentDateTime;
        [super.picker showDate];
    }
}

- (ArcusDateTime *)getSelectedValue {
    if (self.timerStyle == TimerStyleSunrise ||
        self.timerStyle == TimerStyleSunset) {
        return self.picker.eventDateTime;
    }
    return [[ArcusDateTime alloc] initWithDate:self.picker.date];
}


@end
