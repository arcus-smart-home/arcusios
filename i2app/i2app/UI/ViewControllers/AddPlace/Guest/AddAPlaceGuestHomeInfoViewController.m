//
//  AddAPlaceGuestHomeInfoViewController.m
//  i2app
//
//  Created by Arcus Team on 5/16/16.
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
#import "AddAPlaceGuestHomeInfoViewController.h"
#import "ArcusBaseHomeInfoViewController+Private.h"

#import "AddPlaceHomeInfoData.h"
#import "ImagePicker.h"
#import "SmartStreetValidationViewController.h"
#import "NSDictionary+SmartyStreets.h"
#import "PersonController.h"

#import "AddAPlaceGuestTimeZoneViewController.h"
#import "PlaceCapability.h"

@interface AddAPlaceGuestHomeInfoViewController ()

@property (strong, nonatomic) AddPlaceHomeInfoData *homeInfoData;

@property (strong, nonatomic) PlaceModel *placeGeneratedByPlatform;
@property (strong, nonatomic) AccountModel *accountGeneratedByPlatform;

@end

@implementation AddAPlaceGuestHomeInfoViewController

#pragma mark - Creation
+ (AddAPlaceGuestHomeInfoViewController *)create {
    return [[UIStoryboard storyboardWithName:@"AddPlace" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AddAPlaceGuestHomeInfoViewController class])];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeInfoData = [AddPlaceHomeInfoData new];
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
        
        // Reverting logic to delegate to SmartyStreets. See 1bcc84c for PlaceService implementation
        [SmartStreetValidationViewController smartyStreetsValidateStreet:streetStringForValidation
                                                       city:self.homeInfoData.city
                                                      state:self.homeInfoData.state
                                    addressToDisplayOnError:[self extractPrettyAddressFromTextFields]
                                                      owner:self completeHandle:^(SmartstreetValidOperation operation, NSDictionary *data) {
                                                          [self onAddressValidationDidComplete:operation withData:data];
                                                      }];
    }
}

- (void)onAcceptEnteredAddress {
    PlaceModel *placeFromHomeInfo = [PlaceModel placeModelFrom:self.homeInfoData usingSmartyStreetsTimeZone:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        PersonModel *currPerson = [[CorneaHolder shared] settings].currentPerson;
        [PersonController promoteToAccountWithPlace:placeFromHomeInfo onPerson:currPerson].thenInBackground(^(NSDictionary *placeAccountDict) {
            [self onAccountPromoted:placeAccountDict byPerson:currPerson];
        });
    });
}

- (void)onEditEnteredAddress {
    [self hideGif];
}

- (void)onAccountPromoted:(NSDictionary*)placeAccountDict byPerson:(PersonModel*)currPerson {
  
    self.placeGeneratedByPlatform = [[PlaceModel alloc] initWithAttributes:placeAccountDict[kPromoteToAccountReturnPlaceKey]];
    [[[CorneaHolder shared] modelCache] addModel:self.placeGeneratedByPlatform];

    self.accountGeneratedByPlatform = [[AccountModel alloc] initWithAttributes:placeAccountDict[kPromoteToAccountReturnAccountKey]];
    [[[CorneaHolder shared] modelCache] addModel:self.accountGeneratedByPlatform];

    // Set Timezone
    if ([self.homeInfoData.smartyStreetsInfo getSmartyStreetsTimeZone]) {
        [PlaceCapability setTzName:[self.homeInfoData.smartyStreetsInfo getSmartyStreetsTimeZone] onModel:self.placeGeneratedByPlatform];
        [PlaceCapability setTzOffset:[self.homeInfoData.smartyStreetsInfo getSmartyStreetsUTCOffset] onModel:self.placeGeneratedByPlatform];
        [PlaceCapability setTzUsesDST:[self.homeInfoData.smartyStreetsInfo getSmartyStreetsDoesObserveDaylightSavings] onModel:self.placeGeneratedByPlatform];
    }

    [self.placeGeneratedByPlatform commit];

    [AccountController changeToPlaceId:self.placeGeneratedByPlatform.modelId person:currPerson].thenInBackground(^{
        if (self.homeInfoData.homeImage) {
          [ArcusSettingsHomeImageHelper saveHomeImage:self.homeInfoData.homeImage
                                             placeId:[self.placeGeneratedByPlatform modelId]];
        }
      
        [AccountController completedAccountStep:AccountStateNewSignUpTimeZone
                                          model:(Model *)CorneaHolder.shared.settings.currentPerson
                               withAccountModel:CorneaHolder.shared.settings.currentAccount];
      
        RunOnMain(^{
            [self hideGif];
        });
    });
}

- (void) onAddressValidationDidComplete:(SmartstreetValidOperation)operation withData:(NSDictionary*)data {
    switch (operation) {
        case SmartstreetValidOperationUseUserTyped:
        case SmartstreetValidOperationUseThis:
            self.homeInfoData.smartyStreetsInfo = data;
            [self onAcceptEnteredAddress];
            break;

        case SmartstreetValidOperationEditUserTyped:
            [self onEditEnteredAddress];
            break;
    }
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
