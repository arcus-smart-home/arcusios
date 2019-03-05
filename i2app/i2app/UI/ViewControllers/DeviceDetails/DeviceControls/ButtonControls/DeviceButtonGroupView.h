//
//  DeviceButtonGroupView.h
//  i2app
//
//  Created by Arcus Team on 7/20/15.
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
#import "DeviceButtonBaseControl.h"
#import "DeviceButtonSwitchControl.h"
#import "DeviceAttributeItemBaseControl.h"

@interface DeviceButtonGroupView : UIView

- (void)loadControl:(DeviceButtonBase *)control;
- (void)loadControl:(DeviceButtonBase *)control control2:(DeviceButtonBase *)control2;
- (void)loadControl:(DeviceButtonBase *)control attributeControl:(DeviceAttributeItemBaseControl *)control2 control3:(DeviceButtonBase *)control3 withHorizSpacing:(CGFloat) spacing;
- (void)loadControl:(DeviceButtonBase *)control control2:(DeviceButtonBase *)control2 control3:(DeviceButtonBase *)control3;
- (void)loadControl:(DeviceButtonBase *)control control2:(DeviceButtonBase *)control2 control3:(DeviceButtonBase *)control3 withHorizSpacing:(CGFloat) spacing;

@end
