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
#import "LawnNGardenDeviceCell.h"
#import "DeviceButtonBaseControl.h"
#import "DeviceDetailsLawnNGardenDeviceController.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionNumberView.h"
#import "IrrigationControllerCapability.h"
#import "PopupSelectionIrrigationView.h"
#import "NSDate+Convert.h"
#import "PopupSelectionTimerView.h"
#import "LawnNGardenScheduleController.h"
#import "LawnNGardenScheduleModeSelectionDelegate.h"
#import "UIView+Animation.h"
#import "LawnNGardenDeviceCard.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import <i2app-Swift.h>

@interface LawnNGardenDeviceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *waterIcon;

@property (weak, nonatomic) IBOutlet UIView *nowContainer;
@property (weak, nonatomic) IBOutlet UILabel *nowZoneLabel;

@property (weak, nonatomic) IBOutlet UIView *nextContainer;
@property (weak, nonatomic) IBOutlet UILabel *nextZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTitleLabel;

@end

@implementation LawnNGardenDeviceCell {

}

+ (LawnNGardenDeviceCell *)createCell:(DeviceModel *)deviceModel owner:(UIViewController *)owner {
    NSArray *xibViews = [[NSBundle mainBundle] loadNibNamed:@"LawnNGardenDeviceCell" owner:self options:nil];
    LawnNGardenDeviceCell *cell = [xibViews objectAtIndex:0];
    cell.parentController = owner;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:cell selector:@selector(getDeviceStateChangedNotification:) name:[deviceModel modelChangedNotification] object:nil];
    return cell;
}

- (void)bindCard:(Card *)card {
    LawnNGardenDeviceCard *deviceCard = (LawnNGardenDeviceCard*)card;

    self.deviceModel = deviceCard.model;

    [self setTitle:self.deviceModel.name];
    [self loadDeviceImageFromPlatform];

    if (!self.deviceDataModel  || ![self.deviceDataModel isKindOfClass:[DeviceDetailsLawnNGardenDeviceController class]]) {
        DeviceDetailsLawnNGardenDeviceController *device = [[DeviceDetailsLawnNGardenDeviceController alloc] initWithDeviceId:self.deviceModel.modelId];
        [device loadData:self];
        self.deviceDataModel = device;
    }

    [self.deviceDataModel loadData];

    if ((self.leftButton && self.leftButton.button.imageView.image) || (self.rightButton && self.rightButton.button.imageView.image)) {
        self.titleSizeConstraint.constant = 140;
        self.subtitleSizeConstraint.constant = 150;
    }
    else {
        self.titleSizeConstraint.constant = 280;
        self.subtitleSizeConstraint.constant = 280;
    }
}

#pragma mark - Load Data
- (void)loadData {
    // Moved to bindCard
}

# pragma mark Button Pressed

- (IBAction)onClickBackgroup:(id)sender {
    [super onClickBackgroup:sender];
}

- (IBAction)onSchedulerPressed:(id)sender {
    LawnNGardenScheduleController *scheduler = [LawnNGardenScheduleController new];
    scheduler.schedulingModelAddress = self.deviceModel.address;

    SimpleTableViewController *vc = [SimpleTableViewController createWithDelegate:[[LawnNGardenScheduleModeSelectionDelegate alloc] initWithScheduler:scheduler]];
    [self.parentController.navigationController pushViewController:vc animated:YES];

}

# pragma mark Helping Functions

- (void)loadDeviceImageFromPlatform {
    if (self.centerIcon.image && ![self.centerIcon.image isEqual:[UIImage imageNamed:@"PlaceholderWhite"]]) {
        return;
    }

    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:self.deviceModel] withDevTypeId:[self.deviceModel devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {

        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground) {
            return;
        }

        [self.centerIcon setImage:image];
        [self.waterIcon setImage:image];
    });
}

- (void)rubberBandExpand:(UIView *)ringLogo {
    if (ringLogo.frame.size.width >= 190) {
        [ringLogo animateRubberBandExpand:nil circleBroad:5.0f alpha:.6f];
    }
    else {
        [ringLogo animateRubberBandExpand:nil circleBroad:2.0f alpha:1.0f];
    }
}

- (void)rubberBandContract:(UIView *)ringLogo {
    if (ringLogo.frame.size.width >= 190) {
        [ringLogo animateRubberBandContract:^{
            ringLogo.layer.borderWidth = 5.0f;
        }];
    }
    else {
        [ringLogo animateRubberBandContract:^{
            ringLogo.layer.borderWidth = 0.0f;
        }];
    }
}

- (void)enableButton:(DeviceDetailsButton)button enabled:(BOOL)enabled {
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;

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
        case LEFT_BUTTON: {
            [self.leftButton setDefaultStyle:name withSelector:sel owner:self];
            break;
        }
        case RIGHT_BUTTON:
            [self.rightButton setDefaultStyle:name withSelector:sel owner:self];
            break;
        default:
            break;
    }
}

- (void)showSubtitle:(NSString *)subtitle {
    [super setSubtitle:subtitle];
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

- (void)skip:(id)obj {
    [(DeviceDetailsLawnNGardenDeviceController*) self.deviceDataModel skip:[((NSNumber *) obj) intValue]];
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
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"CURRENT ZONE ONLY", nil) event:@selector(stopCurrent) obj:nil],
                                             [PopupSelectionButtonModel create:NSLocalizedString(@"ALL ZONES", nil) event:@selector(stopAll) obj:nil], nil];
    buttonView.owner = self;
    [self popup:buttonView complete:nil withOwner:self];
}

- (void)stopCurrent {
    [self stop:YES];
}

- (void)stopAll {
    [self stop:NO];
}

- (void)stop:(BOOL)currentOnly {
    [(DeviceDetailsLawnNGardenDeviceController*) self.deviceDataModel stopWatering:currentOnly];
}

- (void)showWaterNowPopup:(id)sender {
    OrderedDictionary *zoneModels = [(DeviceDetailsLawnNGardenDeviceController *) self.deviceDataModel zonePopupModels];

    // Catch an error state just in case...
    if (zoneModels == nil)
        return;

    PopupSelectionIrrigationView *picker = [PopupSelectionIrrigationView create:@"" list:zoneModels];
    [picker setSelectedZoneKey:@"z1"];
    [picker setSelectedDurationKey:@"1"];
    [super popup:picker complete:@selector(onMultiWaterNowPopupSelection:) withOwner:self inRootViewControllerWindow:YES];
}

- (void)onMultiWaterNowPopupSelection:(NSDictionary *)selectedValue {
    NSString *selectedTimeStr = selectedValue[@"time"];
    int durationInMinutes = [[selectedTimeStr componentsSeparatedByString:@" "][0] intValue];
    NSString *zone = [selectedValue objectForKey:@"zone"];
    
    if (durationInMinutes > 0) {
        [(DeviceDetailsLawnNGardenDeviceController *) self.deviceDataModel waterNowWithZone:zone duration:durationInMinutes];
    }
}

- (void)showCurrentlyWatering:(NSString*)mode {
    [self enableButton:LEFT_BUTTON enabled:true];
    [self setDefaultStyle:@"STOP" onButton:LEFT_BUTTON selector:@selector(showStopPopup:)];

    if (![mode isEqualToString:@"Manual"]) {
        [self enableButton:RIGHT_BUTTON enabled:false];
        [self setDefaultStyle:@"SKIP" onButton:RIGHT_BUTTON selector:@selector(showSkipPopup:)];
    } else {
        self.rightButton.hidden = true;
    }

    [self rubberBandExpand:self.centerIcon];
}

- (void)showTimeRemaining:(NSString *)remaining {
    self.subtitleLabel.text = remaining;
}

- (void)showNotWatering:(NSString *)mode {
    self.subtitleLabel.text = mode;

    [self enableButton:BOTH_BUTTONS enabled:true];
    [self setDefaultStyle:@"WATER\n  NOW" onButton:LEFT_BUTTON selector:@selector(showWaterNowPopup:)];

    if (![mode isEqualToString:@"Manual"]) {
        [self setDefaultStyle:@"SKIP" onButton:RIGHT_BUTTON selector:@selector(showSkipPopup:)];
    } else {
        self.rightButton.hidden = true;
    }

    [self rubberBandContract:self.centerIcon];
}

- (void)showCurrentSchedule:(BOOL)shown zone:(NSString *)zone {
    self.nowContainer.hidden = !shown;
    self.nowZoneLabel.text = zone;
}

- (void)showNextSchedule:(BOOL)shown zone:(NSString *)zone {
    self.nextContainer.hidden = !shown;
    self.nextZoneLabel.text = zone;
    self.nextTitleLabel.text = @"Next";
}

- (void)showRainDelay:(NSString *)until withMode:(NSString*)mode {
    self.subtitleLabel.text = mode;

    [self enableButton:LEFT_BUTTON enabled:false];
    [self setDefaultStyle:@"WATER\n  NOW" onButton:LEFT_BUTTON selector:@selector(showStopPopup:)];

    if (![mode isEqualToString:@"Manual"]) {
        [self setDefaultStyle:@"CANCEL" onButton:RIGHT_BUTTON selector:@selector(cancelRainDelay:)];
        [self enableButton:RIGHT_BUTTON enabled:true];
    }
    else {
        self.rightButton.hidden = true;
    }

    if (until != nil) {
        self.nextContainer.hidden = false;
        self.nextTitleLabel.text = @"Skip Until";
        self.nextZoneLabel.text = until;
    }
}

- (void)cancelRainDelay:(id)sender {
    [(DeviceDetailsLawnNGardenDeviceController *)self.deviceDataModel cancelSkip];
}

@end
