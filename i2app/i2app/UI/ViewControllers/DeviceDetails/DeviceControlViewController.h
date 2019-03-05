//
//  DeviceControlViewController.h
//  i2app
//
//  Created by Arcus Team on 5/30/15.
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

#import <UIKit/UIKit.h>

@class DeviceDetailsTabBarController;


@interface DeviceControlViewController : UIViewController

@property (nonatomic, weak) DeviceDetailsTabBarController *tabBarController;
@property (nonatomic) BOOL enableSwipe;
@property (readonly, nonatomic) CGFloat edgeWidth;

@property (nonatomic, readonly) DeviceModel *deviceModel;

+ (DeviceControlViewController *)createWithTabBarController:(DeviceDetailsTabBarController *)tabBar andDeviceModel:(DeviceModel *)device;

- (void)popupWindow:(NSString *)key view:(UIView *)view;
- (void)removeWindow:(NSString *)key;

#pragma mark - footer style control
- (void)setFooterColor:(UIColor*)color;
- (void)setFooterColorToClean;
- (void)setFooterLeftText:(NSString *)leftText;

@end
