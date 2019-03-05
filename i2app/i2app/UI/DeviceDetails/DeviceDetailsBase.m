//
//  DeviceDetailsBase.m
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
#import "DeviceDetailsBase.h"

#import "DeviceButtonBaseControl.h"
#import "UIView+Animation.h"
#import "UIView+Overlay.h"
#import "ServiceControlCell.h"

@interface DeviceDetailsBase ()

@end


@implementation DeviceDetailsBase

@dynamic deviceModel;
@synthesize deviceId;

#pragma mark - DeviceDetailsDelegate
- (instancetype)initWithDeviceId:(NSString *)modelId {
    if (self = [super init]) {
        self.deviceId = modelId;
    }
    return self;
}

- (DeviceModel *)deviceModel {
    return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[DeviceModel addressForId:self.deviceId]];
}

- (void)loadDelegate:(ServiceControlCell *)cell {
    self.controlCell = cell;
}

- (void)loadData {
    
}

- (void)loadOfflineMode {
    [self.controlCell setSubtitle:NSLocalizedString(@"Offline", nil)];
    [self.controlCell.rightButton setDisable:YES];
    [self.controlCell.leftButton setDisable:YES];
    [self.controlCell setupPinkBannerOfflineModeView];
}

- (void)loadOnlineMode {
    for (UIView *item in self.controlCell.subviews) {
        if (item.tag == kGrayViewTag) {
            [item removeFromSuperview];
        }
    }

    if (self.deviceModel.deviceType != DeviceTypeGarageDoor) {
        // Enabling buttons here overwrites setting them based on device state.
        [self.controlCell.rightButton setDisable:NO];
        [self.controlCell.leftButton setDisable:NO];
        [self.controlCell.bottomButton setHidden:YES];
    }

    [self.controlCell tearDownPinkBannerOfflineModeView];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    
}

#pragma mark - Secret methods: Animation
- (void)animateRubberBandExpand:(UIView *)ringLogo {
    if (ringLogo.frame.size.width >= 190) {
        [ringLogo animateRubberBandExpand:nil circleBroad:5.0f alpha:.6f];
    }
    else {
        [ringLogo animateRubberBandExpand:nil circleBroad:2.0f alpha:1.0f];
    }
}

- (void)animateRubberBandContract:(UIView *)ringLogo {
    if (ringLogo.frame.size.width >= 190) {
        [ringLogo animateRubberBandContract:^{
            ringLogo.layer.borderWidth = 5.0f;
        }];
    }
    else {
        [ringLogo animateRubberBandContract:^{
            ringLogo.layer.borderWidth = 0.0f;
        }];
    }
}

- (void)animateStartShining:(UIView *)ringLogo {
    if (ringLogo.frame.size.width >= 190) {
        [ringLogo animateStartShining:nil withBoarderWidth:20.0f];
    }
    else {
        [ringLogo animateStartShining:nil withBoarderWidth:3.0f];
    }
}

- (void)animateStopShining:(UIView *)ringLogo {
    if (ringLogo.frame.size.width >= 190) {
        [ringLogo animateStartShining:nil withBoarderWidth:5.0f];
    }
    else {
        [ringLogo animateStartShining:nil withBoarderWidth:.0f];
    }
}

- (void)hideRubberBand:(UIView *)ringLogo {
  [ringLogo setHidden:NO];
}

- (void)displayRubberBand:(UIView *)ringLogo {
  [ringLogo setHidden:YES];
}

#pragma mark - helping method
- (BOOL)checkOverrides:(SEL)selector {
    Class objSuperClass = [self superclass];
    BOOL isMethodOverridden = NO;
    
    while (objSuperClass != Nil) {
        
        isMethodOverridden = [self methodForSelector: selector] != [objSuperClass instanceMethodForSelector: selector];
        
        if (isMethodOverridden) {
            break;
        }
        
        objSuperClass = [objSuperClass superclass];
        if (objSuperClass == [NSObject class]) {
            break;
        }
    }
    
    return isMethodOverridden;
}

@end
