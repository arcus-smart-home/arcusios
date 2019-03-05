//
//  CareMoreViewController.m
//  i2app
//
//  Created by Arcus Team on 1/21/16.
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
#import "CareMoreViewController.h"
#import "CareSubsystemController.h"

@interface CareMoreViewController ()

@property (weak, nonatomic) IBOutlet UILabel *careSilentAlarmLabel;
@property (weak, nonatomic) IBOutlet UITextView *careMessageTextView;
@property (weak, nonatomic) IBOutlet UISwitch *careSilentAlarmSwitch;

@end

@implementation CareMoreViewController

BOOL _CareMoreFromDashboardCell;

#pragma mark - View LifeCycle

+ (CareMoreViewController *)create {
    _CareMoreFromDashboardCell = YES;
   return [[UIStoryboard storyboardWithName:@"CareMore" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareMoreViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Care", nil)];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [[self careSilentAlarmLabel] styleSet:NSLocalizedString(@"Care Silent Alarm", nil) andButtonType:FontDataType_DemiBold_13_White upperCase:YES];
    
    [[self careMessageTextView] setText:NSLocalizedString(@"Care More Text", nil)];
    [[self careMessageTextView] setFont:[UIFont fontWithName:@"AvenirNext-MediumItalic" size:14.0]];
    [[self careMessageTextView] setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]];
    
    [[self careSilentAlarmSwitch] setOn:[[SubsystemsController sharedInstance].careController getSilentStatus]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction methods

- (IBAction)changeSilentAlarmState:(UISwitch *)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        BOOL state = [[SubsystemsController sharedInstance].careController setSilent:[sender isOn]];
        DDLogInfo(@"Setting silent to: %@ - Returning state: %@", [sender isOn]? @"ON" : @"OFF", state ? @"true" : @"false");
    });
}

@end
