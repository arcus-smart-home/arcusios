//
//  DeviceHoneywellConnectViewController.m
//  i2app
//
//  Created by Arcus Team on 1/25/16.
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
#import "DeviceHoneywellConnectViewController.h"

@interface DeviceHoneywellConnectViewController ()

@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation DeviceHoneywellConnectViewController

#pragma mark - Life Cycle
+ (DeviceHoneywellConnectViewController *)create {
    return [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceHoneywellConnectViewController class])];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"HONEYWELL ACCOUNT", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];

    [self navBarWithBackButtonAndTitle:self.title];

    [_updateButton styleSet:NSLocalizedString(@"UPDATE CREDENTIALS", nil) andButtonType:FontDataTypeButtonLight upperCase:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

#pragma mark - Methods
- (IBAction)onUpdateButtonPressed:(id)sender {

}


@end
