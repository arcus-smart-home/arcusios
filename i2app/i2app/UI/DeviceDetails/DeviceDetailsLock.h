//
//  DeviceDetailsLock.h
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
#import "DeviceDetailsBase.h"

@class DeviceButtonBaseControl;

@interface DeviceDetailsLock : DeviceDetailsBase

@property (nonatomic, assign, readonly) BOOL hasBuzzInCapability;
@property (nonatomic, strong, readonly) NSString *lockStatus;

- (void)loadData:(UIView *)logoView leftButton:(DeviceButtonBaseControl *)leftButton withRightButton:(DeviceButtonBaseControl *)rightButton;

+ (BOOL)getLastEvent:(DeviceModel *)deviceModel eventText:(NSString **)eventText eventTime:(NSDate **)eventTime;

@end
