//
//  CustomPickerController.m
//  i2app
//
//  Created by Arcus Team on 4/6/15.
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
#import "CustomPickerController.h"

@interface CustomPickerController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *displaySource;

@end

@implementation CustomPickerController

+ (instancetype)customPickerViewWithDataSource:(NSArray *)dataSource displayDataSource:(NSArray *)displaySource withPickerButton:(UIButton *)pickerButton {
    CustomPickerController *customPickerController = [[UIStoryboard storyboardWithName:@"CustomPicker" bundle:nil] instantiateInitialViewController];
    customPickerController.dataSource = dataSource;
    customPickerController.displaySource = displaySource;
    customPickerController.pickerButton = pickerButton;
    [customPickerController setCurrentSelection:[pickerButton currentTitle]];
    
    return customPickerController;
}

+ (instancetype)customPickerViewWithDataSource:(NSArray *)dataSource withPickerButton:(UIButton *)pickerButton {
    CustomPickerController *customPickerController = [[UIStoryboard storyboardWithName:@"CustomPicker" bundle:nil] instantiateInitialViewController];
    customPickerController.dataSource = dataSource;
    customPickerController.pickerButton = pickerButton;
    [customPickerController setCurrentSelection:[pickerButton currentTitle]];
    
    return customPickerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
    NSInteger index = [self.dataSource indexOfObject:_currentSelection];
    if (index != NSNotFound) {
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }
}

#pragma mark - Actions

- (IBAction)closeButtonPressed:(id)sender {
    NSInteger selectedRowIndex = [_pickerView selectedRowInComponent:0];
    NSString *selection = _dataSource[selectedRowIndex];
    [self.delegate picker:self didPressCloseButtonWithSelection:selection];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_displaySource && _displaySource.count > row) {
        return _displaySource[row];
    }
    else {
        return _dataSource[row];
    }
}

@end
