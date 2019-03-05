//
// LawnNGardenPairingZoneListViewController.m
//
// Created by Arcus Team on 3/17/16.
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
#import "LawnNGardenPairingZoneListViewController.h"
#import "LawnNGardenMoreZoneListCell.h"
#import "OrderedDictionary.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "IrrigationZoneModel.h"
#import "LawnNGardenPairingZoneDetailsViewController.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"

#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"


@interface LawnNGardenPairingZoneListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *zoneModels;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonPressed:(id)sender;

@end

@implementation LawnNGardenPairingZoneListViewController {
    
}

+ (LawnNGardenPairingZoneListViewController *)create {
    LawnNGardenPairingZoneListViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

static IrrigationZoneModel  *_currentZone;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToLastNavigateColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"ZONES", nil)];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
    
    [self.tableView reloadData];
}

- (void)loadData {
    self.zoneModels = [LawnNGardenSubsystemController getZonesForDeviceAddresses:@[self.deviceModel.address]].allValues[0];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.zoneModels > 0) {
        return self.zoneModels.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LawnNGardenMoreZoneListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (self.zoneModels > 0) {
        IrrigationZoneModel *model = self.zoneModels[indexPath.row];
        [cell initializeWithZone:model
                  andDeviceModel:(DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:model.controller]
              withTextColorBlack:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _currentZone = self.zoneModels[indexPath.row];
    
    [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
}

- (IBAction)nextButtonPressed:(id)sender {
    [[DevicePairingManager sharedInstance].pairingWizard skipNextPairingStep];
    [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
}

+ (IrrigationZoneModel *)getSelectedZone {
    return _currentZone;
}

@end
