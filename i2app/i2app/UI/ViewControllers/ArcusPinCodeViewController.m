//
//  ArcusPinCodeViewController.m
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

#import <i2app-Swift.h>
#import "ArcusPinCodeViewController.h"
#import "ArcusLabel.h"
#import "UIImage+ImageEffects.h"
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionWindow.h"

@interface ArcusPinCodeViewController ()

@property (nonatomic, strong) NSMutableArray *enteredValuesArray;
@property (nonatomic, strong) PopupSelectionWindow* popupWindow;

@end

@implementation ArcusPinCodeViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.enteredValuesArray = nil;
    [self updateEnteredPinTicks];
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

#pragma mark - Setters & Getters

- (NSString *)enteredPin {
    if (self.enteredValuesArray.count > 0) {
        _enteredPin = [self.enteredValuesArray componentsJoinedByString:@""];
    } else {
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
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(pinCodeEntryViewController:didEnterPin:)]) {
                [self.delegate pinCodeEntryViewController:self
                                              didEnterPin:self.enteredPin];
            }
        }
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.enteredValuesArray removeLastObject];
    [self updateEnteredPinTicks];
}

#pragma mark - Methods

- (void)clearPin {
    [self.enteredValuesArray removeAllObjects];
    [self updateEnteredPinTicks];
}

- (void) handleSetPinError:(NSError *)error {
    [self displayPinNotAvailableError];
    [self clearPin];
}

#pragma mark - Helper Methods

- (void) displayPinNotAvailableError {
  NSString *title = NSLocalizedString(@"PIN CODE NOT AVAILABLE", comment: @"");
  NSString *errorMessage = NSLocalizedString(@"Please choose a different PIN code.",
                                             comment: @"");
  
  PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:title
                                                                            subtitle:errorMessage
                                                                             buttons:nil];
  buttonView.owner = self;
  
  self.popupWindow = [PopupSelectionWindow popup:self.view
                                         subview:buttonView
                                           owner:self
                                   closeSelector:@selector(handleErrorClosePinNotAvailable)
                                           style:PopupWindowStyleCautionWindow];
  
}

#pragma mark - Callbacks

- (void)handleErrorClosePinNotAvailable {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
