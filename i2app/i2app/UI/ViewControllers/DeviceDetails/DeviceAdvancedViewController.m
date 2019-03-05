//
//  AdvancedViewController.m
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
#import "DeviceAdvancedViewController.h"


#import "HubNetworkCapability.h"
#import "HubAdvancedCapability.h"

@interface DeviceAdvancedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *deviceInformationArray;
@property (weak, nonatomic) IBOutlet UIButton *updatebutton;

@property (nonatomic, strong) DeviceModel *currentDevice;
@end

@implementation DeviceAdvancedViewController

+ (DeviceAdvancedViewController *)createWithDeviceModel:(DeviceModel *)deviceModel {
    DeviceAdvancedViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceAdvancedViewController class])];
    vc.currentDevice = deviceModel;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"Advanced", nil);
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
    DeviceAdvancedViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
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
        self.deviceInformationArray = [[NSMutableArray alloc] initWithArray:@[@{@"title": @"Internal \r\n Ip Address", @"value": @"-"}, @{@"title": @"Firmware", @"value": @"ArcusV2.01"} ]];
    }
    else if ([_currentDevice isKindOfClass:[HubModel class]]) {
        NSString *ip = [HubNetworkCapability getIpFromModel:(HubModel *)_currentDevice];
        
        NSString *firmware = [HubAdvancedCapability getBootloaderVerFromModel:(HubModel *)_currentDevice];
        firmware = [NSString stringWithFormat:@"Arcus V%@", firmware];
        
        self.deviceInformationArray = [[NSMutableArray alloc] initWithArray:@[
              @{@"title": @"Internal \r\n Ip Address", @"value": ip?ip:@"-"},
              @{@"title": @"Wireless", @"value":@"Zigbee, Z-Wave, Wifi"},
              @{@"title": @"Firmware", @"value":firmware?firmware:@"-"}
        ]];
    }
    else {
        self.deviceInformationArray = [[NSMutableArray alloc] initWithArray:@[@{@"title": @"Internal \r\n Ip Address", @"value": @"-"}, @{@"title": @"Firmware", @"value": @"ArcusV2.01"} ]];
    }
}

- (IBAction)onClickUpdate:(id)sender {
    
}

@end


@implementation DeviceAdvancedViewControllerTableViewCell

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
