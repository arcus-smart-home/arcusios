//
//  AddAPlaceGuestTimeZoneViewController.m
//  i2app
//
//  Created by Arcus Team on 5/17/16.
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
#import "AddAPlaceGuestTimeZoneViewController.h"
#import "PersonController.h"

#import "UIViewController+backgroundColor.h"
#import <i2app-Swift.h>

@interface AddAPlaceGuestTimeZoneViewController ()

@property (strong, nonatomic) PlaceModel *placeGeneratedByPlatform;
@property (strong, nonatomic) AccountModel *accountGeneratedByPlatform;

@end

@implementation AddAPlaceGuestTimeZoneViewController

NSString *const kAddPlaceGuestTimeZonePinCodeSegueIdentifier = @"guestPinCodeEnterSegue";

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Required overrides from ArcusBaseTimeZoneViewController
- (IBAction)nextButtonPressed:(id)sender {
    
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        PlaceModel *placeFromHomeInfo = [PlaceModel placeModelFrom:self.homeInfoData usingSmartyStreetsTimeZone:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            PersonModel *currPerson = [[CorneaHolder shared] settings].currentPerson;
            [PersonController promoteToAccountWithPlace:placeFromHomeInfo onPerson:currPerson].thenInBackground(^(NSDictionary *placeAccountDict) {
                self.placeGeneratedByPlatform = placeAccountDict[kPromoteToAccountReturnPlaceKey];
                self.accountGeneratedByPlatform = placeAccountDict[kPromoteToAccountReturnAccountKey];
                [AccountController changeToPlaceId:self.placeGeneratedByPlatform.modelId
                                                person:currPerson].thenInBackground(^{
                    if (self.homeInfoData.homeImage) {
                        [ArcusSettingsHomeImageHelper saveHomeImage:self.homeInfoData.homeImage
                                                                placeId:self.placeGeneratedByPlatform.modelId];
                        [self setCurrentBackgroup:self.homeInfoData.homeImage];
                    }
                    [AccountController completedAccountStep:AccountStateNewSignUpTimeZone
                                                          model:CorneaHolder.shared.settings.currentPerson
                                               withAccountModel:self.accountGeneratedByPlatform];
                    RunOnMain(^{
                        [self hideGif];
                        [self performSegueWithIdentifier:kAddPlaceGuestTimeZonePinCodeSegueIdentifier sender:self];
                    })
                });
            });
        });
        
    });
}

- (NSString *)defaultTimeZoneValue {
    //TODO: Implement
    return nil;
}

- (void)userChoseTimezoneWithName:(NSString *)timeZone timeZoneID:(NSString *)tzID offset:(NSNumber *)offset usesDST:(BOOL)usesDST {
    self.homeInfoData.timeZoneName = timeZone;
    self.homeInfoData.timeZoneID = tzID;
    self.homeInfoData.timeZoneOffset = offset;
    self.homeInfoData.timeZoneUsesDST = usesDST;
}

@end
