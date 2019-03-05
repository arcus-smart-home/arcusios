//
//  PairingExtraFinalStepViewController.m
//  i2app
//
//  Created by Arcus Team on 1/19/16.
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
#import "PairingExtraFinalStepViewController.h"
#import "SimpleTableViewController.h"
#import "HoneywellC2CAutoModeDelegate.h"
#import "FoundDevicesViewController.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"

@interface PairingExtraFinalStepViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pairingTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *pairingStepInstructionsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pairingStepImageView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightconstraint;

- (IBAction)nextButtonPressed:(id)sender;

@end


@implementation PairingExtraFinalStepViewController {
    NSString    *_pairingStepTitle;
    NSString    *_pairingStepInstructions;
    NSString    *_pairingStepImageName;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    switch ([DevicePairingManager sharedInstance].currentDevice.deviceType) {
        case DeviceTypeHalo:
            [self setAsHaloStep];
            break;
            
        case DeviceTypePetDoor:
            [self setAsPetDoorStep];
            break;

        case DeviceTypeWaterHeater:
            [self setAsWaterHeaterStep];
            break;

        case DeviceTypeThermostat:
            [self setAsThermostateStep];
            break;

      case DeviceTypeThermostatNest:
        [self setAsThermostateStep];
        break;

        case DeviceTypeThermostatHoneywellC2C:
            [self setAsHoneywellC2CThermostatStep];
            break;

        case DeviceTypeIrrigation:
            [self setAsLNGStep];
            break;

        default:
            [self navBarWithBackButtonAndTitle:self.title];
            break;
    }
}

- (void)setAsPetDoorStep {
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Pet Door", nil)];
    self.pairingTextLabel.text = NSLocalizedString(@"Pet Door Pairing text", nil);
    self.pairingStepInstructionsLabel.text = @"";
    self.pairingStepImageView.image = [UIImage imageNamed:@"PetDoorPairingStep"];
    self.nextButton.hidden = NO;
}

- (void)setAsHoneywellC2CThermostatStep {
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Honeywell schedule", nil)];
    _pairingStepTitle = @"Honeywell schedule";
    self.pairingTextLabel.text = NSLocalizedString(@"Honeywell thermostat pairing text", nil);
    self.pairingStepInstructionsLabel.text = NSLocalizedString(@"", nil);
    self.pairingStepImageView.image = [UIImage imageNamed:@"image_pairing_c2c_final_step"];
    self.titleHeightconstraint.constant = 90;
    self.nextButton.hidden = NO;

    [self addCloseButtonItem];
}

- (void)setAsWaterHeaterStep {
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Water Heater", nil)];
    self.pairingTextLabel.text = NSLocalizedString(@"Tap the Water card on the \n Dashboard to control \n your water heater.", nil);
    self.pairingStepInstructionsLabel.text = @"";
    self.pairingStepImageView.image = [UIImage imageNamed:@"WaterHeaterPairingStep"];
    self.titleHeightconstraint.constant = 40;
    self.nextButton.hidden = NO;
}

- (void)setAsLNGStep {
    if ([self.deviceModel name] != nil && ![[self.deviceModel name] isEqualToString:@""]){
        [self navBarWithBackButtonAndTitle: [self.deviceModel name]];
    }
    else {
        [self navBarWithBackButtonAndTitle: NSLocalizedString(@"Irrigation Timer", nil)];
    }
    _pairingStepTitle = @"Control Your Irrigation Timer";
    self.pairingTextLabel.text = NSLocalizedString(@"N&G Pairing text", nil);
    self.pairingStepInstructionsLabel.text = @"";
    self.pairingStepImageView.image = [UIImage imageNamed:@"LNG_Pairing_Image"];
    self.nextButton.hidden = NO;
}

- (void)setAsHaloStep {
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Halo", nil)];
    self.pairingTextLabel.text = NSLocalizedString(@"Manage Your Halo Device", nil);
    self.pairingStepInstructionsLabel.text = NSLocalizedString(@"Halo Pairing text", nil);
    self.pairingStepImageView.image = [UIImage imageNamed:@"HaloInstructions"];
    self.nextButton.hidden = NO;
}

- (void)setAsThermostateStep {
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Thermostat", nil)];
    self.pairingTextLabel.text = NSLocalizedString(@"Tap the Climate card on the \n Dashboard to manage \n your thermostat.", nil);
    self.pairingStepInstructionsLabel.text = @"";
    self.pairingStepImageView.image = [UIImage imageNamed:@"ThermostatPairingStep"];
    self.nextButton.hidden = NO;
}

- (IBAction)nextButtonPressed:(id)sender {
    if ([_pairingStepTitle isEqualToString:@"Honeywell schedule"]) {
        SimpleTableViewController *vc = [SimpleTableViewController createWithNewStyle:YES andDelegate:[HoneywellC2CAutoModeDelegate new]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_pairingStepTitle isEqualToString:@"Control Your Irrigation Timer"]) {
        [self close:self];
    }
    else if ([[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES] == nil) {
        [self close:self];
    }
}

- (void)close:(id)sender {
    // Go to the list of the just paired devices
    UIViewController *gotoVC = [self findLastViewController:[FoundDevicesViewController class]];
    if (gotoVC) {
        [self.navigationController popToViewController:gotoVC animated:YES];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
