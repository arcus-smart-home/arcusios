//
//  AlarmPartialSettingViewController.m
//  i2app
//
//  Created by Arcus Team on 8/26/15.
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
#import "AlarmPartialSettingViewController.h"
#import "SubsystemsController.h"
#import "SecuritySubsystemAlertController.h"
#import "SecurityAlarmModeCapability.h"


@interface AlarmParialSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;

- (void)setTitle:(NSString *)title selected:(BOOL)selected;

@end

@interface AlarmPartialSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) DeviceModel *deviceModel;

@end

@implementation AlarmPartialSettingViewController {
    NSMutableArray *partials;
}

+ (AlarmPartialSettingViewController *)createWithStoryboard:(NSString *)storyboard {
    AlarmPartialSettingViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

+ (AlarmPartialSettingViewController *)createDeviceModel:(DeviceModel *)deviceModel withStoryboard:(NSString *)storyboard {
    AlarmPartialSettingViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navBarWithBackButtonAndTitle:@""];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onModeDevicesChanged:) name: [Model attributeChangedNotification:[NSString stringWithFormat:@"%@:ON", kAttrSecurityAlarmModeDevices]] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partialModeDevicesChanged:) name: [Model attributeChangedNotification:[NSString stringWithFormat:@"%@:PARTIAL", kAttrSecurityAlarmModeDevices]] object:nil];
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return partials.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmParialSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell setTitle:partials[indexPath.row][@"title"] selected:((NSNumber *)(partials[indexPath.row][@"check"])).boolValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AlarmParialSettingCell *cell = (AlarmParialSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.checkbox setSelected:!cell.checkbox.selected];
    
    switch (indexPath.row) {
        case 0:
            [self setDeviceToModeOnAndPartial:self.deviceModel];
            break;
        case 1:
            [self setDeviceToOnOnlyMode:self.deviceModel];
            break;
        case 2:
            [self setDeviceToPartialOnlyMode:self.deviceModel];
            break;
        case 3:
            [self setDeviceToNoParticipating:self.deviceModel];
            break;
        default:
            break;
    }
}

- (void)loadData {
    partials = [[NSMutableArray alloc] init];
    [partials addObject:@{ @"title":@"ON & PARTIAL", @"check":[NSNumber numberWithBool:[self isOnAndPartialDevice:self.deviceModel]] }];
    [partials addObject:@{ @"title":@"ON", @"check":[NSNumber numberWithBool: [self isOnOnlyDevice:self.deviceModel]] }];
    [partials addObject:@{ @"title":@"PARTIAL", @"check":[NSNumber numberWithBool: [self isPartialOnlyDevice:self.deviceModel]] }];
    [partials addObject:@{ @"title":@"Not Participating", @"check":[NSNumber numberWithBool:[self isNoParticipanting:self.deviceModel]] }];

}

#pragma private helper 

- (BOOL)isOnModeDevice:(DeviceModel *)deviceModel {
    NSArray *onModeDevices = [[SubsystemsController sharedInstance].securityController modeONDevices];
    for (NSString * deviceAddress in onModeDevices) {
        if ([deviceAddress containsString:[deviceModel modelId]]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isPartialModeDevice:(DeviceModel *)deviceModel {
    NSArray *partialModeDevices = [[SubsystemsController sharedInstance].securityController modePARTIALDevices];
    for (NSString * deviceAddress in partialModeDevices) {
        if ([deviceAddress containsString:[deviceModel modelId]]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isOnAndPartialDevice:(DeviceModel *)deviceModel {
    return [self isOnModeDevice:deviceModel] && [self isPartialModeDevice:deviceModel];
}

- (BOOL)isOnOnlyDevice:(DeviceModel *)deviceModel {
    return [self isOnModeDevice:deviceModel] && ![self isPartialModeDevice:deviceModel];
}

- (BOOL)isPartialOnlyDevice:(DeviceModel *)deviceModel {
    return ![self isOnModeDevice:deviceModel] && [self isPartialModeDevice:deviceModel];
}

- (BOOL)isNoParticipanting:(DeviceModel *)deviceModel {
    return ![self isOnModeDevice:deviceModel] && ![self isPartialModeDevice:deviceModel];
}

- (void)removeDeviceFromOnMode:(DeviceModel *)deviceModel {
    if (![self isOnModeDevice:deviceModel]) {
        return;
    }
    
     NSMutableArray *newOnModeDevices = [NSMutableArray arrayWithArray:[[[ SubsystemsController sharedInstance] securityController] modeONDevices]];
    for (NSString *deviceAddress in newOnModeDevices) {
        if ([deviceAddress containsString: [deviceModel modelId]]) {
            [newOnModeDevices removeObject:deviceAddress];
            break;
        }
    }
    
    [[SubsystemsController sharedInstance].securityController setModeONDevices: newOnModeDevices];
}

- (void)addDeviceToOnModeDevices:(DeviceModel *)deviceModel {
    
    if ([self isOnModeDevice:deviceModel]) {
        return;
    }
    
    NSMutableArray *newOnModeDevices = [NSMutableArray arrayWithArray:[[[ SubsystemsController sharedInstance] securityController] modeONDevices]];
    [newOnModeDevices addObject:[deviceModel address]];
    [[SubsystemsController sharedInstance].securityController setModeONDevices: newOnModeDevices];
}

- (void)removeDeviceToPartialModeDevices:(DeviceModel *)deviceModel {
    NSMutableArray *newPartialModeDevices = [NSMutableArray arrayWithArray:[[[ SubsystemsController sharedInstance] securityController] modePARTIALDevices]];
    
    for (NSString *deviceAddress in newPartialModeDevices) {
        if ([deviceAddress containsString: [deviceModel modelId]]) {
            [newPartialModeDevices removeObject:deviceAddress];
            break;
        }
    }
    
    [[SubsystemsController sharedInstance].securityController setModePARTIALDevices: newPartialModeDevices];
}

- (void)addDeviceToPartialModeDevices:(DeviceModel *)deviceModel {
    
    if ([self isPartialModeDevice:deviceModel]) {
        return;
    }
    
    NSMutableArray *newPartialModeDevices = [NSMutableArray arrayWithArray:[[[ SubsystemsController sharedInstance] securityController] modePARTIALDevices]];
    [newPartialModeDevices addObject:[deviceModel address]];
    [[SubsystemsController sharedInstance].securityController setModePARTIALDevices: newPartialModeDevices];
}

- (void)setDeviceToModeOnAndPartial:(DeviceModel *)deviceModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self addDeviceToOnModeDevices:deviceModel];
        [self addDeviceToPartialModeDevices:deviceModel];
    });
}

- (void)setDeviceToOnOnlyMode:(DeviceModel *)deviceModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self addDeviceToOnModeDevices:deviceModel];
        [self removeDeviceToPartialModeDevices:deviceModel];
    });
}

- (void)setDeviceToPartialOnlyMode:(DeviceModel *)deviceModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self addDeviceToPartialModeDevices:deviceModel];
        [self removeDeviceFromOnMode:deviceModel];
    });
}

- (void)setDeviceToNoParticipating: (DeviceModel *)deviceModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self removeDeviceFromOnMode:deviceModel];
        [self removeDeviceToPartialModeDevices:deviceModel];
    });
}

#pragma mark - notification

- (void)onModeDevicesChanged:(NSNotification *)notification {
    [self refreshTable];
}

- (void)partialModeDevicesChanged:(NSNotification *)notification {
    [self refreshTable];
}

- (void)refreshTable {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
        [self.tableView reloadData];
    });
}

@end

@implementation AlarmParialSettingCell

- (void)setTitle:(NSString *)title selected:(BOOL)selected {
    [self.titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    self.checkbox.selected = selected;
}

@end
