//
//  DuraflameOperationViewController.m
//  i2app
//
//  Arcus Team on 8/11/16.
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
#import "DuraflameOperationViewController.h"
#import "SpaceHeaterCapability.h"
#import "TwinStarCapability.h"
#import "DeviceController.h"
#import "TemperatureCapability.h"
#import "DeviceAdvancedCapability.h"
#import "DeviceNotificationLabel.h"
#import "UIViewController+AlertBar.h"
#import "MultipleErrorsViewController.h"
#import "DeviceControlViewController.h"
#import <i2app-Swift.h>
#import "ClimateScheduleController.h"
#import "NSDate+Convert.h"
#import "SchedulerCapability.h"
#import "DeviceButtonLabelledSwitchControl.h"
#import "DeviceButtonLabelledControl.h"

#import <Foundation/Foundation.h>

@interface DuraflameOperationViewController ()

@property (atomic, assign) NSInteger displayedSetpointValue;
@property (atomic, assign) NSInteger errorBannerTag;
@property (strong, nonatomic) ThrottledExecutor *executor;

@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet DeviceNotificationLabel *nextEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentlyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flameImage;
@property (weak, nonatomic) IBOutlet DeviceButtonGroupView *adjusterView;
@property (weak, nonatomic) IBOutlet DeviceButtonGroupView *togglesView;

@property (nonatomic, strong) DeviceButtonLabelledSwitchControl *powerSwitch;
@property (nonatomic, strong) DeviceButtonLabelledSwitchControl *ecomodeSwitch;
@property (nonatomic, strong) DeviceButtonLabelledControl *plusButton;
@property (nonatomic, strong) DeviceButtonLabelledControl *minusButton;
@property (nonatomic, strong) DeviceTempAttributeControl *setpointAttribute;

@end

#define kThrottlePeriodSec 0.5
#define kQuiescenceIntervalSec 0.5
#define kButtonEnabledAlpha 1.0
#define kButtonDisabledAlpha 0.4

@implementation DuraflameOperationViewController

- (void)viewDidLoad {
    self.deviceLogo.image = [[UIImage alloc] init];
    self.executor = [[ThrottledExecutor alloc] initWithThrottlePeriodSec:kQuiescenceIntervalSec quiescencePeriodSec:kQuiescenceIntervalSec];
    [super viewDidLoad];

    [self.currentlyLabel styleSet:NSLocalizedString(@"CURRENTLY", nil) andButtonType:FontDataType_DemiBold_13_WhiteAlpha upperCase:YES];
    
    [self.togglesView loadControl:self.powerSwitch control2:self.ecomodeSwitch];
    [self.adjusterView loadControl:self.minusButton attributeControl:self.setpointAttribute control3:self.plusButton withHorizSpacing:-25.0];
}

- (DeviceTempAttributeControl *)setpointAttribute {
    if (!_setpointAttribute) {
        _setpointAttribute = [DeviceTempAttributeControl createWithTemp:0.0 withTitle:NSLocalizedString(@"SET TO", nil)];
    }
    return _setpointAttribute;
}


- (DeviceButtonLabelledControl *)plusButton {
    if (!_plusButton) {
        _plusButton = [DeviceButtonLabelledControl create:nil withImageName:@"deviceThermostatPlusButton" withClick:^BOOL(id sender) {
            [self onPlusButton:sender];
            return NO;
        }];
    }
    return _plusButton;
}

- (DeviceButtonLabelledControl *)minusButton {
    if (!_minusButton) {
        _minusButton = [DeviceButtonLabelledControl create:nil withImageName:@"deviceThermostatMinusButton" withClick:^BOOL(id sender) {
            [self onMinusButton:sender];
            return NO;
        }];
    }
    return _minusButton;
}


- (DeviceButtonLabelledSwitchControl *)powerSwitch {
    if (!_powerSwitch) {
        _powerSwitch = [DeviceButtonLabelledSwitchControl create:@"power" withSelect:^BOOL(id sender) {
            [self onPowerSwitch:sender];
            return NO;
        } withUnselect:^BOOL(id sender) {
            [self onPowerSwitch:sender];
            return NO;
        }];
    }
    return _powerSwitch;
}

- (DeviceButtonLabelledSwitchControl *)ecomodeSwitch {
    if (!_ecomodeSwitch) {
        _ecomodeSwitch = [DeviceButtonLabelledSwitchControl create:@"ecomode" withSelect:^BOOL(id sender) {
            [self onEcomodeSwitch:sender];
            return NO;
        } withUnselect:^BOOL(id sender) {
            [self onEcomodeSwitch:sender];
            return NO;
        }];
    }
    return _ecomodeSwitch;
}


- (void)centerMode {
    [super centerMode];
    [self.deviceLogo setImage:nil];
}


- (void)onPlusButton:(id)sender {
    NSInteger setpoint = [self getDisplayedSetpoint];
    NSInteger maxSetpoint = [DeviceController getSpaceHeaterMaxSetpointForModel:self.deviceModel];
    
    if (++setpoint < maxSetpoint) {
        [self setDisplayedSetpoint:setpoint];
        [self.executor execute:^{}];
        [self.executor executeAfterQuiescence:^{
            [self setValueAdjusterEnabled:NO];      // Button will be re-enabled when platform sends base:ValueChange
            [DeviceController setSpaceHeaterSetpointForModel:setpoint onModel:self.deviceModel];
        }];
    }
}

- (void)onMinusButton:(id)sender {
    NSInteger setpoint = [self getDisplayedSetpoint];
    NSInteger minSetpoint = [DeviceController getSpaceHeaterMinSetpointForModel:self.deviceModel];
    
    if (--setpoint > minSetpoint) {
        [self setDisplayedSetpoint:setpoint];
        [self.executor execute:^{}];
        [self.executor executeAfterQuiescence: ^{
            [self setValueAdjusterEnabled:NO];      // Button will be re-enabled when platform sends base:ValueChange
            [DeviceController setSpaceHeaterSetpointForModel:setpoint onModel:self.deviceModel];
        }];
    }
}

- (void)onPowerSwitch:(id)sender {
    self.powerSwitch.selected = !self.powerSwitch.selected;
    [self setDisplayedHeatState:self.powerSwitch.selected];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString* heatState = self.powerSwitch.selected ? kEnumSpaceHeaterHeatstateON : kEnumSpaceHeaterHeatstateOFF;
        [SpaceHeaterCapability setHeatstate:heatState onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (IBAction)onEcomodeSwitch:(id)sender {
    self.ecomodeSwitch.selected = !self.ecomodeSwitch.selected;
    [self setDisplayedEcoMode:self.ecomodeSwitch.selected];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString* ecoMode = self.ecomodeSwitch.selected ? kEnumTwinStarEcomodeENABLED : kEnumTwinStarEcomodeDISABLED;
        [TwinStarCapability setEcomode:ecoMode onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (void)setDisplayedEcoMode: (BOOL) isOn {
    self.ecomodeSwitch.selected = isOn;
    [self setTemperatureAdjusterHidden:self.ecomodeSwitch.selected || !self.powerSwitch.selected];
}

- (void)setDisplayedHeatState:(BOOL) isOn {
    self.powerSwitch.selected = isOn;
    [self.flameImage setHidden:!isOn];
    [self setTemperatureAdjusterHidden:self.ecomodeSwitch.selected || !self.powerSwitch.selected];
}

- (void)setTemperatureAdjusterHidden:(BOOL) isHidden {
    [self.plusButton setHidden:isHidden];
    [self.minusButton setHidden:isHidden];
    [self.setpointAttribute setHidden:isHidden];
}

-(void)setDisplayedSetpoint:(NSInteger) setpoint {
    [self.setpointAttribute setTemp:setpoint];
    self.displayedSetpointValue = setpoint;
}

-(NSInteger)getDisplayedSetpoint {
    return self.displayedSetpointValue;
}

-(void)setDisplayedTemperature:(NSInteger) currentTemp {
    if (currentTemp == NSNotFound ) {
        [self.currentTempLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"-"] withFont:FontDataTypeDeviceCenterTemperatureNumber]];
    }
    else {
        [self.currentTempLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)currentTemp] withFont:FontDataTypeDeviceCenterTemperatureNumber]];
    }
}

-(void)setValueAdjusterEnabled:(BOOL) enabled {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.plusButton.button.enabled = enabled;
        self.minusButton.button.enabled = enabled;
        self.plusButton.button.imageView.alpha = enabled ? kButtonEnabledAlpha : kButtonDisabledAlpha;
        self.minusButton.button.imageView.alpha = enabled ? kButtonEnabledAlpha : kButtonDisabledAlpha;
    });
}

-(void)setDisplayedNextEvent:(NSString*) nextEventString {
    if (nextEventString == nil) {
        self.nextEventLabel.hidden = YES;
    } else {
        self.nextEventLabel.hidden = NO;
        [self.nextEventLabel setAttributedText:[FontData getString:NSLocalizedString(@"NEXT EVENT", nil) andString2:nextEventString withFont:FontDataTypeDeviceEventTitle andFont2:FontDataTypeDeviceEventTime]];
    }
}

-(void)updateErrorBanner {
    
    NSDictionary *duraflameErrors = [DeviceController getDeviceErrors:self.deviceModel];
    
    NSTimeInterval delay = 1;
    
    // Multiple errors
    if (duraflameErrors.count > 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissErrorBanner];
            self.errorBannerTag = [self popupLinkAlert:@"Multiple Errors" type:AlertBarTypeClickableWarning sceneType:AlertBarSceneInDevice grayScale:NO linkText:nil selector:@selector(onOpenErrorsView) displayArrow:YES];
        });
    }
    
    // One error
    else if (duraflameErrors.count == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissErrorBanner];
            self.errorBannerTag = [self popupError:duraflameErrors.allKeys[0] withMessage:duraflameErrors.allValues[0]];
        });
    }
    
    // No errors
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissErrorBanner];
        });
    }
}

- (void) dismissErrorBanner {
    [self closePopupAlertWithTag:self.errorBannerTag];
}

- (NSInteger)popupError:(NSString*) errorKey withMessage:(NSString *)errorMessage {
    if ([errorKey isEqualToString:@"E1"] || [errorKey isEqualToString:@"E2"]) {
        return [self popupAlert:errorMessage type:AlertBarTypeWarning sceneType:AlertBarSceneInDevice bottomButton:@"1-0" grayScale:NO selector:@selector(onCallSupport)];
    } else {
        return [self popupAlert:errorMessage type:AlertBarTypeWarning canClose:YES grayScale:NO sceneType:AlertBarSceneInDevice];
    }
}

-(void)onCallSupport {
    NSURL *phoneUrl = [NSURL URLWithString:@"tel://+18003189373"];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

-(void)onOpenErrorsView {
    dispatch_async(dispatch_get_main_queue(), ^{
        MultipleErrorsViewController *vc = [MultipleErrorsViewController createWithErrorList:[DeviceController getDeviceErrors:self.deviceModel].allValues withHeaderVisible:NO];
        [self.deviceController.navigationController pushViewController:vc animated:YES];
    });
}

- (NSString*)nextEventString {

    SchedulerModel *scheduler = [ClimateScheduleController getSchedulerForModelWithAddress:self.deviceModel.address];
    
    NSDictionary *commands = [SchedulerCapability getCommandsFromModel:scheduler];
    NSString *nextFireSchedule = [SchedulerCapability getNextFireScheduleFromModel:scheduler];
    BOOL scheduleEnabled = [[scheduler get] valueForKey: @"sched:enabled:CLIMATE"] == nil ? NO : [[scheduler get] valueForKey: @"sched:enabled:CLIMATE"];
    
    // No schedule or upcoming events for this device
    if (scheduler == nil || commands == nil || nextFireSchedule == nil || [nextFireSchedule isEqual:[NSNull null]] || commands.count == 0 || !scheduleEnabled) {
        return nil;
    }
    
    NSString *nextEvent = [[scheduler get] valueForKey:[@"sched:nextFireCommand:" stringByAppendingString:nextFireSchedule]];
    NSDictionary *nextCommand = [[SchedulerCapability getCommandsFromModel:scheduler] valueForKey:nextEvent];
    
    if (nextCommand == nil) {
        return nil;
    }

    NSNumber* nextEventTimestamp = [[scheduler get] valueForKey:[@"sched:nextFireTime:" stringByAppendingString:nextFireSchedule]];
    
    if (nextEventTimestamp == nil) {
        return nil;
    }
    
    ArcusDateTime *nextEventTime = [[ArcusDateTime alloc] initWithArcusTimestamp: [nextEventTimestamp doubleValue]];
    NSString *nextEventTimeString = [[nextEventTime.date formatBasedOnDayOfWeekAndHours] uppercaseString];    
    NSDictionary *nextCommandAttributes = [nextCommand valueForKey:@"attributes"];
    NSNumber *setpoint = [nextCommandAttributes valueForKey:kAttrSpaceHeaterSetpoint];
    NSString *heatState = [nextCommandAttributes valueForKey:kAttrSpaceHeaterHeatstate];
    NSString *newlinePrefix = @"";
    
    if (setpoint == nil) {
        return nil;
    }
    
    int setpointDisplay = [DeviceController celsiusToFahrenheit:[setpoint doubleValue]];
    if (nextEventTime.currentTimeType == DateTimeSunrise || nextEventTime.currentTimeType == DateTimeSunset) {
        NSString *sunsetOrSunrise = nextEventTime.currentTimeType == DateTimeSunrise ? NSLocalizedString(@"SUNRISE", nil) : NSLocalizedString(@"SUNSET", nil);
        NSString *beforeOrAfter = [nextEventTime offsetMinutes] > 0 ? NSLocalizedString(@"MINS AFTER", nil) : NSLocalizedString(@"MINS BEFORE", nil);
        nextEventTimeString = [NSString stringWithFormat:@"%@ %d %@ %@", [[nextEventTime.date getShortWeekDay] uppercaseString], abs([nextEventTime offsetMinutes]), beforeOrAfter, sunsetOrSunrise];
        newlinePrefix = @"\n";
    }

    if ([heatState isEqualToString:kEnumSpaceHeaterHeatstateOFF]) {
        return [NSString stringWithFormat:@"%@ %@ %@", newlinePrefix, nextEventTimeString, heatState];
    } else {
        return [NSString stringWithFormat:@"%@ %d° %@ %@", newlinePrefix, setpointDisplay, nextEventTimeString, heatState];
    }
    
    return nil;
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if ([attributes.allKeys containsObject:kAttrSpaceHeaterHeatstate]) {
        NSString* heatState = [SpaceHeaterCapability getHeatstateFromModel:self.deviceModel];
        [self setDisplayedHeatState:[heatState isEqualToString:kEnumSpaceHeaterHeatstateON]];
    }
    
    if ([attributes.allKeys containsObject:kAttrTwinStarEcomode]) {
        NSString* ecoMode = [TwinStarCapability getEcomodeFromModel:self.deviceModel];
        [self setDisplayedEcoMode:[ecoMode isEqualToString:kEnumTwinStarEcomodeENABLED]];
    }
    
    if ([attributes.allKeys containsObject:kAttrSpaceHeaterSetpoint]) {
        NSInteger setpoint = [DeviceController getSpaceHeaterSetpointForModel:self.deviceModel];
        [self setDisplayedSetpoint:setpoint];
        
        // Re-enable value +/- buttons as a result of receiving a base:ValueChange
        [self setValueAdjusterEnabled:YES];
    }
    
    if ([attributes.allKeys containsObject:kAttrTemperatureTemperature]) {
        NSInteger temperature = [DeviceController getTemperatureForModel:self.deviceModel];
        [self setDisplayedTemperature:temperature];
    }
    
    if ([attributes.allKeys containsObject:kAttrDeviceAdvancedErrors]) {
        if (![self.deviceModel isDeviceOffline]) {
            [self updateErrorBanner];
        }
    }

    [self setDisplayedNextEvent:[self nextEventString]];
}

@end
