//
//  ThermostatOperationViewControllerOld.m
//  i2app
//
//  Created by Arcus Team on 6/6/15.
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
#import "ThermostatOperationViewControllerOld.h"
#import <PureLayout/PureLayout.h>
#import "UIImage+ScaleSize.h"
#import "DeviceDetailsTabBarController.h"
#import "DeviceControlViewController.h"
#import "UIImage+ImageEffects.h"
#import "ThermostatCapability.h"
#import "PopupSelectionButtonsView.h"
#import "DeviceController.h"
#import "NSDate+Convert.h"
#import "DeviceDetailsThermostatDelegate.h"
#import "HoneywellC2CCredentialsRemovedDelegate.h"
#import "HoneywellTCCCapability.h"
#import "ErrorSheetController.h"
#import "DeviceDetailsBase.h"
#import "UIViewController+AlertBar.h"
#import "UIView+Subviews.h"
#import "NSTimer+Block.h"
#import "ClimateSubSystemController.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )
#define radians(degrees) (degrees * M_PI/180)

const float kThermostatAnimationDuration = 0.3f;
const float kHoneywellThermostatDebounceDuration = 3;
const float kHoneywellThermostatEventTimer = 120;

#pragma mark - ThermostatHandleModel

@interface ThermostatHandleModel : NSObject

@property (nonatomic) int coolTemp;
@property (nonatomic) int heatTemp;

- (BOOL)moveCoolTemp:(int)temp;
- (BOOL)moveHeatTemp:(int)temp;

@end


@implementation ThermostatHandleModel

const int kTempStep = 1;

- (BOOL)isOutOfBoundTemperature:(int)temp {
    return (temp < kThermostatMinTemperature) || (temp > kThermostatMaxTemperature) ;
}

- (BOOL)moveCoolTemp:(int)temp {
    // DDLogWarn(@"@@@@@@@ current coolTemp = %d", (int)self.coolTemp);
    if ((temp < kThermostatMinTemperature + kThermostatDefaultTempDifference) || (temp > kThermostatMaxTemperature) || (temp < self.heatTemp)) {
        return NO;
    }

    self.coolTemp = temp;
    if (self.heatTemp + kThermostatDefaultTempDifference > temp) {
        [self moveHeatTemp:self.heatTemp - kTempStep];
    }
    // DDLogWarn(@"@@@@@@@ set coolTemp = %d", self.coolTemp);

    return YES;
}

- (BOOL)moveHeatTemp:(int)temp {
    // DDLogWarn(@"@@@@@@@ current heatTemp = %d", (int)self.heatTemp);

    if ((temp < kThermostatMinTemperature) || (temp > kThermostatMaxTemperature - kThermostatDefaultTempDifference) || temp > self.coolTemp) {
        return NO;
    }
    self.heatTemp = temp;
    if (self.coolTemp < kThermostatDefaultTempDifference + temp) {
        [self moveCoolTemp:self.coolTemp + kTempStep];
    }
    // DDLogWarn(@"@@@@@@@ set heatTemp = %d", self.heatTemp);

    return YES;
}

@end


#pragma mark - ThermostatOperationViewController
@interface ThermostatOperationViewControllerOld ()

@property (weak, nonatomic) IBOutlet UIButton *eventCloseButton;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *modeButton;

@property (weak, nonatomic) IBOutlet UIView *centerArea;
@property (weak, nonatomic) IBOutlet UIView *thermostaControlArea;

@property (weak, nonatomic) IBOutlet UILabel *thermostaNumber;
@property (weak, nonatomic) IBOutlet UIImageView *thermostaRing;
@property (weak, nonatomic) IBOutlet UILabel *currentlyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *coolIcon;
@property (weak, nonatomic) IBOutlet UIImageView *heatIcon;

@property (weak, nonatomic) IBOutlet UIButton *coolButton;
@property (weak, nonatomic) IBOutlet UIButton *heatButton;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (strong, nonatomic) NSTimer *debounceTimer;
@property (strong, nonatomic) NSTimer *waitEventTimer;


- (IBAction)reduceTemperaturePressed:(id)sender;
- (IBAction)increaseTemperaturePressed:(id)sender;
- (IBAction)modeButtonPressed:(id)sender;

@end


@implementation ThermostatOperationViewControllerOld {
    ThermostatHandleModel *_thermoHandlesModel;

    UIImage             *_logoImage;
    NSLayoutConstraint  *_coolIconPosition;
    NSLayoutConstraint  *_heatIconPosition;
    NSLayoutConstraint  *_evenLabelPosition;
    __weak IBOutlet NSLayoutConstraint *_centerLogoConstraint;

    __weak IBOutlet NSLayoutConstraint *modeHighConstraint;
    IBOutletCollection(NSLayoutConstraint) NSArray *tagHighConstaints;

    NSInteger             _heatTemp;
    NSInteger             _coolTemp;

    BOOL                _settingHeat;
    ThermostatModeType  _modeType;

    NSAttributedString *_originalEventMessage;

    UIImage *_unselectPointerImage;
    UIImage *_selectPointerImage;

    CGPoint _pointorLication;
    CGFloat _coolAngle;
    CGFloat _heatAngle;

    BOOL    _updatedUsingButtons;

    PopupSelectionWindow *_popupWindow;

    BOOL    _displayLoginError;

    BOOL    _wasInitial; // Value Change Event comes in twice from the beginning. Need to ignore both of these.
}

NSTimeInterval _controlUpdateStartTime = -1;
const int kSecBetweenUpdates = 1;
const int kSecWaitToUpdate = 2;

BOOL isWaiting = false;

#pragma mark - life cycle
- (void)viewDidLoad {
    //This is a hack to prevent display logo image in thermostat
    self.deviceLogo.image = [[UIImage alloc] init];
    _thermoHandlesModel = [[ThermostatHandleModel alloc] init];

    [super viewDidLoad];
    // set positions
    _coolIconPosition = [self.coolIcon autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _heatIconPosition = [self.heatIcon autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _evenLabelPosition = [self.eventLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.view layoutIfNeeded];

    if (IS_IPHONE_5) {
        [_centerLogoConstraint setConstant: -50];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6P) {
        [_centerLogoConstraint setConstant: -60];
    }

    // Auto Ring
    self.thermostaControlArea.alpha = .0f;

    // init setting
    _settingHeat = NO;

    self.coolIcon.alpha = .0f;
    self.heatIcon.alpha = .0f;
    self.eventCloseButton.alpha = .0f;
    self.eventCloseButton.hidden = YES;

    _unselectPointerImage = [UIImage imageNamed:@"ThermostatHandUnselectedIcon"];
    _selectPointerImage = [UIImage imageNamed:@"ThermostatHandSelectedIcon"];

    if (IS_IPHONE_5) {
        modeHighConstraint.constant /= 3;
        for (NSLayoutConstraint *item in tagHighConstaints) {
            item.constant /= 2;
        }
    }

    // runningWaveImage
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ThermostatWavesanim" ofType:@"gif"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];


    // Set buttons
    UIImage *unselectedButtonIcon = [UIImage imageNamed:@"ThermostatHandUnselectedIcon"];
    UIImage *selectedButtonIcon = [UIImage imageNamed:@"ThermostatHandSelectedIcon"];

    self.coolButton.tag = 1;
    [self.coolButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:15]];
    [self.coolButton setBackgroundImage:[UIImage imageWithCGImage: [unselectedButtonIcon imageRotatedByDegrees:45]] forState:UIControlStateNormal];
    [self.coolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.coolButton setBackgroundImage:[UIImage imageWithCGImage: [selectedButtonIcon imageRotatedByDegrees:45]] forState:UIControlStateSelected];
    [self.coolButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f] forState:UIControlStateSelected];
    self.coolButton.selected = !_settingHeat;
    [self.coolButton addTarget:self action:@selector(onClickCoolButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.coolButton setTitle:[NSString stringWithFormat:@"%d", (int)_coolTemp] forState:UIControlStateNormal];
    [self.coolButton setTitle:[NSString stringWithFormat:@"%d", (int)_coolTemp] forState:UIControlStateSelected];

    self.heatButton.tag = 2;
    [self.heatButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:15]];
    [self.heatButton setBackgroundImage:[UIImage imageWithCGImage: [unselectedButtonIcon imageRotatedByDegrees:-45]] forState:UIControlStateNormal];
    [self.heatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.heatButton setBackgroundImage:[UIImage imageWithCGImage: [selectedButtonIcon imageRotatedByDegrees:-45]] forState:UIControlStateSelected];
    [self.heatButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f] forState:UIControlStateSelected];
    self.heatButton.selected = _settingHeat;
    [self.heatButton addTarget:self action:@selector(onClickHeatButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.heatButton setTitle:[NSString stringWithFormat:@"%d", (int)_heatTemp] forState:UIControlStateNormal];
    [self.heatButton setTitle:[NSString stringWithFormat:@"%d", (int)_heatTemp] forState:UIControlStateSelected];

    UIPanGestureRecognizer *coolButtonRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PointerButtonDragged:)];
    coolButtonRecognizer.cancelsTouchesInView = YES;
    [self.coolButton addGestureRecognizer:coolButtonRecognizer];
    UIPanGestureRecognizer *heatButtonRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PointerButtonDragged:)];
    heatButtonRecognizer.cancelsTouchesInView = YES;
    [self.heatButton addGestureRecognizer:heatButtonRecognizer];

    [self.modelLabel styleSet:NSLocalizedString(@"Desired", nil) andFontData:[FontData createFontData:FontTypeDemiBold size:11 blackColor:NO space:YES alpha:YES ] upperCase:YES];

    [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_coolTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];

    [self.thermostaNumber setAttributedText:[FontData getString:@"" withFont:FontDataTypeDeviceCenterTemperatureNumber]];
    [self.currentlyLabel styleSet:NSLocalizedString(@"currently", nil) andFontData:[FontData createFontData:FontTypeDemiBold size:11 blackColor:NO space:YES alpha:YES ]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    _controlUpdateStartTime = -1;

    if (_debounceTimer) {
        [self sendTemperatureUpdate:(int)_coolTemp heatPoint:(int)_heatTemp];
        [self stopDebounceTimer];
    }
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:animated];

    isWaiting = NO;

    // Check if we should disable the screen or not for pending events
    // if honeywell
    if ([self.deviceModel isC2CDevice]) {
        [self disableThermostat];

        // Clear old events and start timer
        NSTimeInterval duration = [self.deviceModel clearStaleEventsAndReturnLongestDuration:kHoneywellThermostatEventTimer];

        if (duration > 0) {
            NSTimeInterval delay = 0.5;
            // Delay execution of my block while the UI has a chance to update first.
            // Not ideal but need a callback after the screen has loaded and device has loaded into the screen.
            // TODO Clean up device event notifications
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self startTimerWithDuration:duration - delay];
            });
        } else {
            [self enableThermostat];
        }

    }
}

- (void)centerMode {
    [super centerMode];

    [self.deviceLogo setImage:nil];
}

- (void)edgeMode:(SEL)onClick {
    [super edgeMode:onClick];

    self.deviceLogo.layer.borderWidth = 5.0f;
    self.deviceLogo.image = nil;
}

#pragma mark - mode choosing
- (IBAction)modeButtonPressed:(id)sender {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Choose A Mode", nil) button:
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"COOL", nil) event:@selector(thermostatCoolMode)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"HEAT", nil) event:@selector(thermostatHeatMode)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"AUTO", nil) event:@selector(thermostatAutoMode)],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"OFF", nil) event:@selector(thermostatOffMode)], nil];
    buttonView.owner = self;
    [self popup:buttonView];
}

- (void)thermostatHeatMode {
    [self displaythermostatHeatMode];

    [self commitThermostatMode:kEnumThermostatHvacmodeHEAT];
}

- (void)displaythermostatHeatMode {
    _settingHeat = YES;
    _modeType = ThermostatHeatMode;

    self.modeButton.titleLabel.text = [NSLocalizedString(@"heat", nil) uppercaseString];
    [self.modelLabel styleSet:@"HEAT" andFontData:[FontData createFontData:FontTypeDemiBold size:11 blackColor:NO space:YES alpha:YES] upperCase:YES];
    [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_heatTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];

    [self displayThermostatRunningImage];

    [UIView animateWithDuration:kThermostatAnimationDuration animations:^{
        self.coolIcon.alpha = .0f;
        self.heatIcon.alpha = 1.0f;
        _heatIconPosition.constant = 0;

        self.thermostaControlArea.alpha = 0.0f;
        self.deviceLogo.layer.borderWidth = 5.0f;

        self.minusButton.hidden = NO;
        self.plusButton.hidden = NO;

        self.eventLabel.hidden = NO;

        [self.view layoutIfNeeded];
    }];
}

- (void)thermostatCoolMode {
    [self displayThermostatCoolMode];

    [self commitThermostatMode:kEnumThermostatHvacmodeCOOL];
}

- (void)displayThermostatCoolMode {
    _settingHeat = NO;
    _modeType = ThermostatCoolMode;

    self.modeButton.titleLabel.text = [NSLocalizedString(@"cool", nil) uppercaseString];
    [self.modelLabel styleSet:@"COOL" andFontData:[FontData createFontData:FontTypeDemiBold size:11 blackColor:NO space:YES alpha:YES] upperCase:YES];
    [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_coolTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];

    [self displayThermostatRunningImage];

    [UIView animateWithDuration:kThermostatAnimationDuration animations:^{
        self.coolIcon.alpha = 1.0f;
        self.heatIcon.alpha = 0.0f;
        _coolIconPosition.constant = 0;

        self.thermostaControlArea.alpha = 0.0f;
        self.deviceLogo.layer.borderWidth = 5.0f;

        self.minusButton.hidden = NO;
        self.plusButton.hidden = NO;

        self.eventLabel.hidden = NO;

        [self.view layoutIfNeeded];
    }];
}

- (void)thermostatAutoMode {
    // Honeywell Thermostats do not have access to Auto if therm:supportsAuto is false
    if ([self.deviceModel isC2CDevice] && ![ThermostatCapability getSupportsAutoFromModel:self.deviceModel]) {
        [self displayAutoModeAlert];
        return;
    }

    [self displayThermostatAutoMode];

    [self commitThermostatMode:kEnumThermostatHvacmodeAUTO];
}

- (void)displayThermostatAutoMode {
    _modeType = ThermostatAutoMode;

    self.modeButton.titleLabel.text = [NSLocalizedString(@"auto", nil) uppercaseString];
    [self.modelLabel styleSet:@"AUTO" andFontData:[FontData createFontData:FontTypeDemiBold size:11 blackColor:NO space:YES alpha:YES] upperCase:YES];
    [self onClickHeatButton:self.heatButton];

    [self displayThermostatRunningImage];

    if ((_coolTemp != _thermoHandlesModel.coolTemp) || ( _heatTemp != _thermoHandlesModel.heatTemp)) {
        _thermoHandlesModel.coolTemp = (_coolTemp == NSNotFound) ? 75 : (int)_coolTemp;
        _thermoHandlesModel.heatTemp = (_heatTemp == NSNotFound) ? 65 : (int)_heatTemp;
    }

    [self displayThermoHandlesWithModel];

    [UIView animateWithDuration:kThermostatAnimationDuration animations:^{
        self.coolIcon.alpha = 1.0f;
        self.heatIcon.alpha = 1.0f;
        _coolIconPosition.constant = 15;
        _heatIconPosition.constant = -15;

        self.thermostaControlArea.alpha = 1.0f;
        self.deviceLogo.layer.borderWidth = 0.0f;

        self.minusButton.hidden = NO;
        self.plusButton.hidden = NO;

        self.eventLabel.hidden = NO;

        [self.view layoutIfNeeded];
    }];
}

- (void)thermostatOffMode {
    [self displayThermostatOffMode];

    [self commitThermostatMode:kEnumThermostatHvacmodeOFF];
}

- (void)displayThermostatOffMode {
    _modeType = ThermostatOffMode;

    self.modeButton.titleLabel.text = [NSLocalizedString(@"off", nil) uppercaseString];
    [self.modelLabel styleSet:@"OFF" andFontData:[FontData createFontData:FontTypeDemiBold size:11 blackColor:NO space:YES alpha:YES] upperCase:YES];
    [self.settingValueLabel setAttributedText:[FontData getString:@"--" andString2:@"" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];

    [self displayThermostatRunningImage];

    [UIView animateWithDuration:kThermostatAnimationDuration animations:^{
        self.coolIcon.alpha = .0f;
        self.heatIcon.alpha = .0f;
        self.minusButton.hidden = YES;
        self.plusButton.hidden = YES;

        _coolIconPosition.constant = 0;
        _heatIconPosition.constant = 0;
        [self.view layoutIfNeeded];

        self.thermostaControlArea.alpha = 0.0f;
        self.deviceLogo.layer.borderWidth = 5.0f;

        self.eventLabel.hidden = YES;

        [self.modelLabel styleSet:@"OFF" andFontData:[FontData createFontData:FontTypeDemiBold size:11 blackColor:NO space:YES alpha:YES] upperCase:YES];
    }];
}

- (void)commitThermostatMode:(NSString *)mode {

    [self startDebounceTimer:0.0 event:^{
        if ([self.deviceModel isC2CDevice]) {
            // Add event for the device model's attribute
            [self.deviceModel addNewEventForAttribute:kAttrThermostatHvacmode];

            // Start Timer for 2 Minutes
            [self startTimerWithDuration:kHoneywellThermostatEventTimer];
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [ThermostatCapability setHvacmode:mode onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }];
}

- (void)displayThermostatRunningImage {

}

#pragma mark - Adjust temperature methods
- (void)onClickCoolButton:(id)sender {
    _settingHeat = NO;
    self.coolButton.selected = YES;
    self.heatButton.selected = NO;

    [self.coolButton setTitle:[NSString stringWithFormat:@"%d", (int)_coolTemp] forState:UIControlStateNormal];
    [self.coolButton setTitle:[NSString stringWithFormat:@"%d", (int)_coolTemp] forState:UIControlStateSelected];
    [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_coolTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];
}

- (void)onClickHeatButton:(id)sender {
    _settingHeat = YES;
    self.coolButton.selected = NO;
    self.heatButton.selected = YES;

    [self.heatButton setTitle:[NSString stringWithFormat:@"%d", (int)_heatTemp] forState:UIControlStateNormal];
    [self.heatButton setTitle:[NSString stringWithFormat:@"%d", (int)_heatTemp] forState:UIControlStateSelected];
    [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_heatTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];
}

- (void)commitSetCoolTemp:(int)temp {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DeviceController setThermostatCoolSetPoint:temp onModel:self.deviceModel];
    });
}

- (void)commitSetHeatTemp:(int)temp {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DeviceController setThermostatHeatSetPoint:temp onModel:self.deviceModel];
    });
}

- (void)commitSetPoints:(int)coolTemp heatPoint:(int)heatTemp {
    NSTimeInterval duration = kSecBetweenUpdates;

    if ([self.deviceModel isC2CDevice]) {
        duration = kHoneywellThermostatDebounceDuration;
    }

    [self startDebounceTimer:duration event:^{
        [self sendTemperatureUpdate:coolTemp heatPoint:heatTemp];
    }];
}

- (void)sendTemperatureUpdate:(int)coolTemp heatPoint:(int)heatTemp {
    if ([self.deviceModel isC2CDevice]) {
        // Add event for the device model's attribute
        [self.deviceModel addNewEventForAttribute:kAttrThermostatCoolsetpoint];
        [self.deviceModel addNewEventForAttribute:kAttrThermostatHeatsetpoint];

        // Start Timer for 2 Minutes
        [self startTimerWithDuration:kHoneywellThermostatEventTimer];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DeviceController setThermostatSetPoints:coolTemp heatPoint:heatTemp onModel:self.deviceModel];
        _controlUpdateStartTime = [[NSDate date] timeIntervalSince1970];
    });
}

- (void)displayCoolButtonForTemp:(int)coolTemp {

    [self.coolButton setTitle:[NSString stringWithFormat:@"%d", coolTemp] forState:UIControlStateNormal];
    [self.coolButton setTitle:[NSString stringWithFormat:@"%d", coolTemp] forState:UIControlStateSelected];

    int angle = (coolTemp - 45) * 6 + 30;

    CGPoint _point = [self getPointFromAngle:(int)angle];
    [self.coolButton setCenter:_point];

    [self.coolButton setBackgroundImage:[UIImage imageWithCGImage: [_selectPointerImage imageRotatedByDegrees:(angle - 90) * -1 + 90]] forState:UIControlStateSelected];
    [self.coolButton setBackgroundImage:[UIImage imageWithCGImage: [_unselectPointerImage imageRotatedByDegrees:(angle - 90) * -1 + 90]] forState:UIControlStateNormal];
}

- (void)displayHeatButtonForTemp:(int)heatTemp {

    [self.heatButton setTitle:[NSString stringWithFormat:@"%d", heatTemp] forState:UIControlStateNormal];
    [self.heatButton setTitle:[NSString stringWithFormat:@"%d", heatTemp] forState:UIControlStateSelected];

    int angle = (heatTemp - 45) * 6 + 30;

    CGPoint _point = [self getPointFromAngle:(int)angle];
    [self.heatButton setCenter:_point];

    [self.heatButton setBackgroundImage:[UIImage imageWithCGImage: [_selectPointerImage imageRotatedByDegrees:(angle - 90) * - 1 + 90]] forState:UIControlStateSelected];
    [self.heatButton setBackgroundImage:[UIImage imageWithCGImage: [_unselectPointerImage imageRotatedByDegrees:(angle - 90) * -1 + 90]] forState:UIControlStateNormal];
}

- (IBAction)reduceTemperaturePressed:(id)sender {
    if (_modeType == ThermostatOffMode) {
        return;
    }

    _updatedUsingButtons = YES;

    if (_settingHeat) {
        [self moveHeatTemp:(int)_heatTemp - kTempStep];
        [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_heatTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];
    }
    else {
        [self moveCoolTemp:(int)_coolTemp - kTempStep];
        [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_coolTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];
    }

    [self commitSetPoints:(int)_coolTemp heatPoint:(int)_heatTemp];
}

- (IBAction)increaseTemperaturePressed:(id)sender {
    if (_modeType == ThermostatOffMode) {
        return;
    }

    _updatedUsingButtons = YES;

    if (_settingHeat) {
        [self moveHeatTemp:(int)_heatTemp + kTempStep];
        [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_heatTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];
    }
    else {
        [self moveCoolTemp:(int)_coolTemp + kTempStep];
        [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)_coolTemp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];
    }

    [self commitSetPoints:(int)_coolTemp heatPoint:(int)_heatTemp];

}

- (BOOL)moveCoolTemp:(int)temp {
    // DDLogWarn(@"@@@@@@@ current coolTemp = %d", (int)_coolTemp);

    if ((temp < kThermostatMinTemperature + kThermostatDefaultTempDifference) || (temp > kThermostatMaxTemperature) || (temp < _heatTemp) ) {
        return NO;
    }

    _coolTemp = temp;
    if (_heatTemp + kThermostatDefaultTempDifference > temp) {
        [self moveHeatTemp:(int)_heatTemp - kTempStep];
    }
    // DDLogWarn(@"@@@@@@@ set coolTemp = %d", _coolTemp);
    [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d",temp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];

    return YES;
}

- (BOOL)moveHeatTemp:(int)temp {
    // DDLogWarn(@"@@@@@@@ current heatTemp = %d", (int)_heatTemp);

    if ((temp < kThermostatMinTemperature) || (temp > kThermostatMaxTemperature - kThermostatDefaultTempDifference) || temp > _coolTemp) {
        return NO;
    }
    _heatTemp = temp;
    if (_coolTemp < kThermostatDefaultTempDifference + temp) {
        [self moveCoolTemp:(int)_coolTemp + kTempStep];
    }
    // DDLogWarn(@"@@@@@@@ set heatTemp = %d", _heatTemp);
    [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d",temp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];

    return YES;
}

- (void)PointerButtonDragged:(UIPanGestureRecognizer *)recognizer {
    _updatedUsingButtons = NO;
    UIButton *button = (UIButton *)recognizer.view;
    CGPoint translation = [recognizer translationInView:button];

    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled ||
        recognizer.state == UIGestureRecognizerStateFailed ||
        recognizer.state == UIGestureRecognizerStateChanged) {

        CGPoint lastPoint = CGPointMake(_pointorLication.x + translation.x, _pointorLication.y + translation.y);
        CGPoint centerPoint = self.thermostaControlArea.bounds.origin;
        centerPoint.x += self.thermostaControlArea.bounds.size.width / 2;
        centerPoint.y += self.thermostaControlArea.bounds.size.height / 2;

        float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
        int temp = (int)(currentAngle - 30) / 6 + 45;

        if (button.tag == 1) {
            [_thermoHandlesModel moveCoolTemp:temp];
        }
        else {
            [_thermoHandlesModel moveHeatTemp:temp];
        }

        [self.settingValueLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d",temp] andString2:@" o" withCombineFont:FontDataCombineTypeDeviceNumberSignCombine]];

        [self displayThermoHandlesWithModel];

        if (recognizer.state == UIGestureRecognizerStateEnded) {
            [self commitSetPoints:_thermoHandlesModel.coolTemp heatPoint:_thermoHandlesModel.heatTemp];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.coolButton.selected = NO;
        self.heatButton.selected = NO;
        button.selected = YES;

        _settingHeat = button.tag == 2;

        _pointorLication = button.center;
    }
}

- (CGPoint)getPointFromAngle:(int)angleInt {
    //Circle center
    CGPoint centerPoint = CGPointMake(self.thermostaControlArea.frame.size.width / 2 - 20, self.thermostaControlArea.frame.size.height / 2 - 10);

    //The point position on the circumference
    CGPoint result;
    int radius = self.thermostaControlArea.frame.size.width / 2 - 25;

    result.y = round(centerPoint.y + radius * cos(ToRad(-angleInt))) + 15;
    result.x = round(centerPoint.x + radius * sin(ToRad(-angleInt))) + 20;

    return result;
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x - p1.x, p2.y - p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y, v.x);
    result = ToDeg(radians);
    float angle = (result >= 0  ? result : result + 360.0);
    return angle > 90 ? angle - 90 : 270 + angle;
}


#pragma mark - Top event methods

- (IBAction)onClickEventClose:(id)sender {
    [UIView animateWithDuration:kThermostatAnimationDuration animations:^{
        [self.eventLabel setAttributedText:_originalEventMessage];
        _evenLabelPosition.constant = 0;
        self.eventCloseButton.alpha = .0f;
    }];
}

- (void)displayThermostatWithMode:(NSString *)mode {
    if ([mode isEqualToString:kEnumThermostatHvacmodeOFF]) {
        [self displayThermostatOffMode];
    }
    else if ([mode isEqualToString:kEnumThermostatHvacmodeAUTO]) {
        [self displayThermostatAutoMode];
    }
    else if ([mode isEqualToString:kEnumThermostatHvacmodeCOOL]) {
        [self displayThermostatCoolMode];
    }
    else if ([mode isEqualToString:kEnumThermostatHvacmodeHEAT]) {
        [self displaythermostatHeatMode];
    }
}

- (void)displayThermoHandlesWithModel {
    [self displayCoolButtonForTemp:_thermoHandlesModel.coolTemp];
    [self displayHeatButtonForTemp:_thermoHandlesModel.heatTemp];
}

#pragma mark Thermostat Button Management

- (void)disableThermostat {
    self.heatButton.enabled = NO;
    self.coolButton.enabled = NO;
    self.modeButton.enabled = NO;
    self.plusButton.enabled = NO;
    self.minusButton.enabled = NO;
}

- (void)enableThermostat {
    self.heatButton.enabled = YES;
    self.coolButton.enabled = YES;
    self.modeButton.enabled = YES;
    self.plusButton.enabled = YES;
    self.minusButton.enabled = YES;
}

#pragma mark Honeywell Device Handling

- (BOOL)isHoneywellC2CDevice {
    return [self.deviceModel.caps containsObject:[HoneywellTCCCapability namespace]];
}


- (void)disableForLogin {
    [self disableThermostat];
    [self displayLoginAlert];
    [self setFooterToPink:YES];
}

- (void)displayLoginAlert {
    [self popupLinkAlert:NSLocalizedString(@"Honeywell login information needs attention", nil)
                    type:AlertBarTypeClickableWarning
               sceneType:AlertBarSceneInDevice
               grayScale:YES
                linkText:nil
                selector:@selector(showLogin)
            displayArrow:YES];
}

- (void)showLogin {
    [self closeAlert];

    HoneywellC2CCredentialsRemovedDelegate *delegate = [HoneywellC2CCredentialsRemovedDelegate new];
    delegate.goToViewController = self;
    SimpleTableViewController *vc = [SimpleTableViewController createWithDelegate:delegate];
    [((UIViewController *)self.deviceController.tabBarController).navigationController pushViewController:vc animated:YES];
}

- (void)disableLoginError {
    [self displayLoginErrorAlert];
    [self setFooterToPink:YES];
}

- (void)displayLoginErrorAlert {
    [super popupAlert:NSLocalizedString(@"Your login information was not updated.", nil)
                 type:AlertBarTypeClickableWarning
            sceneType:AlertBarSceneInDevice
         bottomButton:NSLocalizedString(@"1-0", nil)
            grayScale:YES
             selector:@selector(callSupport)];
}

- (void)disableUnavailableError {
    [self disableThermostat];
    [self displayUnavailableAlert];
    [self setFooterToPink:YES];
}

- (void)displayUnavailableAlert {
    [super popupAlert:NSLocalizedString(@"The Honeywell service is currently unavailable.\nPlease try again later or call the Honeywell\nsupport team.", nil)
                 type:AlertBarTypeClickableWarning
            sceneType:AlertBarSceneInDevice
         bottomButton:NSLocalizedString(@"1-0", nil)
            grayScale:YES
             selector:@selector(callSupport)];
}

- (void)disableBecauseRevoked {
    [self disableThermostat];
    [self displayRevokedAlert];
    [self setFooterToPink:YES];
}

- (void)displayRevokedAlert {
    [self popupLinkAlert:NSLocalizedString(@"Honeywell account information revoked.", nil)
                    type:AlertBarTypeClickableWarning
               sceneType:AlertBarSceneInDevice
               grayScale:YES
                linkText:nil
                selector:@selector(showRevoked)
            displayArrow:YES];
}

- (void)showRevoked {

    // Show New View Controller
    ErrorSheetModel *errorModel = [[ErrorSheetModel alloc] init];
    [errorModel setEventOwner:self];
    [errorModel setPopupController:self.deviceController.tabBarController];
    [errorModel setOnClickBottom:@selector(onClickErrorBotton)];
    [errorModel setIcon:[UIImage imageNamed:@"icon_c2c_frame_cloud"]];
    [errorModel setButtonText:@"Return to dashboard"];
    [errorModel setBackgoundTopColor:pinkAlertColor];
    [errorModel setBackgoundBottomColor:[UIColor colorWithRed:157.0f/255.0f green:40.0f/255.0f blue:112.0f/255.0f alpha:1.0f]];

    [errorModel setFirstText:[[FontData createFontData:FontTypeDemiBold size:14 blackColor:NO space:YES] getFontAttributed:[@"Honeywell Credential Revoked" uppercaseString]]];
    [errorModel setSecondText:[[FontData createFontData:FontTypeMedium size:13 blackColor:NO space:NO] getFontAttributed:@"Honeywell Credential Revoked First"]];
    [errorModel setThirdText:[[FontData createFontData:FontTypeMedium size:13 blackColor:NO space:NO] getFontAttributed:@"Honeywell Credential Revoked Second"]];

    [ErrorSheetController popup:errorModel];
}

- (void)onClickErrorBotton {
    [self.deviceController.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)callSupport {
    // Callout
    NSString *phNo = NSLocalizedString(@"+18772718620", nil);
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];

    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

- (void)disableWaiting {
    if (!isWaiting) {
        [self disableThermostat];
        [self displayWaitingAlert];
        [self setFooterSideText:@"Waiting on "];
        isWaiting = YES;
    }
}

- (void)displayWaitingAlert {
    [self popupLinkAlert:NSLocalizedString(@"Just a moment...", nil)
                    type:AlertBarTypeWaiting
               sceneType:AlertBarSceneInDevice
               grayScale:YES
                linkText:nil
                selector:nil
            displayArrow:NO];
}

- (void)closeAlert {
    [self enableThermostat];
    [super closePopupAlert];
    [self setFooterToPink:NO];
    [self setFooterSideText:nil];

    if (isWaiting)
        isWaiting = NO;
}

- (void)displayAutoModeAlert {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"AUTO MODE", nil)
                                                                              subtitle:NSLocalizedString(@"To use Auto mode on your thermostat, Honeywell requires you to first enable the Auto mode setting on the device. Check the Honeywell owner's manual for details.", nil)
                                                                                button:nil, nil];
    buttonView.owner = self;

    _popupWindow = [PopupSelectionWindow popup:self.deviceController.view
                                       subview:buttonView
                                         owner:self
                                 closeSelector:@selector(closeAutoAlert:)
                                         style:PopupWindowStyleCautionWindow];
}

- (void)closeAutoAlert:(id)obj {
    [_popupWindow closePopupAlert];
}

- (NSInteger)showNoConnectionAlertBar {
    [self disableThermostat];
    NSTimeInterval delay = 0.5;
    // Delay execution of my block while the UI has a chance to update first.
    // Not ideal but need a callback after the screen has loaded and device has loaded into the screen.
    // TODO Clean up device event notifications
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [super showNoConnectionAlertBar];
    });

    return -1;
}

- (void)closePopupAlert {
    [self enableThermostat];
    [super closePopupAlert];
    [self setFooterToPink:NO];
}

- (void)checkDeviceIsOfflineOrUpdating {
    if ([self.deviceModel isC2CDevice]) {
        if (_displayLoginError) {
            [self disableUnavailableError];
        }
        else {
            if (!self.deviceModel.isAuthorizedC2CDevice) {
                [self disableBecauseRevoked];
            }
            else if ([HoneywellTCCCapability getRequiresLoginFromModel:self.deviceModel]) {
                [self disableForLogin];
            }
            else if ([self.deviceModel isDeviceOffline]) {
                [self disableUnavailableError];
            }
            else if (![self.deviceModel isDeviceOffline]) {
                [self closePopupAlert];
            }
        }
    }
    else {
        [super checkDeviceIsOfflineOrUpdating];
    }
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if (isInitial) {
        _wasInitial = YES;
        return;
    }

    // DDLogWarn(@"$$$$$$$$$$$ received update %@ \n %@", [NSDate date].description, attributes.description);
    if (_controlUpdateStartTime != -1 && _controlUpdateStartTime + kSecWaitToUpdate <= [[NSDate date] timeIntervalSinceNow]) {
        // Update every 2 seconds after updates were started
        // DDLogWarn(@"$$$$$$$$$$$ received update NOT USED");
        return;
    }
    _controlUpdateStartTime = -1;

    NSString *mode = ([ThermostatCapability getHvacmodeFromModel:self.deviceModel] == nil) ? kEnumThermostatHvacmodeAUTO : [ThermostatCapability getHvacmodeFromModel:self.deviceModel];
    [self.modelLabel styleSet:NSLocalizedString(mode, nil) andFontData:[FontData createFontData:FontTypeDemiBold size:11 blackColor:NO space:YES alpha:YES ] upperCase:YES];

    NSInteger currentTemp = [DeviceController getTemperatureForModel:self.deviceModel];
    if (currentTemp == NSNotFound ) {
        [self.thermostaNumber setAttributedText:[FontData getString:[NSString stringWithFormat:@"-"] withFont:FontDataTypeDeviceCenterTemperatureNumber]];
    }
    else {
        [self.thermostaNumber setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)currentTemp] withFont:FontDataTypeDeviceCenterTemperatureNumber]];
    }
    _coolTemp = [DeviceController getThermostatCoolSetPointForModel:self.deviceModel];
    _heatTemp = [DeviceController getThermostatHeatSetPointForModel:self.deviceModel];

    [self displayThermostatWithMode:mode];

    [(DeviceDetailsBase<DeviceDetailsThermostatDelegate> *)self.deviceOpDetails displayNextEvent:mode eventLabel:self.eventLabel eventCloseButton:self.eventCloseButton animationDuration:kThermostatAnimationDuration];

    // Honeywell Device Handling
    if ([self.deviceModel isC2CDevice]) {

        NSArray *keys = [attributes allKeys];

        BOOL containsHeatSetpoint = [keys containsObject:kAttrThermostatHeatsetpoint];
        BOOL containsCoolSetpoint = [keys containsObject:kAttrThermostatCoolsetpoint];
        BOOL containsHvacMode = [keys containsObject:kAttrThermostatHvacmode];

        // Initial checks are to get around being sent a value change from the get go when we're expecting to display
        // the waiting screen. Without it, we will remove it rather quickly as the device comes in.
        if ((containsCoolSetpoint || containsHeatSetpoint || containsHvacMode) && !isInitial && !_wasInitial) {
            [self.deviceModel clearStaleEventsWithDuration:kHoneywellThermostatEventTimer];
            [self.deviceModel removeEventForAttribute:kAttrThermostatHeatsetpoint];
            [self.deviceModel removeEventForAttribute:kAttrThermostatCoolsetpoint];
            [self.deviceModel removeEventForAttribute:kAttrThermostatHvacmode];

            // If we have no more events then stop the timer and clear screen
            if (![self.deviceModel hasEvents])
                [self stopTimer];

            // If we still have more events then keep waiting screen up longer
        }
    }

    _wasInitial = NO;

    [self.view setNeedsLayout];
}

- (void)refreshDeviceModel:(BOOL)success {
    if (success) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [self.deviceModel refresh].then(^ {
                if (![HoneywellTCCCapability getRequiresLoginFromModel:self.deviceModel]) {
                    _displayLoginError = NO;
                }
            });
        });
    }
    else {
        _displayLoginError = YES;
        [self disableUnavailableError];
    }
}

#pragma mark Device Event Timer

- (void)startDebounceTimer:(NSTimeInterval)duration event:(void (^)(void))block {
    [self stopDebounceTimer];


    _debounceTimer = [NSTimer arcus_scheduledTimerWithTimeInterval:duration repeats:NO block:^() {
      block();
      _debounceTimer = nil;
    }];
}

- (void)stopDebounceTimer {
    if (_debounceTimer != nil) {
        [_debounceTimer invalidate];
        _debounceTimer = nil;
    }
}

#pragma mark Honeywell Event Timer

- (void)startTimerWithDuration:(NSTimeInterval)duration  {
    // Stop the timer if it's active
    [self stopTimer];

    // Show waiting screen if not already shown
    [self disableWaiting];

    // Start the timer over
    _waitEventTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
}

/**
 * Explicitely stop the timer and remove the attribute that stopped it
 */
- (void)stopTimer {
    if (_waitEventTimer != nil) {
        [_waitEventTimer invalidate];
        _waitEventTimer = nil;
        [self closeAlert];
    }
}

/**
 * Timer fired without resolution
 */
- (void)timerFired:(NSTimer*)timer {
    _waitEventTimer = nil;
    [self closeAlert];
}

@end
