//
//  ErrorSheetController.m
//  i2app
//
//  Created by Arcus Team on 2/8/16.
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
#import "ErrorSheetController.h"

@implementation ErrorSheetModel

@end


@interface ErrorSheetController ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (strong, nonatomic) ErrorSheetModel *model;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end


@implementation ErrorSheetController {
    
}

+ (ErrorSheetController *)popup:(ErrorSheetModel *)model {
    ErrorSheetController *vc = [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.model = model;
    [model.popupController presentViewController:vc animated:YES completion:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_model.backgoundTopColor && _model.backgoundBottomColor) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.view.bounds;
        
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(0, 1);
        
        self.gradientLayer.locations = @[@(0.3f), @(1.0f)];
        [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
        
        self.gradientLayer.colors = @[(__bridge id)_model.backgoundTopColor.CGColor,
                                      (__bridge id)_model.backgoundBottomColor.CGColor];
    }
    
    if (_model.firstText) {
        [self.firstLabel setAttributedText:_model.firstText];
    } else {
        [self.firstLabel setText:@""];
    }
    
    if (_model.secondText) {
        [self.secondLabel setAttributedText:_model.secondText];
    } else {
        [self.secondLabel setText:@""];
    }
    
    if (_model.thirdText) {
        [self.thirdLabel setAttributedText:_model.thirdText];
    } else {
        [self.thirdLabel setText:@""];
    }
    
    if (_model.icon) {
        [self.iconImage setImage:_model.icon];
    }
    
    if (_model.buttonText) {
        [self.bottomButton setHidden:NO];
        [self.bottomButton styleSet:_model.buttonText andButtonType:FontDataTypeButtonLight upperCase:YES];
    } else {
        [self.bottomButton setHidden:YES];
    }
    
}
- (IBAction)onClickClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)onClickBottom:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_model.eventOwner && _model.onClickBottom) {
        if ([_model.eventOwner respondsToSelector:_model.onClickBottom]) {
            [_model.eventOwner performSelector:_model.onClickBottom withObject:nil afterDelay:0];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}


@end
