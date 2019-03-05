//
//  DeviceFirmwareUpdatingViewController.m
//  i2app
//
//  Created by Arcus Team on 10/12/15.
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
#import "DeviceFirmwareUpdatingViewController.h"
#import "DeviceFirmwareUpdateCompletionViewController.h"
#import "DeviceManager.h"
#import "DeviceOtaCapability.h"

NSString *const kUpdateSuccessfulSegue = @"DeviceFirmwareUpdateSuccessfulSegue";
NSString *const kUpdateFailedSegue = @"DeviceFirmwareUpdateFailedSegue";

@interface DeviceFirmwareUpdatingViewController ()

@end

@implementation DeviceFirmwareUpdatingViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBarWithCloseButton:YES];
    [self configureLabels];
    
    [self createGif];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceFirmwareUpdateNotificationReceived:)
                                                 name:[Model attributeChangedNotification:kAttrDeviceOtaStatus]
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Handling

- (void)deviceFirmwareUpdateNotificationReceived:(NSNotification *)notification {
    if ([[[DeviceManager instance] devicesUndergoingFirmwareUpdate] count] == 0) {
        [self deviceFirmwareUpdateWasSuccessful:YES];
    }
}

#pragma mark - UI Configuration

- (void)configureImageView {
    self.iconImageView.image = [UIImage imageNamed:@""];
}

- (void)configureLabels {
    NSString *primaryText = NSLocalizedString(@"Updating", nil);
    NSAttributedString *primaryAttributedText = [[NSAttributedString alloc] initWithString:primaryText
                                                                                attributes:self.primaryTextAttributes];
    [self.primaryTextLabel setAttributedText:primaryAttributedText];
    
    NSString *secondaryText = NSLocalizedString(@"Keep the app open during this update.", nil);
    NSAttributedString *secondaryAttributedText = [[NSAttributedString alloc] initWithString:secondaryText
                                                                                  attributes:self.secondaryTextAttributes];
    [self.secondaryTextLabel setAttributedText:secondaryAttributedText];
}

#pragma mark - Update Completion Handling

- (void)deviceFirmwareUpdateWasSuccessful:(BOOL)updateCompleted {
    if (updateCompleted) {
        [self performSegueWithIdentifier:kUpdateSuccessfulSegue sender:self];
    }
    else {
        [self performSegueWithIdentifier:kUpdateFailedSegue sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DeviceFirmwareUpdateCompletionViewController class]]) {
        DeviceFirmwareUpdateCompletionViewController *completionViewController = (DeviceFirmwareUpdateCompletionViewController *)segue.destinationViewController;
        completionViewController.updateSuccessful = [segue.identifier isEqualToString:kUpdateSuccessfulSegue];
    }
}

@end
