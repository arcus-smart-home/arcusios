//
//  GeneralDeviceOperationController.m
//  i2app
//
//  Created by Arcus Team on 7/20/15.
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
#import "GeneralDeviceOperationController.h"
#import "DeviceAttributeItemBaseControl.h"

@interface GeneralDeviceOperationController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attributeViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonViewConstraint;

@end

@implementation GeneralDeviceOperationController

// Override
+ (DeviceOperationBaseController *)create {
    return [super createWithIdentifier:@"GeneralDeviceOperationController"];
}

+ (DeviceOperationBaseController *)createWithDeviceId:(NSString *)deviceId {
    return [super createWithIdentifier:@"GeneralDeviceOperationController" withDeviceID:deviceId];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadDeviceAbilities {
    _deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilitySecurityIcon | GeneralDeviceAbilityAttributesView;
}

- (void)viewDidLoad {
    [self loadDeviceAbilities];
    
    [super viewDidLoad];
    
    [_eventLabel setHidden:!(_deviceAbilities & GeneralDeviceAbilityEventLabel)];
    [_attributesView setHidden:!(_deviceAbilities & GeneralDeviceAbilityAttributesView)];
    
    //Disable the securityIcon icon
    self.securityIcon.hidden = YES;
    
    [_buttonsView setHidden:!(_deviceAbilities & GeneralDeviceAbilityButtonsView)];
    
    if ((_deviceAbilities & GeneralDeviceAbilityButtonsView) && (_deviceAbilities & GeneralDeviceAbilityAttributesView)) {
        if (IS_IPHONE_5) {
            _buttonViewConstraint.constant = 20;
            _attributeViewConstraint.constant = 160;
            _buttonsView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            _attributesView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }
        else {
            _buttonViewConstraint.constant = 30;
            _attributeViewConstraint.constant = 115;
        }
    }
    else {
        _attributeViewConstraint.constant = 50;
        _buttonViewConstraint.constant = 40;
    }
    
    if (IS_IPHONE_5) {
        _attributeViewConstraint.constant /= 2;
    }
    
    [self.view layoutIfNeeded];
}


@end
