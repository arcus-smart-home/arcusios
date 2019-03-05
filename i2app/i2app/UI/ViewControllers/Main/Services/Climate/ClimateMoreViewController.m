 //
//  ClimateMoreViewController.m
//  i2app
//
//  Created by Arcus Team on 9/2/15.
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
#import "ClimateMoreViewController.h"
#import "CommonTitleWithSubtitleCell.h"
#import "PopupSelectionDeviceView.h"

#import "ClimateSubsystemCapability.h"
#import "ClimateSubSystemController.h"
#import "ThermostatCapability.h"
#import "ClimateSubSystemController.h"


@interface ClimateMoreViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) DashboardCardType cardType;

@end

@implementation ClimateMoreViewController {
    NSMutableArray          *_cellItems;
    PopupSelectionWindow    *_popupWindow;
}

+ (ClimateMoreViewController *)create:(DashboardCardType)type {
    ClimateMoreViewController *controller = [[UIStoryboard storyboardWithName:@"ServicesDetail" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    controller.cardType = type;
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setTitle:@"More"];
    _cellItems = [[NSMutableArray alloc] init];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    [self navBarWithBackButtonAndTitle:self.title];
    [self loadData];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:kSubsystemInitializedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:kSubsystemUpdatedNotification
                                               object:nil];

    if ((self.cardType) == DashboardCardTypeClimate) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(primaryDeviceChanged:) name: [Model attributeChangedNotification:kAttrClimateSubsystemPrimaryTemperatureDevice] object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(primaryDeviceChanged:) name: [Model attributeChangedNotification:kAttrClimateSubsystemPrimaryHumidityDevice] object:nil];
        
        //TODO: for now we need to send on off for all the mode therefore just listen to 1 mode is good enough
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scheduleOnOffChanged:) name: [Model attributeChangedNotification:@"sched:enabled:AUTO"] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(primaryDeviceChanged:) name: [Model attributeChangedNotification:@"sched:enabled:COOL"] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(primaryDeviceChanged:) name: [Model attributeChangedNotification:@"sched:enabled:HEAT"] object:nil];
    }
}

- (void)loadData {
    // Disllow reentry into this block from other threads; results in duplicate cells
    dispatch_async(dispatch_get_main_queue(), ^{
        [_cellItems removeAllObjects];
        switch (self.cardType) {
            case DashboardCardTypeClimate: {
              
                [_cellItems addObject:[[CommonTitleWithSubtitleCell create:_tableView] setWhiteTitle:NSLocalizedString(@"Temperature", nil) subtitle:NSLocalizedString(@"Dashboard temperature is based off of this device.", nil) side: [self primaryTempDeviceName]]];
                [_cellItems addObject:[[CommonTitleWithSubtitleCell create:_tableView] setWhiteTitle:NSLocalizedString(@"Humidity", nil) subtitle:NSLocalizedString(@"Dashboard humidity is based off of this device.", nil) side:[self primaryHumidDeviceName]]];
            }
                break;
            case DashboardCardTypeDoorsLocks: {
                //TODO: disaply door lock more page, it's not in InVision yet.
                [_cellItems addObject:[[CommonTitleWithSubtitleCell create:_tableView] setNoSideWhiteTitle:NSLocalizedString(@"Door lock information", nil) subtitle:NSLocalizedString(@"Information detail..", nil)]];
            }
                break;
            default:
                break;
        }

      [self.tableView reloadData];
      [self.view layoutIfNeeded];
  });
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_cellItems objectAtIndex:indexPath.row];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_cellItems objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[CommonTitleWithSubtitleCell class]]) {
        return 85;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( self.cardType == DashboardCardTypeClimate && (indexPath.row == (_cellItems.count - 2)) ) {
        [self selectPrimaryTempDevice];
    }
    else if ( self.cardType == DashboardCardTypeClimate && (indexPath.row == (_cellItems.count - 1)) ) {
        [self selectPrimaryHumidDevice];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell sizeToFit];
    [cell layoutIfNeeded];
}

#pragma mark - handle primary temp, humid

- (NSString *)primaryTempDeviceName {
    return [self primaryTempDevice].name;
}

- (DeviceModel *)primaryTempDevice {
    NSString *primaryAddress = [[SubsystemsController sharedInstance].climateController primaryTempDeviceId];
    return  (DeviceModel*)[[[CorneaHolder shared] modelCache] fetchModel:primaryAddress];
}

- (NSString *)primaryHumidDeviceName {
    return [self primaryHumidDevice].name;
}

- (DeviceModel *)primaryHumidDevice {
    NSString *primaryAddress = [[SubsystemsController sharedInstance].climateController primaryHumidityDeviceId];
    return  (DeviceModel*)[[[CorneaHolder shared] modelCache] fetchModel:primaryAddress];
}

- (void)selectPrimaryTempDevice {
    NSArray *tempAddresses = [[SubsystemsController sharedInstance].climateController temperatureDeviceIds];
    NSMutableArray *tempDevices = [NSMutableArray array];
    for (NSString *tempAddress in tempAddresses) {
        [tempDevices addObject:[[[CorneaHolder shared] modelCache] fetchModel:tempAddress]];
    }
    PopupSelectionDeviceView *deviceSelectPopup = [PopupSelectionDeviceView create:@"Choose a Device" devices:tempDevices withInitialSelection:[self primaryTempDevice]];
    _popupWindow = [PopupSelectionWindow popup:self.view subview: deviceSelectPopup owner:self closeSelector:@selector(selectedPrimaryTempDevice:)];
}

- (void)selectPrimaryHumidDevice {
    NSArray *humidAddresses = [[SubsystemsController sharedInstance].climateController humidDeviceIds];
    if (humidAddresses.count == 0) {
        [self popupMessageWindow:NSLocalizedString(@"No Humidity Sensors Paired", nil) subtitle:NSLocalizedString(@"You don't have a device that can report humidity paired.", nil)];
        return;
    }

    NSMutableArray *humidDevices = [NSMutableArray array];
    for (NSString *humidAddress in humidAddresses) {
        [humidDevices addObject:[[[CorneaHolder shared] modelCache] fetchModel:humidAddress]];
    }

    PopupSelectionDeviceView *deviceSelectPopup = [PopupSelectionDeviceView create:@"Choose a Device" devices:humidDevices withInitialSelection:[self primaryHumidDevice]];
    _popupWindow = [PopupSelectionWindow popup:self.view subview: deviceSelectPopup owner:self closeSelector:@selector(selectedPrimaryHumidDevice:)];
}

- (void)selectedPrimaryTempDevice:(DeviceModel *)device {
    if (!device) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[SubsystemsController sharedInstance].climateController setPrimaryTempDeviceAddress:device.address];
    });
}

- (void)selectedPrimaryHumidDevice:(DeviceModel *)device {
    if (!device) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[SubsystemsController sharedInstance].climateController setPrimaryHumidDeviceAddress:device.address];
    });
}

#pragma mark - Notifications
- (void)primaryDeviceChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}
- (void)scheduleOnOffChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}
@end
