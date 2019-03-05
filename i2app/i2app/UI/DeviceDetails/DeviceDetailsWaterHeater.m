//
//  DeviceDetailsWaterHeater.m
//  i2app
//
//  Created by Arcus Team on 1/13/16.
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
#import "DeviceDetailsWaterHeater.h"
#import "DeviceButtonBaseControl.h"
#import "PopupSelectionBaseContainer.h"
#import "PopupSelectionButtonsView.h"
#import "DeviceController.h"
#import "WaterHeaterCapability.h"
#import "SimpleTableViewController.h"
#import "CommonCheckableCell.h"
#import "AOSmithWaterHeaterControllerCapability.h"

@interface WaterHeaterModePickerDelegate : SimpleTableDelegateBase

@property (weak, nonatomic) DeviceDetailsWaterHeater *owner;

@end

@implementation WaterHeaterModePickerDelegate {
    NSString *_currentMode;
}

+ (WaterHeaterModePickerDelegate *)create:(DeviceDetailsWaterHeater *)owner {
    WaterHeaterModePickerDelegate *d = [WaterHeaterModePickerDelegate new];
    d.owner = owner;
    return d;
}
- (NSString *)getHeaderText {
    return @"CHOOSE A MODE";
}
- (void)initializeData {
    [super initializeData];
    
    _currentMode = [DeviceController getWaterHeaterControlMode:self.owner.deviceModel];
}

- (NSArray<SimpleTableCell *> *) getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    NSMutableArray<SimpleTableCell *> *reuslt = [[NSMutableArray alloc] init];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    {
        CommonCheckableCell *tableCell = [CommonCheckableCell create:tableView];
        SimpleTableCell *cell = [SimpleTableCell create:tableCell withOwner:self andPressSelector:@selector(chooseMode:)];
        [tableCell setBlackTitle:NSLocalizedString(kEnumAOSmithWaterHeaterControllerControlmodeSTANDARD, nil) withSubtitle:@""];
        [tableCell setSelectedBox:[_currentMode isEqualToString:kEnumAOSmithWaterHeaterControllerControlmodeSTANDARD]];
        [tableCell displayArrow:NO];
        [cell setDataObject:kEnumAOSmithWaterHeaterControllerControlmodeSTANDARD];
        
        [reuslt addObject:cell];
    }
    
    {
        CommonCheckableCell *tableCell = [CommonCheckableCell create:tableView];
        SimpleTableCell *cell = [SimpleTableCell create:tableCell withOwner:self andPressSelector:@selector(chooseMode:)];
        [tableCell setBlackTitle:NSLocalizedString(kEnumAOSmithWaterHeaterControllerControlmodeENERGY_SMART, nil) withSubtitle:@"Energy Smart mode is provided by your water heater manufacturer and it saves energy by monitoring usage and adjusting the set point to match water draw usage."];
        [tableCell setSelectedBox:[_currentMode isEqualToString:kEnumAOSmithWaterHeaterControllerControlmodeENERGY_SMART]];
        [tableCell displayArrow:NO];
        [cell setDataObject:kEnumAOSmithWaterHeaterControllerControlmodeENERGY_SMART];
        
        [reuslt addObject:cell];
    }
#pragma clang diagnostic pop
    
    return reuslt;
}

- (void)chooseMode:(SimpleTableCell *)cell {
    [self.owner chooseMode:cell.dataObject];
    _currentMode = (NSString *)cell.dataObject;
    [self refresh];
}

@end



@interface ServiceControlCell ()

@property (weak, nonatomic) UIButton *bottomButtom;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setBottomButtonText:(NSString *)text;
- (void)setButtonSelector:(SEL)selector toOwner:(id)owner;

- (void)popup:(PopupSelectionBaseContainer *)container;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner;
- (void)popupFullScreen:(UIViewController *)popupController;

@end

@implementation DeviceDetailsWaterHeater {
    PopupSelectionButtonsView   *_modePopup;
    int                         _currentTemp;
    int                         _maxHeatSetPoint;
}

- (void)loadData {
    [self.controlCell.centerIcon setImage:[UIImage imageNamed:@"PlaceholderWhite"]];
    [self.controlCell.leftButton setImageStyle:[UIImage imageNamed:@"deviceThermostatMinusButton"] withSelector:@selector(onClickMin) owner:self];
    [self.controlCell.rightButton setImageStyle:[UIImage imageNamed:@"deviceThermostatPlusButton"] withSelector:@selector(onClickPls) owner:self];
    [self.controlCell setButtonSelector:@selector(onClickButtom) toOwner:self];
    
    _currentTemp = (int)[DeviceController getWaterHeaterSetPoint:self.deviceModel];
    _maxHeatSetPoint = (int)[DeviceController getWaterHeaterMaxSetPoint:self.deviceModel];
    
    [self updateDeviceState:nil initialUpdate:YES];
}

- (void)onClickButtom {
    SimpleTableViewController *pop = [SimpleTableViewController createPopupStyleWithDelegate:[WaterHeaterModePickerDelegate create:self]];
    [self.controlCell popupFullScreen:pop];
}
- (void)chooseMode:(id)selectedMode {
    [DeviceController setWaterHeaterControlMode:self.deviceModel controlMode:selectedMode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self.deviceModel commit];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.controlCell setBottomButtonText:NSLocalizedString(selectedMode, nil)];
    });
}

- (void)onClickMin {
    if ((_currentTemp-1) < 60) {
        return;
    }
    
    if (_currentTemp - 1 < 80 && _currentTemp > 60) {
        _currentTemp = 60;
    } else {
        _currentTemp -= 1;
    }
    
    [self.controlCell setSubtitle:[NSString stringWithFormat:@"Set to %d°", _currentTemp]];
    [self submitTemp:_currentTemp];
    
    [self.controlCell.rightButton setDisable:(_currentTemp == _maxHeatSetPoint)];
    [self.controlCell.leftButton setDisable:(_currentTemp == 60)];
}

- (void)onClickPls {
    if ((_currentTemp + 1) > _maxHeatSetPoint) {
        return;
    }
    
    if (_currentTemp < 80 && _currentTemp + 1 > 60) {
        _currentTemp = 80;
    } else {
        _currentTemp += 1;
    }
    
    [self.controlCell setSubtitle:[NSString stringWithFormat:@"Set to %d°", _currentTemp]];
    [self submitTemp:_currentTemp];
    
    [self.controlCell.rightButton setDisable:(_currentTemp == _maxHeatSetPoint)];
    [self.controlCell.leftButton setDisable:(_currentTemp == 60)];
}

- (void)submitTemp:(CGFloat)temp {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DeviceController setWaterHeaterSetPoint:self.deviceModel setPoint:temp];
    });
}

#pragma mark - override
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if ([self isWifiRssiChanged:attributes]) {
        return;
    }
    
    int heatSettingPoint = (int)[DeviceController getWaterHeaterSetPoint:self.deviceModel];
    NSString *currentMode = [DeviceController getWaterHeaterControlMode:self.deviceModel];
    
    BOOL waterHeating = [WaterHeaterCapability getHeatingstateFromModel:self.deviceModel];
    NSString *hotwaterLevel = [WaterHeaterCapability getHotwaterlevelFromModel:self.deviceModel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.controlCell setSubtitle:[NSString stringWithFormat:@"Set to %d°", heatSettingPoint]];
        [self.controlCell setBottomButtonText:NSLocalizedString(currentMode, nil)];
        
        [self.controlCell.rightButton setDisable:(_currentTemp == _maxHeatSetPoint)];
        [self.controlCell.leftButton setDisable:(_currentTemp == 60)];

        if (waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelLOW]) {
            [self.controlCell.centerIcon setImage: [UIImage imageNamed:@"waterHeater_heating_low"]];
        } else if (waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelMEDIUM]) {
            [self.controlCell.centerIcon setImage: [UIImage imageNamed:@"waterHeater_heating_limited"]];
        } else if (waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelHIGH]) {
            [self.controlCell.centerIcon setImage: [UIImage imageNamed:@"waterHeater_heating_available"]];
        } else if (!waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelLOW]) {
            [self.controlCell.centerIcon setImage: [UIImage imageNamed:@"waterHeater_noHeating_low"]];
        } else if (!waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelMEDIUM]) {
            [self.controlCell.centerIcon setImage: [UIImage imageNamed:@"waterHeater_noHeating_limited"]];
        } else if (!waterHeating && [hotwaterLevel isEqualToString:kEnumWaterHeaterHotwaterlevelHIGH]) {
            [self.controlCell.centerIcon setImage: [UIImage imageNamed:@"waterHeater_noHeating_available"]];
        }
        
    });
}

#pragma mark - helping function
- (BOOL)isWifiRssiChanged:(NSDictionary *)attributes {
    if ((attributes.count == 1) && [attributes objectForKey:@"wifi:rssi"] != nil) {
        return YES;
    }
    return NO;
}

@end
