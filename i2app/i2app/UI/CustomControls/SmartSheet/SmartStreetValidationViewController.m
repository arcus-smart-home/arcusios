//
//  SmartStreetValidationViewController.m
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
#import "SmartStreetValidationViewController.h"
#import "SmartyStreets.h"
#import <PureLayout/PureLayout.h>
#import "i2app-Swift.h"

@interface SmartStreetValidationViewController ()

@property (strong, nonatomic) NSString *addressString;

@property (strong, nonatomic) NSDictionary *data;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *useUserTypedButton;
@property (weak, nonatomic) IBOutlet UIButton *editUserTypedButton;

@end

UIViewController    *_presentingVC;

@implementation SmartStreetValidationViewController {
    vaildCompletedBlock _completeBlock;
    smartyStreetsCompletedBlock _smartyCompleteBlock;
    __weak IBOutlet NSLayoutConstraint *buttomConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_titleLabel styleSet:NSLocalizedString(@"please confirm your address", nil) andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    
    [_useUserTypedButton styleSet:NSLocalizedString(@"use what I typed", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    [_editUserTypedButton styleSet:NSLocalizedString(@"edit what I typed", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
}

- (void)displayWindow:(vaildCompletedBlock)completeBlock {
    completeBlock = completeBlock;
    [self displayWindow];
}

- (void)displaySmartyWindow:(smartyStreetsCompletedBlock)completeBlock {
    _smartyCompleteBlock = completeBlock;
    [self displayWindow];
}

- (void)displayWindow {
    [_addressLabel styleSet:self.addressString andButtonType:FontDataType_DemiBold_18_BlackAlpha_NoSpace];
    buttomConstraint.constant = -self.view.bounds.size.height;
    [UIView animateWithDuration:.5f animations:^{
        buttomConstraint.constant = 0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeWindow {
    [UIView animateWithDuration:.5f animations:^{
        buttomConstraint.constant = -360;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

SmartStreetValidationViewController *vc;
+ (void)validateStreet:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString*)zip addressToDisplayOnError:(NSString *)addressToDisplay owner:(UIViewController *)owner completeHandle:(vaildCompletedBlock)completeBlock {
    _presentingVC = owner;
    NSString* currentPlaceId = [CorneaHolder.shared.settings.currentPlace modelId];
    
    [owner createGif];
    [ValidateAddressController verifyAddress:currentPlaceId street:street city:city state:state zip:zip completionHandler:^(BOOL isValid) {
        [owner hideGif];
        
        if (isValid) {
            completeBlock(isValid);
        } else {
            if (!vc) {
                vc = [[SmartStreetValidationViewController alloc] initWithNibName:@"SmartStreetValidationViewController" bundle:nil];
            }
            vc.addressString = addressToDisplay;
            [owner.view addSubview:vc.view];
            [vc.view autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [vc.view autoPinEdgeToSuperviewEdge:ALEdgeLeading];
            [vc.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [vc.view autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
            [vc.view layoutIfNeeded];
            [vc displayWindow:completeBlock];
        }
    }];
}

+ (void)smartyStreetsValidateStreet:(NSString *)street city:(NSString *)city state:(NSString *)state addressToDisplayOnError:(NSString *)addressToDisplay owner:(UIViewController *)owner completeHandle:(smartyStreetsCompletedBlock)completeBlock {
    _presentingVC = owner;
    [SmartyStreets verifyAddress:street withCity:city withState:state withCompletionHandler:^(NSDictionary *data) {
        if (data.count > 0) {
            completeBlock(SmartstreetValidOperationUseThis,data);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!vc) {
                    vc = [[SmartStreetValidationViewController alloc] initWithNibName:@"SmartStreetValidationViewController" bundle:nil];
                }
                [vc setData:data];
                vc.addressString = addressToDisplay;
                [owner.view addSubview:vc.view];
                [vc.view autoPinEdgeToSuperviewEdge:ALEdgeTop];
                [vc.view autoPinEdgeToSuperviewEdge:ALEdgeLeading];
                [vc.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                [vc.view autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
                [vc.view layoutIfNeeded];
                [vc displaySmartyWindow:completeBlock];
            });
        }
    }];
}


- (IBAction)onClickCloseButton:(id)sender {
    [self closeWindow];
    [_presentingVC hideGif];
}

- (IBAction)onClickUseUsers:(id)sender {
    if (_completeBlock) {
        _completeBlock(false);
    }
    
    if (_smartyCompleteBlock) {
        _smartyCompleteBlock(SmartstreetValidOperationUseUserTyped, self.data);
    }
    
    [self closeWindow];
}

- (IBAction)onClickEditAddress:(id)sender {
    [self hideGif];
    
    if (_smartyCompleteBlock) {
        _smartyCompleteBlock(SmartstreetValidOperationEditUserTyped, self.data);
    }
    
    [self closeWindow];
}

@end





