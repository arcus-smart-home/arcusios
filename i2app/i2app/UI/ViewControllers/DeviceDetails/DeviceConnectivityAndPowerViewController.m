//
//  DeviceConnectivityAndPowerViewController.m
//  i2app
//
//  Created by Arcus Team on 6/3/15.
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
#import "DeviceConnectivityAndPowerViewController.h"

#import "HubNetworkCapability.h"
#import "HubPowerCapability.h"
#import "HubNetworkCapability.h"
#import "HubConnectionCapability.h"
#import "Hub4gCapability.h"

@interface DeviceConnectivityAndPowerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *deviceInformationArray;

@property (nonatomic, strong) DeviceModel *currentDevice;

@end

@implementation DeviceConnectivityAndPowerViewController


#pragma mark - Life Cycle
+ (DeviceConnectivityAndPowerViewController *)createWithDeviceModel:(DeviceModel *)device {
    DeviceConnectivityAndPowerViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceConnectivityAndPowerViewController class])];
    vc.currentDevice = device;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"Connectivity & Power", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];

    [self navBarWithBackButtonAndTitle:self.title];

    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceInformationArray.count;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceConnectivityAndPowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *item = [self.deviceInformationArray objectAtIndex:indexPath.item];
    [cell setTitle:[[item objectForKey:@"title"] uppercaseString] Value:[item objectForKey:@"value"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Load Data Methods
- (void)loadData {
    if ([_currentDevice isKindOfClass:[DeviceModel class]]) {
        self.deviceInformationArray = @[
                                        @{@"title": @"Online since", @"value": @"May 29,2015, 8:00 AM \r\n (8 Days, 2hrs, 33min)"},
                                        @{@"title": @"Current \r\nPower supply", @"value": @"AC, Back battery"},
                                        @{@"title": @"Current Internet \r\n Connection", @"value": @"Broadband, Cellular"},
                                        @{@"title": @"Cellular \r\n Strength", @"value": @"Weak"},
                                        @{@"title": @"Cellular \r\n Subscription", @"value": @"Backup, Primary"},
                                        @{@"title": @"Internal \r\n IP Address", @"value": @"28.29.57.23"}];
    }
    else if ([_currentDevice isKindOfClass:[HubModel class]]) {
        HubModel *hubModel = (HubModel *)_currentDevice;
        long since = [HubNetworkCapability getUptimeFromModel:hubModel];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];

        NSDate *startDate = [[NSDate date] dateByAddingTimeInterval:since * -1];
        NSDate *endDate = [NSDate date];

        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        NSString *sinceStr = [NSString stringWithFormat:@"%@\n(%ldd, %ldhrs, %ldmins)", [dateFormatter stringFromDate:startDate], components.day, components.hour, components.minute];
        
        NSString *power = [HubPowerCapability getSourceFromModel:hubModel];
        if ([power isEqualToString:@"MAINS"]) {
            power = @"AC";
        }
        else if ([power isEqualToString:@"BATTERY"]) {
            power = @"DC";
        }
        else {
            power = @"-";
        }

        BOOL isCellular;
        BOOL isWiFi = false;
        NSString *connection = [HubNetworkCapability getTypeFromModel:hubModel];
        if ([connection isEqualToString:kEnumHubNetworkTypeETH]) {
            connection = @"Broadband";
            isCellular = NO;
        }
        else if ([connection isEqualToString:kEnumHubNetworkType3G]) {
            isCellular = YES;
            connection = @"Cellular";
        }
        else if ([connection isEqualToString:kEnumHubNetworkTypeWIFI]) {
          isWiFi = true;
          connection = @"Wi-Fi";
        }
        else if (!connection && connection.length == 0) {
            connection = @"-";
        }

        self.deviceInformationArray = @[
                                        @{ @"title": @"Online since", @"value": sinceStr },
                                        @{ @"title": @"Current Power\nsupply", @"value": power },
                                        @{ @"title": @"Current Internet \r\n Connection", @"value": connection }];

        // For Hub on Cellular
        if (isCellular) {
            self.deviceInformationArray = [self.deviceInformationArray
                                           arrayByAddingObjectsFromArray:@[
                                                                           @{@"title": @"IMEI", @"value": [Hub4gCapability getImeiFromModel:hubModel]},
                                                                           @{@"title": @"SIM CARD ID", @"value": [Hub4gCapability getIccidFromModel:hubModel]}
                                                                           ]];
        } else if (isWiFi) {
          self.deviceInformationArray = [self.deviceInformationArray
                                         arrayByAddingObjectsFromArray:@[
                                                                         @{@"title": @"Wi-Fi Network", @"value": [HubWiFiCapabilityLegacy getWifiSsid:hubModel]},
                                                                         ]];
        }
    }
    else {
        self.deviceInformationArray = @[];
    }
}

@end

@implementation DeviceConnectivityAndPowerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    // Initialization code
    self.titleTextLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13.0f];
    self.titleTextLabel.textColor = [UIColor whiteColor];
    
    self.valueTextLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:14.0f];
    self.valueTextLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setTitle:(NSString *)title Value:(NSString *)value {
    [self.titleTextLabel setText:title];
    [self.valueTextLabel setText:value];
}

@end


