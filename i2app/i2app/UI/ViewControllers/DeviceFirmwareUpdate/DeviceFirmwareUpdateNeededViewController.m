//
//  DeviceFirmwareUpdateNeededViewController.m
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
#import "DeviceFirmwareUpdateNeededViewController.h"

@interface DeviceFirmwareUpdateNeededViewController ()

@property (nonatomic, strong) IBOutlet UIButton *startUpdateButton;

@end

@implementation DeviceFirmwareUpdateNeededViewController

#pragma mark - View LifeCycle

+ (DeviceFirmwareUpdateNeededViewController *)create {
    DeviceFirmwareUpdateNeededViewController *viewController = [[UIStoryboard storyboardWithName:@"DeviceFirmwareUpdate" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceFirmwareUpdateNeededViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super configureNavigationBarWithCloseButton:NO];
    [self configureImageView];
    [self configureLabels];
    [self configureStartUpdateButton];
}

#pragma mark - UI Configuration

- (void)configureImageView {
    self.iconImageView.image = [UIImage imageNamed:@"hubIcon"];
}

- (void)configureLabels {
    NSString *primaryText = NSLocalizedString(@"Device Firmware Update Required", nil);
    NSAttributedString *primaryAttributedText = [[NSAttributedString alloc] initWithString:primaryText
                                                                                attributes:self.primaryTextAttributes];
    [self.primaryTextLabel setAttributedText:primaryAttributedText];
    
    NSString *secondaryText = NSLocalizedString(@"An update is required. \nThis may take a few minutes.", nil);
    NSAttributedString *secondaryAttributedText = [[NSAttributedString alloc] initWithString:secondaryText
                                                                                  attributes:self.secondaryTextAttributes];
    [self.secondaryTextLabel setAttributedText:secondaryAttributedText];
}

- (void)configureStartUpdateButton {
    [self.startUpdateButton styleSet:NSLocalizedString(@"Update Now", nil)
                andButtonType:FontDataTypeButtonDark
                    upperCase:YES];
}

@end
