//
//  ServiceControlsViewController.m
//  i2app
//
//  Created by Arcus Team on 9/1/15.
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
#import "ServiceControlsViewController.h"

#import "DeviceDetailsTabBarController.h"
#import "ServiceControlCell.h"
#import "UIViewController+AlertBar.h"

#import "ClimateSubSystemController.h"
#import "ClimateSubsystemCapability.h"
#import "DoorsNLocksSubsystemController.h"
#import "DoorsNLocksSubsystemCapability.h"
#import "DeviceConnectionCapability.h"

#import <i2app-Swift.h>

@interface ServiceControlsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) DashboardCardType cardType;

@property (weak, nonatomic) IBOutlet UIView *disableArea;
@property (weak, nonatomic) IBOutlet UILabel *disabledTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *disabledSubtitleLabe;
@property (weak, nonatomic) IBOutlet UIButton *disabledShopButton;


@end

@implementation ServiceControlsViewController {
    NSArray     *_controls;
}

+ (ServiceControlsViewController *)create:(DashboardCardType)type {
    ServiceControlsViewController *controller = [[UIStoryboard storyboardWithName:@"ServicesDetail" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    controller.cardType = type;
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitle:@"Devices"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.view setBackgroundColor:[UIColor clearColor]];
  [self.tableView setBackgroundColor:[UIColor clearColor]];
  [self.tableView setTableFooterView:[UIView new]];
  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, RDV_TABLE_VIEW_BOTTOM_INSET, 0);

  [self navBarWithBackButtonAndTitle:DashboardCardTypeToString(self.cardType)];

  _controls = [[NSMutableArray alloc] init];
  [self loadControls];

  SEL selector = nil;

  if (self.cardType == DashboardCardTypeClimate) {
    selector = @selector(climateDeviceChanged:);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:[Model attributeChangedNotification:kAttrClimateSubsystemControlDevices]
                                               object:nil];
  } else if (self.cardType == DashboardCardTypeDoorsLocks) {
    selector = @selector(doorsNLocksDevicesChanged:);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:[Model attributeChangedNotification:kAttrDoorsNLocksSubsystemLockDevices]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:[Model attributeChangedNotification:kAttrDoorsNLocksSubsystemMotorizedDoorDevices]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:[Model attributeChangedNotification:kAttrDoorsNLocksSubsystemContactSensorDevices]
                                               object:nil];
  }

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:selector
                                               name:kSubsystemInitializedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:selector
                                               name:kSubsystemUpdatedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(connectionStateChangedNotification:) name:[Model attributeChangedNotification:kAttrDeviceConnectionState]
                                             object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.cardType == DashboardCardTypeClimate) {
        [self.tableView reloadData];
    }
}

- (void)loadControls {
    // TODO: adjust the related devices
    switch (self.cardType) {
        case DashboardCardTypeClimate:
            _controls = [SubsystemsController sharedInstance].climateController.allDeviceIds;
            break;
            
        case DashboardCardTypeDoorsLocks:
            _controls = [SubsystemsController sharedInstance].doorsNLocksController.allDeviceIds;
            break;
        default:
            break;
    }
    [self displayShoppingMode:(_controls.count == 0)];
}

- (void)displayShoppingMode:(BOOL)status {
    if (status) {
        [_disableArea setBackgroundColor:[UIColor clearColor]];
        [_disableArea setHidden:NO];
        [_tableView setHidden:YES];
        
        [_disabledShopButton styleSet:@"SHOP" andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
        _disabledShopButton.layer.cornerRadius = 4.0f;
        _disabledShopButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _disabledShopButton.layer.borderWidth = 1.0f;
        [_disabledShopButton addTarget:self action:@selector(shopClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (self.cardType) {
            case DashboardCardTypeClimate:
                [_disabledTitleLabel styleSet:NSLocalizedString(@"Control Your Climate", nil) andButtonType:FontDataType_DemiBold_16_White_NoSpace];
                [_disabledSubtitleLabe styleSet:NSLocalizedString(@"Manage your thermostats, ceiling fans and vents", nil) andButtonType:FontDataType_Medium_14_WhiteAlpha_NoSpace];
                
                break;
            default:
                [_disabledTitleLabel setText:@""];
                [_disabledSubtitleLabe setText:@""];
                break;
        }
    }
    else {
        [_disableArea setHidden:YES];
        [_tableView setHidden:NO];
        
        [self.tableView reloadData];
    }
}


#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _controls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *address = [DeviceModel addressForId:[_controls objectAtIndex:indexPath.row]];
    DeviceModel *model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    
    ServiceControlCell *cell = [ServiceControlCell createCell:model owner:self];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 146;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ServiceControlCell class]]) {
        ServiceControlCell *serviceCell = (ServiceControlCell *)cell;
        [cell layoutIfNeeded];
        [serviceCell loadData];

        NSString *address = [DeviceModel addressForId:[_controls objectAtIndex:indexPath.row]];
        DeviceModel *model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];

        [(ServiceControlCell *)cell displayOfflineScreen:model.isDisabledDevice];
    }
}
#pragma mark - button actions

- (void)shopClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @""]];
}

#pragma mark - Notifications
- (void)climateDeviceChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self loadControls];
    });
}
- (void)doorsNLocksDevicesChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self loadControls];
    });
}

- (void)connectionStateChangedNotification:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

@end


