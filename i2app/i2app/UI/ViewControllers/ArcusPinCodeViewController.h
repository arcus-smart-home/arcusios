//
//  ArcusPinCodeViewController.h
//  i2app
//
//  Created by Arcus Team on 4/28/16.
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

@class ArcusPinCodeViewController;
@class ArcusLabel;

@protocol PinCodeEntryDelegate <NSObject>

- (void)pinCodeEntryViewController:(ArcusPinCodeViewController *)viewController didEnterPin:(NSString *)pinCode;

@end

@interface ArcusPinCodeViewController : UIViewController

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *numericButtons;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *enteredPinIcons;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet ArcusLabel *infoLabel;

@property (nonatomic, assign) id<PinCodeEntryDelegate> delegate;

@property (nonatomic, strong) NSString *enteredPin;

- (IBAction)numericButtonPressed:(UIButton *)sender;

- (void)clearPin;

/**
  This method clears the current PIN and presents an error popup window if the error
  is due to the PIN being unavailable.
 */
- (void)handleSetPinError: (NSError *)error;

@end
