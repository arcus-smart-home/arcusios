//
//  PopupSelectionHoursTimerView.m
//  i2app
//
//  Created by Arcus Team on 3/16/16.
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
#import "PopupSelectionHoursTimerView.h"
#import "CustomHoursTimePicker.h"
#import <PureLayout/PureLayout.h>

@interface PopupSelectionHoursTimerView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSDate *setDate;

@end

@implementation PopupSelectionHoursTimerView {
    CustomHoursTimePicker *_picker;
}


+ (PopupSelectionHoursTimerView *)create:(NSString *)title withMaxTime:(int)timeInMinutes {
    PopupSelectionHoursTimerView *selection = [[PopupSelectionHoursTimerView alloc] initWithNibName:@"PopupSelectionMinsTimerView" bundle:nil];
    selection.titleString = title;
    
    return selection;
}

+ (PopupSelectionHoursTimerView *)create:(NSString *)title withDate:(NSDate *)date {
    PopupSelectionHoursTimerView *selection = [[PopupSelectionHoursTimerView alloc] initWithNibName:@"PopupSelectionMinsTimerView" bundle:nil];
    selection.titleString = title;
    selection.setDate = date;
    
    return selection;
}

#pragma mark - PickerDelegate
- (void)initializePicker {
    [self.titleLabel styleSetWithSpace:_titleString andFontSize:14 bold:YES upperCase:YES];
    
    _picker = [[CustomHoursTimePicker alloc] init];
    [self.view addSubview:_picker];
    
    [_picker autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:76];
    [_picker autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_picker autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_picker autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    if (_setDate) {
        [_picker showDate:_setDate];
    }
    
    [self.view layoutIfNeeded];
    [_picker initialize];
}

- (NSObject *)getSelectedValue {
    [_picker valueChanged];
    return _picker.date;
}

- (void)setCurrentKey:(id)currentValue {
    if ([currentValue isKindOfClass:[NSDate class]]) {
        self.setDate = currentValue;
    }
    else if ([currentValue isKindOfClass:[NSNumber class]]) {
        // it is minutes only
        NSDate *oldDate = [NSDate date]; // Or however you get it.
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:unitFlags fromDate:oldDate];
        int minutes = [currentValue intValue];
        comps.hour   = minutes / 60;
        comps.minute = minutes % 60;
        comps.second = 0;
        self.setDate = [calendar dateFromComponents:comps];
    }
}

@end
