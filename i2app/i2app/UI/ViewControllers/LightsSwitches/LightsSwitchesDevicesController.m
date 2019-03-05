//
//  LightsSwitchesDevicesController.m
//  i2app
//
//  Created by Arcus Team on 12/25/15.
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

#import "LightsSwitchesDevicesController.h"
#import "ServiceControlCell.h"
#import "LightsSwitchesTabbarController.h"
#import "LightsNSwitchesSubsystemController.h"
#import "SubsystemsController.h"

#import "LightsNSwitchesSubsystemController.h"
#import "SubsystemsController.h"
#import <i2app-Swift.h>
#import "LightCapability.h"
#import "ColorCapability.h"
#import "ColorTemperatureCapability.h"
#import "DeviceDetailsDimmer.h"

@interface LightsSwitchesDevicesController () <UITableViewDelegate, UITableViewDataSource, ArcusColorSelectionDelegate, ServiceControlCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) LightsSwitchesTabbarController *tabbar;

@property (nonatomic, strong) DeviceModel *selectedDevice;

@end

@implementation LightsSwitchesDevicesController {
}

+ (LightsSwitchesDevicesController *)createWithTabbar:(LightsSwitchesTabbarController *)tabbarController {
    LightsSwitchesDevicesController *controller = [[UIStoryboard storyboardWithName:@"lightsSwitches" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    controller.tabbar = tabbarController;
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitle:NSLocalizedString(@"Devices", nil)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabbar) {
        [self.tabbar enableEditButton:YES];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAddedOrRemoved:) name:kSubsystemUpdatedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSubsystemUpdatedNotification object:nil];
}

- (void)toggleEditState {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tabbar) {
        [self.tabbar enableEditButton:!self.tableView.editing];
    }
}

- (void)deviceAddedOrRemoved:(NSNotification *)note {
    NSDictionary *infoDict = (NSDictionary*)note.userInfo;
    NSString *subsystemId = [[[[SubsystemsController sharedInstance] lightsNSwitchesController] subsystemModel] modelId];
    if (([note.name isEqualToString:kSubsystemUpdatedNotification]) &&
        [(NSString *)infoDict[@"subystemId"] isEqualToString:subsystemId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[SubsystemsController sharedInstance] lightsNSwitchesController].allDeviceIds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[[SubsystemsController sharedInstance] lightsNSwitchesController].allDeviceIds[indexPath.row]];
    
    ServiceControlCell *cell = [ServiceControlCell createCell:device owner:self];
    cell.delegate = self;
    
    [cell loadData];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.centerLogoTopConstaint.constant = 25.0f;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[[SubsystemsController sharedInstance] lightsNSwitchesController] switchOrderFrom:sourceIndexPath.row to:destinationIndexPath.row];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark - ServiceControlCellDelegate

- (void)bottomButtonPressed:(id)sender serviceControlCell:(ServiceControlCell *)cell {
    self.selectedDevice = cell.deviceModel;
    if (cell.deviceModel.deviceType == DeviceTypeHalo) {
        [self showColorControlForHaloDevice:cell.deviceModel];
    }
    else {
        DeviceDetailsDimmer* deviceDetailsDimmer = (DeviceDetailsDimmer*) cell.deviceDataModel;
        ArcusNormalColorTempSelectionViewController* picker = [deviceDetailsDimmer colorPickerUsingDelegate:self];
        
        if (picker) {
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }
    }
}

#pragma mark - Color Slider View Loading

- (void)showColorControlForHaloDevice:(DeviceModel *)deviceModel {
    if (deviceModel) {
        
        HaloColorSelectionViewController *colorSelectionViewController = [HaloColorSelectionViewController create];
        colorSelectionViewController.selectionType = ColorSelectionTypeColor;
        colorSelectionViewController.currentColor = [self getOnlineColor:1.0];
        colorSelectionViewController.delegate = self;
        
        [self.navigationController presentViewController:colorSelectionViewController
                                                animated:YES
                                              completion:nil];
    }
}

#pragma mark - ArcusColorSelectionDelegate

- (void)didSelectColor:(UIColor *)color
                   hue:(double)hue
            saturation:(double)saturation
            brightness:(double)brightness
                 alpha:(double)alpha
                sender:(ArcusNormalColorTempSelectionViewController *)sender {
    if (self.selectedDevice) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [ColorCapability setHue:hue * 360 onModel:self.selectedDevice];
            [ColorCapability setSaturation:saturation * 100 onModel:self.selectedDevice];
            [self.selectedDevice commit];
        });
    }
}

- (void)didSelectColorTemperature:(UIColor *)color
                      temperature:(double)temperature
                           sender:(ArcusNormalColorTempSelectionViewController *)sender {
    if (self.selectedDevice) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [ColorTemperatureCapability setColortemp:(int)temperature onModel:self.selectedDevice];
            [self.selectedDevice commit];
        });
    }
}

- (void)didChangeColorSelectionType:(enum ColorSelectionType)selectionType
                             sender:(ArcusNormalColorTempSelectionViewController *)sender {
    if (self.selectedDevice) {
        NSString *colorMode = [LightCapability getColormodeFromModel:self.selectedDevice];
        if (selectionType == ColorSelectionTypeColor && ![colorMode isEqualToString:kEnumLightColormodeCOLOR]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [LightCapability setColormode:kEnumLightColormodeCOLOR
                                      onModel:self.selectedDevice];
                [self.selectedDevice commit];
            });
        } else if (selectionType == ColorSelectionTypeTemperature && ![colorMode isEqualToString:kEnumLightColormodeCOLORTEMP]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [LightCapability setColormode:kEnumLightColormodeCOLORTEMP
                                      onModel:self.selectedDevice];
                [self.selectedDevice commit];
            });
        } else if (selectionType == ColorSelectionTypeNormal && ![colorMode isEqualToString:kEnumLightColormodeNORMAL]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [LightCapability setColormode:kEnumLightColormodeNORMAL
                                      onModel:self.selectedDevice];
                [self.selectedDevice commit];
            });
        }
    }
}

- (void)didDismiss:(ArcusNormalColorTempSelectionViewController *)sender {
    self.selectedDevice = nil;
//    [self.tableView reloadData];
}

#pragma mark - Device Color

- (UIColor *)getOnlineDisplayColor {
    return [self getOnlineColor:0.75];
}

- (UIColor *)getOnlineColor:(double)brightness {
    if (self.selectedDevice) {
        if ([self.selectedDevice isHaloOrHaloPlus]) {
            int hue = [ColorCapability getHueFromModel:self.selectedDevice];
            int saturation = [ColorCapability getSaturationFromModel:self.selectedDevice];

            return [UIColor colorWithHue:hue/360.0
                              saturation:saturation/100.0
                              brightness:0.75
                                   alpha:1.0];
        }

        NSString *colorMode = [LightCapability getColormodeFromModel:self.selectedDevice];
        if (colorMode) {
            if ([colorMode isEqualToString:kEnumLightColormodeCOLOR]) {
                int hue = [ColorCapability getHueFromModel:self.selectedDevice];
                int saturation = [ColorCapability getSaturationFromModel:self.selectedDevice];

                return [UIColor colorWithHue:hue/360.0 saturation:saturation/100.0 brightness:0.75 alpha:1.0];
            } else if ([colorMode isEqualToString:kEnumLightColormodeCOLORTEMP]) {
                int colorTemp = [ColorTemperatureCapability getColortempFromModel:self.selectedDevice];

                return [UIColor colorWithKelvin:colorTemp];
            }
        }
    }

    return [UIColor whiteColor];
}

@end
