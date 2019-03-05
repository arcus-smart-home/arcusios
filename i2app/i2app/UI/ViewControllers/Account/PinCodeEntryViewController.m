//
//  PinCodeEntryViewController.m
//  i2app
//
//  Created by Arcus Team on 8/14/15.
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
#import "PinCodeEntryViewController.h"

#import "AKFileManager.h"
#import "UIImage+ImageEffects.h"

#import "PersonCapability.h"
#import "SuccessAccountViewController.h"
#import <i2app-Swift.h>

@interface PinCodeEntryViewController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *numericButtons;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *enteredPinIcons;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) NSString *enteredPin;
@property (nonatomic, strong) NSMutableArray *enteredValuesArray;

@end

@implementation PinCodeEntryViewController

#pragma mark - View LifeCycle

+ (PinCodeEntryViewController *)create {
    PinCodeEntryViewController *viewController = [[UIStoryboard storyboardWithName:@"AccountSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PinCodeEntryViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureViewForPinMode];
    
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
    
    [self configureInfoLabelForType];
}

#pragma mark - UI Configuration

- (void)updateEnteredPinTicks {
    for (UIImageView *pinIcon in self.enteredPinIcons) {
        [pinIcon setHighlighted:NO];
    }
    
    for (int i = 0; i < self.enteredValuesArray.count; i++) {
        for (UIImageView *pinIcon in self.enteredPinIcons) {
            if (pinIcon.tag == i) {
                [pinIcon setHighlighted:YES];
                break;
            }
        }
    }
}

- (void)configureInfoLabelForType {
    NSAttributedString *infoAttributedText;
    NSDictionary *attributes;
    if (self.pinViewMode == EnterPinViewModeAccountCreationFirstEntry ||
        self.pinViewMode == EnterPinViewModeAccountSettingsFirstEntry) {
        attributes = [FontData getWhiteFontWithSize:17.0f bold:NO];
        
        infoAttributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Enter your PIN code by \nentering a new 4-digit number.", @"") attributes:attributes];
    }
    else if (self.pinViewMode == EnterPinViewModeAccountCreationConfirmation ||
               self.pinViewMode == EnterPinViewModeAccountSettingsConfirmation) {
        attributes = [FontData getWhiteFontWithSize:17.0f bold:NO];
        
        infoAttributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Verify your new PIN by \nentering the 4-digit number again.", @"") attributes:attributes];
    }
    else if (self.pinViewMode == EnterPinViewModePersonUpdateFirstEntry) {
        attributes = [FontData getWhiteFontWithSize:17.0f bold:NO];
        
        infoAttributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Create a PIN code for this person.", @"") attributes:attributes];
    }
    else if (self.pinViewMode == EnterPinViewModePersonUpdateConfirmation) {
        attributes = [FontData getWhiteFontWithSize:17.0f bold:NO];
        
        infoAttributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please confirm the pin code.", @"") attributes:attributes];
    }
    
    if (infoAttributedText) {
        [self.infoLabel setAttributedText:infoAttributedText];
    }
}

- (void)configureViewForPinMode {
    [self setBackgroundColorToParentColor];
}

#pragma mark - Setters & Getters

- (EnterPinViewMode)pinViewMode {
    if (!_pinViewMode) {
        _pinViewMode = EnterPinViewModeAccountCreationFirstEntry;
    }
    return _pinViewMode;
}

- (NSString *)enteredPin {
    if (self.enteredValuesArray.count > 0) {
        _enteredPin = [self.enteredValuesArray componentsJoinedByString:@""];
    }
    else {
        _enteredPin = nil;
    }
    
    return _enteredPin;
}

- (NSMutableArray *)enteredValuesArray {
    if (!_enteredValuesArray) {
        _enteredValuesArray = [[NSMutableArray alloc] init];
    }
    return _enteredValuesArray;
}

#pragma mark - IBActions

- (IBAction)numericButtonPressed:(UIButton *)sender {
    if (self.enteredValuesArray.count < 4) {
        [self.enteredValuesArray addObject:sender.titleLabel.text];
        
        [self updateEnteredPinTicks];
        
        if (self.enteredValuesArray.count == 4) {
            if (self.pinViewMode == EnterPinViewModeAccountCreationFirstEntry ||
                self.pinViewMode == EnterPinViewModeAccountSettingsFirstEntry ||
                self.pinViewMode == EnterPinViewModePersonUpdateFirstEntry) {
                [self loadPinConfirmationView];
            }
            else if (self.pinViewMode == EnterPinViewModeAccountCreationConfirmation ||
                       self.pinViewMode == EnterPinViewModeAccountSettingsConfirmation ||
                       self.pinViewMode == EnterPinViewModePersonUpdateConfirmation) {
                [self savePinCode];
            }
        }
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.enteredValuesArray removeLastObject];
    [self updateEnteredPinTicks];
}

- (void)savePinCode {
    [self createGif];
    if ([self.enteredPin isEqualToString:self.confirmationPin]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            if (self.pinViewMode == EnterPinViewModeAccountCreationConfirmation) {
                [AccountController setPin:self.enteredPin
                                  personModel:CorneaHolder.shared.settings.currentPerson
                                   placeModel:CorneaHolder.shared.settings.currentPlace
                                 accountModel:CorneaHolder.shared.settings.currentAccount].thenInBackground(^(void) {

                    // Check if the user is adding a place as a guest and if so do not show the security questions
                  [PersonCapability getSecurityAnswersOnModel:[[CorneaHolder shared] settings].currentPerson].then(^(PersonGetSecurityAnswersResponse *response) {
                    [self hideGif];

                    if ([[response getSecurityAnswers] count] > 0) {
                      [self.navigationController pushViewController:[SuccessAccountViewController create] animated:YES];
                    } else {
                      SecurityQuestionsViewController *vc = [SecurityQuestionsViewController create];
                      [self.navigationController pushViewController:vc animated:YES];
                    }
                  }).catch(^(NSError *error) {
                    [self hideGif];
                    [self displayErrorMessage:error.localizedDescription];
                  });;
                }).catch(^(NSError *error) {
                    [self hideGif];
                    [self displayErrorMessage:error.localizedDescription];
                });
            }
            else if (self.pinViewMode == EnterPinViewModeAccountSettingsConfirmation) {
                [PersonController updatePin:self.enteredPin
                                onPlaceModel:CorneaHolder.shared.settings.currentPlace onModel:CorneaHolder.shared.settings.currentPerson].then(^(void) {
                    [self hideGif];
                    
                    [self popToPinOptionsViewController];
                }).catch(^(NSError *error) {
                    [self hideGif];
                    
                    [self displayErrorMessage:error.localizedDescription];
                });
            }
            if (self.pinViewMode == EnterPinViewModePersonUpdateConfirmation) {
                [PersonController updatePin:self.enteredPin
                                onPlaceModel:CorneaHolder.shared.settings.currentPlace onModel:self.updatePersonModel].then(^(void) {
                    [self hideGif];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }).catch(^(NSError *error) {
                    [self hideGif];
                    [self displayErrorMessage:error.localizedDescription];
                });
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideGif];
            [self displayErrorMessage:NSLocalizedStringFromTable(@"Please re-enter your pin code.", @"ErrorMessages", nil)];
            [self.enteredValuesArray removeAllObjects];
            [self updateEnteredPinTicks];
        });
    }
}

- (void)popToPinOptionsViewController {
    NSArray *viewControllers = [self.navigationController viewControllers];
    // TEMP - Popping to Account Settings view since PinCodeOptionsViewController is currently hidden.
    /* for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:[PinCodeOptionsViewController class]]) {
            [self.navigationController popToViewController:viewController
                                                  animated:YES];
        }
    } */
    
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:[AccountSettingsViewController class]]) {
            [self.navigationController popToViewController:viewController
                                                  animated:YES];
            break;
        }
    }

}

- (void)loadPinConfirmationView {
    PinCodeEntryViewController *confirmationViewController = [PinCodeEntryViewController create];
    if (self.pinViewMode == EnterPinViewModeAccountCreationFirstEntry) {
        confirmationViewController.pinViewMode = EnterPinViewModeAccountCreationConfirmation;
    }
    else if (self.pinViewMode == EnterPinViewModeAccountSettingsFirstEntry) {
        confirmationViewController.pinViewMode = EnterPinViewModeAccountSettingsConfirmation;
    }
    else if (self.pinViewMode == EnterPinViewModePersonUpdateFirstEntry) {
        confirmationViewController.pinViewMode = EnterPinViewModePersonUpdateConfirmation;
        confirmationViewController.updatePersonModel = self.updatePersonModel;
    }
    confirmationViewController.confirmationPin = self.enteredPin;
    
    if (self.addPersonManager) {
        confirmationViewController.addPersonManager = self.addPersonManager;
    }
    
    [self.navigationController pushViewController:confirmationViewController
                                         animated:YES];
}

@end
