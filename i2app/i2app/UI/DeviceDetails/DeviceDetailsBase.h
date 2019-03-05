//
//  DeviceDetailsBase.h
//  i2app
//
//  Created by Arcus Team on 9/17/15.
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

#import <Foundation/Foundation.h>

@class DeviceModel;
@class DeviceButtonBaseControl;
@class ServiceControlCell;

@protocol DeviceDetailsDelegate <NSObject>

@optional

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial;

- (instancetype)initWithDeviceId:(NSString *)deviceId;

@required

@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, assign, readonly) DeviceModel *deviceModel;

@end

@interface DeviceDetailsBase : NSObject <DeviceDetailsDelegate>

@property (nonatomic, weak) ServiceControlCell *controlCell;

- (void)loadDelegate:(ServiceControlCell *)cell;

- (void)loadData;

- (void)loadOfflineMode;
- (void)loadOnlineMode;

- (void)animateRubberBandExpand:(UIView *)ringLogo;
- (void)animateRubberBandContract:(UIView *)ringLogo;
- (void)hideRubberBand:(UIView *)ringLogo;
- (void)displayRubberBand:(UIView *)ringLogo;

@end


