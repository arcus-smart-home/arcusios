//
//  PopupMessageViewController.m
//  i2app
//
//  Created by Arcus Team on 7/15/15.
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
#import "PopupMessageViewController.h"
#import "ArcusLabel.h"
#import <PureLayout/PureLayout.h>
#import "UIColor+Convert.h"
#import "UIImage+ImageEffects.h"

@interface PopupMessageViewController ()

@property (weak, nonatomic) IBOutlet ArcusLabel *titleLabel;
@property (weak, nonatomic) IBOutlet ArcusLabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *subtitleString;

@property (nonatomic) CGSize size;
@property (nonatomic) BOOL errorMessage;

@end

@implementation PopupMessageViewController

PopupMessageViewController *_controller;
NSLayoutConstraint *_buttomConstraint;

+ (void)popupWindow:(UIViewController *)owner
              title:(NSString *)title
            message:(NSString *)message {
    [self closePopup];

    _controller = [[PopupMessageViewController alloc] initWithNibName:@"PopupMessageViewController" bundle:nil];

    if (_controller.isOpening) {
        [_controller.view removeFromSuperview];
    }
    
    _controller.titleString = title;
    _controller.subtitleString = message;
    _controller.errorMessage = NO;

    [owner.view addSubview:_controller.view];

    _buttomConstraint = [_controller.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_controller.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_controller.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_controller.view autoSetDimension:ALDimensionHeight toSize:_controller.size.height + 120];
    _buttomConstraint.constant = [self heightForPopUp];
    [owner.view layoutIfNeeded];
    
    _controller.isOpening = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _buttomConstraint.constant = 0;
        [owner.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

+ (CGFloat)heightForPopUp {
    CGFloat desiredWidth = 300; // adjust accordingly

    NSDictionary *attributes = @{NSFontAttributeName : _controller.titleLabel.font};
    CGRect rect = [_controller.titleLabel.text
                         boundingRectWithSize:CGSizeMake(desiredWidth, CGFLOAT_MAX)
                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                         attributes:attributes context:nil];
    CGFloat titleSize = rect.size.height;

    attributes = @{NSFontAttributeName : _controller.messageLabel.font};
    rect = [_controller.messageLabel.text
                   boundingRectWithSize:CGSizeMake(desiredWidth, CGFLOAT_MAX)
                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                   attributes:attributes context:nil];
    CGFloat messageSize = rect.size.height;

    CGFloat textSize = titleSize + messageSize + 84.0f;

    CGFloat height = 230.0f;

    return MAX(textSize, height);
}

+ (void)popupErrorWindow:(UIView *)owner title:(NSString *)title message:(NSString *)message {
    [self closePopup];

    _controller = [[PopupMessageViewController alloc] initWithNibName:@"PopupMessageViewController" bundle:nil];
    
    if (_controller.isOpening) {
        [_controller.view removeFromSuperview];
    }
    
    _controller.titleString = title;
    _controller.subtitleString = message;
    _controller.errorMessage = YES;
    [_controller updateLabels];
    
    [owner addSubview:_controller.view];
    
    [_controller.view setBackgroundColor:pinkAlertColor];

    CGFloat height = [self heightForPopUp];

    _buttomConstraint = [_controller.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_controller.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_controller.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_controller.view autoSetDimension:ALDimensionHeight toSize:height];
    _buttomConstraint.constant = height;
    [owner layoutIfNeeded];
    
    _controller.isOpening = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _buttomConstraint.constant = 0;
        [owner layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)closePopup {
    if (_controller) {
        [_controller.view removeFromSuperview];
        [_controller removeFromParentViewController];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLabels];
}

- (void)updateLabels {
    self.titleLabel.text = _titleString;
    self.messageLabel.text = _subtitleString;

    if (_errorMessage) {
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.messageLabel.textColor = [UIColor whiteColor];
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
        [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.messageLabel styleSet:_subtitleString andButtonType:FontDataType_Medium_14_BlackAlpha_NoSpace];
    }
    
    _controller.size = [_controller.messageLabel.text boundingRectWithSize:CGSizeMake(_controller.messageLabel.bounds.size.width, FLT_MAX)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:14]}
                                                                   context:nil].size;
}

- (IBAction)pressedClose:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _buttomConstraint.constant = 230;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        _controller.isOpening = NO;
    }];

}

@end
