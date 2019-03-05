//
//  ContactSensorOperationController.m
//  i2app
//
//  Created by Arcus Team on 6/6/15.
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
#import "ContactSensorOperationController.h"
#import "Capability.h"
#import "TemperatureCapability.h"
#import "DevicePowerCapability.h"
#import "DeviceController.h"
#import "ContactCapability.h"

@interface ContactSensorOperationController()

@property (readonly, strong, nonatomic) NSString *sensorState;
@property (readonly, strong, nonatomic) NSDate *time;
@property (readonly, assign, nonatomic) int batteryState;
@property (readonly, assign, nonatomic) NSInteger temperature;

@end

@implementation ContactSensorOperationController {
    BOOL  _contactSensorIsOpen;
    
    DeviceTimeAttributeControl          *_timeControl;
    DeviceTempAttributeControl          *_tempControl;
    DevicePercentageAttributeControl    *_percentageControl;
}

@dynamic deviceOpDetails;

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilitySecurityIcon | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contactSensorIsOpen = NO;
    
    _timeControl = [DeviceTimeAttributeControl createWithDate:[NSDate date] withState:@""];
    _percentageControl = [DevicePercentageAttributeControl createWithBatteryPercentage:0];
    
    // Check if the contact sensor has temperature capability
    if ([[Capability capabilitiesForModel:self.deviceModel] containsObject:[TemperatureCapability namespace]]) {
        _tempControl = [DeviceTempAttributeControl create];
        [self.attributesView loadControl:_timeControl control2:_tempControl control3:_percentageControl];
    }
    else {
        [self.attributesView loadControl:_timeControl control2:_percentageControl];
    }

    [self setSensorEnable];
}


- (void)setSensorEnable {
    if ([[ContactCapability getContactFromModel:self.deviceModel] isEqualToString:kEnumContactContactOPENED]) {
        [self.deviceOpDetails animateRubberBandExpand:self.deviceLogo];
    }
    else {
        [self.deviceOpDetails animateRubberBandContract:self.deviceLogo];
    }
}


- (NSString *)sensorState {
    return [ContactCapability getContactFromModel:self.deviceModel];
}

- (NSDate *)time {
    return [ContactCapability getContactchangedFromModel:self.deviceModel];
}

- (int)batteryState {
    return [DevicePowerCapability getBatteryFromModel:self.deviceModel];
}

- (NSInteger)temperature {
    return [DeviceController getTemperatureForModel:self.deviceModel];
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)edgeMode:(SEL)onClick {
    [super edgeMode:onClick];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    int batteryState = self.batteryState;
    NSString *sensorState = self.sensorState;
    NSDate *time = self.time;
    
    [_timeControl setDateTime:time andState:sensorState];
    
    [_percentageControl setPercentage:batteryState];
    if (_tempControl) {
        [_tempControl setTemp:self.temperature];
    }
    
    if (self.isCenterMode) {
        [self setSensorEnable];
    }
}

@end



