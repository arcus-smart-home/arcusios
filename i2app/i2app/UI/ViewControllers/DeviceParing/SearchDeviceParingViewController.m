//
//  SearchDeviceParingViewController.m
//  i2app
//
//  Created by Arcus Team on 7/21/15.
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
#import "SearchDeviceParingViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "DevicePairingWizard.h"
#import "DeviceCapability.h"
#import "DeviceTextfieldViewController.h"
#import "PairingStep.h"

@interface SearchDeviceParingViewController ()

@property (nonatomic, strong) NSTimer *waitTimer;

- (void)deviceAdded:(NSNotification *)note;

@end

@implementation SearchDeviceParingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.step.title];    
    [self setBackgroundColorToParentColor];
    
    if ([DevicePairingManager sharedInstance].justPairedDevices.count > 0) {
        [self deviceAdded:nil];
    }    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Add notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAdded:) name:kUpdateUIDeviceAddedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playSound {
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"108" ofType:@"wav"]] error:NULL];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

// We need to override the nextButtonPressed so that we don't navigate away from
// this page
- (void)nextButtonPressed:(id)sender {
}

- (void)deviceAdded:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the current deviceModel from DevicePairingManager
        if ([DevicePairingManager sharedInstance].currentDevice.deviceType == [DevicePairingManager sharedInstance].pairingWizard.deviceType) {
            if ([DevicePairingManager sharedInstance].currentDevice.deviceType != DeviceTypeCarePendant) {
                DeviceTextfieldViewController *vc = [DeviceTextfieldViewController createWithDeviceModel:[DevicePairingManager sharedInstance].currentDevice];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [super nextButtonPressed:self];
            }
        }
        else if ([DevicePairingManager sharedInstance].pairingWizard.deviceType == DeviceTypeNone) {
            DeviceTextfieldViewController *vc = [DeviceTextfieldViewController createWithDeviceModel:[DevicePairingManager sharedInstance].currentDevice];
            [self.navigationController pushViewController:vc animated:YES];
        }
    });
}

- (void)gotoNextStep {
    // We need to make sure that the
    [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
}

@end
