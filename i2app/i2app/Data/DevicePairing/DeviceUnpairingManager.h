//
//  DeviceUnpairingManager.h
//  i2app
//
//  Created by Arcus Team on 9/30/15.
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

@class MessageWithButtonsViewController;

@interface DeviceUnpairingManager : NSObject

+ (DeviceUnpairingManager *)sharedInstance;


- (MessageWithButtonsViewController *)startRemovingDevice:(DeviceModel *)device;

- (MessageWithButtonsViewController *)productInfoRemovalWithDevice:(DeviceModel *)device;

- (MessageWithButtonsViewController *)disabledRemovalWithTitle:(NSString*)title subtitle:(NSString*)subtitle;

@end
