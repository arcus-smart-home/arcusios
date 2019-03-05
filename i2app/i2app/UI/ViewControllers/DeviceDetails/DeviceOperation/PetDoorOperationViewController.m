//
//  PetDoorOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 1/12/16.
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
#import "PetDoorOperationViewController.h"
#import "DevicePercentageAttributeControl.h"
#import "DeviceButtonFrameBtnControl.h"
#import "DevicePowerCapability.h"
#import "DoorsNLocksSubsystemController.h"
#import "PetDoorCapability.h"
#import "PetTokenCapability.h"
#import "Capability.h"
#import "ALView+PureLayout.h"
#import "DeviceButtonGroupView.h"
#import "PopupSelectionButtonsView.h"
#import "DeviceDetailsPetDoor.h"


@interface PetDoorOperationViewController ()

- (void)modeButtonPressed:(id)sender;

@end

@implementation PetDoorOperationViewController {
    DevicePercentageAttributeControl    *_batteryControl;
    
    DeviceButtonFrameBtnControl         *_autoButton;

    PopupSelectionButtonsView           *_modePopup;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityButtonsView | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _batteryControl = [DevicePercentageAttributeControl createWithBatteryPercentage:0];
    
    [self.attributesView loadControl:_batteryControl];
    
    _autoButton = [DeviceButtonFrameBtnControl create:@"" withSelector:@selector(modeButtonPressed:) andOwner:self];
    
    [self.buttonsView loadControl:_autoButton];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    int batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
    if (batteryState > -1) {
        [_batteryControl setPercentage:batteryState];
    }
    
    [self displayPetDoorMode];
    
    NSDate *eventTime;
    NSString *eventText;
    self.eventLabel.hidden = ![DeviceDetailsPetDoor getLastEvent:self.deviceModel eventText:&eventText eventTime:&eventTime];
    
    if (!self.eventLabel.hidden) {
        [self.eventLabel setTitle:[NSString stringWithFormat:@"%@|", eventText] andTime:eventTime];
    }
    if (self.isCenterMode) {
        [self setSensorEnable];
    }
 }

- (void)setSensorEnable {
    NSString *mode = [PetDoorCapability getLockstateFromModel:self.deviceModel];

    if ([mode isEqualToString:kEnumPetDoorLockstateLOCKED]) {
        [self startRubberBandContractAnimation];
    }
    else if ([mode isEqualToString:kEnumPetDoorLockstateUNLOCKED]) {
        [self startRubberBandExpandAnimation];
    }
    else if ([mode isEqualToString:kEnumPetDoorLockstateAUTO]) {
        [self startRubberBandExpandAnimation];
    }
}

#pragma mark - Pet Door Mode
- (void)displayPetDoorMode {
    NSString *mode = [PetDoorCapability getLockstateFromModel:self.deviceModel];

    if ([mode isEqualToString:kEnumPetDoorLockstateAUTO]) {
        [_autoButton setText:NSLocalizedString(@"AUTO", nil)];
    }
    else if ([mode isEqualToString:kEnumPetDoorLockstateLOCKED]) {
        [_autoButton setText:NSLocalizedString(@"LOCKED", nil)];
    }
    else if ([mode isEqualToString:kEnumPetDoorLockstateUNLOCKED]) {
        [_autoButton setText:NSLocalizedString(@"UNLOCKED", nil)];
    }
}

- (void)modeButtonPressed:(id)sender {
    _modePopup = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Choose A Mode", nil) button:
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"AUTO", nil) event:@selector(petDoorAutoMode)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"LOCKED", nil) event:@selector(petDoorLockedMode)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"UNLOCKED", nil) event:@selector(petDoorUnlockedMode)], nil];
    _modePopup.owner = self;
    [self popup:_modePopup];
}

- (void)petDoorAutoMode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorsNLocksSubsystemController setPetDoorLockStateToAutoForModel:self.deviceModel].then(^ {
            [self displayPetDoorMode];
        });
    });
}

- (void)petDoorLockedMode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorsNLocksSubsystemController setPetDoorLockStateToLockedForModel:self.deviceModel].then(^ {
            [self displayPetDoorMode];
        });
    });
}

- (void)petDoorUnlockedMode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorsNLocksSubsystemController setPetDoorLockStateToUnlockedForModel:self.deviceModel].then(^ {
            [self displayPetDoorMode];
        });
    });
}

@end
