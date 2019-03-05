//
//  DeviceDetailsPetDoor.m
//  i2app
//
//  Created by Arcus Team on 1/18/16.
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
#import "DeviceDetailsPetDoor.h"
#import "PopupSelectionBaseContainer.h"
#import "PopupSelectionButtonsView.h"
#import "PetDoorCapability.h"
#import "PetTokenCapability.h"
#import "DoorsNLocksSubsystemController.h"
#import "Capability.h"
#import "NSDate+TimeAgo.h"
#import "NSDate+Convert.h"
#import "ServiceControlCell.h"

@interface DeviceDetailsBase ()

- (void)animateRubberBandExpand:(UIView *)ringLogo;
- (void)animateRubberBandContract:(UIView *)ringLogo;

@end

@interface ServiceControlCell()

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setBottomButtonText:(NSString *)text;
- (void)setButtonSelector:(SEL)selector toOwner:(id)owner;

- (void)popup:(PopupSelectionBaseContainer *)container;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner style:(PopupWindowStyle)style;

@end


@implementation DeviceDetailsPetDoor
- (void)loadData {
    NSString *mode = [PetDoorCapability getLockstateFromModel:self.deviceModel];
    [self.controlCell setBottomButtonText:mode];
    [self.controlCell setButtonSelector:@selector(onClickBottomButton) toOwner:self];
    
    [self loadNextEvent:mode];
}

+ (BOOL)getLastEvent:(DeviceModel *)deviceModel eventText:(NSString **)eventText eventTime:(NSDate **)eventTime {
    NSString *mode = [PetDoorCapability getLockstateFromModel:deviceModel];
    if ([mode isEqualToString:kEnumPetDoorLockstateAUTO]) {
        NSDate *time;
        NSString *petName;
        BOOL available = [DoorsNLocksSubsystemController getLastPetDoorEntranceParametersForDevice:deviceModel petName:&petName eventTime:&time];
        if (available) {
            NSString *text = [NSString stringWithFormat:@"%@ Moved Through ", petName];
            *eventText = text;
            *eventTime = time;
            return YES;
        }
    }
    else if([mode isEqualToString:kEnumPetDoorLockstateLOCKED]) {
        *eventText = @"Locked ";
        *eventTime = [PetDoorCapability getLastlockstatechangedtimeFromModel:deviceModel];
        return YES;
    }
    else if([mode isEqualToString:kEnumPetDoorLockstateUNLOCKED]) {
        *eventText = @"Unlocked ";
        *eventTime = [PetDoorCapability getLastlockstatechangedtimeFromModel:deviceModel];
        return YES;
    }
    
    *eventText = @"";
    *eventTime = nil;
    return NO;
}

- (void)loadNextEvent:(NSString *)mode {
    NSDate *eventTime;
    NSString *eventText;

    if ([DeviceDetailsPetDoor getLastEvent:self.deviceModel eventText:&eventText eventTime:&eventTime]) {
        [self.controlCell setSubtitle:[NSString stringWithFormat:@"%@ %@", eventText, eventTime.formatDeviceLastEvent]];
    }
    else {
        [self.controlCell setSubtitle:@""];
    }
  
    if ([mode isEqualToString:kEnumPetDoorLockstateLOCKED]) {
        [self animateRubberBandContract:self.controlCell.centerIcon];
    }
    else if ([mode isEqualToString:kEnumPetDoorLockstateUNLOCKED]) {
        [self animateRubberBandExpand:self.controlCell.centerIcon];
    }
    else if ([mode isEqualToString:kEnumPetDoorLockstateAUTO]) {
        [self animateRubberBandExpand:self.controlCell.centerIcon];
    }
}

- (void)onClickBottomButton {
    PopupSelectionButtonsView *buttonView =  [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Choose A Mode", nil) button:
                                              [PopupSelectionButtonModel create:NSLocalizedString(@"AUTO", nil) event:@selector(petDoorAutoMode)],
                                              [PopupSelectionButtonModel create:NSLocalizedString(@"LOCKED", nil) event:@selector(petDoorLockedMode)],
                                              [PopupSelectionButtonModel create:NSLocalizedString(@"UNLOCKED", nil) event:@selector(petDoorUnlockedMode)], nil];
    buttonView.owner = self;
    [self.controlCell popup:buttonView];
}


- (void)petDoorAutoMode {
    [self.controlCell setBottomButtonText:@"AUTO"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorsNLocksSubsystemController setPetDoorLockStateToAutoForModel:self.deviceModel].then(^ {
            [self loadNextEvent:kEnumPetDoorLockstateAUTO];
        });
    });
}

- (void)petDoorLockedMode {
    [self.controlCell setBottomButtonText:@"LOCKED"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorsNLocksSubsystemController setPetDoorLockStateToLockedForModel:self.deviceModel].then(^ {
            [self loadNextEvent:kEnumPetDoorLockstateLOCKED];
        });
    });
}
- (void)petDoorUnlockedMode {
    [self.controlCell setBottomButtonText:@"UNLOCKED"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorsNLocksSubsystemController setPetDoorLockStateToUnlockedForModel:self.deviceModel].then(^ {
            [self loadNextEvent:kEnumPetDoorLockstateUNLOCKED];
        });
    });
}

#pragma mark - override
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *mode = [PetDoorCapability getLockstateFromModel:self.deviceModel];
    [self.controlCell setBottomButtonText:mode];
    [self loadNextEvent:mode];
}

@end
