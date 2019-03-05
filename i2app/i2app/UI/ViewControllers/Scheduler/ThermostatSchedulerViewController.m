//
//  ThermostatSchedulerViewController.m
//  i2app
//
//  Created by Arcus Team on 1/8/16.
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
#import "ThermostatSchedulerViewController.h"
#import "DeviceNotificationLabel.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionButtonsView.h"
#import "WeeklyScheduleViewController.h"
#import "ScheduleController.h"


#import <PureLayout/PureLayout.h>
#import "ClimateScheduleController.h"
#import "ThermostatCapability.h"
#import "NSDate+Convert.h"
#import "ThermostatScheduledEventModel.h"

@interface ThermostatSchedulerViewController ()

@property (weak, nonatomic) IBOutlet DeviceNotificationLabel *eventLabel;
@property (weak, nonatomic) IBOutlet UIButton *modeButton;
@property (weak, nonatomic) IBOutlet UIView *schedulerView;

@end

@implementation ThermostatSchedulerViewController {
    PopupSelectionWindow            *_popupWindow;
    WeeklyScheduleViewController    *_schedulerViewController;
}

+ (ThermostatSchedulerViewController *)create:(DeviceModel *)model {
    ThermostatSchedulerViewController *controller = [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _schedulerViewController = [WeeklyScheduleViewController createWithOwner:self];
    _schedulerViewController.hasLightBackground = NO;

    [self navBarWithBackButtonAndTitle:[@"Schedule" uppercaseString]];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    NSString *currentMode = [ThermostatCapability getHvacmodeFromModel:(DeviceModel *)ScheduleController.scheduleController.schedulingModel];
    [self setBottomButtonText:currentMode];
    
    ScheduleController.scheduleController.scheduleMode = [ClimateScheduleController scheduleStringToMode:currentMode];

    if (ScheduleController.scheduleController.scheduleMode == ThermostatOffMode) {
        [self turnThermostatOffMode];
    }

    [self loadData];
}

- (IBAction)onClickMode:(id)sender {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Choose A Mode", nil) button:
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"COOL", nil) event:@selector(turnThermostatCoolMode)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"HEAT", nil) event:@selector(turnThermostatHeatMode)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"AUTO", nil) event:@selector(turnThermostatAutoMode)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"OFF", nil) event:@selector(turnThermostatOffMode)], nil];
    buttonView.owner = self;
    _popupWindow = [PopupSelectionWindow popup:self.view subview:buttonView];
}

- (void)loadData {
    [_schedulerViewController.view removeFromSuperview];

    NSString *tempValue;
    NSDate *nextEventDate;
    if ([ClimateScheduleController nextEventForModel:(DeviceModel *)ScheduleController.scheduleController.schedulingModel eventTime:&nextEventDate eventValue:&tempValue]) {
        NSString *title = [NSString stringWithFormat:@"Next event %@ At ", tempValue];
        NSString *dateString = [nextEventDate formatDateTimeStamp];
        
        [self.eventLabel setTitle:title andContent:dateString];
    }

    [self.schedulerView addSubview:_schedulerViewController.view];
    [_schedulerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_schedulerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_schedulerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_schedulerViewController.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    [_schedulerViewController loadData];
}

#pragma mark - Device function
- (void)turnThermostatHeatMode {
    ScheduleController.scheduleController.scheduleMode = ThermostatHeatMode;
    [self setBottomButtonText:[ClimateScheduleController scheduleModeToString:ThermostatHeatMode]];
    
    [self closeOperation:NO];
    [self loadData];
}

- (void)turnThermostatCoolMode {
    ScheduleController.scheduleController.scheduleMode = ThermostatCoolMode;
    [self setBottomButtonText:[ClimateScheduleController scheduleModeToString:ThermostatCoolMode]];
    
    [self closeOperation:NO];
    [self loadData];
}

- (void)turnThermostatAutoMode {
    ScheduleController.scheduleController.scheduleMode = ThermostatAutoMode;
    [self setBottomButtonText:[ClimateScheduleController scheduleModeToString:ThermostatAutoMode]];
    
    [self closeOperation:NO];
    [self loadData];
}

- (void)turnThermostatOffMode {
    ScheduleController.scheduleController.scheduleMode = ThermostatOffMode;
    [self setBottomButtonText:[ClimateScheduleController scheduleModeToString:ThermostatOffMode]];

    [self closeOperation:YES];
}

- (void)closeOperation:(BOOL)state {
    if (state) {
        [_eventLabel setAttributedText: [FontData getString:@"The thermostat is off." andString2:@"\r\n\r\nTap off above to choose a different mode." withFont:FontDataType_DemiBold_16_White_NoSpace andFont2:FontDataType_Medium_14_WhiteAlpha_NoSpace]];
        [self.schedulerView setHidden:YES];
    }
    else {
        [self.schedulerView setHidden:NO];
        [_eventLabel setText:@""];
        [self loadData];
    }
}

#pragma mark - helping methods
- (void)setBottomButtonText:(NSString *)text {
    if (text && text.length > 0) {
        [_modeButton styleSet:text andButtonType:FontDataType_DemiBold_12_White upperCase:YES];
        _modeButton.layer.cornerRadius = 4.0f;
        _modeButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _modeButton.layer.borderWidth = 1.0f;
    }
    else {
        [_modeButton setTitle:@"" forState:UIControlStateNormal];
        _modeButton.layer.borderWidth = 0.0f;
    }
}

@end
