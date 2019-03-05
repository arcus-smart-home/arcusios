//
//  AddAPlaceAccountOwnerTimeZoneViewController.m
//  i2app
//
//  Created by Arcus Team on 5/10/16.
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
#import "AddAPlaceAccountOwnerTimeZoneViewController.h"
#import "ArcusBaseTimeZoneViewController+Private.h"

#import "UIViewController+backgroundColor.h"

@interface AddAPlaceAccountOwnerTimeZoneViewController ()

@property (strong, nonatomic) PlaceModel *placeGeneratedByPlatform;
@property (strong, nonatomic) PlaceModel *usersPrimaryPlace;

@end

@implementation AddAPlaceAccountOwnerTimeZoneViewController

NSString *const kAccountOwnerTimeZonePinCodeSegueIdentifier = @"pinCodeEnterSegue";

#pragma mark - UIViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAccountOwnerTimeZonePinCodeSegueIdentifier]) {
        AddAPlaceAccountOwnerPinCodeViewController *vc = (AddAPlaceAccountOwnerPinCodeViewController *)segue.destinationViewController;
        vc.placeToSetPinOn = self.placeGeneratedByPlatform;
        vc.usersPrimaryPlace = self.usersPrimaryPlace;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onPlaceChanged:)
                                               name:Constants.kPlaceChangedNotification
                                             object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Required overrides from ArcusBaseTimeZoneViewController
- (IBAction)nextButtonPressed:(id)sender {
    [self createGif];
    
    PlaceModel *placeFromHomeInfo = [PlaceModel placeModelFrom:self.homeInfoData usingSmartyStreetsTimeZone:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [SessionController listAvailablePlaces].thenInBackground(^(NSArray<PlaceAndRoleModel *> *placeRoleModels){
            
            PlaceAndRoleModel *primaryPlaceRoleModel;
            for (PlaceAndRoleModel *prModel in placeRoleModels) {
                if (prModel.primary) {
                    primaryPlaceRoleModel = prModel;
                    break;
                }
            }
            
            if (primaryPlaceRoleModel) {
                NSString *placeAddress = [PlaceModel addressForId:primaryPlaceRoleModel.placeId];
                PlaceModel *primaryPlace = (PlaceModel*) [[[CorneaHolder shared] modelCache] fetchModel: placeAddress];
              
                if (primaryPlace) {
                    [primaryPlace refresh].thenInBackground(^{
                        [AccountController addPlace:placeFromHomeInfo
                                             population:@"000000-00-000000000000"
                                           serviceLevel:[AnyServiceLevelable getInheritedServiceLevelFrom: primaryPlace]
                                                 addOns:[NSDictionary new]
                                                account:[[CorneaHolder shared] settings].currentAccount].thenInBackground(^(PlaceModel *generatedPlace){

                            // Switch Places
                            self.usersPrimaryPlace = primaryPlace;
                            self.placeGeneratedByPlatform = generatedPlace;
                            [[[CorneaHolder shared] session] setActivePlaceWithSuspendedRouting:generatedPlace.modelId];
                        });
                    });
                } else {
                    [self displayGenericError];
                }
            } else {
                [self displayGenericError];
            }
        });
        
    });
}

- (void) onPlaceChanged: (NSNotification *)note {
    RunOnMain(^{
        if (self.homeInfoData.homeImage) {
            [ArcusSettingsHomeImageHelper saveHomeImage:self.homeInfoData.homeImage placeId:self.placeGeneratedByPlatform.modelId];
            [self setCurrentBackgroup:self.homeInfoData.homeImage];
        }

        [self hideGif];
        [self performSegueWithIdentifier:kAccountOwnerTimeZonePinCodeSegueIdentifier sender:self];
    });
}

- (void) displayGenericError {
    RunOnMain(^{
        [self hideGif];
        [self displayGenericErrorMessage];
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
