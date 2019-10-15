//
//  SwitchOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 6/4/15.
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
#import "SwitchOperationViewController.h"
#import "SwitchCapability.h"
#import "PowerUseCapability.h"
#import "Capability.h"

#import "DeviceAttributeGroupView.h"
#import "DeviceNotificationLabel.h"
#import "UIViewController+AlertBar.h"
#import "DeviceAdvancedCapability.h"
#import "UIViewController+AlertBar.h"
#import <i2app-Swift.h>

@interface SwitchOperationViewController ()

@property (weak, nonatomic) IBOutlet DeviceNotificationLabel *eventLabel;
@property (weak, nonatomic) IBOutlet UIButton *lightSwitch;
@property (weak, nonatomic) IBOutlet DeviceAttributeGroupView *attributeView;
@property (weak, nonatomic) UILabel *topSign;
@property (weak, nonatomic) UILabel *downNumber;
@property (atomic, assign) NSInteger errorBannerTag;

- (IBAction)logoTapped:(id)sender;

@end

@implementation SwitchOperationViewController {
    BOOL            hasPowerCapabilityLegacy;
    BOOL            _animationRunning;
    __weak IBOutlet NSLayoutConstraint *attributeToSwitchConstraint;
    
    // use the _lastAnimationOn to determine if the glow is present or not
    BOOL            _lastAnimationOn;
    
    DeviceRunningAttributeControl   *_runningControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hasPowerCapabilityLegacy = [self.deviceModel.caps containsObject:[PowerUseCapability namespace]];
    
    _runningControl = [DeviceRunningAttributeControl createWithContinueMins:1 power:[PowerUseCapability getInstantaneousFromModel:self.deviceModel]];
    
    if (hasPowerCapabilityLegacy) {
        [self.attributeView loadControl:_runningControl];
    }
    
    [self.lightSwitch setImage:[UIImage imageNamed:@"switchButtonWhiteOn"] forState:UIControlStateSelected];
    [self.lightSwitch setImage:[UIImage imageNamed:@"switchButtonWhiteOff"] forState:UIControlStateNormal];
    
    _animationRunning = NO;

    _lastAnimationOn = NO;
    
    if (IS_IPHONE_5) {
        attributeToSwitchConstraint.constant = 5;
        _runningControl.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }
}

#pragma mark - Control device
- (IBAction)logoTapped:(id)sender {
    self.lightSwitch.selected = !self.lightSwitch.selected;
    NSString *state = self.lightSwitch.selected ? kEnumSwitchStateON : kEnumSwitchStateOFF;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [SwitchCapability setState:state onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (void)enableDevice:(BOOL)state {
    DDLogWarn(@"Switch state = %d", state);
    self.lightSwitch.selected = state;
    if (state) {
        [super startShiningAnimation];
    }
    else {
        [super stopShiningAnimation];
    }
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if ([attributes.allKeys containsObject:kAttrSwitchState]) {
        NSString *state = [SwitchCapability getStateFromModel:self.deviceModel];
        DDLogWarn(@"Switch state: %@", state);

        [self enableDevice:[state isEqualToString:kEnumSwitchStateON]];
    }
    
    if ([attributes.allKeys containsObject:kAttrPowerUseInstantaneous]) {
        if (hasPowerCapabilityLegacy) {
            double power = [PowerUseCapability getInstantaneousFromModel:self.deviceModel];
            [_runningControl setPower:power];
        }
    }
    [self updateErrorBanner];
}

#pragma mark - Error Handling State

- (void)updateErrorBanner {
    NSDictionary *errorsPrecheck = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
    if (errorsPrecheck != nil && errorsPrecheck.allKeys.count > 0 && ![self.deviceModel isDeviceOffline]) {
        [self dismissErrorBanner];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSDictionary *errors = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
            if (!(errors != nil  && errors.allKeys.count > 0  && ![self.deviceModel isDeviceOffline])){
                [self dismissErrorBanner];
                [self setFooterToPink:false];
                return;
            }
            if (errors[@"ERR_UNAUTHED_LUTRON"]) {
                [self showRevokedBanner];
            }
            else if (errors[@"ERR_DELETED_LUTRON"]) {
                [self showDeviceRemovedBanner];
            }
            else if (errors[@"ERR_BRIDGE_LUTRON"]) {
                [self showBridgeErrorBanner];
            }
            [self setFooterToPink:true];

        });
    } else {
        [self dismissErrorBanner];
        [self setFooterToPink:false];
    }
}


- (void)getSupportRevokedPressed {
  LutronRevokedViewController *vc = [LutronRevokedViewController create];
  [self.deviceController.navigationController presentViewController:vc animated:true completion:nil];
}

- (void)getSupportRemovedPressed {
  LutronDeviceRemovedViewController *vc = [LutronDeviceRemovedViewController create];
  [self.deviceController.navigationController presentViewController:vc animated:true completion:nil];
}

- (void)getSupportBridgeErrorPressed {
    [self getSupportPressed:@"err_bridge_lutron"];
}

- (void)getSupportPressed:(NSString *)error {
    NSString *deviceTypeHint = [DeviceCapability getDevtypehintFromModel:self.deviceModel];
    NSURL *productSupportUrl = [NSURL productSupportUrlWithDeviceType:deviceTypeHint
                                                            productId:self.deviceModel.productId
                                                            devadvErr:error];
    [[UIApplication sharedApplication] openURL:productSupportUrl options:@{} completionHandler:nil];
}

- (void) dismissErrorBanner {
    if (self.errorBannerTag != NSNotFound) {
        [self closePopupAlert];
        self.errorBannerTag = NSNotFound;
    }
}


- (void)updateErrorState {
    NSDictionary *errors = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
    if (errors != nil && errors.count > 0 && ![self.deviceModel isDeviceOffline]) {
        if (errors[@"ERR_UNAUTHED_LUTRON"]) {
            [self showRevokedBanner];
        }
        else if (errors[@"ERR_DELETED_LUTRON"]) {
            [self showDeviceRemovedBanner];
        }
        else if (errors[@"ERR_BRIDGE_LUTRON"]) {
            [self showBridgeErrorBanner];
        }
    }
}

- (void)showRevokedBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = NSLocalizedString(@"Lutron account information revoked", nil);
        self.errorBannerTag = [self popupLinkAlert:text
                                              type:AlertBarTypeWarning
                                         sceneType:AlertBarSceneInDevice
                                         grayScale:NO
                                          linkText:nil
                                          selector:@selector(getSupportRevokedPressed)
                                      displayArrow:YES];
    });
}

- (void)showDeviceRemovedBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = NSLocalizedString(@"Device removed in Lutron app", nil);
        self.errorBannerTag = [self popupLinkAlert:text
                                              type:AlertBarTypeWarning
                                         sceneType:AlertBarSceneInDevice
                                         grayScale:NO
                                          linkText:nil
                                          selector:@selector(getSupportRemovedPressed)
                                      displayArrow:YES];
    });
}

- (void)showBridgeErrorBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = NSLocalizedString(@"Lutron bridge has an error", nil);
        NSString *linkText = NSLocalizedString(@"Get Support", nil);
        self.errorBannerTag = [self popupLinkAlert:text
                                              type:AlertBarTypeWarning
                                         sceneType:AlertBarSceneInDevice
                                         grayScale:NO
                                          linkText:linkText
                                          selector:@selector(getSupportBridgeErrorPressed)
                                      displayArrow:YES];
    });
}

@end
