//
//  SmartStreetTextField.m
//  i2app
//
//  Created by Arcus Team on 7/7/15.
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
#import "SmartStreetTextField.h"
#import "SmartyStreets.h"
#import "SmartStreetChooseViewController.h"
#import <PureLayout/PureLayout.h>

@interface SmartStreetTextField() <UITextFieldDelegate>

@end

@implementation SmartStreetTextField {
    SmartStreetChooseViewController *_smartSheetChooseController;
    streetblock _handler;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [super setAccountFieldType:AccountTextFieldTypeGeneral];
    
    [self addTarget:self action:@selector(sheetUpdated:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(sheetEnter:) forControlEvents:UIControlEventEditingDidEnd|UIControlEventEditingDidEndOnExit];
}

- (void)closeChooseWindow {
    if (_smartSheetChooseController&&_smartSheetChooseController.view) {
        [_smartSheetChooseController.view removeFromSuperview];
        [_smartSheetChooseController removeFromParentViewController];
        _smartSheetChooseController = nil;
    }
}

- (IBAction)sheetEnter:(id)sender {
    [self closeChooseWindow];
}

- (IBAction)sheetUpdated:(id)sender {
    if (!_smartSheetChooseController) {
        _smartSheetChooseController = [SmartStreetChooseViewController create:self];
        [self.superview addSubview:_smartSheetChooseController.view];
        
        [_smartSheetChooseController.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self];
        [_smartSheetChooseController.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_smartSheetChooseController.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_smartSheetChooseController.view autoSetDimension:ALDimensionHeight toSize:150];
    }
    
    [_smartSheetChooseController displayLoading];
    [SmartyStreets autoCompleteAddress:self.text withCompletionHandler:^(NSArray *data) {
        if ([data count] > 0) {
            [_smartSheetChooseController loadData:data];
        }
        else {
            [self closeChooseWindow];
        }
    }];
}

- (void)setupRequired:(BOOL)required chosenHandler:(streetblock)handler {
    [super setIsRequired:required];
    _handler = handler;
}

- (void)choseAddress:(SmartyStreetsAddress *)address {
    [self closeChooseWindow];
    if (_handler) _handler(address);
}

@end
