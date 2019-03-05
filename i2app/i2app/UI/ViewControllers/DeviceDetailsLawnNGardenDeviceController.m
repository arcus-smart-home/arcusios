//
// Created by Arcus Team on 3/1/16.
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
#import "DeviceDetailsLawnNGardenDeviceController.h"
#import "LawnNGardenDeviceCell.h"
#import "IrrigationControllerCapability.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "OrderedDictionary.h"
#import "NSTimer+Block.h"
#import "NSDate+TimeAgo.h"
#import "NSDate+Convert.h"
#import "LawnNGardenScheduleController.h"
#import "LawnNGardenSubsystemCapability.h"
#import "LawnNGardenZoneController.h"
#import "IrrigationZoneModel.h"

@interface DeviceDetailsLawnNGardenDeviceController ()

@property (weak, nonatomic) LawnNGardenDeviceCell *cell;
@property (weak, nonatomic) NSObject<DeviceDetailsLawnNGardenDeviceProtocol> *callback;

@property (strong, nonatomic) NSTimer *countdownTimer;
@property (assign, nonatomic) NSTimeInterval countdownLength;

@end

@implementation DeviceDetailsLawnNGardenDeviceController

static NSMutableArray *_inTransitionStateDeviceAddresses;

+ (void)initialize {
    _inTransitionStateDeviceAddresses = [NSMutableArray new];
}

+ (BOOL)isInTransitionState:(NSString *)deviceAddress {
    return [_inTransitionStateDeviceAddresses containsObject:deviceAddress];
}

+ (void)removeFromInTransitionState:(NSString *)deviceAddress {
    [_inTransitionStateDeviceAddresses removeObject:deviceAddress];
}

+ (void)addToIntransitionState:(NSString *)deviceAddress {
    [_inTransitionStateDeviceAddresses addObject:deviceAddress];
}

- (void)loadData:(id<DeviceDetailsLawnNGardenDeviceProtocol>)callback {
    if (![callback conformsToProtocol:@protocol(DeviceDetailsLawnNGardenDeviceProtocol)]) {
        // Error
        [NSException raise:NSInvalidArgumentException
                    format:@"Callback must conform to Protocol"];
    }

    self.callback = callback;

    [self setupListeners];

    [self refreshData];
}

- (void)refreshData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.callback enabledForEvent:![DeviceDetailsLawnNGardenDeviceController isInTransitionState:self.deviceModel.address]];

        // Is currently watering?
        NSTimeInterval isWateringCountdown = [[SubsystemsController sharedInstance].lawnNGardenController getCurrentWateringTimeRemaining:self.deviceModel.address];
        BOOL isSkip = [[SubsystemsController sharedInstance].lawnNGardenController getSkipUntilForModel:self.deviceModel.address] != -1;

        NSString *mode = [[SubsystemsController sharedInstance].lawnNGardenController getCurrentIrrigationModeForModel:self.deviceModel.address];

        if (isWateringCountdown > 0 && !isSkip) {
            // If we're watering now then show stop button and disable the skip button
            self.countdownLength = isWateringCountdown;
            [self.callback showCurrentlyWatering:[mode capitalizedString]];
            [self startTimer];
        } else if (isSkip) {
            // Get Skip Until Date and show
            [self.callback showRainDelay:[self skipUntilDate] withMode:[mode capitalizedString]];
            return;
        } else if (![_inTransitionStateDeviceAddresses containsObject:self.deviceModel.address]) {
            // Stop a timer if it's currently going
            [self stopTimer];
            [self.callback showNotWatering:[mode capitalizedString]];
        }

        // Is there currently a schedule going on
        NSDictionary *currentEvent = [[SubsystemsController sharedInstance].lawnNGardenController getCurrentEventForModel:self.deviceModel.address];
        if (currentEvent != nil && currentEvent.count > 0 && [LawnNGardenScheduleController isValidEvent:currentEvent]) {
            NSString *zoneName = [LawnNGardenZoneController getSafeNameForZone:currentEvent[@"zone"] device:self.deviceModel];
            if (zoneName != nil)
                [self.callback showCurrentSchedule:YES zone:zoneName];
        }
        else {
            [self.callback showCurrentSchedule:NO zone:@""];
        }

        // Is there a schedule coming up next
        NSDictionary *nextEvent = [[SubsystemsController sharedInstance].lawnNGardenController getNextEventForCurrentIrrigationModeForModel:self.deviceModel.address];
        if (nextEvent != nil && nextEvent.count > 0 && [LawnNGardenScheduleController isValidEvent:nextEvent]) {
            NSString *zoneName = [LawnNGardenZoneController getSafeNameForZone:nextEvent[@"zone"] device:self.deviceModel];
            NSString *nextEvent = [[[SubsystemsController sharedInstance].lawnNGardenController getNextZoneTime:self.deviceModel.address] formatBasedOnDayOfWeekAndHoursIncludingToday];
	        if (zoneName.length > 0 && isWateringCountdown > 0) {
                [self.callback showNextSchedule:YES zone:zoneName];
            } else {
                [self.callback showNextSchedule:YES zone:nextEvent];
            }
        }
        else {
            [self.callback showNextSchedule:NO zone:@""];
        }
        
    });
}

#pragma mark - Device / Subsystem Listeners

// TODO: This should all be handled here in the controller

- (void)getSubsystemStateChangedNotification:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([note.object isKindOfClass:[NSDictionary class]] && ((NSDictionary *) note.object)[kAttrLawnNGardenSubsystemZonesWatering]) {
            [DeviceDetailsLawnNGardenDeviceController removeFromInTransitionState:self.deviceModel.address];
         }
        [self refreshData];
    });
}

- (void)setupListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSubsystemStateChangedNotification:) name:[SubsystemModel attributeChangedNotification:kAttrLawnNGardenSubsystemZonesWatering] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSubsystemStateChangedNotification:) name:[SubsystemModel attributeChangedNotification:kAttrLawnNGardenSubsystemControllers] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSubsystemStateChangedNotification:) name:[SubsystemModel attributeChangedNotification:kAttrLawnNGardenSubsystemScheduleStatus] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSubsystemStateChangedNotification:) name:[SubsystemModel attributeChangedNotification:kAttrLawnNGardenSubsystemNextEvent] object:nil];
}

- (void)removeListeners {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[SubsystemModel attributeChangedNotification:kAttrLawnNGardenSubsystemZonesWatering] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[SubsystemModel attributeChangedNotification:kAttrLawnNGardenSubsystemControllers] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[SubsystemModel attributeChangedNotification:kAttrLawnNGardenSubsystemScheduleStatus] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[SubsystemModel attributeChangedNotification:kAttrLawnNGardenSubsystemNextEvent] object:nil];
}


#pragma mark - Actions
- (void)skip:(int)hours {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[SubsystemsController sharedInstance].lawnNGardenController skipWithController:self.deviceModel.address withHours:hours];
    });
}

- (void)setWaterPercentage:(int)percentage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [IrrigationControllerCapability setBudget:percentage onModel:self.deviceModel];
    });
}

- (void)waterNowWithZone:(NSString *)zone duration:(int)duration {
    // Disable
    [DeviceDetailsLawnNGardenDeviceController addToIntransitionState:self.deviceModel.address];
    [self.callback enabledForEvent:![DeviceDetailsLawnNGardenDeviceController isInTransitionState:self.deviceModel.address]];

    // Make Request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{

        [IrrigationControllerCapability waterNowV2WithZone:zone withDuration:duration onModel:self.deviceModel].then(^(IrrigationControllerWaterNowResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.callback enabledForEvent:true];
            });
        });
    });
}

- (void)stopWatering:(BOOL)currentOnly {
    [DeviceDetailsLawnNGardenDeviceController addToIntransitionState:self.deviceModel.address];
    [self.callback enabledForEvent:![DeviceDetailsLawnNGardenDeviceController isInTransitionState:self.deviceModel.address]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[SubsystemsController sharedInstance].lawnNGardenController stopWithController:self.deviceModel.address currentOnly:currentOnly];
    });
}

- (void)cancelSkip {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[SubsystemsController sharedInstance].lawnNGardenController cancelSkipWithController:self.deviceModel.address];
    });
}

# pragma mark - override
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    [self refreshData];
}

# pragma mark Helper

- (int)numberOfZones {
    return [IrrigationControllerCapability getNumZonesFromModel:self.deviceModel];
}

/***
 * Returns an OrderedDictionary of IrrigationZoneModels
 * @return zones as an OrderedDictionary of IrrigationZoneModel
 */
- (OrderedDictionary *)zonePopupModels {
    OrderedDictionary *zoneModelsForDevices = [LawnNGardenSubsystemController getZonesForDeviceAddresses:@[self.deviceModel.address]];
    NSArray *zoneModelsForDevice = zoneModelsForDevices[self.deviceModel.name];

    OrderedDictionary *zoneModels = [[OrderedDictionary alloc] initWithCapacity:zoneModelsForDevice.count];

    for (IrrigationZoneModel *model in zoneModelsForDevice) {
        [zoneModels setObject:model forKey:[model zoneValue]];
    }

    return zoneModels;
}

- (int)maxIrrigationTime {
    return [IrrigationControllerCapability getMaxirrigationtimeFromModel:self.deviceModel];
}

- (NSString *)skipUntilDate {
    NSTimeInterval skipUntilTime = [[SubsystemsController sharedInstance].lawnNGardenController getSkipUntilForModel:self.deviceModel.address];

    if (skipUntilTime == -1)
        return nil;

    NSDate *skipUntil = [NSDate dateWithTimeIntervalSince1970:skipUntilTime];

    return [skipUntil formatBasedOnDayOfWeekAndHoursIncludingToday];
}

#pragma mark - Timer methods

- (void)stopTimer {
    if (self.countdownTimer != nil) {
        [self.countdownTimer invalidate];
    }

    self.countdownTimer = nil;
}

- (void)startTimer {
    [self stopTimer];
    self.countdownTimer = [NSTimer arcus_scheduledTimerWithTimeInterval:1.0 repeats:YES block:^() {
        self.countdownLength -= 1.0;

        if (self.countdownLength < 0) {
            [self stopTimer];
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            int duration  = self.countdownLength;

            NSString *time = @"";
            if (duration >= 60) {
                int minutes = (duration / 60) % 60;
                int hours = (duration / 3600);
                int seconds = duration % 3600;
                if (seconds > 30) {
                    // round up
                    minutes++;
                }
                if (hours > 0) {
                    time = [time stringByAppendingFormat:@"%d Hr", hours];
                }
                if (minutes > 0) {
                    if (![time isEqualToString:@""])
                        time = [time stringByAppendingString:@" "];
                    
                    time = [time stringByAppendingFormat:@"%d Min", minutes];
                }
            }
            else {
                time = [time stringByAppendingString:@"1 Min"];
            }
            [self.callback showTimeRemaining:[NSString stringWithFormat:@"%@ Remaining", time]];
        });
    }];

    [self.countdownTimer fire];
}

@end
