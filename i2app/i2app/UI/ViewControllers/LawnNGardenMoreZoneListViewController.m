// 
// LawnNGardenMoreZoneListViewController.m
//
// Created by Arcus Team on 3/11/16.
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
#import <PureLayout/PureLayout.h>
#import "LawnNGardenMoreZoneListViewController.h"
#import "LawnNGardenMoreZoneListCell.h"
#import "OrderedDictionary.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "IrrigationZoneModel.h"
#import "LawnNGardenMoreZoneDetailsViewController.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"


@interface LawnNGardenMoreZoneListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) OrderedDictionary *zoneModels;


@end

@implementation LawnNGardenMoreZoneListViewController {

}

+ (LawnNGardenMoreZoneListViewController *)create {
    LawnNGardenMoreZoneListViewController *vc = [[UIStoryboard storyboardWithName:@"LawnNGarden" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];

    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"ZONES", nil)];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];

    [self observeNotifications];

    [self loadData];
}

- (void)dealloc {
  [self removeNotificationObservers];
}

- (void)observeNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadData)
                                               name:kSubsystemInitializedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadData)
                                               name:kSubsystemUpdatedNotification
                                             object:nil];
}

- (void)removeNotificationObservers {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kSubsystemInitializedNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kSubsystemUpdatedNotification
                                                object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadData];
}

- (void)loadData {
    self.zoneModels = [[SubsystemsController sharedInstance].lawnNGardenController getAllZones];

    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.zoneModels && self.zoneModels > 0) {
        return self.zoneModels.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.zoneModels && self.zoneModels > 0) {
        return ((NSArray *)self.zoneModels[[self.zoneModels keyAtIndex:section]]).count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LawnNGardenMoreZoneListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];

    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];

    if (self.zoneModels && self.zoneModels > 0) {
        IrrigationZoneModel *model = self.zoneModels[[self.zoneModels keyAtIndex:indexPath.section]][indexPath.row];
        [cell initializeWithZone:model
                  andDeviceModel:(DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:model.controller]
              withTextColorBlack:NO];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];

    NSString *key = [self.zoneModels keyAtIndex:section];

    UILabel *label = [[UILabel alloc] initForAutoLayout];
    [label styleSet:key andButtonType:FontDataType_DemiBold_14_White_NoSpace];

    [view addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view withOffset:15.0f];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    IrrigationZoneModel *model = self.zoneModels[[self.zoneModels keyAtIndex:indexPath.section]][indexPath.row];

    LawnNGardenMoreZoneDetailsViewController *vc = [LawnNGardenMoreZoneDetailsViewController createWithZoneModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
