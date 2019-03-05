//
//  ArcusBaseHomeInfoViewController+Private.h
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

#import "ArcusBaseHomeInfoViewController.h"
#import "CustomPickerController.h"
#import "AccountTextField.h"

#define CONSTRAINT_PRIORITY_SHOW_PRIMARY_RESIDENCE 250
#define CONSTRAINT_PRIORITY_HIDE_PRIMARY_RESIDENCE 230
#define ZIP_CODE_MAX_LENGTH 5

@interface ArcusBaseHomeInfoViewController ()

@property (weak, nonatomic) IBOutlet AccountTextField *homeNameTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *addressOneTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *addressTwoTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *cityTextField;
@property (weak, nonatomic) IBOutlet AccountTextField *zipTextField;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonToPrimaryResidenceTopConstraint;

@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *residenceButton;

- (IBAction)stateButtonPressed:(id)sender;
- (IBAction)photoButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)residenceButtonPressed:(id)sender;

#pragma mark - Utility
- (NSString *)extractPrettyAddressFromTextFields;

@end
