//
//  IrrigationOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 7/28/15.
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
#import "IrrigationOperationViewController.h"
#import <PureLayout/PureLayout.h>
#import "PopupSelectionTimerView.h"
#import "PopupSelectionIrrigationView.h"
#import "NSDate+Convert.h"
#import "IrrigationControllerCapability.h"
#import "IrrigationZoneCapability.h"
#import "DeviceController.h"
#import "DevicePowerCapability.h"
#import "DeviceCapability.h"
#import "PopupSelectionTitleTableView.h"
#import "DeviceControlViewController.h"
#import "DeviceDetailsTabBarController.h"
#import "LawnNGardenDeviceCell.h"
#import "PopupSelectionButtonsView.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "NSDate+Convert.h"
#import "ALView+PureLayout.h"
#import "UIViewController+AlertBar.h"
#import <i2app-Swift.h>

#define kTimeoutInSeconds 30

@interface IrrigationOperationViewController () <DeviceDetailsLawnNGardenDeviceProtocol>

@property (strong, nonatomic) DeviceButtonBaseControl *leftButton;
@property (strong, nonatomic) DeviceButtonBaseControl *rightButton;

@property (strong, nonatomic) DeviceDetailsLawnNGardenDeviceController<DeviceDetailsLawnNGardenDeviceProtocol> *deviceDataModel;

@property (assign, nonatomic) BOOL isStateOff;

@end

@implementation IrrigationOperationViewController {
    DevicePercentageAttributeControl    *_battery;
    DeviceTextAttributeControl          *_power;
    
    PopupSelectionWindow    *_popupWindow;
    
    UIImageView     *_rainDropImageView;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityButtonsView | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isStateOff = false;
    
    [self displayFooterView];

    // Show buttons but keep them inactive until the device loads completely
    self.leftButton = [DeviceButtonBaseControl createDefaultButton:NSLocalizedString(@"WATER\n  NOW", nil) withSelector:nil owner:self];
    self.rightButton = [DeviceButtonBaseControl createDefaultButton:NSLocalizedString(@"SKIP", nil) withSelector:@selector(showSkipPopup:) owner:self];
    [self.buttonsView loadControl:self.leftButton control2:self.rightButton];
    [self enableButton:BOTH_BUTTONS enabled:NO];

    [self initialize];
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:animated];

    [self checkDeviceStateOff];
}

- (void)deviceDidDisappear:(BOOL)animated {
    [super deviceDidDisappear:animated];

    self.isStateOff = NO;
}

- (void)displayFooterView {
    NSString *powerSource = [DevicePowerCapability getSourceFromModel:self.deviceModel];
    if ([powerSource isEqualToString:kEnumDevicePowerSourceLINE]) {
        _power = [DeviceTextAttributeControl create:@"Power" withValue:@"AC"];
        [self.attributesView loadControl:_power];
        
    }
    else {
        NSInteger powerState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
        _battery = [DevicePercentageAttributeControl createWithBatteryPercentage:powerState];
        [self.attributesView loadControl:_battery];
    }
}

#pragma mark - platform related
//TODO Refactor this code too long
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    [self.deviceDataModel refreshData];

    [self displayFooterView];
}
- (NSString *)zodeEncodeNameWithIndex:(int)index {
    return [NSString stringWithFormat:@"z%d",index];
}

- (NSArray *)popupModels {
    int numberOfZones = [IrrigationControllerCapability getNumZonesFromModel:self.deviceModel];
    
    NSMutableArray *popupModels = [NSMutableArray array];
    
    for (int index = 1 ; index <= numberOfZones ; index ++) {
        NSString *zoneName = [DeviceController getIrrigationParameterState:self.deviceModel forParameter:kAttrIrrigationZoneZonename forZoneInstance:[self zodeEncodeNameWithIndex:index]];
        
        if ([zoneName isEqualToString:@"(null)"]) {
            zoneName = [NSString stringWithFormat:@"Zone %d", index];
        }
        
        [popupModels addObject:[PopupSelectionModel create:zoneName obj:@(index)]];
    }
    
    return popupModels;
}

#pragma mark - From Service Card
- (void)initialize {
    if (!self.deviceDataModel  || ![self.deviceDataModel isKindOfClass:[DeviceDetailsLawnNGardenDeviceController class]]) {
        self.deviceDataModel = (DeviceDetailsLawnNGardenDeviceController<DeviceDetailsLawnNGardenDeviceProtocol> *)[[DeviceDetailsLawnNGardenDeviceController alloc] initWithDeviceId:self.deviceModel.modelId];
        [self.deviceDataModel loadData:self];
    }

    [self.deviceDataModel loadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStateChangedNotification:) name:[Model attributeChangedNotification:kAttrIrrigationControllerControllerState] object:nil];
}

#pragma mark - Load Data
- (void)loadData {
 }

# pragma mark Button Pressed

# pragma mark Helping Functions
- (void)enableButton:(DeviceDetailsButton)button enabled:(BOOL)enabled {
    [self.buttonsView loadControl:self.leftButton control2:self.rightButton];

    // Off disabled both buttons
    if (_isStateOff) {
        button = BOTH_BUTTONS;
        enabled = false;
    }

    switch (button) {
        case LEFT_BUTTON:
            self.leftButton.button.enabled = enabled;
            break;
            
        case RIGHT_BUTTON:
            self.rightButton.button.enabled = enabled;
            break;
            
        case BOTH_BUTTONS:
            self.leftButton.button.enabled = self.rightButton.button.enabled = enabled;
            break;
            
        default:
            break;
    }
}

- (void)setDefaultStyle:(NSString *)name onButton:(DeviceDetailsButton)button selector:(SEL)sel {
    switch (button) {
        case LEFT_BUTTON:
            [self.leftButton setDefaultStyle:name withSelector:sel owner:self];
            break;

        case RIGHT_BUTTON:
            [self.rightButton setDefaultStyle:name withSelector:sel owner:self];
            break;
            
        default:
            break;
    }
}

- (void)showSubtitle:(NSString *)subtitle {
}

# pragma mark DeviceDetailsLawnNGardenDeviceProtocol

- (void)enabledForEvent:(BOOL)enabled {
    [self enableButton:BOTH_BUTTONS enabled:enabled];
}

- (void)showSkipPopup:(id)sender {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"SKIP IRRIGATION FOR", nil) button:
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"12 HOURS", nil) event:@selector(skip:) obj:[NSNumber numberWithInt:12]],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"24 HOURS", nil) event:@selector(skip:) obj:[NSNumber numberWithInt:24]],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"48 HOURS", nil) event:@selector(skip:) obj:[NSNumber numberWithInt:48]],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"72 HOURS", nil) event:@selector(skip:) obj:[NSNumber numberWithInt:72]], nil];
    buttonView.owner = self;
    [self popup:buttonView complete:nil withOwner:self];
}

- (void)skip:(NSNumber *)obj {
    [self.deviceDataModel skip:[obj intValue]];
}

- (void)showStopPopup:(id)sender {
    if ([[SubsystemsController sharedInstance].lawnNGardenController isManualWateringTrigger]) {
        [self stop:false];
        return;
    }
    
    // If this is a controller with only one zone then stop that zone.
    if ([(DeviceDetailsLawnNGardenDeviceController*)self.deviceDataModel numberOfZones] <= 1) {
        [self stop:true];
        return;
    }
    
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"STOP WATERING", nil)
                                                                              subtitle:NSLocalizedString(@"You are watering on a schedule. Do you want\nto stop watering the current zone only,\nor all zones in this event?", nil)
                                                                                button:
                                                                                        [PopupSelectionButtonModel create:NSLocalizedString(@"CURRENT ZONE ONLY", nil) event:@selector(stop:) obj:[NSNumber numberWithBool:YES]],
                                                                                        [PopupSelectionButtonModel create:NSLocalizedString(@"ALL ZONES", nil) event:@selector(stop:) obj:[NSNumber numberWithBool:NO]], nil];
    buttonView.owner = self;
    [self popup:buttonView complete:nil withOwner:self];
}

- (void)stop:(BOOL)currentOnly {
    [self.deviceDataModel stopWatering:currentOnly];
}

- (void)showWaterNowPopup:(id)sender {
    PopupSelectionIrrigationView *picker = [PopupSelectionIrrigationView create:@"" list:[self.deviceDataModel zonePopupModels]];
    [picker setSelectedZoneKey:@"z1"];
    [picker setSelectedDurationKey:@"1"];
    [self popup:picker complete:@selector(onMultiWaterNowPopupSelection:) withOwner:self];
}

- (void)onMultiWaterNowPopupSelection:(NSDictionary *)selectedValue {
    NSString *selectedTimeStr = selectedValue[@"time"];
    int durationInMinutes = [[selectedTimeStr componentsSeparatedByString:@" "][0] intValue];
    NSString *zone = [selectedValue objectForKey:@"zone"];
    
    if (durationInMinutes > 0) {
        [self.deviceDataModel waterNowWithZone:zone duration:durationInMinutes];
    }
}

- (void)showCurrentlyWatering:(NSString*)mode {
    [self enableButton:LEFT_BUTTON enabled:YES];
    [self setDefaultStyle:@"STOP" onButton:LEFT_BUTTON selector:@selector(showStopPopup:)];

    if (![mode isEqualToString:@"Manual"]) {
        [self enableButton:RIGHT_BUTTON enabled:NO];
        [self setDefaultStyle:@"SKIP" onButton:RIGHT_BUTTON selector:@selector(showSkipPopup:)];
    }
    else {
        [self.buttonsView loadControl:self.leftButton];
    }

    [self startRubberBandExpandAnimation];
}

- (void)showNotWatering:(NSString *)mode {
    [self enableButton:LEFT_BUTTON enabled:YES];
    [self setDefaultStyle:@"WATER\n  NOW" onButton:LEFT_BUTTON selector:@selector(showWaterNowPopup:)];
    
    if (![mode isEqualToString:@"Manual"]) {
        [self setDefaultStyle:@"SKIP" onButton:RIGHT_BUTTON selector:@selector(showSkipPopup:)];
    }
    else {
        [self.buttonsView loadControl:self.leftButton];
    }
    
    self.eventLabel.text = nil;
    if (_rainDropImageView) {
        [_rainDropImageView removeFromSuperview];
        _rainDropImageView = nil;
    }
    
    [self startRubberBandContractAnimation];
}

- (void)showTimeRemaining:(NSString *)remainingTime {
    @synchronized (_rainDropImageView) {
        NSString *deviceAddress = self.deviceModel.address;
        NSString *zones = [[SubsystemsController sharedInstance].lawnNGardenController getCurrentlyWateringZonesString:&deviceAddress];
        if (zones.length > 0) {
            [self.eventLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%@ ", zones.uppercaseString] andString2:remainingTime.uppercaseString withFont:FontDataTypeDeviceEventTitle andFont2:FontDataTypeDeviceEventTime]];
            
            if (_rainDropImageView) {
                [_rainDropImageView removeFromSuperview];
                _rainDropImageView = nil;
            }
            _rainDropImageView = [UIImageView newAutoLayoutView];
            _rainDropImageView.image = [UIImage imageNamed:@"water_drop"];
            [self.eventLabel.superview addSubview:_rainDropImageView];
            CGRect textFrame = self.eventLabel.frame;
            
            // Set the constraints for imageView
            [_rainDropImageView autoSetDimension:ALDimensionWidth toSize:_rainDropImageView.image.size.width];
            [_rainDropImageView autoSetDimension:ALDimensionHeight toSize:_rainDropImageView.image.size.height];
            [_rainDropImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:textFrame.origin.y + 3];
            [_rainDropImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:textFrame.origin.x + textFrame.size.width + 5];
            
            self.eventLabel.hidden = NO;
        }
    }
}

- (void)showRainDelay:(NSString *)until withMode:(NSString *)mode {
    [self enableButton:LEFT_BUTTON enabled:NO];
    [self enableButton:RIGHT_BUTTON enabled:YES];
    [self setDefaultStyle:@"WATER\n  NOW" onButton:LEFT_BUTTON selector:@selector(showStopPopup:)];

    if (![mode isEqualToString:@"Manual"]) {
        [self setDefaultStyle:@"CANCEL" onButton:RIGHT_BUTTON selector:@selector(cancelRainDelay:)];
        [self enableButton:RIGHT_BUTTON enabled:YES];
    } else {
        [self.buttonsView loadControl:self.leftButton];
    }

    if (until != nil) {
        self.eventLabel.hidden = NO;

        NSString *title = [NSString stringWithFormat:@"%@ ", NSLocalizedString(@"SKIP UNTIL", nil)];
        [_rainDropImageView removeFromSuperview];
        [self.eventLabel setAttributedText:[FontData getString:title andString2:until.uppercaseString withFont:FontDataTypeDeviceEventTitle andFont2:FontDataTypeDeviceEventTime]];
    }
}

- (void)cancelRainDelay:(id)sender {
    [self.deviceDataModel cancelSkip];
}


- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
    _popupWindow = [PopupSelectionWindow popup:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)showCurrentSchedule:(BOOL)shown zone:(NSString *)zone {
}

- (void)showNextSchedule:(BOOL)shown zone:(NSString *)zone {
    NSString *nextZone = [[SubsystemsController sharedInstance].lawnNGardenController getNextZone];
    NSDate *nextZoneTime = [[SubsystemsController sharedInstance].lawnNGardenController getNextZoneTime:self.deviceModel.address];

    if (nextZone.length > 0 && nextZoneTime) {
        NSString *title = NSLocalizedString(@"NEXT EVENT ", nil);

        [_rainDropImageView removeFromSuperview];
        [self.eventLabel setAttributedText:[FontData getString:title andString2:[nextZoneTime formatBasedOnDayOfWeekAndHoursExceptToday] withFont:FontDataTypeDeviceEventTitle andFont2:FontDataTypeDeviceEventTime]];
        self.eventLabel.hidden = NO;
    }
}

#pragma mark - State Checking

- (void)deviceStateChangedNotification:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkDeviceStateOff];
    });
}

- (void)checkDeviceStateOff {

    if ([self.deviceModel isControllerStateOff]) {
        if (!self.isStateOff) {
            [self popupAlert:NSLocalizedString(@"Manually set dial to \"Auto\" to work with Arcus", nil) type: AlertBarTypeNoConnection canClose:NO sceneType:AlertBarSceneInDevice];
            self.isStateOff = YES;
        }
    }
    else {
        if (self.isStateOff) {
            self.isStateOff = NO;
            [self closePopupAlert];
        }
    }
}


#pragma mark - firmware update
- (void)stopFirmwareUpdate {
    [self enabledForEvent:NO];
}

- (void)startFirmwareUpdate {
    [self enabledForEvent:YES];
}

@end
