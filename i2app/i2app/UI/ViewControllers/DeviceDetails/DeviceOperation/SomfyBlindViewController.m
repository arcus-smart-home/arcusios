//
//  SomfyBlindViewController.m
//  i2app
//
//  Created by Arcus Team on 7/21/15.
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
#import "SomfyBlindViewController.h"
#import "DeviceDetailsSomfyBlinds.h"
#import "Somfy1Capability.h"
#import "Somfyv1Capability.h"

@interface SomfyBlindViewController ()

@property (nonatomic, assign, readonly) DeviceDetailsSomfyBlinds *deviceOpDetails;

@property (nonatomic, strong) DevicePercentageAttributeControl *battery;
@property (nonatomic, strong) DeviceButtonBaseControl *leftButton;
@property (nonatomic, strong) DeviceButtonBaseControl *centerButton;
@property (nonatomic, strong) DeviceButtonBaseControl *rightButton;

@end

@implementation SomfyBlindViewController

@dynamic deviceOpDetails;

- (DeviceDetailsSomfyBlinds *)deviceOpDetails {
    return (DeviceDetailsSomfyBlinds *)super.deviceOpDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.leftButton = [[DeviceButtonBaseControl alloc] init];
    self.rightButton = [[DeviceButtonBaseControl alloc] init];
    self.centerButton = [[DeviceButtonBaseControl alloc] init];

    [self.buttonsView loadControl:self.leftButton control2:self.centerButton control3:self.rightButton];

    BOOL isShade = [[Somfyv1Capability getTypeFromModel:self.deviceModel] isEqualToString:kEnumSomfy1ModeSHADE];

    [self.deviceOpDetails configureCellWithLogo:self.deviceLogo leftButton:self.leftButton centerButton:self.centerButton rightButton:self.rightButton upDownMode:isShade];
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityButtonsView | GeneralDeviceAbilityAttributesView;
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if (self.isCenterMode) {
        [self.deviceOpDetails updateDeviceState:attributes initialUpdate:isInitial];

        if (!isInitial) {
            BOOL isShade = [[Somfyv1Capability getTypeFromModel:self.deviceModel] isEqualToString:kEnumSomfy1ModeSHADE];

            [self.deviceOpDetails configureCellWithLogo:self.deviceLogo leftButton:self.leftButton centerButton:self.centerButton rightButton:self.rightButton upDownMode:isShade];
        }
    }
}

@end
