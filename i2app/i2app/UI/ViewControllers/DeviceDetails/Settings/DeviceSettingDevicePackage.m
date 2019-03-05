//
//  DeviceSettingDevicePackage.m
//  i2app
//
//  Created by Arcus Team on 8/7/15.
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
#import "DeviceSettingDevicePackage.h"
#import "DeviceSettingCellController.h"
#import "DeviceSettingCells.h"
#import "OrderedDictionary.h"

@implementation DeviceSettingDevicePackage


- (instancetype)initWithOwner: (UIViewController *)owner deviceModel:(DeviceModel *)model {
  self = [super initWithOwner:owner deviceModel:model];
  if (self) {
    self.controlOwner = owner;
    self.deviceModel = model;
    [self loadSettings];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"device address: %@", self.deviceModel.address];
}

- (void)loadSettings {
  [super.unitCollection removeAllUnit];
}

@end

@implementation DeviceSettingDeviceCameraPackage

- (void)loadSettings {
  [super loadSettings];

  if (self.deviceModel.isSwannCamera) {
    [self loadBatteryCameraSettings];
  } else {
    [self loadCameraSettings];
  }
}

- (void)loadBatteryCameraSettings {
  // Camera Configuration
  DeviceSettingGroupUnit *cameraConfiguration = [DeviceSettingGroupUnit createWithTitle:@"Camera Configuration"];

  DeviceSettingWifiNetworkUnit *networkUnit = [[DeviceSettingWifiNetworkUnit alloc] init];
  networkUnit.openSettings = ^ (UIViewController *viewController) {
    [self.controlOwner.navigationController pushViewController:viewController animated:YES];
  };
  networkUnit.closeSettings = ^ (UIViewController *viewController) {
    [self.controlOwner.navigationController popViewControllerAnimated:YES];
  };
  networkUnit.deviceModel = self.deviceModel;
  [cameraConfiguration addObject:networkUnit];

  DeviceSettingBatteryCameraImageQualityUnit *settimgImageQuality = [[DeviceSettingBatteryCameraImageQualityUnit alloc] init];
  settimgImageQuality.deviceModel = self.deviceModel;
  [cameraConfiguration addObject:settimgImageQuality];

  [cameraConfiguration addObject:[[DeviceSettingBatteryCameraMotionSensitivityUnit alloc] init]];

//  if ([self.deviceModel cameraSupportsIR]) {
//    [cameraConfiguration addObject:[[DeviceSettingCameraInfraredLightUnit alloc] init]];
//  }

  [cameraConfiguration addObject:[[DeviceSettingCameraRotateCamera180Unit alloc] init]];

  [super.unitCollection addUnit:cameraConfiguration];
}

- (void)loadCameraSettings {
  // Camera Configuration
  DeviceSettingGroupUnit *cameraConfiguration = [DeviceSettingGroupUnit createWithTitle:@"Camera Configuration"];

  DeviceSettingCameraWifiNetworkUnit *networkUnit = [[DeviceSettingCameraWifiNetworkUnit alloc] init];
  networkUnit.openSettings = ^ (UIViewController *viewController) {
    [self.controlOwner.navigationController pushViewController:viewController animated:YES];
  };
  networkUnit.closeSettings = ^ (UIViewController *viewController) {
    [self.controlOwner.navigationController popViewControllerAnimated:YES];
  };
  networkUnit.deviceModel = self.deviceModel;
  [cameraConfiguration addObject:networkUnit];

  DeviceSettingCameraImageQualityUnit *settimgImageQuality = [[DeviceSettingCameraImageQualityUnit alloc] init];
  settimgImageQuality.deviceModel = self.deviceModel;
  [cameraConfiguration addObject:settimgImageQuality];

  [cameraConfiguration addObject:[[DeviceSettingCameraFrameRateUnit alloc] init]];

  if ([self.deviceModel cameraSupportsIR]) {
    [cameraConfiguration addObject:[[DeviceSettingCameraInfraredLightUnit alloc] init]];
  }

  [cameraConfiguration addObject:[[DeviceSettingCameraRotateCamera180Unit alloc] init]];

  DeviceSettingCameraLocalStreamingUnit *streamingUnit = [[DeviceSettingCameraLocalStreamingUnit alloc] init];
  streamingUnit.openSettings = ^ (UIViewController *viewController) {
    [self.controlOwner.navigationController pushViewController:viewController animated:YES];
  };
  streamingUnit.closeSettings = ^ (UIViewController *viewController) {
    [self.controlOwner.navigationController popViewControllerAnimated:YES];
  };
  streamingUnit.deviceModel = self.deviceModel;
  [cameraConfiguration addObject:streamingUnit];


  [super.unitCollection addUnit:cameraConfiguration];
}

@end

@implementation DeviceSettingDeviceKeyFobPackage

- (void)loadSettings {
  [super loadSettings];

  [super setHeaderText:NSLocalizedString(@"What would you like each button to do?", nil)];

  if ([self.deviceModel instances].count > 0) {
    OrderedDictionary *orderedDic = [[OrderedDictionary alloc] init];

    for (NSString *instance in self.deviceModel.instances) {
      NSString *dicKey = instance;
      if ([instance hasPrefix:@"circle"]) {
        dicKey = [NSString stringWithFormat:@"1%@", instance];
      }
      else if ([instance hasPrefix:@"diamond"]) {
        dicKey = [NSString stringWithFormat:@"2%@", instance];
      }
      else if ([instance hasPrefix:@"square"]) {
        dicKey = [NSString stringWithFormat:@"3%@", instance];
      }
      ButtonType buttonType = stringToButtonType(instance);
      DeviceSettingKeyFobButton *button =
      [[DeviceSettingKeyFobButton alloc] initWithButtonType:buttonType
                                                  productId:self.deviceModel.productId];
      [orderedDic setObject:button forKey:dicKey];
    }

    [orderedDic sortArray];
    for (NSString *key in orderedDic) {
      [super.unitCollection addUnit:[orderedDic objectForKey:key]];
    }
  }
  else {
    [super.unitCollection addUnit:[[DeviceSettingKeyFobButton alloc] init]];
  }
}

- (BOOL)shouldDisplay {
  return [self.deviceModel instances].count > 0;
}

@end

@implementation DeviceSettingDeviceCarePendantPackage

- (void)loadSettings {
  [super loadSettings];

  [super setHeaderText:NSLocalizedString(@"Test Your Coverage", nil)];
  [super setSubscriptionText:NSLocalizedString(@"test your coverage text", nil)];
}


@end
