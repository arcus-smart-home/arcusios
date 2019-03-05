//
//  DeviceDetailsGarageDoor.m
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
#import "DeviceDetailsGarageDoor.h"
#import "DeviceButtonBaseControl.h"
#import "MotorizedDoorCapability.h"
#import "ServiceControlCell.h"
#import "NSDate+Convert.h"
#import "DeviceAdvancedCapability.h"
#import "UIView+Overlay.h"

@interface DeviceDetailsBase ()

- (void)animateRubberBandExpand:(UIView *)ringLogo;
- (void)animateRubberBandContract:(UIView *)ringLogo;

@end

@interface DeviceDetailsGarageDoor()

@property (nonatomic, strong) DeviceButtonBaseControl *openButton;
@property (nonatomic, strong) DeviceButtonBaseControl *closeButton;
@property (nonatomic, strong) UIView *logoView;
@property (nonatomic, assign) BOOL isSingleButton;

@end


@implementation DeviceDetailsGarageDoor

@dynamic doorStatus;

- (void)loadData {
    [self configureCellWithLogo:self.controlCell.centerIcon
                     openButton:self.controlCell.leftButton
                    closeButton:self.controlCell.rightButton];

    [self updateDeviceState:nil initialUpdate:YES];
    [self.controlCell setSubtitle:self.doorStatus];

    NSDate *eventTime;
    NSString *eventText;
    if ([DeviceDetailsGarageDoor getLastEvent:self.deviceModel eventText:&eventText eventTime:&eventTime]) {
        [self.controlCell setSubtitle:[NSString stringWithFormat:@"%@ %@", eventText, eventTime.formatDeviceLastEvent]];
    }
    else {
        [self.controlCell setSubtitle:@""];
    }
}

- (void)configureCellWithLogo:(UIView *)logoView
                   openButton:(DeviceButtonBaseControl *)openButton
                  closeButton:(DeviceButtonBaseControl *)closeButton {
    self.isSingleButton = NO;
    
    self.logoView = logoView;
    self.openButton = openButton;
    self.closeButton = closeButton;
    
    [self.openButton setDefaultStyle:NSLocalizedString(@"OPEN", nil) withSelector:@selector(openCloseButtonPressed:) owner:self];
    [self.closeButton setDefaultStyle:NSLocalizedString(@"CLOSE", nil) withSelector:@selector(openCloseButtonPressed:) owner:self];
}

- (void)configureCellWithLogo:(UIView *)logoView
              openCloseButton:(DeviceButtonBaseControl *)openCloseButton {
    self.isSingleButton = YES;
    
    self.logoView = logoView;
    self.openButton = openCloseButton;
    
    [self.openButton setDefaultStyle:NSLocalizedString(@"OPEN", nil) withSelector:@selector(openCloseButtonPressed:) owner:self];
}

- (void)openCloseButtonPressed: (UIButton *)sender {
    [self toggleDoorState:[MotorizedDoorCapability getDoorstateFromModel:self.deviceModel]];
}

- (void)toggleDoorState:(NSString *)doorState {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *toggledState = nil;
        
        if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateCLOSED]) {
            toggledState = kEnumMotorizedDoorDoorstateOPEN;
        }
        else if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateOPEN]) {
            toggledState = kEnumMotorizedDoorDoorstateCLOSED;
        }

        if (toggledState) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.openButton setDisable:YES];
                [self.closeButton setDisable:YES];
            });
            
            [MotorizedDoorCapability setDoorstate:toggledState
                                          onModel:self.deviceModel];
            [self.deviceModel commit].catch(^(NSError *error) {
                [self.openButton setDisable:NO];
                [self.closeButton setDisable:NO];
            });
        }
    });
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    NSString *doorState = [self doorStatus];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateButtonTextForState:doorState];
        [self updateButtonStateForState:doorState];
        [self updateLogoForState:doorState];
        [self updateBanner];
    });
}

- (void)updateBanner {
    if ([self isObstructed]) {
      [self.controlCell teardownDeviceError];
      [self.controlCell setupDeviceError:NSLocalizedString(@"Obstruction Detected", nil)];
    } else {
      if(![self.deviceModel isDeviceOffline]){
        // don't remove the offline banner if it exist
        [self.controlCell teardownDeviceError];
      }
    }
}

- (void)updateButtonTextForState:(NSString *)doorState {

    if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateCLOSING]) {
        if (self.isSingleButton) {
            [self.openButton setLabelText:@"CLOSING"];
        }
        else {
            [self.openButton setLabelText:@"OPEN"];
            [self.closeButton setLabelText:@"CLOSING"];
        }
    }
    else if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateOPENING]) {
        if (self.isSingleButton) {
            [self.openButton setLabelText:@"OPENING"];
        }
        else {
            [self.openButton setLabelText:@"OPENING"];
            [self.closeButton setLabelText:@"CLOSE"];
        }
    }
    else if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateCLOSED]) {
        if (self.isSingleButton) {
            [self.openButton setLabelText:@"OPEN"];
        }
        else {
            [self.openButton setLabelText:@"OPEN"];
            [self.closeButton setLabelText:@"CLOSE"];
        }
    }
    else if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateOPEN]) {
        if (self.isSingleButton) {
            [self.openButton setLabelText:@"CLOSE"];
        }
        else {
            [self.openButton setLabelText:@"OPEN"];
            [self.closeButton setLabelText:@"CLOSE"];
        }
    }
}

- (void)updateButtonStateForState:(NSString *)doorState {
    if ([self isObstructed]) {
        [self.openButton setDisable:YES];
        [self.closeButton setDisable:YES];
        return;
    }
    if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateCLOSING] ||
        [doorState isEqualToString:kEnumMotorizedDoorDoorstateOPENING] ||
        !doorState) {
        [self.openButton setDisable:YES];
        [self.closeButton setDisable:YES];
    }
    else if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateCLOSED]) {
        if (self.isSingleButton) {
            [self.openButton setDisable:NO];
        }
        else {
            [self.openButton setDisable:NO];
            [self.closeButton setDisable:YES];
        }
    }
    else if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateOPEN]) {
        if (self.isSingleButton) {
            [self.openButton setDisable:NO];
        }
        else {
            [self.openButton setDisable:YES];
            [self.closeButton setDisable:NO];
        }
    }
}

- (void)updateLogoForState:(NSString *)doorState {
  if ([self isObstructed] ) {
    [self animateRubberBandContract:self.logoView];
  } else if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateCLOSED]) {
    [self animateRubberBandContract:self.logoView];
  } else if ([doorState isEqualToString:kEnumMotorizedDoorDoorstateOPEN]) {
    [self animateRubberBandExpand:self.logoView];
  }
}

- (NSString *) doorStatus {
    return [MotorizedDoorCapability getDoorstateFromModel:self.deviceModel];
}

- (BOOL) isObstructed {
  NSDictionary *errors = [DeviceAdvancedCapability getErrorsFromModel:self.deviceModel];
  NSString *errObstruction = errors[@"ERR_OBSTRUCTION"];
  if (errObstruction != nil && ![self.deviceModel isDeviceOffline] ) {
    return true;
  } else {
    return false;
  }
}

+ (BOOL)getLastEvent:(DeviceModel *)deviceModel eventText:(NSString **)eventText eventTime:(NSDate **)eventTime {
    NSString *mode = [MotorizedDoorCapability getDoorstateFromModel:deviceModel];
    if([mode isEqualToString:kEnumMotorizedDoorDoorstateCLOSED]) {
        *eventText = @"Closed";
        *eventTime = [MotorizedDoorCapability getDoorstatechangedFromModel:deviceModel];
        return YES;
    }
    else if([mode isEqualToString:kEnumMotorizedDoorDoorstateOPEN]) {
        *eventText = @"Opened";
        *eventTime = [MotorizedDoorCapability getDoorstatechangedFromModel:deviceModel];
        return YES;
    }
    else if ([mode isEqualToString:kEnumMotorizedDoorDoorstateOBSTRUCTION]) {
        *eventText = @"Obstruction";
        *eventTime = [MotorizedDoorCapability getDoorstatechangedFromModel:deviceModel];
        return YES;
    }
    else if ([mode isEqualToString:kEnumMotorizedDoorDoorstateOPENING]) {
        *eventText = @"Opening";
        *eventTime = [MotorizedDoorCapability getDoorstatechangedFromModel:deviceModel];
        return YES;
    }
    else if ([mode isEqualToString:kEnumMotorizedDoorDoorstateCLOSING]) {
        *eventText = @"Closing";
        *eventTime = [MotorizedDoorCapability getDoorstatechangedFromModel:deviceModel];
        return YES;
    }
    *eventText = @"";
    *eventTime = nil;
    return NO;
}


@end
