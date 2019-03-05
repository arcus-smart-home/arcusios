//
//  BasePairingViewController.h
//  i2app
//
//  Created by Arcus Team on 5/25/15.
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
#import "BaseTextViewController.h"

@class PairingStep;
@class DeviceModel;

@interface BasePairingViewController : UIViewController

+ (instancetype)createWithDeviceStep:(PairingStep *)step;
+ (instancetype)createWithDeviceStep:(PairingStep *)nextStep withDeviceModel:(DeviceModel *)deviceModel;

- (void)initializeTemplateViewController;

@property (nonatomic, readonly) PairingStep *step;
@property (atomic, weak) DeviceModel *deviceModel;

// Used in the derived view controllers to connect in the storyboards
- (IBAction)nextButtonPressed:(id)sender;
- (void)setDeviceStep:(PairingStep *)step;

- (void)refreshVideo;

- (void)back:(NSObject *)sender;

- (void)close:(id)sender;
@end
