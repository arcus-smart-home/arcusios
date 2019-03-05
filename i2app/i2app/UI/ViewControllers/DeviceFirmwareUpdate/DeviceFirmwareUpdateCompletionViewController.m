//
//  DeviceFirmwareUpdateFailureViewController.m
//  i2app
//
//  Created by Arcus Team on 10/12/15.
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
#import "DeviceFirmwareUpdateCompletionViewController.h"
#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"

@interface DeviceFirmwareUpdateCompletionViewController ()

@property (nonatomic, strong) IBOutlet UIButton *contactSupportButton;

@property (nonatomic, strong) NSString *primaryText;
@property (nonatomic, strong) NSString *secondaryText;

@end

@implementation DeviceFirmwareUpdateCompletionViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureNavigationBarWithCloseButton:YES];
    [self configureImageView];
    [self configureLabels];
    [self configureContactSupportButton];
}

#pragma mark - UI Configuration

- (void)configureImageView {
    self.iconImageView.image = self.updateSuccessful ? [UIImage imageNamed:@"checkedMark"] : [[UIImage imageNamed:@"alartHisotry"] invertColor];
}

- (void)configureLabels {
    NSAttributedString *primaryAttributedText = [[NSAttributedString alloc] initWithString:self.primaryText
                                                                                attributes:self.primaryTextAttributes];
    [self.primaryTextLabel setAttributedText:primaryAttributedText];
    
    NSAttributedString *secondaryAttributedText = [[NSAttributedString alloc] initWithString:self.secondaryText
                                                                                  attributes:self.secondaryTextAttributes];
    [self.secondaryTextLabel setAttributedText:secondaryAttributedText];
}

- (void)configureContactSupportButton {
    self.contactSupportButton.layer.cornerRadius = 4.0f;
    self.contactSupportButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.contactSupportButton.layer.borderWidth = 1.0f;
    [self.contactSupportButton styleSet:self.contactSupportButton.titleLabel.text
                            andFontData:[FontData createFontData:FontTypeDemiBold
                                                            size:12
                                                      blackColor:YES
                                                           space:YES]
                              upperCase:YES];
}

#pragma mark - Getters & Setters

- (NSString *)primaryText {
    if (!_primaryText) {
        _primaryText = self.updateSuccessful ? NSLocalizedString(@"Update Complete", nil) : NSLocalizedString(@"Update Failed", nil);
    }
    return _primaryText;
}

- (NSString *)secondaryText {
    if (!_secondaryText) {
        _secondaryText = self.updateSuccessful ? NSLocalizedString(@"Your device was successfully update.", nil) : NSLocalizedString(@"The update cannot be performed \nat this time. Please try again later. \nIf you continue to get this error, \nplease contact the number below.", nil);
    }
    return _secondaryText;
}


#pragma mark - IBActions

- (IBAction)contactSupportButtonPressed:(id)sender {
    NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@", self.contactSupportButton.titleLabel.text];
    [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneString]];
}

@end
