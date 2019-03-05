//
//  AccountCreationHomeInfoViewController.m
//  i2app
//
//  Created by Arcus Team on 5/7/16.
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
#import "AccountCreationHomeInfoViewController.h"
#import "ArcusBaseHomeInfoViewController+Private.h"


#import "BuildConfigure.h"
#import "ImagePicker.h"
#import "SmartyStreets.h"
#import "SmartStreetTextField.h"
#import "SmartStreetValidationViewController.h"
#import "AccountCreationTimeZoneViewController.h"

#import "PinCodeEntryViewController.h"

@interface AccountCreationHomeInfoViewController ()

@end

@implementation AccountCreationHomeInfoViewController

#pragma mark - Creation
+ (AccountCreationHomeInfoViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CreateAccount" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AccountCreationHomeInfoViewController class])];
}

#pragma mark - IBActions
- (IBAction)nextButtonPressed:(id)sender {
    if ([self validateTextFields]) {
        
        NSString *street = self.addressOneTextField.text;
        if (self.addressTwoTextField.text.length > 0) {
            street = [street stringByAppendingFormat:@" %@",self.addressTwoTextField.text];
        }
        [self createGif];
        [SmartStreetValidationViewController smartyStreetsValidateStreet:street
                                                       city:self.cityTextField.text
                                                      state:self.stateButton.titleLabel.text
                                    addressToDisplayOnError:[self extractPrettyAddressFromTextFields]
                                                      owner:self
                                             completeHandle:^(SmartstreetValidOperation operation, NSDictionary *data) {
                                                 
                                                 if (operation == SmartstreetValidOperationUseThis) {
                                                     // Disabled popup window
                                                     [self saveRegistrationContext:data];
                                                 }
                                                 else if (operation == SmartstreetValidOperationUseUserTyped) {
                                                     [self saveRegistrationContext:nil];
                                                 }
                                                 else if (operation == SmartstreetValidOperationEditUserTyped) {
                                                     [self hideGif];
                                                 }
                                                 else {
                                                     [self hideGif];
                                                 }
                                             }];
    }
}

- (IBAction)photoButtonPressed:(id)sender {
    [[ImagePicker sharedInstance] presentImagePickerInViewController:self withImageId:@"ID" withCompletionBlock:^(UIImage *image) {
        if ([image isKindOfClass:[UIImage class]]) {
            [ImagePicker saveImage:image imageName:[[CorneaHolder shared] settings].currentPlace.modelId];
            
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

#pragma mark - Save Registration Context
- (void)saveRegistrationContext:(NSDictionary *)smartyStreetsDetails {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//      [AccountController configureAccountClientAgentInfo:[BuildConfigure clientAgentInfo] clientVersionInfo:[BuildConfigure clientVersionInfo]];

        [AccountController setPlaceDetails:self.homeNameTextField.text
                                      address1:self.addressOneTextField.text
                                      address2:self.addressTwoTextField.text
                                          city:self.cityTextField.text
                                         state:self.stateButton.titleLabel.text
                                    postalCode:self.zipTextField.text
                                       country:@"US"
                                    placeModel:[[CorneaHolder shared] settings].currentPlace
                                  accountModel:[[CorneaHolder shared] settings].currentAccount
                      smartyStreetsDetails:smartyStreetsDetails].then(^(NSDictionary *dict) {
            if (((NSString *)smartyStreetsDetails[@"metadata/time_zone"]).length == 0) {
                [self hideGif];
                AccountCreationTimeZoneViewController *vc = [AccountCreationTimeZoneViewController create];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    [AccountController completedAccountStep:AccountStateNewSignUpTimeZone
                                                          model:(Model *)[[CorneaHolder shared] settings].currentAccount
                                               withAccountModel:[[CorneaHolder shared] settings].currentAccount].then(^(NSDictionary *dict) {
                        [self hideGif];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        PinCodeEntryViewController *vc = [PinCodeEntryViewController create];
#pragma clang diagnostic pop
                        vc.pinViewMode = EnterPinViewModeAccountCreationFirstEntry;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                });
            }
        }).catch(^(NSError *error) {
            [self hideGif];
            [self displayErrorMessage:error.localizedDescription withTitle:@"Home Address Error"];
        });
    });
}

@end
