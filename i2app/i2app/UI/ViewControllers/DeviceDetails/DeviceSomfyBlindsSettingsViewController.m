//
//  DeviceSomfyBlindsSettingsViewController.m
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
#import "DeviceSomfyBlindsSettingsViewController.h"

#import "DeviceMoreTableViewCell.h"
#import "DeviceSettingCells.h"
#import "Somfyv1Capability.h"
#import "PopupSelectionBaseContainer.h"
#import "PopupSelectionTitleTableView.h"
#import "PopupSelectionButtonsView.h"
#import "MessageWithButtonsViewController.h"
#import "DeviceSomfyBlindsCustomizationViewController.h"

@interface DeviceSomfyBlindsSettingsViewController ()

@property (strong, nonatomic) DeviceModel *deviceModel;
@property (assign, nonatomic) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@property (assign, nonatomic) NSString *mode;

@end

@implementation DeviceSomfyBlindsSettingsViewController {
    PopupSelectionWindow *_popupWindow;
}

#pragma mark - Life Cycle
+ (DeviceSomfyBlindsSettingsViewController *)createWithDevice:(NSString*)address {
    DeviceSomfyBlindsSettingsViewController *viewController =
  [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil]
            instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceSomfyBlindsSettingsViewController class])];
    viewController.deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];

    return viewController;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"SETTINGS", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];

    [self navBarWithBackButtonAndTitle:self.title];

    [_updateButton styleSet:NSLocalizedString(@"UPDATE CREDENTIALS", nil) andButtonType:FontDataTypeButtonLight upperCase:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSString *mode = [Somfyv1Capability getTypeFromModel:self.deviceModel];

    if ([mode isEqualToString:kEnumSomfyv1TypeBLIND]) {
        self.mode = @"Tilt";
    } else {
        self.mode = @"Raise/Lower";
    }
}

#pragma mark - TableView Delegate DataSource

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];

            int channel = [Somfyv1Capability getChannelFromModel:self.deviceModel];

            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [cell setBackgroundColor:[UIColor clearColor]];
            [(DeviceMoreTableViewCell *)cell setData:NSLocalizedString(@"CHANNEL ON CONTROLLER", nil) secondText:nil iconType:NSNotFound];
            [((DeviceMoreTableViewCell *)cell).settingsLabel styleSet:[NSString stringWithFormat:@"%d", channel]
                           andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
            [((DeviceMoreTableViewCell *)cell).disclosureImage setHidden:YES];

            break;
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];

            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [cell setBackgroundColor:[UIColor clearColor]];
            [(DeviceMoreTableViewCell *) cell setData:NSLocalizedString(@"BLIND TYPE", nil) secondText:nil iconType:NSNotFound];
            [((DeviceMoreTableViewCell *) cell).settingsLabel styleSet:self.mode
                                                         andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
            [((DeviceMoreTableViewCell *) cell).disclosureImage setHidden:NO];

            break;
        }
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];

            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [cell setBackgroundColor:[UIColor clearColor]];
            [(DeviceMoreTableViewCell *) cell setData:NSLocalizedString(@"CUSTOMIZATION", nil) secondText:nil iconType:NSNotFound];
            [((DeviceMoreTableViewCell *) cell).disclosureImage setHidden:NO];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"TextSwitchCell"];

            NSString *reversed = [Somfyv1Capability getReversedFromModel:self.deviceModel];
            BOOL isReversed = [reversed isEqualToString:kEnumSomfyv1ReversedREVERSED];

            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [cell setBackgroundColor:[UIColor clearColor]];
            DeviceSettingTextSubtitleSwitchCell *switchCell = (DeviceSettingTextSubtitleSwitchCell *)cell;
            [switchCell setUnitData:nil];
            [[switchCell titleLabel] setText:@"REVERSE BLIND DIRECTION"];
            [[switchCell switchButton] addTarget:self
                                          action:@selector(clickedSwitch:)
                                forControlEvents:UIControlEventTouchUpInside];
            [[switchCell switchButton] setSelected:isReversed];

            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 1) {
        PopupSelectionButtonsView *buttonView;
        buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"BLIND TYPE", nil) button:
                    [PopupSelectionButtonModel create:@"TILT" event:@selector(onTiltPressed)],
                    [PopupSelectionButtonModel create:@"RAISE/LOWER" event:@selector(onRaiseLowerPressed)], nil];

        buttonView.owner = self;
        [self popup:buttonView complete:nil];
    } else if (indexPath.row == 2) {
        DeviceSomfyBlindsCustomizationViewController *vc = [DeviceSomfyBlindsCustomizationViewController create];

        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - Methods

- (IBAction)clickedSwitch:(id)sender {
    NSString *reversed = [Somfyv1Capability getReversedFromModel:self.deviceModel];
    BOOL isReversed = [reversed isEqualToString:kEnumSomfyv1ReversedREVERSED];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [Somfyv1Capability setReversed:((isReversed) ? kEnumSomfyv1ReversedNORMAL : kEnumSomfyv1ReversedREVERSED) onModel:self.deviceModel];
        [self.deviceModel commit].then(^{
        });
    });
}

- (void)completedSelection:(id)selectedValue {

}

- (void)onTiltPressed {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [Somfyv1Capability setType:kEnumSomfyv1TypeBLIND onModel:self.deviceModel];
            [self.deviceModel commit].then(^{
                self.mode = @"Tilt";
                [self.tableView reloadData];
            });
        });
}

- (void)onRaiseLowerPressed {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [Somfyv1Capability setType:kEnumSomfyv1TypeSHADE onModel:self.deviceModel];
            [self.deviceModel commit].then(^{
                self.mode = @"Raise/Lower";
                [self.tableView reloadData];
            });
        });
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}



@end
