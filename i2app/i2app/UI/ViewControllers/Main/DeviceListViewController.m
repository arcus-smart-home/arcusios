//
//  DeviceListViewController.m
//  i2app
//
//  Created by Arcus Team on 5/27/15.
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
#import "DeviceListViewController.h"
#import "DeviceTableViewCell.h"
#import "ChooseDeviceViewController.h"
#import "DeviceDetailsTabBarController.h"
#import "DeviceManager.h"
#import "DeviceController.h"

#import "DeviceCapability.h"
#import "HubCapability.h"

#import "UIImageView+WebCache.h"
#import "UIImage+ScaleSize.h"
#import "AKFileManager.h"
#import "ImageDownloader.h"
#import "ZWaveRemovalStartViewController.h"
#import <i2app-Swift.h>
#import <QuartzCore/QuartzCore.h>

@interface DeviceListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *totalDevicesCount;
@property (nonatomic, weak) IBOutlet UILabel *totalDeviceLabel;
@property (nonatomic, weak) IBOutlet UIView *topBar;
@property (nonatomic, weak) IBOutlet UIButton *zWaveToolsButton;

@property (nonatomic, assign) NSInteger selectedDeviceIndex;

@end

@implementation DeviceListViewController {
    NSArray *displayingDevices;
}

#pragma mark - Life Cycle
+ (DeviceListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceListViewController class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:@"Devices"];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    self.topBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [self.totalDeviceLabel setAttributedText:[FontData getString:@"Total Devices" withFont:FontDataTypeTableViewLabel]];
    [self.totalDevicesCount setAttributedText:[FontData getString:[NSString stringWithFormat:@"%lu", (unsigned long)[DeviceManager instance].devices.count] withFont:FontDataTypeTableViewLabel]];
    
    [self configureZWaveToolsButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self deviceListRefreshed:nil];

    [self subscribeToNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self stopSubscribeToNofitication];
}

- (void)configureZWaveToolsButton {
    self.zWaveToolsButton.layer.cornerRadius = 4.0f;
    self.zWaveToolsButton.layer.borderWidth = 1.0f;
    self.zWaveToolsButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:[self.zWaveToolsButton titleForState:UIControlStateNormal]
                                                                      attributes:[FontData getFontWithSize:12.0f
                                                                                                      bold:YES
                                                                                                   kerning:2.0f
                                                                                                     color:[UIColor whiteColor]]];
    
    [self.zWaveToolsButton.titleLabel setAttributedText:buttonTitle];
}

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListRefreshed:) name:Constants.kModelAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListRefreshed:) name:Constants.kModelRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceNameChanged:) name:[Model attributeChangedNotification:kAttrDeviceName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceNameChanged:) name:[Model attributeChangedNotification:kAttrHubName] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListRefreshed:) name:kDeviceListRefreshedNotification object:nil];
}

- (void)stopSubscribeToNofitication {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceListRefreshed:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.totalDevicesCount setAttributedText:[FontData getString:[NSString stringWithFormat:@"%lu", (unsigned long)[DeviceManager instance].devices.count] withFont:FontDataTypeTableViewLabel]];
        [self.view setNeedsLayout];
        
        [self.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)zWaveToolsPressed:(id)sender {
    UIStoryboard *zWaveToolsStoryboard = [UIStoryboard storyboardWithName:@"ZWaveTools" bundle:nil];
    UIViewController *zWaveToolsViewController = [zWaveToolsStoryboard instantiateInitialViewController];
    
    [self.navigationController pushViewController:zWaveToolsViewController animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(DeviceTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (displayingDevices.count <= indexPath.row) {
    return;
  }

  Model *model = displayingDevices[indexPath.row];

  if ([model isKindOfClass:[DeviceModel class]]) {
    DeviceModel *device = (DeviceModel *)model;
    [cell.mainTextLabel styleSet:[device name] andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:NO space:YES] upperCase:YES];
    if ([device isC2CDevice]) {
      cell.cloudImageView.hidden = NO;
      cell.cloudImageView.image = [UIImage imageNamed:[device isDeviceOffline] || device.isDisabledC2CDevice ? @"icon_c2c_device_disconnected" : @"icon_c2c_device_connected"];
    }
    else {
      cell.cloudImageView.hidden = YES;
    }
  }
  else {
    HubModel *hub = (HubModel *)model;
    [cell.mainTextLabel styleSet:[hub name] andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:NO space:YES] upperCase:YES];
    cell.cloudImageView.hidden = YES;
  }

  UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:model.modelId
                                                               atSize:[UIScreen mainScreen].bounds.size
                                                            withScale:[UIScreen mainScreen].scale];

  if (image) {
    cell.deviceImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.deviceImage.clipsToBounds = YES;
    cell.deviceImage.layer.cornerRadius = cell.deviceImage.bounds.size.width / 2;
    [cell.deviceImage setImage:image];
  }
  else {
    if ([model isKindOfClass:[DeviceModel class]]) {
      [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:(DeviceModel *)model]
                             withDevTypeId:[(DeviceModel *)model devTypeHintToImageName]
                           withPlaceHolder:nil isLarge:NO isBlackStyle:NO]
      .then(^(UIImage *image) {
        cell.deviceImage.image = image;
      });
    } else {
      HubModel *hub = (HubModel *)model;
      NSString *productId = nil;
      NSString *hubModel = [HubCapability getModelFromModel:hub];
      if ([hubModel isEqualToString:@"IH300"]){
        productId = @"dee001";
      }
      [ImageDownloader downloadDeviceImage:productId
                             withDevTypeId:[(DeviceModel *)model devTypeHintToImageName]
                           withPlaceHolder:nil isLarge:NO isBlackStyle:NO]
      .then(^(UIImage *image) {
        cell.deviceImage.image = image;
      });
    }
  }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    displayingDevices = [DeviceManager instance].devices;
    return displayingDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.deviceImage.image = [UIImage imageNamed:@"PlaceholderWhite"];
    cell.secondaryTextLabel.textColor = [UIColor whiteColor];
    cell.secondaryTextLabel.font = [UIFont fontWithName:@"AvenirNext-MediumItalic" size:12.0f];

    NSArray * devices = [DeviceManager instance].devices;
    if (indexPath.row < devices.count) {
      DeviceModel* device = devices[indexPath.row];
      cell.offlineImage.hidden = ![device isDeviceOffline];
    }
    cell.disclosureImage.image = [UIImage imageNamed:@"ChevronWhite"];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedDeviceIndex = indexPath.row;
    DeviceModel *device = [DeviceManager instance].devices[indexPath.row];
    
    // It means device list is updated
    if (!device) {
        [self.tableView reloadData];
        return;
    }
    
    UIViewController *vc = [DeviceDetailsTabBarController createWithModel:device];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
}

- (void)addPressed:(id)sender {
    ChooseDeviceViewController *vc = [ChooseDeviceViewController create];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Observers
- (void)deviceNameChanged:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.totalDevicesCount setAttributedText:[FontData getString:[NSString stringWithFormat:@"%lu", (unsigned long)[DeviceManager instance].devices.count] withFont:FontDataTypeTableViewLabel]];
        [self.view setNeedsLayout];
        
        [self.tableView reloadData];
    });
}

@end
