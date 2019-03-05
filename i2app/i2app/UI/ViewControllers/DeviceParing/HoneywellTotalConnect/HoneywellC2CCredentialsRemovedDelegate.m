//
//  HoneywellC2CCredentialsRemovedDelegate.m
//  i2app
//
//  Created by Arcus Team on 2/4/16.
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
#import "HoneywellC2CCredentialsRemovedDelegate.h"
#import "HoneywellC2CViewController.h"
#import <i2app-Swift.h>

@implementation HoneywellC2CCredentialsRemovedDelegate

- (NSString *)getTitle {
    return @"Honeywell Credentials";
}

- (NSString *)getHeaderText {
    return @"Honeywell Credentials Removed";
}

- (NSString *)getSubheaderText {
    return @"go to honeywell site";
}

- (NSString *)getBottomButtonText {
    return @"NEXT";
}

- (void)onClickBottomButton {
    HoneywellC2CViewController *vc = [HoneywellC2CViewController new];
    vc.isPairingMode = NO;
    vc.goToViewController = self.goToViewController;
    [[ApplicationRoutingService.defaultService displayingViewControllerInViewController:nil].navigationController pushViewController:vc animated:YES];
}

@end
