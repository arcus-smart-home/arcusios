//
//  BasePairingViewController.m
//  i2app
//
//  Created by Arcus Team on 5/25/15.
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
#import "BasePairingViewController.h"
#import "DevicePairingWizard.h"
#import "FoundDevicesViewController.h"
#import "DevicePairingManager.h"
#import "DeviceFirmwareUpdateNeededViewController.h"
#import "DeviceOtaCapability.h"
#import "PairingStep.h"
#import <i2app-Swift.h>

@interface BasePairingViewController ()
    
- (void)setDeviceStep:(PairingStep *)step;

@end


@implementation BasePairingViewController

#pragma mark - Life Cycle
+ (instancetype)create {
    BasePairingViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

+ (instancetype)createWithDeviceStep:(PairingStep *)step {
    BasePairingViewController *vc = [self create];
    [vc setDeviceStep:step];
    return vc;
}

+ (instancetype)createWithDeviceStep:(PairingStep *)nextStep withDeviceModel:(DeviceModel *)deviceModel {
    BasePairingViewController *vc = [self createWithDeviceStep:nextStep];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToDashboardColor];
    
    [self addBackButtonItemAsLeftButtonItem];
    
    [self initializeTemplateViewController];
}

- (void)setDeviceStep:(PairingStep *)step {
    _step = step;
}

- (void)refreshVideo {
    
}

- (void)back:(NSObject *)sender {
    [[DevicePairingManager sharedInstance].pairingWizard backToPreviousPage];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 * Used to initialize all control IBOutlets and IBActions
 */
- (void)initializeTemplateViewController {
    if (self.step && self.step.title.length > 0) {
        [self navBarWithBackButtonAndTitle:[self.step.title uppercaseString]];
    }

    //add white overlay
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
}

- (void)close:(id)sender {
    if ([[DevicePairingManager sharedInstance] areAllDevicesUpdated]) {
      [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
    } else {
        UIViewController* foundDevicesVC = [self findLastViewController:[FoundDevicesViewController class]];
        if (foundDevicesVC) {
            [self.navigationController popToViewController:foundDevicesVC animated:YES];
        }
    }
}

- (IBAction)nextButtonPressed:(id)sender {
    if (![[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES]) {
        if ([[DeviceOtaCapability getStatusFromModel:[DevicePairingManager sharedInstance].currentDevice] isEqualToString:kEnumDeviceOtaStatusINPROGRESS]) {
            [self.navigationController pushViewController:[DeviceFirmwareUpdateNeededViewController create] animated:YES];
        }
        else {
            [DevicePairingWizard runPostPostPairingWizard:self];
        }
    }
}

- (void)renderImage:(UIImage *)image inButton:(UIButton *)photoButton {
    if (image) {
        photoButton.layer.cornerRadius = photoButton.frame.size.width / 2.0f;
        photoButton.layer.borderColor = [UIColor blackColor].CGColor;
        photoButton.layer.borderWidth = 1.0f;
        [photoButton setImage:image forState:UIControlStateNormal];
        if (image) {
            self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        }
    }
}

@end
