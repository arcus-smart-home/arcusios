//
//  DeviceDetailsDimmer.h
//  i2app
//
//  Created by Arcus Team on 12/2/15.
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
#import <i2app-Swift.h>

@class DeviceButtonBaseControl;
@class PopupSelectionBaseContainer;

typedef NS_ENUM(NSInteger, LightColorType) {
    LightColorTypeNone,                         // No color support (OOD): on, off, dim
    LightColorTypeColor,                        // Supports RGB
    LightColorTypeTemperature,                  // Supports temperature (true-white)
    LightColorTypeColorNormal,                  // Supports RGB and "normal" mode
    LightColorTypeTemperatureNormal,            // Supports true-white and "normal" mode
    LightColorTypeColorTemperatureNormal,       // Trifecta: RGB, temperature and normal modes
};

@protocol DeviceDetailsDimmerDelegate <NSObject>

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner;
- (void)displayDeviceBatteryPoweredMessage;

@end

@interface DeviceDetailsDimmer : DeviceDetailsBase

@property(nonatomic, weak) id<DeviceDetailsDimmerDelegate> delegate;
@property (nonatomic, assign) LightColorType colorType;

- (ArcusNormalColorTempSelectionViewController*)colorPickerUsingDelegate:(id) delegate;
- (ArcusNormalColorTempSelectionViewController*)colorPickerForType:(ColorSelectionType) type withColor:(BOOL) showColor andTemperature:(BOOL) showTemp andNormal:(BOOL) showNormal usingDelegate:(id) delegate;

- (ColorSelectionType)currentColorMode;
- (void)refresh;

@end
