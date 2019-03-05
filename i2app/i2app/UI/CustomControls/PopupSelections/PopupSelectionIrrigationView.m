//
//  PopupSelectionIrrigationView.m
//  i2app
//
//  Created by Arcus Team on 7/23/15.
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
#import "PopupSelectionIrrigationView.h"
#import <PureLayout/PureLayout.h>
#import "PopupSelectionCells.h"
#import "NSDate+Convert.h"
#import "IrrigationZoneModel.h"

@interface PopupSelectionIrrigationView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *stationButton;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;

// Middle View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation PopupSelectionIrrigationView {
    OrderedDictionary *_zonesList;
    OrderedDictionary *_durationsList;
    
    BOOL              _isDurationCurrentlySelected;
}

+ (PopupSelectionIrrigationView *)create:(NSString *)title list:(OrderedDictionary *)list {
    PopupSelectionIrrigationView *selection = [[PopupSelectionIrrigationView alloc] initWithNibName:@"PopupSelectionIrrigationView" bundle:nil];
    selection.textPickerList = list;
    return selection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _zonesList = [OrderedDictionary dictionaryWithDictionary:self.textPickerList];
    _durationsList = [self getDurationValueList];

    [self.stationButton styleSet:@"zone" andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
    [self.timerButton styleSet:@"duration" andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];

    self.stationButton.layer.cornerRadius = 4.0f;
    self.stationButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.stationButton.layer.borderWidth = 1.0f;

    self.timerButton.layer.cornerRadius = 4.0f;
    self.timerButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.timerButton.layer.borderWidth = 0.0f;

    [self.view layoutIfNeeded];

    // If we have one zone then just show the duration picker
    if (self.textPickerList.count <= 1) {
        // Duration is currently selected
        self.textPickerList = _durationsList;
        [self.titleLabel styleSetWithSpace:@"DURATION" andFontSize:14 bold:YES upperCase:YES];
        self.stationButton.hidden = YES;
        self.timerButton.hidden = YES;

        self.middleHeightConstraint.constant = 0.0;
        _isDurationCurrentlySelected = YES;
        
        [self setCurrentKey:_selectedZoneKey];
    }
    else {
        // Irrigation zone is currently selected
        // Set Middle Text Labels
        self.zoneLabel.text = @"";
        self.durationLabel.text = @"";
        
        _isDurationCurrentlySelected = NO;
        
        [self setCurrentKey:_selectedZoneKey];

        [self onZonePickerChanged:self.textPickerList.allKeys[0]];
    }

    [self durationChanged:self.selectedDurationKey];
}

#pragma mark - PickerDelegate
- (void)initializePicker {
}

- (NSDictionary *)getSelectedValue {
    NSString *zone = _selectedZoneKey;
    if (!zone) {
        zone = @"";
    }
    return @{@"zone": zone, @"time" : _selectedDurationKey};
}


#pragma- UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    id object = self.textPickerList[[self.textPickerList keyAtIndex:row]];

    NSString *valueText;

    if ([object isKindOfClass:[IrrigationZoneModel class]]) {
        valueText = ((IrrigationZoneModel *)object).safeName;
    } else {
        valueText = (NSString*)object;
    }

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
    NSString *key = [self.textPickerList keyAtIndex:row];
    if (!_isDurationCurrentlySelected) {
        [self onZonePickerChanged:key];
    }
    else {
        [self durationChanged:key];
    }
}

#pragma mark - initialize Picker
- (OrderedDictionary *)getDurationValueList {
    // Add minutes
    OrderedDictionary *dict = [[OrderedDictionary alloc] init];


    [dict setObject:@"1 minute" forKey:@(1).stringValue];
    
    for (int i = 2; i <= 15; i++) {
        NSString *str = [NSString stringWithFormat:@"%d minutes", i];
        [dict setObject:str forKey:@(i).stringValue];
    }

    for (int i = 20; i<= 30; i = i+5) {
        NSString *str = [NSString stringWithFormat:@"%d minutes", i];
        [dict setObject:str forKey:@(i).stringValue];
    }

    [dict setObject:@"45 minutes" forKey:@(45).stringValue];

    // Add hours
    [dict setObject:@"1 hour" forKey:@(60).stringValue];
    
    for (int i = 2; i <= 240 / 60; i++) {
        NSString *str = [NSString stringWithFormat:@"%d hours", i];
        [dict setObject:str forKey:@(60 * i).stringValue];
    }
    return dict;
}

#pragma mark - switch buttons
- (IBAction)clickStation:(id)sender {
    _stationButton.layer.borderWidth = 1.0f;
    _timerButton.layer.borderWidth = 0.0f;
    
    self.textPickerList = _zonesList;
    [self setCurrentKey:_selectedZoneKey];
    
    [self.textPicker reloadAllComponents];
    _isDurationCurrentlySelected = NO;
}

- (IBAction)clickTimer:(id)sender {
    _stationButton.layer.borderWidth = 0.0f;
    _timerButton.layer.borderWidth = 1.0f;

    self.textPickerList = _durationsList;
    [self setCurrentKey:_selectedDurationKey];
    
    [self.textPicker reloadAllComponents];
    _isDurationCurrentlySelected = YES;
}

#pragma mark - Custom Time Picker Callback
- (void)onZonePickerChanged:(NSString *)zone {
    self.zoneLabel.text = ((IrrigationZoneModel *)self.textPickerList[zone]).safeName;
    _selectedZoneKey = zone;
    NSString *defaultDuration = @(((IrrigationZoneModel *)self.textPickerList[zone]).defaultDuration).stringValue;
    if (defaultDuration == nil || [defaultDuration isEqualToString:@""])
        defaultDuration = @"1";
    [self durationChanged:defaultDuration];
}

- (void)durationChanged:(NSString *)minutes {
    _selectedDurationKey = minutes;
   self.durationLabel.text = _durationsList[_selectedDurationKey];
 }

@end
