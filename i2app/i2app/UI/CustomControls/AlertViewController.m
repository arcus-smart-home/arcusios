//
//  AlertViewController.m
//  i2app
//
//  Created by Arcus Team on 4/23/15.
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
#import "AlertViewController.h"
#import <PureLayout/PureLayout.h>
#import "ArcusLabel.h"
#import <i2app-Swift.h>

@interface AlertViewController ()

@property(nonatomic, strong) IBOutlet UIView *actionSheetView;
@property(nonatomic, weak) IBOutlet ArcusLabel *titleLabel;
@property(nonatomic, weak) IBOutlet ArcusLabel *messageLabel;

@end

@implementation AlertViewController {
    NSLayoutConstraint *bottomConstraint;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

- (void)setMessageString:(NSString *)messageString {
    _messageString = messageString;
    self.messageLabel.text = messageString;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.titleLabel.text = self.titleString;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.messageLabel.text = self.messageString;
    self.view.alpha = 0.0f;
}

- (void)slideIn {
    self.isUsing = YES;
    
    //set initial location at bottom of view
    [self.view autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    [self.view addSubview:self.actionSheetView];
    bottomConstraint = [self.actionSheetView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-200.0f];
    [self.actionSheetView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.actionSheetView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.actionSheetView autoSetDimension:ALDimensionHeight toSize:200.0f];
    self.view.alpha = 1.0f;
    [self.view layoutIfNeeded];
    
    self.actionSheetView.backgroundColor = pinkAlertColor;
    [UIView animateWithDuration:0.5f animations:^{
        bottomConstraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)slideInWhite {
  self.isUsing = YES;
  
  //set initial location at bottom of view
  [self.view autoPinEdgeToSuperviewEdge:ALEdgeTop];
  [self.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
  [self.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
  [self.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
  
  [self.view addSubview:self.actionSheetView];
  bottomConstraint = [self.actionSheetView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-200.0f];
  [self.actionSheetView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
  [self.actionSheetView autoPinEdgeToSuperviewEdge:ALEdgeRight];
  [self.actionSheetView autoSetDimension:ALDimensionHeight toSize:200.0f];
  self.view.alpha = 1.0f;
  [self.view layoutIfNeeded];
  
  self.doneButton.tintColor = [UIColor blackColor];
  self.doneButton.titleLabel.textColor = [UIColor blackColor];
  self.doneButton.alpha = 0.60;
  self.titleLabel.textColor = [UIColor blackColor];
  self.messageLabel.textColor = [UIColor blackColor];
  self.messageLabel.alpha = 0.60;
  self.actionSheetView.backgroundColor = [UIColor whiteColor];
  [UIView animateWithDuration:0.5f animations:^{
    bottomConstraint.constant = 0.0f;
    [self.view layoutIfNeeded];
  } completion:^(BOOL finished) {
    
  }];
}

- (IBAction)slideOut {
    [UIView animateWithDuration:0.5f animations:^{
        bottomConstraint.constant = 200.0f;
        self.view.alpha = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.actionSheetView removeFromSuperview];
        self.isUsing = NO;
    }];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [self.view removeFromSuperview];
        
        self.isUsing = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self slideOut];
}

@end



@interface TwoButtonAlertViewController ()

@end


@implementation TwoButtonAlertViewController

- (void) awakeFromNib {
    [super awakeFromNib];
    
    _mainText.attributedText = [FontData getString:[NSLocalizedString(@"Hub time out", nil) uppercaseString] withFont:FontDataTypeDeviceKeyfobSettingSheetTitle];
    _subText.attributedText = [FontData getString:[NSLocalizedString(@"Keep looking?", nil) uppercaseString] withFont:FontDataType_MediumMedium_12_BlackAlpha_NoSpace];
    
    [_yesButton styleSet:@"YES" andButtonType:FontDataTypeButtonDark upperCase:YES];
    [_noButton styleSet:@"NO" andButtonType:FontDataTypeButtonDark upperCase:YES];
    self.hubActionSheetView.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_yesButton styleSet:self.yesButtonTitle?self.yesButtonTitle:@"YES" andButtonType:self.yesButtonStyle upperCase:YES];
    [_noButton styleSet:self.noButtonTitle?self.noButtonTitle:@"NO" andButtonType:self.noButtonStyle upperCase:YES];
}

- (void)slideIn {
    self.isUsing = YES;
    
    //set initial location at bottom of view
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0, ((AppDelegate *)[UIApplication sharedApplication].delegate).window.bounds.size.height);
    frame.size.width = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.bounds.size.width;
    frame.size.height = 257;
    self.view.frame = frame;
    
    frame = self.hubActionSheetView.frame;
    frame.origin = CGPointMake(0.0, 0.0);
    frame.size.width = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.bounds.size.width;
    frame.size.height = 257;
    self.hubActionSheetView.frame = frame;

    [self.view addSubview:self.hubActionSheetView];

    [self.view layoutIfNeeded];

    //animate to new location, determined by height of the view in the NIB
    [UIView beginAnimations:@"presentWithSuperview" context:nil];
    self.view.alpha = 1.0f;
    [self.view layoutIfNeeded];
    frame.origin = CGPointMake(0.0, ((AppDelegate *)[UIApplication sharedApplication].delegate).window.bounds.size.height - self.hubActionSheetView.bounds.size.height);
    self.view.frame = frame;
    [UIView commitAnimations];
    
}

- (IBAction)slideOut {
    
    //do what you need to do with information gathered from the custom action sheet. E.g., apply data filter on parent view.
    [UIView beginAnimations:@"removeFromSuperviewWithAnimation" context:nil];
    
    // Set delegate and selector to remove from superview when animation completes
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.view.alpha = 0.0f;
    // Move this view to bottom of superview
    CGRect frame = self.hubActionSheetView.frame;
    frame.origin = CGPointMake(0.0, ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.bounds.size.height);
    self.hubActionSheetView.frame = frame;
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [self.view removeFromSuperview];
        
        self.isUsing = NO;
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self slideOut];
//}

@end
