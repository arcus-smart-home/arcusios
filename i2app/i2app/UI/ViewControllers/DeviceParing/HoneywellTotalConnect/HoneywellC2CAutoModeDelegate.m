//
//  HoneywellC2CAutoModeDelegate.m
//  i2app
//
//  Created by Arcus Team on 1/25/16.
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
#import "HoneywellC2CAutoModeDelegate.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"

@implementation HoneywellC2CAutoModeDelegate

- (NSString *)getTitle {
    return @"Honeywell thermostat";
}

- (BOOL)enableScrolling {
    return NO;
}


- (NSString *)getHeaderText {
    return NSLocalizedString(@"Auto Mode", nil);
}

- (NSString *)getSubheaderText {
    return NSLocalizedString(@"How to use Auto mode", nil);
}

- (NSString *) getBottomButtonText {
    return NSLocalizedString(@"next", nil).uppercaseString;
}

- (void)onClickBottomButton {
    PairingStep *step = [[PairingStep alloc] init];
    step.stepType = PairingStepPromo;
    step.stepIndex = 0;
    step.title = [DevicePairingManager sharedInstance].currentDevice.name;
    
    [[DevicePairingManager sharedInstance].pairingWizard addPairingStep:step];
    [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
}

@end
