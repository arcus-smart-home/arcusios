//
//  GarageDoorViewController.m
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
#import "GarageDoorViewController.h"
#import "DevicePercentageAttributeControl.h"
#import "MotorizedDoorCapability.h"
#import "DevicePowerCapability.h"
#import "DeviceAttributeGroupView.h"
#import "DeviceDetailsGarageDoor.h"
#import "DevicePowerCapability.h"
#import "DeviceAdvancedCapability.h"
#import "UIViewController+AlertBar.h"
#import <i2app-Swift.h>

@interface GarageDoorViewController ()

@property (nonatomic, assign, readonly) DeviceDetailsGarageDoor *deviceOpDetails;

@property (nonatomic, strong) DevicePercentageAttributeControl *battery;
@property (nonatomic, strong) DeviceButtonBaseControl *openButton;
@property (nonatomic, strong) DeviceButtonBaseControl *closeButton;
@property (atomic, assign) NSInteger errorBannerTag;

@end

@implementation GarageDoorViewController

@dynamic deviceOpDetails;

- (DeviceDetailsGarageDoor *)deviceOpDetails {
    return (DeviceDetailsGarageDoor *)super.deviceOpDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.errorBannerTag = NSNotFound;
    _battery = [DevicePercentageAttributeControl createWithBatteryPercentage:[DevicePowerCapability getBatteryFromModel:self.deviceModel]];
    
    [self.attributesView loadControl:_battery];
    
    self.openButton = [[DeviceButtonBaseControl alloc] init];
    self.closeButton = [[DeviceButtonBaseControl alloc] init];
    
    [self.buttonsView loadControl:self.openButton];
    
    [self.deviceOpDetails configureCellWithLogo:self.deviceLogo
                                openCloseButton:self.openButton];
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityButtonsView | GeneralDeviceAbilityAttributesView;
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
  if (self.isCenterMode) {
    [self.deviceOpDetails updateDeviceState:attributes initialUpdate:isInitial];
  }

  NSDate *eventTime;
  NSString *eventText;
  self.eventLabel.hidden = ![DeviceDetailsGarageDoor getLastEvent:self.deviceModel eventText:&eventText eventTime:&eventTime];

  if (!self.eventLabel.hidden) {
    [self.eventLabel setTitle:[NSString stringWithFormat:@"%@ ", eventText] andTime:eventTime];
  }

  [self updateErrorBanner];
}

- (void)updateErrorBanner {
  NSDictionary *errors = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
  NSString *errObstruction = errors[@"ERR_OBSTRUCTION"];
  if (errObstruction && ![self.deviceModel isDeviceOffline]) {
    [self dismissErrorBanner];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      NSDictionary *errors = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
      NSString *errObstruction = errors[@"ERR_OBSTRUCTION"];
      if (!(errObstruction && ![self.deviceModel isDeviceOffline])){
        [self dismissErrorBanner];
        return;
      }
      NSString *text = NSLocalizedString(@"Obstruction Detected", nil);
      NSString *linkText = NSLocalizedString(@"Get Support", nil);
      self.errorBannerTag = [self popupLinkAlert:text
                                            type:AlertBarTypeWarning
                                       sceneType:AlertBarSceneInDevice
                                       grayScale:NO
                                        linkText:linkText
                                        selector:@selector(getSupportPressed)
                                    displayArrow:YES];
    });
  } else {
    [self dismissErrorBanner];
  }
}

- (void)getSupportPressed {
  NSString *deviceTypeHint = [DeviceCapability getDevtypehintFromModel:self.deviceModel];
  NSURL *productSupportUrl = [NSURL productSupportUrlWithDeviceType:deviceTypeHint
                                                          productId:self.deviceModel.productId
                                                          devadvErr:@"err_obstruction"];
  [[UIApplication sharedApplication] openURL:productSupportUrl];
}

- (void) dismissErrorBanner {
  if (self.errorBannerTag != NSNotFound) {
    [self closePopupAlert];
    self.errorBannerTag = NSNotFound;
  }
}

@end
