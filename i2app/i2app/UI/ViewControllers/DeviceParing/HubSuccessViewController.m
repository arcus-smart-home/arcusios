//
//  HubSuccessViewController.m
//  i2app
//
//  Created by Arcus Team on 5/5/15.
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
#import "HubSuccessViewController.h"
#import "DevicePairingWizard.h"
#import "ChooseDeviceViewController.h"
#import "AddDeviceViewController.h"
#import "DeviceController.h"

#import <i2app-Swift.h>

@interface HubSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *hubIcon;
@property (weak, nonatomic) IBOutlet UIButton *addDeviceButton;


@end

@implementation HubSuccessViewController

#pragma mark - Life Cycle
+ (instancetype)create {
    HubSuccessViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_addDeviceButton styleSet:@"Add a device" andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    [self setBackgroundColorToDashboardColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    [self navBarWithCloseButtonAndTitle:NSLocalizedString(@"success", nil)];
}

- (void)close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)PressedAddDevice:(id)sender {
    AddDeviceViewController *vc = (AddDeviceViewController *)[self findLastViewController:[AddDeviceViewController class]];
    if (vc) {
        [self.navigationController popToViewController:vc animated:NO];
    }
    else {
      [[ApplicationRoutingService defaultService] showPairingCatalog:NO];
    }
}

@end
