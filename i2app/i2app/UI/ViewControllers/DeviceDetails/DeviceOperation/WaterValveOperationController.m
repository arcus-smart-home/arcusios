//
//  WaterShutOperationController.m
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
#import "WaterValveOperationController.h"
#import "NSDate+Convert.h"
#import "ValveCapability.h"
#import "TestCapability.h"
#import "DeviceConnectionCapability.h"
#import "DevicePowerCapability.h"
#import "UIViewController+AlertBar.h"
#import <i2app-Swift.h>

@interface WaterValveOperationController ()

@end

@implementation WaterValveOperationController {
    DeviceButtonBaseControl *_opencloseButton;
    
    DeviceTimeAttributeControl *_lastTest;
    DeviceTextIconAttributeControl *_power;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityAttributesView | GeneralDeviceAbilityButtonsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _opencloseButton = [DeviceButtonBaseControl createDefaultButton:NSLocalizedString(@"open", nil) withSelector:@selector(pressedOpenclose:) owner:self];
    [self.buttonsView loadControl:_opencloseButton];
    
    _lastTest = [DeviceTimeAttributeControl createWithDate:[NSDate date] withState:@"Last Test"];
    _power = [DeviceTextIconAttributeControl create:NSLocalizedString(@"Power", nil) withValue:@"AC" andIcon:[UIImage imageNamed:@"HubPower"]];
    [self.attributesView loadControl:_lastTest control2:_power];
}

- (void)pressedOpenclose:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *valveState = [ValveCapability getValvestateFromModel:self.deviceModel];
        
        if ([valveState isEqualToString:kEnumValveValvestateCLOSED]) {
            [ValveCapability setValvestate: kEnumValveValvestateOPEN onModel:self.deviceModel];
            [self.deviceModel commit];
        }
        else if ([valveState isEqualToString:kEnumValveValvestateOPEN]) {
            [ValveCapability setValvestate:kEnumValveValvestateCLOSED onModel:self.deviceModel];
            [self.deviceModel commit];
        }
    });
}

- (void)startClosingValve {
    [super startRubberBandContractAnimation];
    _opencloseButton.alpha = 0.4f;

}

- (void)startOpeningValve {
    [super startRubberBandExpandAnimation];
    _opencloseButton.alpha = 0.4f;

}

- (void)closedValve {
    [(DeviceButtonBaseControl *)_opencloseButton setLabelText:NSLocalizedString(@"OPEN", nil)];
    _opencloseButton.alpha = 1.f;

}

- (void)openedValve {
    [(DeviceButtonBaseControl *)_opencloseButton setLabelText:NSLocalizedString(@"CLOSE", nil)];
    _opencloseButton.alpha = 1.f;

}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *valveState = [ValveCapability getValvestateFromModel:self.deviceModel];
    NSDate *lasTestDate = [TestCapability getLastTestTimeFromModel:self.deviceModel];
    NSString *powerSource = [DevicePowerCapability getSourceFromModel:self.deviceModel];

    if ([valveState isEqualToString:kEnumValveValvestateOBSTRUCTION]) {
        NSTimeInterval bannerDelay = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, bannerDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissErrorBanner];
            self.errorBannerTag = [self popupAlert:NSLocalizedString(@"Obstruction Detected. Open and close the valve manually to resolve.", nil) type:AlertBarTypeWarning sceneType:AlertBarSceneInDevice bottomButton:NSLocalizedString(@"GET SUPPORT", nil) grayScale:NO selector:@selector(onCallSupport)];
        });
    } else {
        [self dismissErrorBanner];
    }

    if ([valveState isEqualToString:kEnumValveValvestateCLOSING]) {
        [self startClosingValve];
    }
    else if ([valveState isEqualToString:kEnumValveValvestateOPENING]) {
        [self startOpeningValve];
    }
    else if ([valveState isEqualToString:kEnumValveValvestateCLOSED]) {
        [self closedValve];
    }
    else if ([valveState isEqualToString:kEnumValveValvestateOPEN]) {
        [self openedValve];
        if (isInitial) {
            [super startRubberBandExpandAnimation];
        }
    }
  
    if ([powerSource isEqual: @"LINE"]) {
        [_power setValue:@"AC" withIcon:[UIImage imageNamed:@"HubPower"]];
    }
    else {
        [_power setValue:powerSource withIcon:nil];
    }
    [_lastTest setDateTime:lasTestDate andState:NSLocalizedString(@"Last Test", nil)];
}

- (void) dismissErrorBanner {
    [self closePopupAlertWithTag:self.errorBannerTag];
}

-(void)onCallSupport {
    [[UIApplication sharedApplication] openURL:[NSURL SupportLeakSmart] options:@{} completionHandler:nil];
}

@end
