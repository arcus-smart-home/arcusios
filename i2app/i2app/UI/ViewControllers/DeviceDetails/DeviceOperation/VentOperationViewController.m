//
//  VentOperationViewController.m
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

#import <i2app-Swift.h>
#import "VentOperationViewController.h"
#import "VentCapability.h"
#import "DeviceController.h"

#define kVentThrottlePeriod 3.0
#define kVentQuiescentSeconds 5.0

@interface VentOperationViewController ()

@end

@implementation VentOperationViewController {
    DevicePercentageAttributeControl *_percentageControl;
    DeviceTempAttributeControl *_tempControl;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities =  AdjusterDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [self setShouldUpdateBrightness:NO];
    [super viewDidLoad];
    
    [super setOffLabels:NSLocalizedString(@"shut", nil) andOnLabel:NSLocalizedString(@"open", nil)];
    [super setThrottlePeriod:kVentThrottlePeriod andQuiescence:kVentQuiescentSeconds];
    
    _percentageControl = [DevicePercentageAttributeControl createWithPercentage:82 title:NSLocalizedString(@"open", nil)];
    _tempControl = [DeviceTempAttributeControl create];
    
    [self.attributesView loadControl:_percentageControl control2:_tempControl];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    int ventLevel = [VentCapability getLevelFromModel:self.deviceModel];
    NSString *ventState = [VentCapability getVentstateFromModel:self.deviceModel];
    int temperature = (int)[DeviceController getTemperatureForModel:self.deviceModel];

    [_tempControl setTemp:temperature];
    [self setAdjusterValue:ventLevel];
    
    if (ventLevel <= 25) {
        [_percentageControl setText:NSLocalizedString(@"OFF", nil)];
    }
    else {
        if ([ventState isEqualToString:kEnumVentVentstateOK]) {
            [_percentageControl setText:NSLocalizedString(@"OPEN", nil)];
        }
        if ([ventState isEqualToString:kEnumVentVentstateOBSTRUCTION]) {
            [_percentageControl setText:NSLocalizedString(@"OBSTRUCTION", nil)];
        }
    }
}


#pragma mark - adjtster control for override
// for update value to platform
- (BOOL)submitChangedValue:(int)value becauseOf:(ValueChangeCause)reason {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [VentCapability setLevel:value onModel:self.deviceModel];
        [self.deviceModel commit];
    });

    return !self.currentlySliding;
}

// for update UI change
- (void)adjusterValueChanged:(int)percentageValue {
    [_percentageControl setPercentage:percentageValue];

}

- (void)handleTap:(id)sender {
    DDLogWarn(@"Tap %d",[self getAdjusterValue]);
}


@end
