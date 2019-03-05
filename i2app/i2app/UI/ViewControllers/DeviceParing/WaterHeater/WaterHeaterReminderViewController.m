//
//  WaterHeaterReminderViewController.m
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
#import "WaterHeaterReminderViewController.h"
#import "SimpleTitleHeader.h"
#import "ALView+PureLayout.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"

@interface WaterHeaterReminderViewController ()

@property (strong, nonatomic) SimpleTitleHeader *simpleHeader;
@property (strong, nonatomic) UIButton *nextButton;
@end

@implementation WaterHeaterReminderViewController

+ (instancetype)createWithDeviceStep:(PairingStep *)step {
    WaterHeaterReminderViewController *vc = [WaterHeaterReminderViewController new];
    [vc setDeviceStep:step];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Water Heater", nil)];

    self.simpleHeader = [SimpleTitleHeader create:self.view];
    [self.simpleHeader setTitle:NSLocalizedString(@"Reminder", nil) andSubtitle:NSLocalizedString(@"The LCD screen on your water heater", nil) newStyle:YES];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.nextButton];
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nextButton autoSetDimension:ALDimensionHeight toSize:45.0f];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.f];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.f];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.f];
    [self.nextButton styleSet:@"Next" andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    [self.nextButton addTarget:self action:@selector(onClickNext:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickNext:(id)sender {
    [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
}

@end





