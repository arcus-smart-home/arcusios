//
//  AddAPlaceAccountOwnerHomeInfoViewController.m
//  i2app
//
//  Created by Arcus Team on 5/9/16.
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
#import "AddAPlaceAccountOwnerHomeInfoViewController.h"
#import "ArcusBaseHomeInfoViewController+Private.h"

#import "AddPlaceHomeInfoData.h"
#import "ImagePicker.h"
#import "SmartStreetValidationViewController.h"

#import "PlaceCapability.h"

#import "NSDictionary+SmartyStreets.h"
#import "AddAPlaceAccountOwnerTimeZoneViewController.h"
#import <i2app-Swift.h>

NSString *const kAddPlaceAccountOwnerTimeZoneSegue = @"timeZoneSegue";
NSString *const kAddPlaceAccountOwnerPinCodeSegue = @"accountOwnerHomeInfoToPinSegue";

@interface AddAPlaceAccountOwnerHomeInfoViewController ()

@property (strong, nonatomic) AddPlaceHomeInfoData *homeInfoData;
@property (strong, nonatomic) PlaceModel *placeGeneratedByPlatform;
@property (strong, nonatomic) PlaceModel *usersPrimaryPlace;

@end

@implementation AddAPlaceAccountOwnerHomeInfoViewController

#pragma mark - Creation
+ (AddAPlaceAccountOwnerHomeInfoViewController *)create {
    return [[UIStoryboard storyboardWithName:@"AddPlace" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AddAPlaceAccountOwnerHomeInfoViewController class])];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeInfoData = [AddPlaceHomeInfoData new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onPlaceChanged:)
                                               name:Constants.kPlaceChangedNotification
                                             object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAddPlaceAccountOwnerTimeZoneSegue]) {
        AddAPlaceAccountOwnerTimeZoneViewController *vc = (AddAPlaceAccountOwnerTimeZoneViewController *)segue.destinationViewController;
        vc.homeInfoData = self.homeInfoData;
    } else if ([segue.identifier isEqualToString:kAddPlaceAccountOwnerPinCodeSegue]) {
        AddAPlaceAccountOwnerPinCodeViewController *vc = (AddAPlaceAccountOwnerPinCodeViewController *)segue.destinationViewController;
        vc.placeToSetPinOn = self.placeGeneratedByPlatform;
        vc.usersPrimaryPlace = self.usersPrimaryPlace;
    }
}

#pragma mark - IBActions
- (IBAction)nextButtonPressed:(id)sender {
    if ([self validateTextFields]) {
        
        self.homeInfoData.homeName = self.homeNameTextField.text;
        self.homeInfoData.addressOne = self.addressOneTextField.text;
        self.homeInfoData.addressTwo = self.addressTwoTextField.text;
        self.homeInfoData.city = self.cityTextField.text;
        self.homeInfoData.postalCode = self.zipTextField.text;
        self.homeInfoData.state = self.stateButton.titleLabel.text;
        self.homeInfoData.country = @"US";
        
        NSString *streetStringForValidation = [self.homeInfoData.addressOne stringByAppendingFormat:@" %@", self.homeInfoData.addressTwo];
        [self createGif];
        
        [SmartStreetValidationViewController smartyStreetsValidateStreet:streetStringForValidation
                                                       city:self.homeInfoData.city
                                                      state:self.homeInfoData.state
                                    addressToDisplayOnError:[self extractPrettyAddressFromTextFields]
                                                      owner:self completeHandle:^(SmartstreetValidOperation operation, NSDictionary *data) {
                                                          
                                                          switch (operation) {
                                                              case SmartstreetValidOperationUseThis: {
                                                                  
                                                                  self.homeInfoData.smartyStreetsInfo = data;
                                                                  if ([self.homeInfoData.smartyStreetsInfo getSmartyStreetsTimeZone]) {
                                                                      PlaceModel *placeFromHomeInfo = [PlaceModel placeModelFrom:self.homeInfoData usingSmartyStreetsTimeZone:YES];
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
                                                                                  [primaryPlace refresh].thenInBackground(^{
                                                                                    [AccountController addPlace:placeFromHomeInfo
                                                                                                         population:@"000000-00-000000000000"
                                                                                                       serviceLevel:[AnyServiceLevelable getInheritedServiceLevelFrom: primaryPlace]
                                                                                                             addOns:[NSDictionary new]
                                                                                                            account:[[CorneaHolder shared] settings].currentAccount]
                                                                                    .thenInBackground(^(PlaceModel *generatedPlace){
                                                                                          
                                                                                          // Set Timezone
                                                                                          [PlaceCapability setTzName:[self.homeInfoData.smartyStreetsInfo getSmartyStreetsTimeZone] onModel:generatedPlace];
                                                                                          [PlaceCapability setTzOffset:[self.homeInfoData.smartyStreetsInfo getSmartyStreetsUTCOffset] onModel:generatedPlace];
                                                                                          [PlaceCapability setTzUsesDST:[self.homeInfoData.smartyStreetsInfo getSmartyStreetsDoesObserveDaylightSavings] onModel:generatedPlace];
                                                                                          
                                                                                          [generatedPlace commit];
                                                                                          
                                                                                          // Switch Places
                                                                                          self.usersPrimaryPlace = primaryPlace;
                                                                                          self.placeGeneratedByPlatform = generatedPlace;
                                                                                          [[[CorneaHolder shared] session] setActivePlaceWithSuspendedRouting:generatedPlace.modelId];
                                                                                      })
                                                                                      .catch(^(NSError *error) {
                                                                                          [self hideGif];
                                                                                          [self displayGenericErrorMessageWithError:error];
                                                                                      });
                                                                                  });
                                                                              } else {
                                                                                  RunOnMain(^{
                                                                                      [self hideGif];
                                                                                      [self displayGenericErrorMessage];
                                                                                  })
                                                                              }
                                                                          });
                                                                          
                                                                      });
                                                                  } else {
                                                                      RunOnMain(^{
                                                                          [self hideGif];
                                                                          [self performSegueWithIdentifier:kAddPlaceAccountOwnerTimeZoneSegue sender:self];
                                                                      })
                                                                  }
                                                                  break;
                                                              }
                                                              case SmartstreetValidOperationUseUserTyped:
                                                                  [self hideGif];
                                                                  [self performSegueWithIdentifier:kAddPlaceAccountOwnerTimeZoneSegue sender:self];
                                                                  break;
                                                                  
                                                              case SmartstreetValidOperationEditUserTyped:
                                                                  DDLogInfo(@"User editing their input");
                                                                  [self hideGif];
                                                                  break;
                                                                  
                                                              default:
                                                                  [self hideGif];
                                                                  break;
                                                          }
                                                      }];
    }
}

- (void) onPlaceChanged: (NSNotification *)note {
    RunOnMain(^{
        if (self.homeInfoData.homeImage) {
            [ArcusSettingsHomeImageHelper saveHomeImage:self.homeInfoData.homeImage placeId:self.placeGeneratedByPlatform.modelId];
        }

        [self hideGif];
        [self performSegueWithIdentifier:kAddPlaceAccountOwnerPinCodeSegue sender:self];
    });
}

- (IBAction)photoButtonPressed:(id)sender {
    [[ImagePicker sharedInstance] presentImagePickerInViewController:self withImageId:@"ID" withCompletionBlock:^(UIImage *image) {
        if ([image isKindOfClass:[UIImage class]]) {
            self.homeInfoData.homeImage = image;
            
            self.photoButton.layer.cornerRadius = self.photoButton.frame.size.width/2.0f;
            self.photoButton.layer.borderColor = [UIColor blackColor].CGColor;
            self.photoButton.layer.borderWidth = 1.0f;
            [self.photoButton setImage:image forState:UIControlStateNormal];
            [self.photoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        }
    }];
}

#pragma mark - BaseTextViewController overrides
- (BOOL)validateTextFields {
    [self.view endEditing:YES];
    
    NSString *errorMessageKey;
    return [self isDataValid:&errorMessageKey];
}

@end
