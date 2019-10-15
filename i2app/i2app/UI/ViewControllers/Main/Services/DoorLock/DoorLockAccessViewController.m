//
//  DoorLockAccessViewController.m
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
#import "DoorLockAccessViewController.h"
#import "CommonIconTitleCellTableViewCell.h"
#import "DoorLockPersonViewController.h"

#import "ImagePaths.h"
#import "DoorsNLocksSubsystemController.h"
#import "DoorsNLocksSubsystemCapability.h"



@interface DoorLockAccessViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *shopArea;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;

@end

@implementation DoorLockAccessViewController{
    NSArray *controls;
}

+ (DoorLockAccessViewController *)create {
    DoorLockAccessViewController *controller = [[UIStoryboard storyboardWithName:@"ServicesDetail" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitle:NSLocalizedString(@"Access", nil)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    [self navBarWithBackButtonAndTitle:self.title];
    
    [_shopButton addTarget:self action:@selector(onClickShopButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationListChanged:) name: [Model attributeChangedNotification:kAttrDoorsNLocksSubsystemAuthorizationByLock] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationListChanged:) name: [Model attributeChangedNotification:kAttrDoorsNLocksSubsystemLockDevices] object:nil];
}

- (void)onClickShopButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @""] options:@{} completionHandler:nil];
}

- (void)loadControls {
    
    NSMutableArray *locks = [NSMutableArray array];
    NSArray *lockAddresses  = [[SubsystemsController sharedInstance].doorsNLocksController allDoorLockDeviceAddresses];
    for (NSString *lockAddress in lockAddresses) {
      DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:lockAddress];
      if (device != nil) {
        [locks addObject:device];
      }
    }
    controls = locks;
    [self openShoppingMode:(controls.count == 0)];

    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return controls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonIconTitleCellTableViewCell *cell = [CommonIconTitleCellTableViewCell create:tableView];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    DeviceModel *device = controls[indexPath.row];
    NSString *urlString = [ImagePaths getSmallProductImageFromDevTypeHint:[device devTypeHintToImageName]];
    int numberOfPerson = [self numberOfAuthorizedPersonsForDevice:device];
    [cell setIconPath:urlString withWhiteTitle:device.name subtitle:[NSString stringWithFormat:@"%d People Have Access",numberOfPerson]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceModel *device = controls[indexPath.row];
    
    [self.navigationController pushViewController:[DoorLockPersonViewController createWithDeviceModel:device] animated:YES];
}

#pragma mark - helping methods
- (void)openShoppingMode:(BOOL)status {
    if (status) {
        [_shopArea setHidden:NO];
        [_tableView setHidden:YES];
        
        _shopArea.backgroundColor = [UIColor clearColor];
        [_titleLabel styleSet:NSLocalizedString(@"Know who has access to your home.", nil) andButtonType:FontDataType_DemiBold_16_White_NoSpace];
        [_subtitleLabel styleSet:NSLocalizedString(@"Manage the People who can lock and unlock your doors using PIN codes.", nil) andButtonType:FontDataType_Medium_14_WhiteAlpha_NoSpace];
        
        [_shopButton styleSet:NSLocalizedString(@"SHOP", nil) andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
        _shopButton.layer.cornerRadius = 4.0f;
        _shopButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _shopButton.layer.borderWidth = 1.0f;
    }
    else {
        [_shopArea setHidden:YES];
        [_tableView setHidden:NO];
    }
}

- (int)numberOfAuthorizedPersonsForDevice:(DeviceModel *)deviceModel {
    NSDictionary *authorizedPersonsByLock = [[SubsystemsController sharedInstance].doorsNLocksController authorizationByLockPersons];
    NSArray *person = [authorizedPersonsByLock objectForKey:deviceModel.address];
    
    NSMutableArray *personFilter = [NSMutableArray arrayWithArray:person];
    [personFilter filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        return [[object objectForKey:@"state"] isEqualToString:@"AUTHORIZED"];
    
    }]];
    
    return (int)personFilter.count;
}
#pragma mark - Notification handler 

- (void)authorizationListChanged:(NSNotification *)notification {
    [self loadControls];
}

@end
