//
//  WaterSoftenerOperationController.m
//  i2app
//
//  Created by Arcus Team on 7/28/15.
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
#import "WaterSoftenerOperationController.h"
#import "WaterSoftenerCapability.h"
#import "FlowCapability.h"
#import "NSDate+Convert.h"
#import "UIViewController+AlertBar.h"
#import "WaterSoftenerSaltTypeController.h"
#import "DeviceControlViewController.h"

@interface WaterSoftenerOperationController ()

@end

@implementation WaterSoftenerOperationController {
    DevicePercentageAttributeControl *_saltLevel;
    DeviceTextWithUnitAttributeControl *_current;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _saltLevel = [DevicePercentageAttributeControl createWithPercentage:80 title:NSLocalizedString(@"Salt level", nil)];
    _current = [DeviceTextWithUnitAttributeControl create:@"current" withValue:@"22" andUnit:@"GPM"];
    [self.attributesView loadControl:_saltLevel control2:_current];
    
    [self updateDeviceState:nil initialUpdate:YES];
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:animated];

    [self checkWaterSoftenerSaltLevel];
}


- (void)checkWaterSoftenerSaltLevel {
    DeviceModel *currentDevice = self.deviceModel;
    if ([currentDevice getAttribute:kAttrWaterSoftenerCurrentSaltLevel]) {
        float percentageSaltLevel;

        BOOL saltLevelEnabled = [WaterSoftenerCapability getSaltLevelEnabledFromModel:self.deviceModel];
        int maxSaltLevel = [WaterSoftenerCapability getMaxSaltLevelFromModel:self.deviceModel];
        int currentSaltLevel = [WaterSoftenerCapability getCurrentSaltLevelFromModel:self.deviceModel];

        if (saltLevelEnabled) {
            percentageSaltLevel = (((float)currentSaltLevel / (float)maxSaltLevel) * 100);
        }
        else {
            percentageSaltLevel = .0f;
        }

        if (percentageSaltLevel <= 20) {
            [self showLowSaltBanner];
        }
    }
}

- (void)showLowSaltBanner {
    [super popupLinkAlert:NSLocalizedString(@"Low Salt Levels", nil)
                     type:AlertBarTypeWarning
                sceneType:AlertBarSceneInDevice
                grayScale:NO
                 linkText:NSLocalizedString(@"Order More", nil)
                 selector:@selector(showBuyMoreSaltViewController)
             displayArrow:YES];
}

- (void)showBuyMoreSaltViewController {
    [self.deviceController.navigationController pushViewController:[WaterSoftenerSaltTypeController create] animated:YES];
}

// Work around for get chargeState

- (NSString *)chargeState {
    int rechargerRemainingTime = [WaterSoftenerCapability getRechargeTimeRemainingFromModel:self.deviceModel];
    
    if (rechargerRemainingTime > 0) {
        return kEnumWaterSoftenerRechargeStatusRECHARGING;
    }
    
    int rechargerStartTime = [WaterSoftenerCapability getRechargeStartTimeFromModel:self.deviceModel];
    if (rechargerStartTime > 0) {
        return kEnumWaterSoftenerRechargeStatusRECHARGE_SCHEDULED;
    }
    
    return kEnumWaterSoftenerRechargeStatusREADY;
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    
    // TODO workaround for now because server didn't return right state
    //chargeState = [WaterSoftenerCapability getRechargeStatusFromModel:self.deviceModel];
    
    NSString *chargeState = [self chargeState];
    BOOL saltLevelEnabled = [WaterSoftenerCapability getSaltLevelEnabledFromModel:self.deviceModel];
    int maxsaltLevel = [WaterSoftenerCapability getMaxSaltLevelFromModel:self.deviceModel];
    int currentSaltLevel = [WaterSoftenerCapability getCurrentSaltLevelFromModel:self.deviceModel];
    int currentFlowLevel = [FlowCapability getFlowFromModel:self.deviceModel];
    
    float percentageSaltLevel;
    if (saltLevelEnabled) {
        percentageSaltLevel = (((float)currentSaltLevel / (float)maxsaltLevel) * 100);
    }
    else {
        percentageSaltLevel = .0f;
    }
    
    int rechargerRemainingTime = [WaterSoftenerCapability getRechargeTimeRemainingFromModel:self.deviceModel];
    int rechargerStartTime = [WaterSoftenerCapability getRechargeStartTimeFromModel:self.deviceModel];
    
    [_saltLevel setPercentage:percentageSaltLevel];
    [_current setValueText:[NSString stringWithFormat:@"%i", currentFlowLevel]
                  withUnit:@"GPM"];
    
    if (rechargerRemainingTime > 0) {
        
        [self.eventLabel setTitle:NSLocalizedString(@"RECHARGING", nil) andDurationInMinute:rechargerRemainingTime];
        
    } else if ([chargeState isEqualToString: kEnumWaterSoftenerRechargeStatusREADY]) {
        
        [self.eventLabel setTitle:NSLocalizedString(@"READY", nil) andContent:@""];
        
    } else if ( [chargeState isEqualToString: kEnumWaterSoftenerRechargeStatusRECHARGE_SCHEDULED]) {
        
        NSDate *date = [NSDate dateWithTimeInHour:rechargerStartTime];
        [self.eventLabel setTitle:NSLocalizedString(@"RECHARGE TIME", nil) andContent:[date formatDate:@"h a"]];
        
    }
}

@end
