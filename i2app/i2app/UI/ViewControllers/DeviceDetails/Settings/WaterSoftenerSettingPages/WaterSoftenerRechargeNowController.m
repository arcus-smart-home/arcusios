//
//  WaterSoftenerRechargeNowController.m
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
#import "WaterSoftenerRechargeNowController.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionButtonsView.h"
#import "WaterSoftenerCapability.h"


@interface WaterSoftenerRechargeNowController ()

@end

@implementation WaterSoftenerRechargeNowController {
    
    __weak IBOutlet UIButton    *theBottomButton;
    PopupSelectionWindow        *_popupWindow;
}


+ (WaterSoftenerRechargeNowController *)createWithDeviceModel:(DeviceModel *)deviceModel {
    WaterSoftenerRechargeNowController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetailSetting" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Recharge now", nil) uppercaseString]];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [theBottomButton styleSet:NSLocalizedString(@"Recharge now", nil) andButtonType:FontDataTypeButtonLight];
}

- (IBAction)onClickRechargeButton:(id)sender {
    if (![self isRecharging]) {
        PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Are your sure", nil) subtitle:NSLocalizedString(@"water softener sure text", nil) button:[PopupSelectionButtonModel create:NSLocalizedString(@"Continue", nil) event:@selector(continueRecharge)], [PopupSelectionButtonModel create:NSLocalizedString(@"Cancel", nil) event:nil], nil];
        buttonView.owner = self;
        
        _popupWindow = [PopupSelectionWindow popup:self.view subview:buttonView owner:self closeSelector:nil style:PopupWindowStyleCautionWindow];
    }
    else {
        [self continueRecharge];
    }
}

- (void)continueRecharge {
    if ([self isRecharging]) {
        PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Already Recharging", nil) subtitle:NSLocalizedString(@"Check your water softener detail page to see how much time is left remaining until the recharge is complete.", nil) button: nil];
        buttonView.owner = self;
        
        _popupWindow = [PopupSelectionWindow popup:self.view subview:buttonView owner:self closeSelector:nil style:PopupWindowStyleCautionWindow];
        return ;
    }
    
    [self rechargeNow];
}

- (void)rechargeNow {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [WaterSoftenerCapability rechargeNowOnModel:self.deviceModel]
        .catch(^(NSError *error) {
            [self displayGenericErrorMessage];
        });
    });
}

- (BOOL)isRecharging {
    int rechargerRemainingTime = [WaterSoftenerCapability getRechargeTimeRemainingFromModel:self.deviceModel];
    
    if (rechargerRemainingTime > 0) {
        return YES;
    }
    
    return NO;
    
    // Work aground now
    // return [[WaterSoftenerCapability getRechargeStatusFromModel:waterSoftener] isEqualToString:kEnumWaterSoftenerRechargeStatusRECHARGING];
}

@end
