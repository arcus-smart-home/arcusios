//
//  GeneralDeviceOperationController.h
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

#import "DeviceOperationBaseController.h"
#import "DeviceNotificationLabel.h"
#import "DeviceAttributeGroupView.h"
#import "DeviceButtonGroupView.h"

typedef NS_OPTIONS(NSUInteger, GeneralDeviceAbility) {
    GeneralDeviceAbilityNothing        = 0,
    GeneralDeviceAbilityEventLabel      = 1 << 1,
    GeneralDeviceAbilitySecurityIcon   = 1 << 2,
    GeneralDeviceAbilityAttributesView = 1 << 3,
    GeneralDeviceAbilityButtonsView    = 1 << 4,
};

@interface GeneralDeviceOperationController : DeviceOperationBaseController

@property (weak, nonatomic) IBOutlet DeviceNotificationLabel *eventLabel;
@property (weak, nonatomic) IBOutlet DeviceAttributeGroupView *attributesView;
@property (weak, nonatomic) IBOutlet DeviceButtonGroupView *buttonsView;

@property (weak, nonatomic) IBOutlet UIImageView *securityIcon;
@property (nonatomic) GeneralDeviceAbility deviceAbilities;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventToTopConstraint;

+ (DeviceOperationBaseController *)create;
+ (DeviceOperationBaseController *)createWithDeviceId:(NSString *)deviceId;
- (void)loadDeviceAbilities;

@end
