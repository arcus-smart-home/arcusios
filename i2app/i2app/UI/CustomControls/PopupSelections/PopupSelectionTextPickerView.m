//
//  PopupSelectionTextPickerView.m
//  i2app
//
//  Created by Arcus Team on 10/5/15.
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
#import "PopupSelectionTextPickerView.h"

@interface PopupSelectionTextPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *titleString;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (strong, nonatomic) NSString *postfix;
@property (strong, nonatomic) NSString *defaultKey;
@property (strong, nonatomic) NSString *defaultValue;

@property (strong, nonatomic) NSString *sign;
@property (nonatomic) BOOL isSignWithFrame;

@end

@implementation PopupSelectionTextPickerView {
    BOOL        _fuzzilySearch;
}

+ (PopupSelectionTextPickerView *)create:(NSString *)title list:(OrderedDictionary *)list {
    PopupSelectionTextPickerView *selection = [[PopupSelectionTextPickerView alloc] initWithNibName:@"PopupSelectionPickerView" bundle:nil];
    selection.titleString = title;
    selection.textPickerList = list;
    return selection;
}

- (void)setCurrentKey:(NSString *)key {
    _defaultKey = key;
    _fuzzilySearch = NO;
    
    if (key.length > 0) {
        key = [key lowercaseString];
        
        NSInteger index = 0;
        for (NSString *item in _textPickerList) {
            if ([key isEqualToString:item.lowercaseString]) {
                [self.textPicker selectRow:index inComponent:0 animated:YES];
                return;
            }
            index ++;
        }
    }
}

- (void)setCurrentValue:(id)value {
    _defaultValue = value;
    
    if (value) {
        NSInteger index = 0;
        for (NSString *item in _textPickerList) {
            if ([value isEqual:[_textPickerList objectForKey:item]]) {
                [self.textPicker selectRow:index inComponent:0 animated:YES];
                return;
            }
            index ++;
        }
    }
}

- (void)setCurrentKeyFuzzily:(NSString *)key {
    key = [key lowercaseString];
    
    _defaultKey = key;
    _fuzzilySearch = YES;
    
    if (key.length > 0) {
        NSString *itemKey =  @"";
        NSInteger index = 0;
        for (NSString *item in _textPickerList) {
            itemKey = [item lowercaseString];
            
            if ([key containsString:itemKey] || [itemKey containsString:key]) {
                [self.textPicker selectRow:index inComponent:0 animated:YES];
                return;
            }
            index ++;
        }
    }
}

- (void)setSign:(NSString *)text withFrame:(BOOL)frame {
    self.sign = text;
    self.isSignWithFrame = frame;
}

#pragma mark - PickerDelegate
- (void)initializePicker {
    [self.titleLabel styleSetWithSpace:self.titleString andFontSize:14 bold:YES upperCase:YES];
    
    if (_defaultValue.length > 0) {
        [self setCurrentValue:_defaultValue];
    }
    else if (_fuzzilySearch && _defaultKey.length > 0) {
        [self setCurrentKeyFuzzily:_defaultKey];
    }
    else if (_defaultKey.length > 0) {
        [self setCurrentKey:_defaultKey];
    }
    
    if (self.sign && self.sign.length > 0) {
        if (self.isSignWithFrame) {
            [_signLabel styleSet:[NSString stringWithFormat:@"  %@  ",self.sign] andFontData:[FontData createFontData:FontTypeDemiBold size:10 blackColor:YES space:YES]];
            _signLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _signLabel.layer.borderWidth = 1.0f;
            _signLabel.layer.cornerRadius = 4.0f;
        } else {
            [_signLabel styleSet:self.sign andFontData:[FontData createFontData:FontTypeDemiBold size:10 blackColor:YES space:YES]];
        }
    }
}

- (NSObject *)getSelectedValue {
    if (self.textPickerList.count > 0) {
        id key = [_textPickerList keyAtIndex:[_textPicker selectedRowInComponent:0]];
        return [_textPickerList objectForKey:key];
    }
    return nil;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _textPickerList.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    NSString *valueText = [_textPickerList keyAtIndex:row];
    CGFloat fontSize = 48.0f;
    if (valueText.length > 18) {
        fontSize = 24.0f;
    }
    else if (valueText.length > 10) {
        fontSize = 30.0f;
    }
    
    UILabel *lblNumber = [[UILabel alloc] init];
    [lblNumber setBackgroundColor:[UIColor clearColor]];
    
    [lblNumber setAttributedText:[[NSAttributedString alloc] initWithString:valueText attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:fontSize], NSKernAttributeName: @(2.0f)} ]];
    
    lblNumber.textAlignment = NSTextAlignmentCenter;
    
    return lblNumber;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}




@end
