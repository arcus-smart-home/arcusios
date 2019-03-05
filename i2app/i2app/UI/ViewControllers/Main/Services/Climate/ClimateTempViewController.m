//
//  ClimateTempViewController.m
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
#import "ClimateTempViewController.h"
#import "CommonIconTitleCellTableViewCell.h"
#import "ImagePaths.h"
#import "DeviceDetailsTabBarController.h"
#import "ImageDownloader.h"
#import "DeviceController.h"
#import "RelativeHumidityCapability.h"
#import "ClimateSubsystemCapability.h"
#import "ClimateSubSystemController.h"

#import "DeviceCapability.h"

#import <i2app-Swift.h>

@interface ClimateTempViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ClimateTempViewController {
    NSArray     *_tempDevices;
}

+ (ClimateTempViewController *)create {
    return [[UIStoryboard storyboardWithName:@"ServicesDetail" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setTitle:@"Temp"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self navBarWithBackButtonAndTitle:self.title];
    [self loadData];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reloadData:)
                                               name:kSubsystemInitializedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reloadData:)
                                               name:kSubsystemUpdatedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:[Model attributeChangedNotification:kAttrClimateSubsystemTemperatureDevices]
                                               object:nil];
}

- (void)loadData {
    _tempDevices = [[SubsystemsController sharedInstance].climateController temperatureDeviceIds];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tempDevices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonIconTitleCellTableViewCell *cell = [CommonIconTitleCellTableViewCell create:tableView];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:_tempDevices[indexPath.row]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceStateChangedNotification:) name:device.modelChangedNotification object:nil];
    
    int humidity = (int)lround([RelativeHumidityCapability getHumidityFromModel:device]);
    NSString *humdityStr = nil;
    if (humidity > 0) {
        humdityStr = [NSString stringWithFormat:@"%d%% %@", humidity, NSLocalizedString(@"Humidity", nil) ];
    }
    int temperature = (int)lround([DeviceController getTemperatureForModel:device]);
    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device]
                           withDevTypeId:[device devTypeHintToImageName]
                         withPlaceHolder:nil
                                 isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
        [cell setIcon:image withWhiteTitle:device.name subtitle:humdityStr andSide:[NSString stringWithFormat:@"%d°",temperature]];
    }).catch(^{
        [cell setIcon:[[UIImage alloc] init] withWhiteTitle:device.name subtitle:humdityStr andSide:[NSString stringWithFormat:@"%d°",temperature]];
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:_tempDevices[indexPath.row]];

     UIViewController *vc = [DeviceDetailsTabBarController createWithModel:device];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - Notifications
- (void)reloadData:(NSNotification *)notificaiton {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

- (void)getDeviceStateChangedNotification:(NSNotification *)notificaiton {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}
@end




