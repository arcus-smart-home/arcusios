//
//  WaterHeaterTemperatureViewController.m
//  i2app
//
//  Created by Arcus Team on 2/29/16.
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
#import "WaterHeaterTemperatureViewController.h"
#import "SimpleTitleHeader.h"
#import "ALView+PureLayout.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"
#import "CommonTitleValueonRightCell.h"
#import "PopupSelectionWindow.h"
#import "DeviceController.h"
#import "DevicePairingManager.h"
#import "OrderedDictionary.h"
#import "PopupSelectionTextPickerView.h"

const int kMaxSetPointInFahrenheit = 120;
const int kMaxSetPointNotSetOnPlatformConst = 212;

@interface WaterHeaterTemperatureViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) SimpleTitleHeader *simpleHeader;

@end

@implementation WaterHeaterTemperatureViewController {
    PopupSelectionWindow    *_popupWindow;
    int                     _currentTemp;
    int                     _maxTemp;
}

+ (instancetype)createWithDeviceStep:(PairingStep *)step {
    WaterHeaterTemperatureViewController *vc = [WaterHeaterTemperatureViewController new];
    [vc setDeviceStep:step];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Water Heater", nil)];
    
    self.tableView = [[UITableView alloc] initForAutoLayout];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:230.f];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.tableView.scrollEnabled = NO;
    
    UIView *parentView = [UIView newAutoLayoutView];
    [self.view addSubview:parentView];
    [parentView autoSetDimension:ALDimensionHeight toSize:45.0f];
    [parentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:70.f];
    [parentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.f];
    [parentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.f];

    self.simpleHeader = [SimpleTitleHeader create:parentView];
    self.simpleHeader.italicSubtitle = YES;
    [self.simpleHeader setTitle:NSLocalizedString(@"How hot do you want your water?", nil) andSubtitle:NSLocalizedString(@"The recommended temperature is", nil) newStyle:YES];

    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.nextButton];
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nextButton autoSetDimension:ALDimensionHeight toSize:45.0f];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.f];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.f];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.f];
    [self.nextButton styleSet:@"Next" andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    [self.nextButton addTarget:self action:@selector(onClickNext:) forControlEvents:UIControlEventTouchUpInside];

    _currentTemp = (int)[DeviceController getWaterHeaterSetPoint:[DevicePairingManager sharedInstance].currentDevice];
    if (_currentTemp == kMaxSetPointNotSetOnPlatformConst) {
        // The platform is defaulting to 100C (212F) before it gets a device update from the heater
        // Once it gets an update it has the correct temp
        // We need to make sure that the heater's temperature doesn't go past 120
        _currentTemp = kMaxSetPointInFahrenheit;
    }
}

- (void)onClickNext:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DeviceController setWaterHeaterSetPoint:[DevicePairingManager sharedInstance].currentDevice setPoint:_currentTemp].then(^ {
            [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
        });
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonTitleValueonRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTitleValueonRightCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommonTitleValueonRightCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBlackTitle:NSLocalizedString(@"TEMPERATURE", nil) sideValue:[NSString stringWithFormat:@"%d°F", _currentTemp]];
    return cell;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderedDictionary *list = [[OrderedDictionary alloc] init];
    int maxSetPoint = (int)[DeviceController getWaterHeaterMaxSetPoint:[DevicePairingManager sharedInstance].currentDevice];
    if (maxSetPoint == kMaxSetPointNotSetOnPlatformConst) {
        maxSetPoint = kMaxSetPointInFahrenheit;
    }
    [list setObject:@(60) forKey:@"60"];
    for (int i = 80; i <= maxSetPoint ; i++) {
        [list setObject:@(i) forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    PopupSelectionTextPickerView *popupSelection = [PopupSelectionTextPickerView create:@"Temperature" list:list];
    [popupSelection setSign:@"°F" withFrame:YES];
    
    NSNumber *currentValue = @([self getHeatSettingPoint]);
    if (currentValue == 0) {
        currentValue = @(kMaxSetPointInFahrenheit);
    }
    [popupSelection setCurrentKey:[NSString stringWithFormat:@"%@", currentValue]];
    
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:popupSelection
                                         owner:self
                                 closeSelector:@selector(chooseTemperature:)];
}

- (void)chooseTemperature:(NSNumber *)value {
    _currentTemp = value.intValue;
    
    [self.tableView reloadData];
}

- (NSInteger)getHeatSettingPoint {
    if (_currentTemp < 60) {
        return 60;
    }
    return _currentTemp;
}

@end





