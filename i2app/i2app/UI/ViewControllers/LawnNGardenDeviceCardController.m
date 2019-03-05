// 
// LawnNGardenDeviceCardController.m
//
// Created by Arcus Team on 3/17/16.
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
#import "LawnNGardenDeviceCardController.h"

#import "DisabledDeviceCard.h"
#import "LawnNGardenDeviceCard.h"
#import "DeviceConnectionCapability.h"
#import "DeviceOtaCapability.h"
#import "IrrigationControllerCapability.h"
#import <i2app-Swift.h>

@interface LawnNGardenDeviceCardController ()

@property (strong, nonatomic) DeviceModel *deviceModel;

@end

@implementation LawnNGardenDeviceCardController {

}

- (instancetype)initWithCallback:(id<CardControllerCallback>)delegate device:(NSString *)address {
    self = [super initWithCallback:delegate];
    if (self) {
        self.deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceStateChangedNotification:) name:self.deviceModel.modelChangedNotification object:nil];

        [self updateCard];
    }
    return self;
}

- (void)updateCard {
    // Figure out which card to show ...
    if (self.deviceModel != nil) {
        // If Offline || firmware
        if ([self.deviceModel isDeviceOffline]) {
            DisabledDeviceCard *card = [[DisabledDeviceCard alloc] init];
            card.title = self.deviceModel.name;
            card.subtitle = NSLocalizedString(@"No Connection", nil);
            card.model = self.deviceModel;
            card.type = ALERT;

            [self setCard:card];
        }
        else if ([self.deviceModel isUpdatingFirmware]) {
            DisabledDeviceCard *card = [[DisabledDeviceCard alloc] init];
            card.title = self.deviceModel.name;
            card.subtitle = NSLocalizedString(@"Firmware Update", nil);
            card.model = self.deviceModel;
            card.type = MESSAGE;

            [self setCard:card];
        }
        else if ([self.deviceModel isControllerStateOff]){
            DisabledDeviceCard *card = [[DisabledDeviceCard alloc] init];
            card.title = self.deviceModel.name;
            card.subtitle = NSLocalizedString(@"Manually set dial to \"Auto\" to work with Arcus", nil);
            card.model = self.deviceModel;
            card.type = ALERT;

            [self setCard:card];
        }
        else {
            LawnNGardenDeviceCard *card = [[LawnNGardenDeviceCard alloc] init];
            card.model = self.deviceModel;

            [self setCard:card];
        }
    }
}

- (void)getDeviceStateChangedNotification:(NSNotification *)note {

    // These are not the models you are looking for
    if (![[(Model *)([note.userInfo objectForKey:@"Model"]) modelId] isEqualToString: self.deviceModel.modelId]) {
        return;
    }

    NSArray *keys = [note.object allKeys];

    if ([keys containsObject:kAttrDeviceConnectionState] || [keys containsObject:kAttrDeviceOtaStatus] || [keys containsObject:kAttrIrrigationControllerControllerState]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCard];
        });
    }
}

@end
