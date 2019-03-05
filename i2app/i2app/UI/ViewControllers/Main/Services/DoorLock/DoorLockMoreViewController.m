//
//  DoorLockMoreViewController.m
//  i2app
//
//  Created by Arcus Team on 9/14/15.
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
#import "DoorLockMoreViewController.h"
#import "CommonTitleWithSwitchCell.h"
#import "ImagePaths.h"
#import "DoorsNLocksSubsystemController.h"
#import "SubsystemsController.h"
#import "DoorsNLocksSubsystemCapability.h"

#import "ArcusLabel.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "DeviceController.h"

@interface DoorLockMoreViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet ArcusLabel *titleLabel;
@property (weak, nonatomic) IBOutlet ArcusLabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DoorLockMoreViewController {
    NSArray *_devices;
}

+ (DoorLockMoreViewController *)create {
    DoorLockMoreViewController *controller = [[UIStoryboard storyboardWithName:@"ServicesDetail" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitle:NSLocalizedString(@"More", nil)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.headerView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    [self navBarWithBackButtonAndTitle:self.title];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactSensorsChanged:) name: [Model attributeChangedNotification:kAttrDoorsNLocksSubsystemContactSensorDevices] object:nil];
}

- (void)loadData {
    NSArray *contactSensorAddresses = [[SubsystemsController sharedInstance].doorsNLocksController allContactSensorDeviceAddresses];
    NSMutableArray *contactSensors = [NSMutableArray array];
    
    for (NSString *address in contactSensorAddresses) {
        DeviceModel *model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];

        [contactSensors addObject:model];
    }
    
    _devices = contactSensors.copy;
    
    if (_devices == nil || [_devices count] <= 0) {
        [self.titleLabel styleSet:NSLocalizedString(@"Do More With Your Doors", nil) andButtonType:FontDataType_DemiBold_16_White_NoSpace];
        [_subtitleLabel styleSet:NSLocalizedString(@"Add contact sensors to your doors to configure the hub and keypad to beep when doors are opened.", nil) andButtonType:FontDataType_Medium_14_WhiteAlpha_NoSpace];
        
        [_shopButton styleSet:NSLocalizedString(@"SHOP", nil) andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
        _shopButton.layer.cornerRadius = 4.0f;
        _shopButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _shopButton.layer.borderWidth = 1.0f;
    } else {
        [self.titleLabel styleSet:NSLocalizedString(@"When the following devices are opened, do you want the Hub and Keypad to chime?", nil) andButtonType:FontDataType_DemiBold_16_White_NoSpace];
        self.subtitleLabel.hidden = YES;
        self.shopButton.hidden = YES;
    }

    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];    
}

- (IBAction)onClickShopButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @""]];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceModel *device = _devices[indexPath.row];
    
//    NSString *urlString = [ImagePaths getSmallProductImageFromDevTypeHint:[device devTypeHintToImageName]];
    CommonTitleWithSwitchCell *cell = [[CommonTitleWithSwitchCell create:tableView] setWhiteTitle:device.name selected:YES withObj:device];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.switchSelected = [[SubsystemsController sharedInstance].doorsNLocksController getChimeConfigFromModel:device];
    
    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device] withDevTypeId:[device devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
//        cell.deviceImage.image = image;
        [cell setLogo:image];
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommonTitleWithSwitchCell *cell = (CommonTitleWithSwitchCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.switchSelected = !cell.switchSelected;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[SubsystemsController sharedInstance].doorsNLocksController setChimeConfiguration:cell.switchSelected onModel:_devices[indexPath.row]];
    });
}

#pragma mark - Contact sensors
- (void)contactSensorsChanged:(NSNotification *)notificaiton {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

@end
