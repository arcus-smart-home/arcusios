//
//  AccessoryOperationController.m
//  i2app
//
//  Created by Arcus Team on 12/3/15.
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

#import <i2app-Swift.h>
#import "AccessoryOperationController.h"

@interface DeviceOperationBaseController()

- (void)connectionStateChangedNotification:(NSNotification *)note;

@end

@interface AccessoryOperationController ()

@end

@implementation AccessoryOperationController {
    DeviceTextAttributeControl *_attributeControl;
}

#pragma mark - Life Cycle

- (void)loadDeviceAbilities {
    self.deviceAbilities =  GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _attributeControl = [DeviceTextAttributeControl create:@"CONNECTED" withValue:nil];
    [self.attributesView loadControl:_attributeControl];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if ([self.deviceModel isDeviceOffline]) {
        [_attributeControl setTitleText:@""];
    }
    else {
        [_attributeControl setTitleText:@"CONNECTED"];
    }
}

- (void)connectionStateChangedNotification:(NSNotification *)note {
    if ([self.deviceModel isDeviceOffline]) {
        [_attributeControl setTitleText:@""];
    }
    else {
        [_attributeControl setTitleText:@"CONNECTED"];
    }
    
    [super connectionStateChangedNotification:note];
}

@end
