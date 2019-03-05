//
//  WaterSoftenerRechargeTimeController.m
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
#import "WaterSoftenerRechargeTimeController.h"
#import "PopupSelectionTimerView.h"
#import "NSDate+Convert.h"

#import "WaterSoftenerCapability.h"

@interface WaterSoftenerRechargeTimeController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation WaterSoftenerRechargeTimeController {
    PopupSelectionWindow        *_popupWindow;
}

+ (WaterSoftenerRechargeTimeController *)createWithDeviceModel:(DeviceModel*)deviceModel {
    WaterSoftenerRechargeTimeController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetailSetting" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Recharge Time", nil) uppercaseString]];
    self.timeLabel.text = [self rechargeStartingTime];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (NSString *)rechargeStartingTime {
    int reChargeStartingTime = [WaterSoftenerCapability getRechargeStartTimeFromModel:self.deviceModel];
    
    NSDate *date = [NSDate dateWithTimeInHour:reChargeStartingTime];
   
    return [date formatDate:@"h a"];
}

- (IBAction)onClickRechargeTime:(id)sender {
    int reChargeStartingTime = [WaterSoftenerCapability getRechargeStartTimeFromModel:self.deviceModel];
    
    NSDate *rechargeTime = [NSDate dateWithTimeInHour:reChargeStartingTime];
    PopupSelectionTimerView *timerPicker = [PopupSelectionTimerView create:@"Time" withDate:rechargeTime timerStyle:TimerStyleHoursOnly];
    
    _popupWindow = [PopupSelectionWindow popup:self.view subview:timerPicker owner:self closeSelector:@selector(closeClicked:)];
}

- (void)closeClicked:(id)value {
    int timeValue = [(NSDate *)value getHours];
    [WaterSoftenerCapability setRechargeStartTime:timeValue onModel:self.deviceModel];
    
    NSDate *date = [NSDate dateWithTimeInHour:timeValue ];

    self.timeLabel.text = [date formatDate:@"h a"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self.deviceModel commit].then(^() {}).catch(^(NSError *error) {
            [self displayGenericErrorMessage];
        });
    });
}

@end
