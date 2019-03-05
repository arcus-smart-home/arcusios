//
//  PopupSelectionListView.m
//  i2app
//
//  Created by Arcus Team on 11/16/15.
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
#import "PopupSelectionListView.h"

@interface PopupSelectionListView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *numberPicker;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;


@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *postfix;
@property (strong, nonatomic) NSString *sign;
@property (nonatomic) NSString *defaultValue;
@property (nonatomic, strong) NSArray *titlesList;
@property (nonatomic, strong) NSArray *valuesList;

@end

@implementation PopupSelectionListView {
    NSString    *_defaultTitle;
    NSString    *_defaultValue;
    NSString    *_defaultFuzzyTitle;
}

+ (PopupSelectionListView *)create:(NSString *)title withTitlesList:(NSArray *)titles withValuesList:(NSArray *)values {
    PopupSelectionListView *selection = [[PopupSelectionListView alloc] initWithNibName:@"PopupSelectionNumberView" bundle:nil];
    selection.titleString = title;
    selection.titlesList = titles;
    selection.valuesList = values;
    return selection;
}
- (PopupSelectionListView *)setDefaultTitle:(NSString *)title {
    _defaultTitle = title;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleLabel styleSetWithSpace:self.titleString andFontSize:14 bold:YES upperCase:YES];
    
    if (self.sign && self.sign.length > 0) {
        [_signLabel styleSet:self.sign andFontData:[FontData createFontData:FontTypeDemiBold size:8 blackColor:YES space:YES]];
    }
}

#pragma mark - PickerDelegate
- (void)initializePicker {
    NSInteger index = 0;
    
    if (_defaultTitle && _defaultValue) {
        index = [self.valuesList indexOfObject:_defaultValue];
        if (index <= 0 || index >= self.titlesList.count) {
            index = [self.titlesList indexOfObject:_defaultTitle];
        }
    }
    else if (_defaultTitle) {
        index = [self.titlesList indexOfObject:_defaultTitle];
    }
    else if (_defaultValue) {
        index = [self.valuesList indexOfObject:_defaultValue];
    }
    
    if ((index == 0 || index == NSNotFound) && _defaultFuzzyTitle) {
        
        NSString *fuzzyTitle = [_defaultFuzzyTitle lowercaseString];
        NSString *itemKey =  @"";
        NSInteger tempIndex = 0;
        for (NSString *item in _titlesList) {
            itemKey = [item lowercaseString];
            
            if ([fuzzyTitle containsString:itemKey] || [itemKey containsString:fuzzyTitle]) {
                index = tempIndex;
                break;
            }
            tempIndex ++;
        }
    }
    
    if (index > 0 && index != NSNotFound) {
        [_numberPicker selectRow:index inComponent:0 animated:YES];
    }
}

- (NSObject *)getSelectedValue {
    return self.valuesList[[_numberPicker selectedRowInComponent:0]];
}

- (void)setCurrentValue:(id)currentValue {
    if (currentValue && [currentValue isKindOfClass:[NSString class]]) {
         _defaultValue = currentValue;
    }
}

- (void)setCurrentKey:(id)currentKey {
    if (currentKey && [currentKey isKindOfClass:[NSString class]]) {
        _defaultTitle = currentKey;
    }
}

- (void)setCurrentKeyFuzzily:(id)currentKey {
    if (currentKey && [currentKey isKindOfClass:[NSString class]]) {
        _defaultFuzzyTitle = currentKey;
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.titlesList.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *lblText = [[UILabel alloc] init];
    [lblText setBackgroundColor:[UIColor clearColor]];
    
    [lblText setAttributedText: [[NSAttributedString alloc] initWithString:self.titlesList[row] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)} ]];
    
    lblText.textAlignment = NSTextAlignmentCenter;
    
    return lblText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}




@end
