//
//  DeviceDetailsWaterSoftener.m
//  i2app
//
//  Created by Arcus Team on 1/13/16.
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
#import "DeviceDetailsWaterSoftener.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionBaseContainer.h"
#import "DeviceButtonBaseControl.h"
#import "DeviceController.h"
#import "WaterSoftenerCapability.h"

@interface ServiceControlCell ()

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setBottomButtonText:(NSString *)text;
- (void)setButtonSelector:(SEL)selector toOwner:(id)owner;

- (void)popup:(PopupSelectionBaseContainer *)container;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner style:(PopupWindowStyle)style;

@end

@implementation DeviceDetailsWaterSoftener {
    ServiceControlCell          *_cell;
}

- (void)loadData:(ServiceControlCell *)cell {
    _cell = cell;
    
    [self updateDeviceState:nil initialUpdate:YES];
}

- (void)onClickRechargeNow {
    if ([self isRecharging]) {
        return;
    }
    PopupSelectionButtonsView *popup = [PopupSelectionButtonsView createWithTitle:@"ARE YOU SURE?" subtitle:@"water softener sure text" button: [PopupSelectionButtonModel create:@"Continue" event:@selector(onClickContinue)], [PopupSelectionButtonModel create:@"Cancel"], nil];
    popup.owner = self;
    [_cell popup:popup complete:nil withOwner:self style:PopupWindowStyleCautionWindow];
}

- (void)onClickContinue {
    if ([self isRecharging]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [WaterSoftenerCapability rechargeNowOnModel:self.deviceModel].then(^(WaterSoftenerRechargeNowResponse *response) {
            DDLogWarn(@"%@", response.description);
        })
        .catch(^(NSError *error) {
            [_cell.parentController displayGenericErrorMessage];
        });
    });
}

- (BOOL)isRecharging {
    int rechargerRemainingTime = [WaterSoftenerCapability getRechargeTimeRemainingFromModel:self.deviceModel];
    
    if (rechargerRemainingTime > 0) {
        return YES;
    }
    
    return NO;
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    int maxsaltLevel = [WaterSoftenerCapability getMaxSaltLevelFromModel:self.deviceModel];
    int currentSaltLevel = [WaterSoftenerCapability getCurrentSaltLevelFromModel:self.deviceModel];
    BOOL saltLevelEnabled = [WaterSoftenerCapability getSaltLevelEnabledFromModel:self.deviceModel];
    
    float percentageSaltLevel;
    if (saltLevelEnabled) {
        percentageSaltLevel = (((float)currentSaltLevel / (float)maxsaltLevel) * 100);
    }
    else {
        percentageSaltLevel = .0f;
    }
    [_cell setSubtitle:[NSString stringWithFormat:@"Salt Level: %d%%", (int)roundf(percentageSaltLevel)]];
}

@end
