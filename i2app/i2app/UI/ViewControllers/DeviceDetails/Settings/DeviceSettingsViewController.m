//
//  DeviceSettingsViewController.m
//  i2app
//
//  Created by Arcus Team on 8/6/15.
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
#import "DeviceSettingsViewController.h"
#import <PureLayout/PureLayout.h>
#import "DeviceSettingModels.h"


@interface DeviceSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (strong, nonatomic) DeviceModel* deviceModel;

@end

@implementation DeviceSettingsViewController {
    DeviceSettingPackage *_package;
}

+ (DeviceSettingsViewController *)createWithDeviceModel:(DeviceModel*)deviceModel {
    DeviceSettingsViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.deviceModel.name.uppercaseString];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    _package = [DeviceSettingPackage generateDeviceSettingFromDevice:self device:self.deviceModel];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [self loadData];
}

- (void)loadData {
    // Add header
    if (_package.headerText.length > 0) {
        [_headerLabel setNumberOfLines:0];
        if (_package.subscriptionText && _package.subscriptionText.length > 0) {
            
            [_headerLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%@\n\n",_package.headerText] andString2:_package.subscriptionText withFont:FontDataType_Medium_18_White_NoSpace andFont2:FontDataType_Medium_14_WhiteAlpha_NoSpace]];
            
        }
        else {
            [_headerLabel styleSet:_package.headerText andButtonType:FontDataType_Medium_18_White_NoSpace];
        }
        
        [_headerLabel sizeToFit];
        [_headerView layoutIfNeeded];
    }
    else {
        [self.tableView setTableHeaderView:[[UIView alloc] init]];
    }
    
    // Add footer
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [_package loadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_package.unitCollection getNumberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_package.unitCollection getNumberOfRows:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_package.unitCollection getCell:indexPath];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![_package.unitCollection hasSecondLevelUnits]) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
    
    NSString *key = [_package.unitCollection getSectionTitle:section];
    
    UILabel *label = [[UILabel alloc] initForAutoLayout];
    [label styleSet:key andButtonType:FontDataType_DemiBold_14_White];
    
    [view addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view withOffset:15.0f];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_package.unitCollection getHeightOfCell:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    if (![_package.unitCollection hasSecondLevelUnits]) {
        return 0;
    }
    
    if (_package.subscriptionText && _package.subscriptionText.length > 0) {
        return 300;
    }
    else {
        return 30;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end



