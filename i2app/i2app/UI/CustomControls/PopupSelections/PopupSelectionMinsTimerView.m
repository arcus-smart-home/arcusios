//
//  PopupSelectionMinsTimerView.m
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
#import "PopupSelectionMinsTimerView.h"
#import "CustomMinsTimePicker.h"
#import <PureLayout/PureLayout.h>

@interface PopupSelectionMinsTimerView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSDate *setDate;
@property (nonatomic) NSInteger maxMinutes;

@end

@implementation PopupSelectionMinsTimerView {
    CustomMinsTimePicker *_picker;
}


+ (PopupSelectionMinsTimerView *)create:(NSString *)title {
    PopupSelectionMinsTimerView *selection = [[PopupSelectionMinsTimerView alloc] initWithNibName:@"PopupSelectionMinsTimerView" bundle:nil];
    selection.titleString = title;
    selection.maxMinutes = 60;
    
    return selection;
}

+ (PopupSelectionMinsTimerView *)create:(NSString *)title withDate:(NSDate *)date {
    PopupSelectionMinsTimerView *selection = [[PopupSelectionMinsTimerView alloc] initWithNibName:@"PopupSelectionMinsTimerView" bundle:nil];
    selection.titleString = title;
    selection.setDate = date;
    selection.maxMinutes = 60;
    
    return selection;
}

+ (PopupSelectionMinsTimerView *)create:(NSString *)title withDate:(NSDate *)date withMaxMinutes:(NSInteger)maxMinutes {
    PopupSelectionMinsTimerView *selection = [[PopupSelectionMinsTimerView alloc] initWithNibName:@"PopupSelectionMinsTimerView" bundle:nil];
    selection.titleString = title;
    selection.setDate = date;
    selection.maxMinutes = maxMinutes;
    
    return selection;
}


#pragma mark - PickerDelegate
- (void)initializePicker {
    [self.titleLabel styleSetWithSpace:_titleString andFontSize:14 bold:YES upperCase:YES];
    
    _picker = [[CustomMinsTimePicker alloc] init];
    [self.view addSubview:_picker];
    
    [_picker setMaxMinutes:_maxMinutes];
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
}
@end
