//
//  AlarmDeviceListViewController.m
//  i2app
//
//  Created by Arcus Team on 8/25/15.
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
#import "AlarmDeviceListViewController.h"
#import "AlarmDeviceListTableViewCell.h"
#import "OrderedDictionary.h"
#import <PureLayout/PureLayout.h>
#import "ImagePaths.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "AlarmPartialSettingViewController.h"
#import "DeviceDetailsTabBarController.h"
#import "ProductCapability.h"
#import "SecuritySubsystemAlertController.h"
#import "SubsystemsController.h"

#import "SecurityAlarmModeCapability.h"
#import "SecuritySubsystemCapability.h"
#import "SafetySubsystemCapability.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "AKFileManager.h"

#import <i2app-Swift.h>

@interface AlarmDeviceListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) OrderedDictionary *deviceGroup;
@property (nonatomic) AlarmDevicePageType type;
@property (strong, nonatomic) NSArray *devices;

@end

@implementation AlarmDeviceListViewController

#pragma mark - View LifeCycle

+ (AlarmDeviceListViewController *)create:(AlarmDevicePageType)type withStoryboard:(NSString *)storyboard {
    AlarmDeviceListViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.type = type;
    return vc;
}

+ (AlarmDeviceListViewController *)createWithDevices:(NSArray *)devices withStoryboard:(NSString *)storyboard {
    AlarmDeviceListViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.type = AlarmDeviceTypeSecurityDevicesMore;
    vc.devices = devices;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    if (self.devices && self.devices > 0) {
        [self navBarWithBackButtonAndTitle:@"Alarm Devices"];
    }
    else {
        NSString *title;
        if (self.type == AlarmDeviceTypeSafety) {
            title = @"Safety Alarm Devices";
        } else if (self.type == AlarmDeviceTypeSecurityOnMode) {
            title = @"On Devices";
        } else {
            title = @"Partial Devices";
        }
        [self navBarWithBackButtonAndTitle:title];
        [self loadData];
    }
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemTriggeredDevices] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemOfflineDevices] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemSecurityDevices] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:[NSString stringWithFormat:@"%@:%@", kAttrSecurityAlarmModeDevices,kEnumSecuritySubsystemAlarmModeON]] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name:[Model attributeChangedNotification:[NSString stringWithFormat:@"%@:%@", kAttrSecurityAlarmModeDevices,kEnumSecuritySubsystemAlarmModePARTIAL]] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name: [Model attributeChangedNotification:kAttrSafetySubsystemTotalDevices] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicesChanged:) name: [Model attributeChangedNotification:kAttrSafetySubsystemActiveDevices] object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Data I/O

- (void)loadData {
    switch (self.type) {
        case AlarmDeviceTypeSafety:
            _deviceGroup = [self deviceGroupSafetyDevices];
            break;
        case AlarmDeviceTypeSecurityOnMode:
            _deviceGroup = [self alarmDeviceTypeSecurityModeOn];
            
            break;
        case AlarmDeviceTypeSecurityPartialMode:
            _deviceGroup = [self alarmDeviceTypeSecurityModePartial];
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.devices && self.devices > 0) {
        return 1;
    }
    return _deviceGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.devices && self.devices > 0) {
        return self.devices.count;
    }
    id key = [_deviceGroup keyAtIndex:section];
    return ((NSArray *)[_deviceGroup objectForKey:key]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"cell";
    
    AlarmDeviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[AlarmDeviceListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIndentifier];
    }
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell.deviceImage setBorderColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4f]];
    [cell.deviceImage setBorderWidth:1.0f];
    
    DeviceModel *model = nil;
    if (self.devices && self.devices > 0) {
        if (self.devices.count > indexPath.row) {
            model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.devices[indexPath.row]];
        }
    } else {
        id key = [_deviceGroup keyAtIndex:indexPath.section];
        if ([_deviceGroup objectForKey:key] &&
            [[_deviceGroup objectForKey:key] isKindOfClass:[NSArray class]] &&
            ((NSArray *)[_deviceGroup objectForKey:key]).count > indexPath.row) {
            
            model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[_deviceGroup objectForKey:key][indexPath.row]];
        }
    }
    
    if (model) {
        [cell.titleLabel setText:model.name];
        
        NSString *subTitle = nil;
        if (self.type == AlarmDeviceTypeSecurityOnMode || self.type == AlarmDeviceTypeSecurityPartialMode) {
            subTitle = [model securityDeviceStatus];
        } else {
            //"dev:productId"
            NSString *address = [ProductModel addressForId:[DeviceCapability getProductIdFromModel:model]];
            ProductModel *productModel = (ProductModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
            if (productModel) {
                subTitle = [NSString stringWithFormat:@"%@ %@", model.vendor, [ProductCapability getNameFromModel:productModel]];
            }
            else {
                subTitle = model.vendor;
            }
        }
        
        [cell.subtitleLabel setText:subTitle];
        
        if (self.type == AlarmDeviceTypeSecurityDevicesMore) {
            [cell.sideLabel setText:[model securityModeStatus]];
        
            cell.titleLableTrailingConstraint.constant = 120.f;
            cell.redDot.layer.cornerRadius = 2.5f;
            
            if ([model isDeviceOffline]) {
                [cell.redDot setHidden:NO];
                cell.sideLabelTrailingSpace.constant = 19.0f;
            } else {
                [cell.redDot setHidden:YES];
                cell.sideLabelTrailingSpace.constant = 10.0f;
            }
            
            [cell setNeedsDisplay];
        } else {
            [cell.redDot setHidden:YES];
        }
    }
    else {
        [cell.titleLabel styleSet:@"-" andButtonType:FontDataType_MediumItalic_14_WhiteAlpha_NoSpace upperCase:NO];
        [cell.sideLabel styleSet:@"" andButtonType:FontDataType_Medium_12_White];
        [cell.deviceImage setImage:[UIImage imageNamed:@"PlaceholderWhite"]];
        [cell.redDot setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    DeviceModel *model = nil;
    AlarmDeviceListTableViewCell *alarmListCell = (AlarmDeviceListTableViewCell *)cell;
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [alarmListCell setBackgroundColor:[UIColor clearColor]];
    
    if (self.devices && self.devices > 0) {
        if (self.devices.count > indexPath.row) {
            model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.devices[indexPath.row]];
        }
    } else {
        id key = [_deviceGroup keyAtIndex:indexPath.section];
        if ([_deviceGroup objectForKey:key] &&
            [[_deviceGroup objectForKey:key] isKindOfClass:[NSArray class]] &&
            ((NSArray *)[_deviceGroup objectForKey:key]).count > indexPath.row) {
            
            model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[_deviceGroup objectForKey:key][indexPath.row]];
        }
    }
    
    if (model) {
        UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:model.modelId
                                                                     atSize:[UIScreen mainScreen].bounds.size
                                                                  withScale:[UIScreen mainScreen].scale];
        
        if (image) {
            [alarmListCell.deviceImage setBorderedModeEnabled:YES];
            [alarmListCell.deviceImage setImage:image];
        } else {
            [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:(DeviceModel *)model] withDevTypeId:[(DeviceModel *)model devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
                [alarmListCell.deviceImage setBorderedModeEnabled:NO];
                [alarmListCell.deviceImage setImage:image];
            });
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
    
    
    if (!_deviceGroup || _deviceGroup.count == 0) {
        return [[UIView alloc] init];
    }
    
    NSString *key = [_deviceGroup keyAtIndex:section];
    
    if ((_deviceGroup.count == 1) && [key containsString:@"More Devices"]) {
        return [[UIView alloc] init];
    }
    
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
    if (!_deviceGroup || _deviceGroup.count == 0) {
        return 0;
    }
    if ((_deviceGroup.count == 1) && [ [_deviceGroup keyAtIndex:section] containsString:@"More Devices"]) {
        return 0;
    }
    return 30;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ((self.devices && self.devices > 0)) {
        DeviceModel *deviceModel = [self deviceModelAtIndexPath:indexPath];
        AlarmPartialSettingViewController *vc = [AlarmPartialSettingViewController createDeviceModel:deviceModel withStoryboard:@"AlarmStoryboard"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        id key = [_deviceGroup keyAtIndex:indexPath.section];
        DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[_deviceGroup objectForKey:key][indexPath.row]];
        UIViewController *vc = [DeviceDetailsTabBarController createWithModel:device];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark data
- (OrderedDictionary *)deviceGroupSafetyDevices {
    OrderedDictionary *deviceGroup = [[OrderedDictionary alloc] initWithCapacity:0];
    SafetySubsystemAlertController *safetySubSystemController = [[SubsystemsController sharedInstance] safetyController];
    
    NSArray *offlineDeviceIds = [(id<AlarmSubsystemProtocol>)safetySubSystemController offlineDeviceIds];
    
    if (offlineDeviceIds.count > 0) {
        [deviceGroup setObject:offlineDeviceIds forKey:@"Triggered & Offline Devices"];
    }
    
    NSArray *onlineDeviceIds =  [(id<AlarmSubsystemProtocol>)safetySubSystemController onlineDeviceIds];
    if (onlineDeviceIds.count > 0) {
        [deviceGroup setObject:onlineDeviceIds forKey:[NSString stringWithFormat:@"%d More Devices", (int)onlineDeviceIds.count]];
    }
    
    return deviceGroup;
}

- (NSArray *)safetyOnlideDeviceExcludeOfflineDevices {
    SafetySubsystemAlertController *safetySubSystemController = [[SubsystemsController sharedInstance] safetyController];
    NSArray *offlineDevices = [(id<AlarmSubsystemProtocol>)safetySubSystemController offlineDeviceIds];
    NSArray *onlineDevices =  [(id<AlarmSubsystemProtocol>)safetySubSystemController onlineDeviceIds];
   
    return [self excludeInputArray:onlineDevices excludeArray:offlineDevices];
}

- (NSArray *)excludeInputArray:(NSArray *)inputArray excludeArray:(NSArray *)excludedArray {
    NSMutableSet *inputSet = [NSMutableSet setWithArray:inputArray];
    NSSet *excludedSet = [NSSet setWithArray:excludedArray];
    
    [inputSet minusSet:excludedSet];
    
    return [inputSet allObjects];
}

- (OrderedDictionary *)alarmDeviceTypeSecurityModeOn {
    OrderedDictionary *deviceGroup = [[OrderedDictionary alloc] initWithCapacity:0];
    SecuritySubsystemAlertController *securitySubSystemController = [[SubsystemsController sharedInstance] securityController];
    
    NSArray *offlineDevices = [securitySubSystemController offlineDevicesModeON];
    NSArray *openDevices = [securitySubSystemController openDevicesModeON];
    if (openDevices.count > 0 || offlineDevices.count > 0) {
        NSMutableArray *deivces = [[NSMutableArray alloc] initWithArray:openDevices];
        [deivces addObjectsFromArray:offlineDevices];
        
        [deviceGroup setObject:deivces forKey:@"Triggered & Offline Devices"];
    }
    
    NSArray *onModeDevices = [self modeOnDevicesExcludeOpenOfflineDevices];
    if (onModeDevices.count > 0) {
        [deviceGroup setObject:onModeDevices forKey:[NSString stringWithFormat:@"%d More Devices", (int)onModeDevices.count]];
    }
    
    return deviceGroup;
}

- (NSArray *)modeOnDevicesExcludeOpenOfflineDevices {
    SecuritySubsystemAlertController *securitySubSystemController = [[SubsystemsController sharedInstance] securityController];
    NSArray *offlineDevices = [securitySubSystemController offlineDevicesModeON];
    NSArray *openDevices = [securitySubSystemController openDevicesModeON];
    NSArray *onModeDevices = [securitySubSystemController modeONDevices];
    
    NSArray *excludedOpenDevices = [self excludeInputArray:onModeDevices excludeArray:openDevices];
    return [self excludeInputArray:excludedOpenDevices excludeArray:offlineDevices];
}

- (NSArray *)modePartialDevicesExcludeOpenOfflineDevices {
    SecuritySubsystemAlertController *securitySubSystemController = [[SubsystemsController sharedInstance] securityController];
    NSArray *offlineDevices = [securitySubSystemController offlineDevicesModePARTIAL];
    NSArray *openDevices = [securitySubSystemController openDevicesModePARTIAL];
    NSArray *partialModeDevices = [securitySubSystemController modePARTIALDevices];
    
    NSArray *excludedOpen =  [self excludeInputArray:partialModeDevices excludeArray:openDevices];
    
    return [self excludeInputArray:excludedOpen excludeArray:offlineDevices];
}

- (OrderedDictionary *)alarmDeviceTypeSecurityModePartial {
    OrderedDictionary *deviceGroup = [[OrderedDictionary alloc] initWithCapacity:0];
    SecuritySubsystemAlertController *securitySubSystemController = [[SubsystemsController sharedInstance] securityController];

    NSArray *offlineDevices = [securitySubSystemController offlineDevicesModePARTIAL];
    NSArray *openDevices = [securitySubSystemController openDevicesModePARTIAL];
    
    if (openDevices.count > 0 || offlineDevices.count > 0) {
        NSMutableArray *deivces = [[NSMutableArray alloc] initWithArray:openDevices];
        [deivces addObjectsFromArray:offlineDevices];
        
        [deviceGroup setObject:deivces forKey:@"Triggered & Offline Devices"];
    }
    
    NSArray *partialModeDevices = [self modePartialDevicesExcludeOpenOfflineDevices];
    if (partialModeDevices.count > 0) {
        [deviceGroup setObject:partialModeDevices forKey:[NSString stringWithFormat:@"%d More Devices", (int)partialModeDevices.count]];
    }
    
    return deviceGroup;
}

- (NSArray *)subtracArray:(NSArray *)array minusArray:(NSArray *)minusArray {
    NSMutableOrderedSet *aSet = [NSMutableOrderedSet orderedSetWithArray:array];
    NSSet *setMinus = [NSSet setWithArray:minusArray];
    [aSet minusSet:setMinus];
    
    return [aSet array];
}

- (DeviceModel *)deviceModelAtIndexPath:(NSIndexPath *)indexPath {
    if (self.devices && self.devices > 0) {
        return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.devices[indexPath.row]];
    }
    return nil;
}

#pragma Notifications
- (void)devicesChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
        [self.tableView reloadData];
    });
}

@end
