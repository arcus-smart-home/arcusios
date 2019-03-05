//
//  AdjusterOperationController.h
//  i2app
//
//  Created by Arcus Team on 7/24/15.
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

#import "DeviceOperationBaseController.h"
#import "EFCircularSlider.h"
#import "DeviceNotificationLabel.h"
#import "DeviceAttributeGroupView.h"
#import "DeviceButtonGroupView.h"

typedef NS_OPTIONS(NSUInteger, ValueChangeCause) {
    ValueChangeCauseSliding = 0,
    ValueChangeCauseStoppedSliding = 1,
    ValueChangeCauseTapped = 2
};

typedef NS_OPTIONS(NSUInteger, AdjusterDeviceAbility) {
    AdjusterDeviceAbilityNothing        = 0,
    AdjusterDeviceAbilityAttributesView = 1 << 1,
    AdjusterDeviceAbilityButtonsView    = 1 << 2
};

@interface AdjusterOperationController : DeviceOperationBaseController <EFCircularSliderDelegate>

@property (weak, nonatomic) IBOutlet DeviceNotificationLabel *eventLabel;
@property (weak, nonatomic) IBOutlet DeviceAttributeGroupView *attributesView;
@property (weak, nonatomic) IBOutlet DeviceButtonGroupView *buttonsView;
@property (nonatomic, assign, readonly) BOOL currentlySliding;
@property (nonatomic) AdjusterDeviceAbility deviceAbilities;

- (void)setShouldUpdateBrightness:(BOOL)status;

# pragma mark - throttle settings
- (void) setThrottlePeriod:(NSTimeInterval) period andQuiescence:(NSTimeInterval) quiesence;

#pragma mark - setting functions
- (void)setOffLabels:(NSString *)offLabel andOnLabel:(NSString *)onLabel;
- (int)getAdjusterValue;
- (void)setAdjusterValue:(int)percent;

#pragma mark - adjtster control for override
// for update value to platform
- (BOOL)submitChangedValue:(int)value becauseOf:(ValueChangeCause)reason;

// for update UI change
- (void)adjusterValueChanged:(int)percentageValue;
- (void)handleTap:(id)sender;

// Slider Bar Color
- (void)setSliderBarColor:(UIColor*)color;

@end
