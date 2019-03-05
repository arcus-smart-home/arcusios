//
//  DeviceDetailsThermostat.m
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
#import "DeviceDetailsThermostat.h"
#import "DeviceButtonBaseControl.h"
#import "DeviceDetailsBase.h"
#import "DeviceController.h"
#import "ThermostatCapability.h"
#import "DeviceController.h"
#import "ServiceControlCell.h"
#import "HoneywellTCCCapability.h"
#import "DeviceButtonBaseControl.h"
#import "PopupSelectionNumberView.h"
#import "PopupSelectionButtonsView.h"
#import "ClimateScheduleController.h"
#import "NSDate+Convert.h"
#import "ImagePaths.h"
#import "NSTimer+Block.h"
#import "ClimateSubSystemController.h"

// Prefixed ddt temp to resolve conflict
const double ddtThermostatSecBetweenUpdates = 1.0f;
const double ddtSecBetweenUpdates = 0.5f;
const int ddtSecWaitToUpdate = 2;


@interface DeviceDetailsThermostat()

@property (strong, nonatomic) NSTimer *debounceTimer;

@end


@implementation DeviceDetailsThermostat

- (void)loadData {
    self.delegate = self.controlCell;
    self.controlUpdateStartTime = -1;

    [self.delegate setButtonSelector:@selector(onClickBottom:) toOwner:self];
    
    NSString *currentMode = [ThermostatCapability getHvacmodeFromModel:self.deviceModel];
    [self setLabels:currentMode];
    [self setButtons:currentMode];

    _coolTemp = ([DeviceController getThermostatCoolSetPointForModel:self.deviceModel]);
    _heatTemp = ([DeviceController getThermostatHeatSetPointForModel:self.deviceModel]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setLabels:currentMode];
        [self setButtons:currentMode];
        
    });
}

- (BOOL)checkMode: (NSString *)modeToCheck isPresentInModes: (NSArray *)modes {
  for (NSString *mode in modes) {
    if ([mode isEqualToString: modeToCheck]) {
      return YES;
    }
  }

  return NO;
}

- (NSString *)autoModeText {
  return NSLocalizedString(@"AUTO", nil);
}

- (void)onClickBottom:(UIButton *)sender {
    switch (self.deviceModel.deviceType) {
        case DeviceTypeThermostatHoneywellC2C:
        case DeviceTypeThermostatNest:
        case DeviceTypeThermostat: {
            NSArray *modes = [DeviceController availableModesForModel:self.deviceModel];
            NSMutableArray *buttons = [NSMutableArray new];

            if ([self checkMode:kEnumThermostatHvacmodeHEAT isPresentInModes:modes]) {
              [buttons addObject:[PopupSelectionButtonModel create:NSLocalizedString(@"HEAT", nil) event:@selector(handleModePressed:) obj: kEnumThermostatHvacmodeHEAT]];
            }
            if ([self checkMode:kEnumThermostatHvacmodeCOOL isPresentInModes:modes]) {
              [buttons addObject:[PopupSelectionButtonModel create:NSLocalizedString(@"COOL", nil) event:@selector(handleModePressed:) obj: kEnumThermostatHvacmodeCOOL]];
            }
            if ([self checkMode:kEnumThermostatHvacmodeAUTO isPresentInModes:modes]) {
              [buttons addObject:[PopupSelectionButtonModel create:[self autoModeText] event:@selector(handleModePressed:) obj: kEnumThermostatHvacmodeAUTO]];
            }
            if ([self checkMode:kEnumThermostatHvacmodeECO isPresentInModes:modes]) {
              [buttons addObject:[PopupSelectionButtonModel create:NSLocalizedString(@"ECO", nil) event:@selector(handleModePressed:) obj: kEnumThermostatHvacmodeECO]];
            }
            if ([self checkMode:kEnumThermostatHvacmodeOFF isPresentInModes:modes]) {
              [buttons addObject:[PopupSelectionButtonModel create:NSLocalizedString(@"OFF", nil) event:@selector(handleModePressed:) obj: kEnumThermostatHvacmodeOFF]];
            }

            PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Choose A Mode", nil) buttons:buttons];
            buttonView.owner = self;
            [self.delegate popup:buttonView complete:nil withOwner:self];
        }
            break;
        default:
            break;
    }
}

- (void)setBottomButtonText:(NSString *)text {
}

- (void)setButtonSelector:(SEL)selector toOwner:(id)owner {
}

- (void)setSubtitle:(NSString *)subtitle {
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
}

-(void)handleModePressed:(id)selectedValue {
  if ([selectedValue isEqualToString: kEnumThermostatHvacmodeHEAT]) {
    [self commitThermostatMode:kEnumThermostatHvacmodeHEAT];
  } else if ([selectedValue isEqualToString: kEnumThermostatHvacmodeCOOL]) {
    [self commitThermostatMode:kEnumThermostatHvacmodeCOOL];
  } else if ([selectedValue isEqualToString: kEnumThermostatHvacmodeAUTO]) {
    [self commitThermostatMode:kEnumThermostatHvacmodeAUTO];
  } else if ([selectedValue isEqualToString: kEnumThermostatHvacmodeECO]) {
    [self commitThermostatMode:kEnumThermostatHvacmodeECO];
  } else if ([selectedValue isEqualToString: kEnumThermostatHvacmodeOFF]) {
    [self commitThermostatMode:kEnumThermostatHvacmodeOFF];
  }
}

- (void)commitThermostatMode:(NSString *)mode {

    [self startDebounceTimer:0.0 event:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [ThermostatCapability setHvacmode:mode onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }];
}

- (void)onThermostatClickMinus:(UIButton *)sender {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    NSString *currentMode = [ThermostatCapability getHvacmodeFromModel:self.deviceModel];
    int coolSet = (int)_coolTemp;
    int heatSet = (int)_heatTemp;

    if ([currentMode isEqualToString:kEnumThermostatHvacmodeCOOL]) {
      _coolTemp = [self adjustTemperatureForLimits:coolSet - 1];
    } else if ([currentMode isEqualToString:kEnumThermostatHvacmodeHEAT]) {
      _heatTemp = [self adjustTemperatureForLimits:heatSet - 1];
    }

    [self commitSetPoints:(int)_coolTemp heatPoint:(int)_heatTemp];
    [self setLabels:currentMode];
  });
}

- (void)onThermostatClickPlus:(UIButton *)sender {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    NSString *currentMode = [ThermostatCapability getHvacmodeFromModel:self.deviceModel];
    int coolSet = (int)_coolTemp;
    int heatSet = (int)_heatTemp;

    if ([currentMode isEqualToString:kEnumThermostatHvacmodeCOOL]) {
      _coolTemp = [self adjustTemperatureForLimits:coolSet + 1];
    } else if ([currentMode isEqualToString:kEnumThermostatHvacmodeHEAT]) {
      _heatTemp = [self adjustTemperatureForLimits:heatSet + 1];
    }

    [self commitSetPoints:(int)_coolTemp heatPoint:(int)_heatTemp];
    [self setLabels:currentMode];
  });
}

- (void)onSetAutoThermostatLow {
  // Do not send value updates while temp popup is visible
  [self stopDebounceTimer];

  int coolSet = (int)[DeviceController getThermostatCoolSetPointForModel:self.deviceModel];
  int currentHeatSet = (int)[DeviceController getThermostatHeatSetPointForModel:self.deviceModel];
  int minLimit = [self minSetpointLimit];
  int separation = (int)[DeviceController getSetpointSeparationForModel:self.deviceModel];

  PopupSelectionNumberView *popupSelection = [PopupSelectionNumberView create:@"Set Low Temperature"
                                                                withMinNumber:minLimit
                                                                    maxNumber:coolSet-separation
                                                                   andPostfix:@"°"];

  [popupSelection setCurrentKey:@(currentHeatSet)];
  [self.delegate popup:popupSelection complete:@selector(setAutoThermostatLow:) withOwner:self];
}

- (void)setAutoThermostatLow:(id)value {
    [self commitSetPoints:(int)_coolTemp heatPoint:(int)[value integerValue]];
}

- (void)onSetAutoThermostatHigh {
  // Do not send value updates while temp popup is visible
  [self stopDebounceTimer];

  int heatSet = (int)[DeviceController getThermostatHeatSetPointForModel:self.deviceModel];
  int currentCoolSet = (int)[DeviceController getThermostatCoolSetPointForModel:self.deviceModel];
  int maxLimit = [self maxSetpointLimit];
  int separation = (int)[DeviceController getSetpointSeparationForModel:self.deviceModel];

  PopupSelectionNumberView *popupSelection = [PopupSelectionNumberView create:@"Set High Temperature"
                                                                withMinNumber:heatSet+separation
                                                                    maxNumber:maxLimit
                                                                   andPostfix:@"°"];

  [popupSelection setCurrentKey:@(currentCoolSet)];
  [self.delegate popup:popupSelection complete:@selector(setAutoThermostatHigh:) withOwner:self];
}

- (void)setAutoThermostatHigh:(id)value {
    [self commitSetPoints:(int)[value integerValue] heatPoint:(int)_heatTemp];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if (self.controlUpdateStartTime != -1 && self.controlUpdateStartTime + ddtSecWaitToUpdate <= [[NSDate date] timeIntervalSinceNow]) {
        // Update every 2 seconds after updates were started
        // DDLogWarn(@"$$$$$$$$$$$ received update NOT USED");
        return;
    }
    self.controlUpdateStartTime = -1;

    // TODO Refresh is updating the device card from ServiceControlCell.
//    NSString *currentMode = [ThermostatCapability getHvacmodeFromModel:self.deviceModel];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self setLabels:currentMode];
//        [self setButtons:currentMode];
//    });
}

#pragma mark - assisting methods

- (int)minSetpointLimit {
  int minLimit = (int)[DeviceController getMinSetpointForModel:self.deviceModel];

  // For Nest thermostats we need to check the lock state
  if (self.deviceModel.deviceType == DeviceTypeThermostatNest && [DeviceController getNestLocked:self.deviceModel]) {
    minLimit = (int)[DeviceController getNestLockedTempMinForModel:self.deviceModel];
  }

  return minLimit;
}

- (int)maxSetpointLimit {
  int maxLimit = (int)[DeviceController getMaxSetpointForModel:self.deviceModel];

  // For Nest thermostats we need to check the lock state
  if (self.deviceModel.deviceType == DeviceTypeThermostatNest && [DeviceController getNestLocked:self.deviceModel]) {
    maxLimit = (int)[DeviceController getNestLockedTempMaxForModel:self.deviceModel];
  }

  return maxLimit;
}

- (void)commitSetPoints:(int)coolTemp heatPoint:(int)heatTemp {
    NSTimeInterval duration = ddtSecBetweenUpdates;

    _heatTemp = heatTemp;
    _coolTemp = coolTemp;
    
    [self startDebounceTimer:duration event:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [DeviceController setThermostatSetPoints:_coolTemp heatPoint:_heatTemp onModel:self.deviceModel];
            self.controlUpdateStartTime = [[NSDate date] timeIntervalSince1970];
        });
    }];
}

- (int)adjustTemperatureForLimits:(int)temp {
  int minLimit = [self minSetpointLimit];
  int maxLimit = [self maxSetpointLimit];

  if (temp < minLimit) {
    return minLimit;
  }
  else if (temp > maxLimit) {
    return maxLimit;
  }

  return temp;
}

- (void)setLabels:(NSString *)currentMode {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *buttonText = currentMode;

    if ([currentMode isEqualToString:kEnumThermostatHvacmodeAUTO]) {
      buttonText = [self autoModeText];
    }

    if ([currentMode isEqualToString:kEnumThermostatHvacmodeOFF] || [currentMode isEqualToString:kEnumThermostatHvacmodeECO]) {
      self.controlCell.leftButton.hidden = YES;
      self.controlCell.rightButton.hidden = YES;
    } else {
      self.controlCell.leftButton.hidden = NO;
      self.controlCell.rightButton.hidden = NO;
    }

    [self.delegate setBottomButtonText:buttonText];

    int coolSet = (int)_coolTemp;
    int heatSet = (int)_heatTemp;
    int currentTemp = (int)([DeviceController getTemperatureForModel:self.deviceModel]);

    NSString *thermoStatus;
    if ([currentMode isEqualToString:kEnumThermostatHvacmodeECO] || [currentMode isEqualToString:kEnumThermostatHvacmodeOFF]) {
      thermoStatus = [NSString stringWithFormat:@"Now %d°",currentTemp];
    }
    else if ([currentMode isEqualToString:kEnumThermostatHvacmodeAUTO]) {
      if (heatSet>0 && coolSet<0) {
        thermoStatus = [NSString stringWithFormat:@"%d° %@ ?° - ?°", currentTemp, NSLocalizedString(@"Set", nil)];
      }
      else {
        thermoStatus = [NSString stringWithFormat:@"%d° %@ %d° - %d°",currentTemp, NSLocalizedString(@"Set", nil), heatSet, coolSet];
      }
    }
    else if ([currentMode isEqualToString:kEnumThermostatHvacmodeCOOL]) {
      if (coolSet<0) {
        thermoStatus = [NSString stringWithFormat:@"Now %d Set [Unset]",currentTemp];
      }
      else {
        thermoStatus = [NSString stringWithFormat:@"Now %d Set %d°",currentTemp, coolSet];
      }
    }
    else if ([currentMode isEqualToString:kEnumThermostatHvacmodeHEAT]) {
      if (heatSet<0) {
        thermoStatus = [NSString stringWithFormat:@"Now %d Set [Unset]",currentTemp];
      }
      else {
        thermoStatus = [NSString stringWithFormat:@"Now %d Set %d°",currentTemp, heatSet];
      }
    }

    [self.delegate setSubtitle:thermoStatus];
  });
}

- (void)setButtons: (NSString *)currentMode {
    [self.controlCell.leftButton setDisable:[currentMode isEqualToString:kEnumThermostatHvacmodeOFF]];
    [self.controlCell.rightButton setDisable:[currentMode isEqualToString:kEnumThermostatHvacmodeOFF]];
    
    if ([currentMode isEqualToString:kEnumThermostatHvacmodeAUTO]) {
        [self.controlCell.leftButton setDefaultStyle:NSLocalizedString(@"Low", nil) withSelector:@selector(onSetAutoThermostatLow) owner:self];
        [self.controlCell.rightButton setDefaultStyle:NSLocalizedString(@"High", nil) withSelector:@selector(onSetAutoThermostatHigh) owner:self];
    }
    else {
        [self.controlCell.leftButton setImageStyle:[UIImage imageNamed:@"deviceThermostatMinusButton"] withSelector:@selector(onThermostatClickMinus:) owner:self];
        [self.controlCell.rightButton setImageStyle:[UIImage imageNamed:@"deviceThermostatPlusButton"] withSelector:@selector(onThermostatClickPlus:) owner:self];
    }
}

#pragma mark - Top event methods
- (void)displayNextEvent:(NSString *)mode eventLabel:(UILabel *)eventLabel eventCloseButton:(UIButton *)eventCloseButton animationDuration:(float)duration {
    if ([mode isEqualToString:kEnumThermostatHvacmodeOFF]) {
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        NSString *tempValue;
        NSDate *nextEventDate;
        if ([ClimateScheduleController nextEventForModel:self.deviceModel eventTime:&nextEventDate eventValue:&tempValue]) {
            NSString *title = NSLocalizedString(@"NEXT EVENT", nil);
            NSString *details = [NSString stringWithFormat:@" %@ AT %@", tempValue, [nextEventDate formatDateTimeStamp]];

            eventLabel.hidden = NO;
            [eventLabel setAttributedText:[FontData getString:title andString2:details withFont:FontDataTypeDeviceEventTitle andFont2:FontDataTypeDeviceEventTime]];

            // Hide the close button
            // self.eventCloseButton.hidden = YES;
        }
        else {
            eventLabel.hidden = YES;
            // self.eventCloseButton.hidden = NO;
        }
    } completion:^(BOOL finished) {
        eventCloseButton.alpha = 1.0f;
    }];
}


#pragma mark Device Event Timer
- (void)startDebounceTimer:(NSTimeInterval)duration event:(void (^)(void))block {
    [self stopDebounceTimer];

    dispatch_async(dispatch_get_main_queue(), ^{
        _debounceTimer = [NSTimer arcus_scheduledTimerWithTimeInterval:duration repeats:NO block:^() {
          block();
          _debounceTimer = nil;
        }];
    });
}

- (void)stopDebounceTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_debounceTimer != nil) {
            [_debounceTimer invalidate];
            _debounceTimer = nil;
        }
    });
}

@end
