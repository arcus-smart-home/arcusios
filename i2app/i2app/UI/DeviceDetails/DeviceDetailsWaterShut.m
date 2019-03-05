//
//  DeviceDetailsWaterShut.m
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
#import "DeviceDetailsWaterShut.h"
#import "DeviceButtonBaseControl.h"
#import "PopupSelectionBaseContainer.h"
#import "DeviceController.h"
#import "ValveCapability.h"
#import "ServiceControlCell.h"
#import "UIView+Overlay.h"

@interface DeviceDetailsBase()

- (void)animateRubberBandExpand:(UIView *)ringLogo;
- (void)animateRubberBandContract:(UIView *)ringLogo;

@end

@implementation DeviceDetailsWaterShut {
}

- (void)loadData {
    [self.controlCell.leftButton setDefaultStyle:@"OPEN" withSelector:@selector(onClickOpen) owner:self];
    [self.controlCell.rightButton setDefaultStyle:@"CLOSE" withSelector:@selector(onClickClose) owner:self];
    
    [self refreshData];
}

- (void)refreshData {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *valveState = [ValveCapability getValvestateFromModel:self.deviceModel];
      
        if ([valveState isEqualToString:kEnumValveValvestateOBSTRUCTION]) {
            [self.controlCell setupDeviceError:NSLocalizedString(@"Obstruction Detected", nil)];
        } else {
            [self.controlCell teardownDeviceError];
        }
      
        if ([valveState isEqualToString:kEnumValveValvestateCLOSING]) {
            [self animateRubberBandContract:self.controlCell.centerIcon];
        }
        else if ([valveState isEqualToString:kEnumValveValvestateOPENING]) {
            [self animateRubberBandExpand:self.controlCell.centerIcon];
        }
        else if ([valveState isEqualToString:kEnumValveValvestateCLOSED]) {
            [self animateRubberBandContract:self.controlCell.centerIcon];
            [self.controlCell.leftButton setDisable:NO];
            [self.controlCell.rightButton setDisable:YES];
        }
        else if ([valveState isEqualToString:kEnumValveValvestateOPEN]) {
            [self animateRubberBandExpand:self.controlCell.centerIcon];
            [self.controlCell.leftButton setDisable:YES];
            [self.controlCell.rightButton setDisable:NO];
        }
    });
}


- (void)onClickOpen {
    [self.controlCell.leftButton setDisable:YES];
    [self.controlCell.rightButton setDisable:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *valveState = [ValveCapability getValvestateFromModel:self.deviceModel];
        
        if ([valveState isEqualToString:kEnumValveValvestateCLOSED]) {
            [ValveCapability setValvestate: kEnumValveValvestateOPEN onModel:self.deviceModel];
            [self.deviceModel commit];
        }
    });
}
- (void)onClickClose {
    [self.controlCell.leftButton setDisable:YES];
    [self.controlCell.rightButton setDisable:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *valveState = [ValveCapability getValvestateFromModel:self.deviceModel];
        
        if ([valveState isEqualToString:kEnumValveValvestateOPEN]) {
            [ValveCapability setValvestate:kEnumValveValvestateCLOSED onModel:self.deviceModel];
            [self.deviceModel commit];
        }
    });
}

#pragma mark - override
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    [self refreshData];
}
     
@end
