//
//  AccountCreationTimeZoneViewController.m
//  i2app
//
//  Created by Arcus Team on 12/15/15.
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
#import "AccountCreationTimeZoneViewController.h"
#import "PinCodeEntryViewController.h"


#import "PlaceCapability.h"
#import "ArcusBaseTimeZoneViewController+Private.h"


@interface AccountCreationTimeZoneViewController ()

@end

@implementation AccountCreationTimeZoneViewController {
    NSString *_timeZoneId;
}

#pragma mark - Life Cycle
+ (AccountCreationTimeZoneViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CreateAccount" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self defaultTimeZoneValue]) {
        _timeZoneId = [PlaceCapability getTzIdFromModel:CorneaHolder.shared.settings.currentPlace];
    }
}

#pragma mark - Required ArcusBaseTimeZoneViewController overrides
- (IBAction)nextButtonPressed:(id)sender {
    if (self.timeZoneValueLabel.text.length > 0) {
        [self createGif];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
          [AccountController setTimeZone:[[CorneaHolder shared] settings].currentPlace
                                     account:[[CorneaHolder shared] settings].currentAccount
                                      tzName:self.timeZoneValueLabel.text
                                        tzId:_timeZoneId].then(^{
                [self hideGif];

                PinCodeEntryViewController *vc = [PinCodeEntryViewController create];

                vc.pinViewMode = EnterPinViewModeAccountCreationFirstEntry;
                [self.navigationController pushViewController:vc animated:YES];
            }).catch(^(NSError *error) {
                [self hideGif];
                [self displayErrorMessage:error.localizedDescription withTitle:@"Home Address Error"];
            });
        });
    }
}

- (NSString *)defaultTimeZoneValue {
    return [PlaceCapability getTzNameFromModel:CorneaHolder.shared.settings.currentPlace];
}

- (void)userChoseTimezoneWithName:(NSString *)timeZone timeZoneID:(NSString *)tzID offset:(NSNumber *)offset usesDST:(BOOL)usesDST {
    _timeZoneId = tzID;
}

@end
