// 
// LawnNGardenPairingZoneDetailsViewController.m
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
#import "LawnNGardenPairingZoneDetailsViewController.h"
#import "IrrigationZoneModel.h"
#import "CommonTitleWithSubtitleCell.h"
#import "SettingsTextFieldTableViewCell.h"
#import "ArcusLabel.h"
#import "PopupSelectionIrrigationView.h"
#import "UIImage+ImageEffects.h"


#import "LawnNGardenZoneController.h"
#import "NSDate+Convert.h"
#import "IrrigationControllerCapability.h"
#import "LawnNGardenSubsystemController.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"
#import "UIViewController+Keyboard.h"
#import "LawnNGardenPairingZoneListViewController.h"

@interface LawnNGardenPairingZoneDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet AccountTextField *textField;
@property (weak, nonatomic) IBOutlet ArcusLabel *wateringDuration;
@property (weak, nonatomic) IBOutlet ArcusLabel *defaultWateringTimeLabel;
@property (weak, nonatomic) IBOutlet ArcusLabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chevron;

@property (strong, nonatomic) PopupSelectionWindow *popupWindow;

@property (assign, atomic) int currentlySelectedDuration;

@property (strong, nonatomic) IrrigationZoneModel *zoneModel;

@property (nonatomic, assign, readonly) DeviceModel *device;

@end

@implementation LawnNGardenPairingZoneDetailsViewController

@dynamic device;

+ (instancetype)createWithDeviceStep:(PairingStep *)step {
    LawnNGardenPairingZoneDetailsViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.zoneModel = [LawnNGardenPairingZoneListViewController getSelectedZone];
    
    if (!vc.zoneModel) {
        // This is a single Zone device
        NSArray *zones = [LawnNGardenSubsystemController getZonesForDeviceAddresses:@[[DevicePairingManager sharedInstance].currentDevice.address]].allValues[0];
        if (zones.count > 0) {
            vc.zoneModel = zones[0];
        }
    }
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundColorToLastNavigateColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    [self.textField setAccountFieldStyle:AccountTextFieldStyleBlack];
    self.textField.delegate = self;
    self.textField.inputAccessoryView = [self initializeKeyboardToolbarWithSelectors:@selector(donePressed:)];
    [self navBarWithBackButtonAndTitle:self.zoneModel.name.length > 0 ? self.zoneModel.name : self.zoneModel.defaultZoneName];

    [self loadData];
    
    _currentlySelectedDuration = self.zoneModel.defaultDuration;
}

- (void)donePressed:(NSObject *)sender {
    [self.view endEditing:YES];
}

- (DeviceModel *)device {
    return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.zoneModel.controller];
}

- (void)loadData {
    self.textField.text = self.zoneModel.name;

    NSString *duration = [NSString stringWithFormat:@"%d Mins", self.zoneModel.defaultDuration];
    self.wateringDuration.text = duration;
}

- (IBAction)clearButtonPressed:(id)sender {
    self.textField.text = @"";
}

- (IBAction)defaultTimeButtonPressed:(id)sender {
    PopupSelectionIrrigationView *picker = [PopupSelectionIrrigationView create:@"DURATION" list:nil];
    picker.selectedDurationKey = @(self.zoneModel.defaultDuration).stringValue;
    [self popup:picker complete:@selector(onDefaultDurationSelection:) withOwner:self];
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:owner
                                 closeSelector:selector];
}

- (void)onDefaultDurationSelection:(NSDictionary *)selectedValue {
    self.currentlySelectedDuration = [selectedValue[@"time"] intValue];
    self.wateringDuration.text = [NSString stringWithFormat:@"%d Mins", self.currentlySelectedDuration];
    [self.wateringDuration setNeedsDisplay];
}

- (IBAction)onSavePressed:(id)sender {
    NSString *name = self.textField.text;

    // TODO: Perform an action like show an error
    if (name.length == 0 || _currentlySelectedDuration == 0) {
        name = @"";
    }
    if ([name isEqualToString:self.zoneModel.name] && self.currentlySelectedDuration == self.zoneModel.defaultDuration) {
        [self didSaveZone];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        LawnNGardenZoneController *controller = [[LawnNGardenZoneController alloc] initWithCallback:self];
        
        [controller saveZoneName:name duration:self.currentlySelectedDuration forDevice:self.zoneModel.controller andZone:self.zoneModel.zoneValue];
    });
}

- (void)didSaveZone {
    if ([IrrigationControllerCapability getNumZonesFromModel:self.device] > 1) {
        [super back:self];
    }
    else {
        [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
    }
}

@end
