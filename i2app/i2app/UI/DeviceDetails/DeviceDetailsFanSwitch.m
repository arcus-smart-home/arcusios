//
//  DeviceDetailsFanSwitch.m
//  i2app
//
//  Created by Arcus Team on 9/17/15.
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
#import "DeviceDetailsFanSwitch.h"
#import "ServiceControlCell.h"
#import "SwitchCapability.h"
#import "DeviceButtonBaseControl.h"
#import "FanCapability.h"

typedef enum {
    kFanOff = 0,
    kFanLow = 1,
    kFanMedium = 2,
    kFanHigh = 3
} FanSpeedType;

@interface DeviceDetailsFanSwitch ()

@end

@implementation DeviceDetailsFanSwitch

- (void)loadData {
    [super.controlCell disableLefRightButtons:NO];

    switch ([self fanSpeedTypeWithDevice:self.deviceModel]) {
        case kFanOff: {
            [self loadFanViewsFanOff];
        }
            break;
        case kFanLow: {
            [self loadFanViewsFanLow];
        }
            break;
        case kFanHigh: {
            [self loadFanviewsFanHigh];
        }
            break;
        default: {
            [self loadFanViewsFanMed];
        }
            break;
    }
}

- (FanSpeedType)fanSpeedTypeWithDevice:(DeviceModel *)deviceModel {
    NSString *fanState = [SwitchCapability getStateFromModel:self.deviceModel];
    int maxSpeed = [FanCapability getMaxSpeedFromModel:deviceModel];
    int speed = [FanCapability getSpeedFromModel:deviceModel];

    if (speed == 0 || ([fanState isEqualToString:kEnumSwitchStateOFF])) {
        return kFanOff;
    }
    else if (speed == 1) {
        return kFanLow;
    }
    else if (speed == maxSpeed) {
        return kFanHigh;
    }
    return kFanMedium;
}


- (void)loadFanViewsFanOff {
    [self.controlCell.leftButton setDefaultStyle:NSLocalizedString(@"ON", nil) withSelector:@selector(onFanClicked:) owner:self];
    [self.controlCell.rightButton setDefaultStyle:NSLocalizedString(@"OFF", nil) withSelector:@selector(offFanClicked:) owner:self];
    [self.controlCell.rightButton setDisable:YES];
    [self.controlCell setSubtitle:NSLocalizedString(@"Off", nil)];
}
- (void)loadFanViewsFanLow {
    [self.controlCell.leftButton setDefaultStyle:NSLocalizedString(@"MED", nil) withSelector:@selector(medFanClicked:) owner:self];
    [self.controlCell.rightButton setDefaultStyle:NSLocalizedString(@"OFF", nil) withSelector:@selector(offFanClicked:) owner:self];
    [self.controlCell.rightButton setDisable:NO];

    [self.controlCell setSubtitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"On", nil), NSLocalizedString(@"Low", nil)]];
}
- (void)loadFanViewsFanMed {
    [self.controlCell.leftButton setDefaultStyle:NSLocalizedString(@"HIGH", nil) withSelector:@selector(highFanClicked:) owner:self];
    [self.controlCell.rightButton setDefaultStyle:NSLocalizedString(@"OFF", nil) withSelector:@selector(offFanClicked:) owner:self];
    [self.controlCell.rightButton setDisable:NO];
    [self.controlCell setSubtitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"On", nil), NSLocalizedString(@"Med", nil)]];
}
- (void)loadFanviewsFanHigh {
    [self.controlCell.leftButton setDefaultStyle:NSLocalizedString(@"LOW", nil) withSelector:@selector(lowFanClicked:) owner:self];
    [self.controlCell.rightButton setDefaultStyle:NSLocalizedString(@"OFF", nil) withSelector:@selector(offFanClicked:) owner:self];
    [self.controlCell.rightButton setDisable:NO];
    [self.controlCell setSubtitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"On", nil), NSLocalizedString(@"High", nil)]];
}

#pragma mark - Control Methods
- (void)onFanClicked: (UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [SwitchCapability setState:kEnumSwitchStateON onModel:self.deviceModel];
        [FanCapability setSpeed:1 onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (void)offFanClicked:(UIButton *)sender  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [SwitchCapability setState:kEnumSwitchStateOFF onModel:self.deviceModel];
        [FanCapability setSpeed:0 onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (void)lowFanClicked:(UIButton *)sender {
    [self onFanClicked:sender];
}

- (void)medFanClicked:(UIButton *)sender  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        int maxSpeed = [FanCapability getMaxSpeedFromModel:self.deviceModel];
        int mediumSpeed = (maxSpeed+1)/2 ;

        [FanCapability setSpeed:mediumSpeed onModel:self.deviceModel];
        [self.deviceModel commit];
    });

}
- (void)highFanClicked:(UIButton *)sender  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        int maxSpeed = [FanCapability getMaxSpeedFromModel:self.deviceModel];
        [FanCapability setSpeed:maxSpeed onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}


@end
