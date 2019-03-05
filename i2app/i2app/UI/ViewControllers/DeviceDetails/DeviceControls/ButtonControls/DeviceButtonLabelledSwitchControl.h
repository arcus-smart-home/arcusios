//
//  DeviceButtonLabelledSwitchControl.h
//  i2app
//
//  Created by Arcus Team on 6/30/16.
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
#import "DeviceButtonBase.h"
#import "ArcusLabel.h"
#import <i2app-Swift.h>

typedef BOOL(^buttonSwitchEventBlock)(id sender);

@interface DeviceButtonLabelledSwitchControl : DeviceButtonBase

@property (copy) buttonSwitchEventBlock buttonSelectEvent;
@property (copy) buttonSwitchEventBlock buttonUnselectEvent;
@property (nonatomic, strong) ArcusButton *button;
@property (nonatomic, strong) ArcusLabel *label;
@property (nonatomic, assign) BOOL selected;

+ (DeviceButtonLabelledSwitchControl *)create:(NSString *)label withSelect:(buttonSwitchEventBlock)selectBlock withUnselect:(buttonSwitchEventBlock)unselectBlock;

@end
