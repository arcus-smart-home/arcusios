//
//  PinCodeEntryViewController.h
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

#import <UIKit/UIKit.h>
#import "SettingsBaseViewController.h"

typedef NS_ENUM(NSInteger, EnterPinViewMode) {
    EnterPinViewModeAccountCreationFirstEntry,
    EnterPinViewModeAccountCreationConfirmation,
    EnterPinViewModeAccountSettingsFirstEntry,
    EnterPinViewModeAccountSettingsConfirmation,
    EnterPinViewModePersonUpdateFirstEntry,
    EnterPinViewModePersonUpdateConfirmation
};

@class AddPersonManager;


__attribute__((deprecated(("Subclass ArcusPinCodeViewController instead. See PersonChangePinViewController or AddPersonPinCodeEntryViewController for an example."))))
@interface PinCodeEntryViewController : SettingsBaseViewController

+ (PinCodeEntryViewController *)create;

@property (nonatomic, assign) EnterPinViewMode pinViewMode;
@property (nonatomic, strong) NSString *confirmationPin;
@property (nonatomic, strong) AddPersonManager *addPersonManager;
@property (nonatomic, strong) PersonModel *updatePersonModel;

@end
