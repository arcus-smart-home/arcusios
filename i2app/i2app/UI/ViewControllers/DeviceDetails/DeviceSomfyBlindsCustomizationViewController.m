// 
// DeviceSomfyBlindsCustomizationViewController.m
//
// Created by Arcus Team on 4/7/16.
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
#import "DeviceSomfyBlindsCustomizationViewController.h"
#import "DeviceMoreTableViewCell.h"

@interface DeviceSomfyBlindsCustomizationViewController()

@property (assign, nonatomic) UITableView *tableView;

@end

@implementation DeviceSomfyBlindsCustomizationViewController {

}

+ (DeviceSomfyBlindsCustomizationViewController *)create {
    DeviceSomfyBlindsCustomizationViewController *viewController = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil]
            instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceSomfyBlindsCustomizationViewController class])];

    return viewController;
}

#pragma mark - Life Cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"CUSTOMIZATION", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];

    [self navBarWithBackButtonAndTitle:self.title];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

#pragma mark - TableView Delegate DataSource

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"CenterTextCell"];

            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [cell setBackgroundColor:[UIColor clearColor]];
            [(DeviceMoreTableViewCell *) cell setData:NSLocalizedString(@"Configure Open/Up Position", nil) secondText:NSLocalizedString(@"1. Open the blind completely.\n\n2. Simultaneously press and hold the up and down button on the remote until the shade jogs.\n\n3. Adjust the blind to the desired Open/Up position.\n\n4. Press and hold \"MY\" on the remote until the shade jogs.", nil) iconType:NSNotFound];
            [((DeviceMoreTableViewCell *) cell).disclosureImage setHidden:YES];

            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"CenterTextCell"];

            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [cell setBackgroundColor:[UIColor clearColor]];
            [(DeviceMoreTableViewCell *) cell setData:NSLocalizedString(@"Configure Closed/Down Position", nil) secondText:NSLocalizedString(@"1. Close the blind completely.\n\n2. Simultaneously press and hold the up and down button on the remote until the shade jogs.\n\n3. Adjust the blind to the desired Closed/Down position.\n\n4. Press and hold \"MY\" on the remote until the shade jogs.", nil) iconType:NSNotFound];
            [((DeviceMoreTableViewCell *) cell).disclosureImage setHidden:NO];

            break;
    }

    return cell;
}

@end
