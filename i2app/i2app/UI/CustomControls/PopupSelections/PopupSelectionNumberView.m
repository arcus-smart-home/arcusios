//
//  PopupSelectionNumberView.m
//  i2app
//
//  Created by Arcus Team on 8/28/15.
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
#import "PopupSelectionNumberView.h"

@interface PopupSelectionNumberView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *numberPicker;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *signLabel;


@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *subtitleString;
@property (nonatomic) CGFloat minNumber;
@property (nonatomic) CGFloat maxNumber;
@property (nonatomic) CGFloat stepNumber;
@property (strong, nonatomic) NSString *postfix;
@property (strong, nonatomic) NSString *sign;
@property (nonatomic) NSNumber *defaultValue;
@property (nonatomic) BOOL shouldIgnoreMinMaxRule;

@property (nonatomic) BOOL isSignWithFrame;
@property (copy) NSString*(^labelTransform)(NSNumber*);

@property (strong, nonatomic) NSArray<NSNumber *> *numbersArray;
@property (nonatomic) BOOL usesArray;

@end

@implementation PopupSelectionNumberView


+ (PopupSelectionNumberView *)create:(NSString *)title withMaxNumber:(CGFloat)max {
    return [self create:title withMinNumber:1.0 maxNumber:max stepNumber:1.0 postfix:nil sign:nil];
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min andMaxNumber:(CGFloat)max {
    return [self create:title withMinNumber:min maxNumber:max stepNumber:1.0 postfix:nil sign:nil];
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step {
    return [self create:title withMinNumber:min maxNumber:max stepNumber:step postfix:nil sign:nil];
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max andPostfix:(NSString *)postfix {
    return [self create:title withMinNumber:min maxNumber:max stepNumber:1.0 postfix:postfix sign:nil];
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step andPostfix:(NSString *)postfix {
    return [self create:title withMinNumber:min maxNumber:max stepNumber:step postfix:postfix sign:nil];
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max withSign:(NSString *)sign {
    return [self create:title withMinNumber:min maxNumber:max stepNumber:1.0 postfix:nil sign:sign];
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step withSign:(NSString *)sign {
    return [self create:title withMinNumber:min maxNumber:max stepNumber:step postfix:nil sign:sign];
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max postfix:(NSString *)postfix sign:(NSString *)sign {
    return [self create:title withMinNumber:min maxNumber:max stepNumber:1.0 postfix:postfix sign:sign];
}

+ (PopupSelectionNumberView *)create:(NSString *)title subtitle:(NSString *)subtitle withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step withSign:(NSString *)sign {
    return [self create:title subtitle:subtitle withMinNumber:min maxNumber:max stepNumber:step postfix:nil sign:sign];
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step postfix:(NSString *)postfix sign:(NSString *)sign {
    PopupSelectionNumberView *selection = [[PopupSelectionNumberView alloc] initWithNibName:@"PopupSelectionNumberView" bundle:nil];
    selection.titleString = title;
    selection.minNumber = min;
    selection.maxNumber = max;
    selection.stepNumber = step;
    selection.postfix = postfix;
    selection.sign = sign;
    selection.usesArray = NO;
    selection.shouldIgnoreMinMaxRule = NO;
    return selection;
}

+ (PopupSelectionNumberView *)create:(NSString *)title subtitle:(NSString *)subtitle withMinNumber:(CGFloat)min maxNumber:(CGFloat)max stepNumber:(CGFloat)step postfix:(NSString *)postfix sign:(NSString *)sign {
    PopupSelectionNumberView *selection = [[PopupSelectionNumberView alloc] initWithNibName:@"PopupSelectionNumberSubtitleView" bundle:nil];
    selection.titleString = title;
    selection.subtitleString = subtitle;
    selection.minNumber = min;
    selection.maxNumber = max;
    selection.stepNumber = step;
    selection.postfix = postfix;
    selection.sign = sign;
    selection.usesArray = NO;
    selection.shouldIgnoreMinMaxRule = NO;
    return selection;
}

+ (PopupSelectionNumberView *)create:(NSString *)title withNumbers:(NSArray<NSNumber *> *)numbers labelTransform:(NSString*(^)(NSNumber*))transform {
    PopupSelectionNumberView *numberSelection = [self create:title withMinNumber:0 maxNumber:1 stepNumber:1.0 postfix:nil sign:nil];
    numberSelection.usesArray = YES;
    numberSelection.numbersArray = numbers;
    numberSelection.labelTransform = transform;
    return numberSelection;
}

+ (PopupSelectionNumberView *)create:(NSString *)title withNumbers:(NSArray<NSNumber *> *)numbers postfix:(NSString *)postfix {
    PopupSelectionNumberView *numberSelection = [self create:title withMinNumber:0 maxNumber:1 stepNumber:1.0 postfix:postfix sign:nil];
    numberSelection.usesArray = YES;
    numberSelection.numbersArray = numbers;
    return numberSelection;
}

+ (PopupSelectionNumberView *)create:(NSString *)title withMinNumber:(CGFloat)min maxNumber:(CGFloat)max andPostfix:(NSString *)postfix ignoreMinMaxRule:(BOOL)ignoreMinMaxRule {
    PopupSelectionNumberView *selection = [self create:title withMinNumber:min maxNumber:max andPostfix:postfix];
    selection.shouldIgnoreMinMaxRule = ignoreMinMaxRule;
    return selection;
}

- (BOOL)shouldDisplayDecimal {
    return (self.minNumber != (int)self.minNumber || self.stepNumber != (int)self.stepNumber);
}

- (PopupSelectionNumberView *)setSignWithFrame:(BOOL)frame {
    self.isSignWithFrame = frame;
    return self;
}

#pragma mark - PickerDelegate
- (void)initializePicker {
    [self.titleLabel styleSetWithSpace:self.titleString andFontSize:14 bold:YES upperCase:YES];

    if (self.subtitleLabel != nil) {
        self.subtitleLabel.text = self.subtitleString;
    }
    
    if (self.stepNumber <= 0) {
        self.stepNumber = 1.0f;
    }
    if (self.minNumber <= 0) {
        self.minNumber = 0;
    }
    if (self.maxNumber <= self.minNumber && !self.shouldIgnoreMinMaxRule) {
        self.maxNumber = self.minNumber + 1.0;
    }
    
    if (self.defaultValue.floatValue > 0 && self.defaultValue.floatValue - _minNumber > 0 && self.defaultValue.floatValue - _minNumber <= _maxNumber - _minNumber) {
        [self.numberPicker selectRow: (NSInteger)((self.defaultValue.floatValue - _minNumber) / self.stepNumber) inComponent:0 animated:YES];
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
    
    if (self.usesArray) {
        if (!self.numbersArray) {
            self.numbersArray = [NSArray arrayWithObject:@(1)];
        }
    }
}

- (NSObject *)getSelectedValue {    
    NSNumber *value;
    
    NSInteger selectedRow = [_numberPicker selectedRowInComponent:0];
    
    if (self.usesArray) {
        if (selectedRow) {
            value = self.numbersArray[selectedRow];
        } else {
            value = self.numbersArray[0];
        }
    } else {
        if (selectedRow) {
            value = @((selectedRow * _stepNumber) + _minNumber);
        }
        else {
            value = @(_minNumber);
        }
    }
    
    return value;
}

- (void)setCurrentKey:(id)currentValue {
    if (currentValue && [currentValue isKindOfClass:[NSNumber class]]) {
        int value = ((NSNumber *)currentValue).intValue;
        
        self.defaultValue = currentValue;
        if (self.usesArray && self.numberPicker) {
            NSInteger row = 0;
            for (int i = 0; i < self.numbersArray.count; i++) {
                if (self.numbersArray[i] == currentValue) {
                    row = i;
                    break;
                }
            }
            [self.numberPicker selectRow:row inComponent:0 animated:YES];
        } else {
            if (self.numberPicker && value > 0 && value - _minNumber > 0 && value- _minNumber <= _maxNumber - _minNumber) {
                [self.numberPicker selectRow:value - _minNumber inComponent:0 animated:YES];
            }
        }
        
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.usesArray) {
        return self.numbersArray.count;
    } else {
        return  (NSInteger)((_maxNumber - _minNumber) / _stepNumber) + 1;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *lblNumber = [[UILabel alloc] init];
    [lblNumber setBackgroundColor:[UIColor clearColor]];
    
    CGFloat valueToShow;
    if (self.usesArray) {
        valueToShow = self.numbersArray[row].floatValue;
    } else {
        valueToShow = ((row *_stepNumber) + _minNumber);
    }
    
    if (_labelTransform != nil) {
        
        [lblNumber setAttributedText: [[NSAttributedString alloc] initWithString:_labelTransform(@(valueToShow)) attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)} ]];
        
        lblNumber.textAlignment = NSTextAlignmentCenter;
    }
    
    else {
    
        NSString *formatText = [self shouldDisplayDecimal] ? @"%.2f" : @"%.0f";
        if (_postfix && _postfix.length > 0) {
            formatText = [formatText stringByAppendingString:_postfix];
        }
        
        [lblNumber setAttributedText: [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:formatText, valueToShow] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:48.0f], NSKernAttributeName: @(2.0f)} ]];
    
        lblNumber.textAlignment = NSTextAlignmentCenter;
    }
    
    return lblNumber;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

#pragma mark -

- (CGFloat)getHeight {
    if (_subtitleString && _subtitleString.length > 0) {

        NSString *realText = NSLocalizedString(_subtitleString, nil);

        CGRect possibleSize =[realText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30,9999)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:14]}
                                                    context:nil];

        return possibleSize.size.height + [super getHeight];
    }
    else {
        return [super getHeight];
    }
}


@end
