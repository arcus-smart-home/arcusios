//
//  WaterSoftenerWaterHardnessLvController.m
//  i2app
//
//  Created by Arcus Team on 10/12/15.
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
#import "WaterSoftenerWaterHardnessLvController.h"
#import "WaterHardnessCapability.h"

#import <i2app-Swift.h>

@interface WaterSoftenerWaterHardnessLvController ()

@end

@implementation WaterSoftenerWaterHardnessLvController {
    __weak IBOutlet UIButton    *theBottomButton;
    __weak IBOutlet UILabel     *titleLabel;
}

+ (WaterSoftenerWaterHardnessLvController *)createWithDeviceModel:(DeviceModel*)deviceModel {
    WaterSoftenerWaterHardnessLvController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetailSetting" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Buy", nil) uppercaseString]];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [theBottomButton styleSet:NSLocalizedString(@"Buy", nil) andButtonType:FontDataTypeButtonLight];

    [self setupHardenessView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceStateChangedNotification:) name:self.deviceModel.modelChangedNotification object:nil];
    
}

- (void)setupHardenessView {
    // DeviceModel *currentDevice = [[DeviceManager instance] getCurrentDevice];
    // double waterHardeness = [WaterHardnessCapability getHardnessFromModel:currentDevice];
    
    // NSString *titleStr = [NSString stringWithFormat:NSLocalizedString(@"Your water hardness level is defaulted to %d gpg (grains per gallon). This should vary by location and water source.", nil), waterHardeness];
    
}

- (IBAction)onClickBuyButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @""] options:@{} completionHandler:nil];
}

- (void)getDeviceStateChangedNotification:(NSNotification *)note {
    if ([self.deviceModel.modelId isEqualToString:((Model *)note.userInfo[Constants.kModel]).modelId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupHardenessView];
        });
    }
}


@end
