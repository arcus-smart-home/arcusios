//
//  DeviceDetailsLock.m
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
#import "DeviceDetailsLock.h"
#import "DeviceController.h"
#import "DoorLockCapability.h"
#import "DevicePowerCapability.h"
#import "DeviceAdvancedCapability.h"
#import "DeviceButtonBaseControl.h"
#import "ServiceControlCell.h"
#import "NSDate+Convert.h"
#import <i2app-Swift.h>

@interface DeviceDetailsBase ()

- (void)animateRubberBandExpand:(UIView *)ringLogo;
- (void)animateRubberBandContract:(UIView *)ringLogo;

@end

@interface DeviceDetailsLock()

- (void)pressedLockButton:(DeviceButtonBaseControl *)lockButton;
- (void)pressedBuzzButton:(DeviceButtonBaseControl *)lockButton;

@end


@implementation DeviceDetailsLock {
    BOOL                        _isBuzzingIn;
    BOOL                        _isLocked;
}

@dynamic hasBuzzInCapability;
@dynamic lockStatus;

#pragma mark - Life Cycle
- (void)loadData {
    [self loadDetailData];

    NSDate *eventTime;
    NSString *eventText;
    if ([DeviceDetailsLock getLastEvent:self.deviceModel eventText:&eventText eventTime:&eventTime]) {
        [self.controlCell setSubtitle:[NSString stringWithFormat:@"%@ %@", eventText, [eventTime formatDeviceLastEvent]]];
    }
    else {
        [self.controlCell setSubtitle:@""];
    }
}

- (void)loadDetailData {
    [self.controlCell.leftButton setDefaultStyle:NSLocalizedString(@"Lock", nil) withSelector:@selector(pressedLockButton:) owner:self];
    
    if (self.hasBuzzInCapability) {
        [self.controlCell.rightButton setDefaultStyle:NSLocalizedString(@"Buzz In", nil) withSelector:@selector(pressedBuzzButton:) owner:self];
    }
    else {
        [self.controlCell.rightButton setHidden:YES];
    }
    
    [self updateDeviceState:nil initialUpdate:YES];
}

- (void)loadData:(UIView *)logoView leftButton:(DeviceButtonBaseControl *)leftButton withRightButton:(DeviceButtonBaseControl *)rightButton {
    [leftButton setDefaultStyle:NSLocalizedString(@"Lock", nil) withSelector:@selector(pressedLockButton:) owner:self];

    if (self.hasBuzzInCapability) {
        [rightButton setDefaultStyle:NSLocalizedString(@"Buzz In", nil) withSelector:@selector(pressedBuzzButton:) owner:self];
    }
    else {
        [rightButton setHidden:YES];
    }

    [self updateDeviceState:nil initialUpdate:YES];
}

#pragma mark - Dynamic Properties
- (BOOL)hasBuzzInCapability {
    return [DoorLockCapability getSupportsBuzzInFromModel:self.deviceModel];
}

- (NSString *)lockStatus {
    return [DoorLockCapability getLockstateFromModel:self.deviceModel];
}

- (void)pressedLockButton:(DeviceButtonBaseControl *)lockButton {
  // If the user is currently buzzing in, we should not allow them to tap the button again
  if (_isBuzzingIn) {
    return;
  }

  [self.controlCell.leftButton setDisable:YES];
  [self.controlCell.rightButton setDisable:YES];

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    BOOL newlockState = !_isLocked;
    if ([self.deviceModel isJammed]) {
      [DoorLockCapability setLockstate:(kEnumDoorLockLockstateUNLOCKED)
                               onModel:self.deviceModel];
    } else {
      [DoorLockCapability setLockstate:(newlockState ? kEnumDoorLockLockstateLOCKED : kEnumDoorLockLockstateUNLOCKED)
                               onModel:self.deviceModel];
    }
    [self.deviceModel commit];
    if (!newlockState) {
      [self.controlCell.rightButton setDisable:YES];
    }
  });
}

- (void)pressedBuzzButton:(UIButton *)sender {

    // If the user is currently buzzing in, we should not allow them to tap the button again
    if (_isBuzzingIn) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorLockCapability buzzInOnModel:self.deviceModel].then(^(DoorLockBuzzInResponse *response) {
            [self setLock:NO];
            [self setBuzzIn:!_isBuzzingIn];
        });
    });
}

- (void)setLock:(BOOL)lock {
  if (_isBuzzingIn) {
    return;
  }
  _isLocked = lock;
  if ([self.deviceModel isJammed]){
    [self.controlCell.leftButton setLabelText:@"Unlock"];
    [self.controlCell.rightButton setDisable:YES];
  }
  else if (_isLocked) {
    [self.controlCell.leftButton setLabelText:@"Unlock"];
    [self.controlCell.rightButton setDisable:NO];
  }
  else {
    [self.controlCell.leftButton setLabelText:@"Lock"];
    [self.controlCell.rightButton setDisable:YES];
  }
}

- (void)setBuzzIn:(BOOL)buzzin {
    _isBuzzingIn = buzzin;
    
    if (_isBuzzingIn) {
        [self.controlCell.rightButton setDisable:YES];
        [self.controlCell.leftButton setDisable:YES];
    }
    else {
        [self.controlCell.rightButton setDisable:NO];
        [self.controlCell.leftButton setDisable:NO];
    }
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *lockState = [self lockStatus];

    if ([self.deviceModel isJammed]){
      [self.controlCell.leftButton setLabelText:@"Unlock"];
      [self.controlCell.leftButton setDisable:NO];
      [self.controlCell.rightButton setDisable:YES];
    }
    else if ([lockState isEqualToString:kEnumDoorLockLockstateLOCKING]) {
        [self.controlCell.rightButton setDisable:YES];
        [self.controlCell.leftButton setDisable:YES];
    }
    else if ([lockState isEqualToString:kEnumDoorLockLockstateUNLOCKING]) {
        [self.controlCell.rightButton setDisable:YES];
        [self.controlCell.leftButton setDisable:YES];
    }
    else if ([lockState isEqualToString:kEnumDoorLockLockstateLOCKED]) {
        [self setLock:YES];
        
        if (_isBuzzingIn) {
            // The door was looked as a result of the buzzing ending
            // Clear the buzz state
            [self setBuzzIn:NO];
        }
        else {
            [self.controlCell.leftButton setDisable:NO];
        }
    }
    else if ([lockState isEqualToString:kEnumDoorLockLockstateUNLOCKED]) {
        if (!_isBuzzingIn) {
            [self setLock:NO];
            
            [self.controlCell.rightButton setDisable:YES];
            [self.controlCell.leftButton setDisable:NO];
        }
    }
    [self updateBanner];
    [self updateRubberBanding];
}

- (void)updateBanner {
  dispatch_async(dispatch_get_main_queue(), ^{
    if([self.deviceModel isJammed]) {
      [self.controlCell teardownDeviceWarning];
      [self.controlCell setupDeviceWarning:NSLocalizedString(@"Door Lock is Jammed", nil)];
    } else {
      if(![self.deviceModel isDeviceOffline]){
        // don't remove the offline banner if it exist
        [self.controlCell teardownDeviceWarning];
      }
    }
  });
}

- (void)updateRubberBanding {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *lockState = [self lockStatus];
    if ([self.deviceModel isJammed]) {
      [self animateRubberBandContract:self.controlCell.centerIcon];
    } else if ([lockState isEqualToString:kEnumDoorLockLockstateLOCKED]) {
      [self animateRubberBandContract:self.controlCell.centerIcon];
    } else if ([lockState isEqualToString:kEnumDoorLockLockstateUNLOCKED]) {
      [self animateRubberBandExpand:self.controlCell.centerIcon];
    }
  });
}

+ (BOOL)getLastEvent:(DeviceModel *)deviceModel eventText:(NSString **)eventText eventTime:(NSDate **)eventTime {
    NSString *lockState = [DoorLockCapability getLockstateFromModel:deviceModel];
  if([deviceModel isJammed]){
    *eventText = @"Unlocked";
    *eventTime = [DoorLockCapability getLockstatechangedFromModel:deviceModel];
    return YES;
  }
  else if([lockState isEqualToString:kEnumDoorLockLockstateLOCKED]) {
    *eventText = @"Locked";
    *eventTime = [DoorLockCapability getLockstatechangedFromModel:deviceModel];
    return YES;
  }
  else if([lockState isEqualToString:kEnumDoorLockLockstateUNLOCKED]) {
    *eventText = @"Unlocked";
    *eventTime = [DoorLockCapability getLockstatechangedFromModel:deviceModel];
    return YES;
  }

  *eventText = @"";
  *eventTime = nil;
  return NO;
}

@end




