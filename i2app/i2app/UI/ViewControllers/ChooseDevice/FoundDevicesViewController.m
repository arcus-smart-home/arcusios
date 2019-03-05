//
//  FoundDevicesViewController.m
//  i2app
//
//  Created by Arcus Team on 7/1/15.
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
#import "FoundDevicesViewController.h"
#import "DeviceTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DevicePairingWizard.h"
#import "DeviceController.h"
#import "DeviceCapability.h"
#import "PromiseKit/Promise.h"
#import "DevicePairingManager.h"
#import "ImageDownloader.h"
#import "UIImage+ImageEffects.h"
#import <i2app-Swift.h>

@interface FoundDevicesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewToBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerSubtitleLabel;

- (IBAction)nextButtonPressed:(id)sender;

@end

@implementation FoundDevicesViewController

+ (FoundDevicesViewController *)create {
    return [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshControls:) name:kUpdateUINotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshControls:) name:kUpdateUIDeviceAddedNotification object:nil];
    
    // If we are in a single device pairing mode but more than one devices have been paired,
    // when we display this VC, hide the "Back"button
    if ([DevicePairingManager sharedInstance].pairingFlowType == PairingFlowTypeAddOneDevice
        || [[DevicePairingManager sharedInstance] hasC2CPairingFlow]) {
        [self hideBackButton];
    }
    
    [[DevicePairingManager sharedInstance] stopHubPairing];
    
    [self.tableView setTableFooterView:[UIView new]];

    long deviceCount = (unsigned long)[DevicePairingManager sharedInstance].justPairedDevices.count;
    if (![[DevicePairingManager sharedInstance] hasHoneywellThermostatsPaired]) {
        // This is the multipairing flow
        [self navBarWithTitle:NSLocalizedString(@"Found devices", nil) andRightButtonText:NSLocalizedString(@"Done", nil) withSelector:@selector(donePressed)];
        NSString *deviceLabel = deviceCount == 1 ? NSLocalizedString(@"Device", nil) : NSLocalizedString(@"Devices", nil);
        self.headerTitleLabel.text = [NSString stringWithFormat:@"%lu %@ Found", deviceCount, deviceLabel];
        self.headerSubtitleLabel.text = NSLocalizedString(@"Name your devices\nand add a photo if you like.", nil);
        self.nextButton.hidden = YES;
        self.tableViewToBottomConstraint = 0;
    }
    else {
        // This is the Honeywell c2c flow
        [self setNavBarTitle:NSLocalizedString(@"Honeywell Thermostat", nil)];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        
        if (deviceCount == 1) {
            self.headerTitleLabel.text = NSLocalizedString(@"You can now control this device in Arcus", nil);
            self.headerSubtitleLabel.text = NSLocalizedString(@"Name your devices\nand add a photo if you like.", nil);
        }
        else {
            self.headerTitleLabel.text = NSLocalizedString(@"You can now control these devices in Arcus", nil);
            self.headerSubtitleLabel.text = NSLocalizedString(@"Name your devices\nand add a photo if you like.", nil);
        }
    }

    if ([[DevicePairingManager sharedInstance] hasC2CPairingFlow]) {
      [[DevicePairingManager sharedInstance] clearUpdatedPairedDevices];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshControls:[NSNotification notificationWithName:kUpdateUINotification object:self]];
}

#pragma mark - Refresh Controls
- (void)refreshControls:(NSNotification *)note {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DevicePairingManager sharedInstance].justPairedDevices.count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    DeviceModel *deviceModel = [DevicePairingManager sharedInstance].justPairedDevices[indexPath.row];
    [cell.mainTextLabel styleSet:deviceModel.name andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
    
    NSString *vendor = [DeviceCapability getVendorFromModel:deviceModel];
    cell.secondaryTextLabel.attributedText = [FontData getString:vendor withFont:FontDataType_MediumItalic_14_BlackAlpha_NoSpace];
    cell.backgroundColor = [UIColor clearColor];
    [cell setMarked:[[DevicePairingManager sharedInstance] isDeviceUpdated:deviceModel]];
    
    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:(DeviceModel *)deviceModel] withDevTypeId:[(DeviceModel *)deviceModel devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:YES].then(^(UIImage *image) {
        cell.deviceImage.image = image;
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceModel *deviceModel = [DevicePairingManager sharedInstance].justPairedDevices[indexPath.row];
    [DevicePairingManager sharedInstance].currentDevice = deviceModel;
    [DevicePairingWizard runMultiplePairingFlowWithDeviceModel:deviceModel andDeviceType:[deviceModel deviceType]];
}

// For non-Honeywell C2C devices
- (void)donePressed {
    if (![[DevicePairingManager sharedInstance] areAllDevicesUpdated]) {
        [self displayMessage:NSLocalizedString(@"Are you sure?", nil) subtitle:NSLocalizedString(@"Arcus is more powerful when you customize your devices.", nil) buttonOne:@"CUSTOMIZE" buttonTwo:@"CONTINUE TO DASHBOARD" withTarget:self withButtonOneSelector:@selector(yesTapped:) andButtonTwoSelector:@selector(noTapped:)];
    }
    else {
        [self noTapped:self];
    }
}

- (void)yesTapped:(id)sender {
    [self slideOutTwoButtonAlert];
}

- (void)noTapped:(id)sender {
    [self slideOutTwoButtonAlert];
    [self onExitFoundDevices];
    
    [[DevicePairingManager sharedInstance] resetAllPairingStates];
}

- (IBAction)nextButtonPressed:(id)sender {
    if (![[DevicePairingManager sharedInstance] areAllDevicesUpdated]) {
        // Go to the first device that has not been paired
        for (int i = 0; i < [DevicePairingManager sharedInstance].justPairedDevices.count; i++) {
            DeviceModel *device = [DevicePairingManager sharedInstance].justPairedDevices[i];
            if (![[DevicePairingManager sharedInstance] isDeviceUpdated:device]) {
                [DevicePairingWizard runMultiplePairingFlowWithDeviceModel:device andDeviceType:device.deviceType];
                break;
            }
        }
    }
    else {
        [self onExitFoundDevices];
    }
}

- (void) onExitFoundDevices {
    [DevicePairingManager sharedInstance].isPostPostPairing = NO;
    [[DevicePairingManager sharedInstance] markAllDevicesUpdated];
    [DevicePairingWizard runPostPostPairingWizard:self];
}

@end
