//
//  AccountNotificationViewController.m
//  i2app
//
//  Created by Arcus Team on 8/14/15.
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
#import "AccountNotificationViewController.h"

@interface AccountNotificationViewController ()

@property (weak, nonatomic) IBOutlet UIView *allowNotificationArea;
@property (weak, nonatomic) IBOutlet UIView *showOnLockArea;
@property (weak, nonatomic) IBOutlet UIImageView *deviceScreenArea;

@end

@implementation AccountNotificationViewController {
    
    __weak IBOutlet NSLayoutConstraint *subTextToMainTextConstraint;
    __weak IBOutlet NSLayoutConstraint *firstLabelToSubTextConstraint;
}

+ (AccountNotificationViewController *)create {
    return [[UIStoryboard storyboardWithName:@"AccountSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Notification", nil)];
    
    [self setBorder:_allowNotificationArea];
    [self setBorder:_showOnLockArea];
    [self setBorder:_deviceScreenArea];
    
    if (IS_IPHONE_5) {
        subTextToMainTextConstraint.constant = 5;
        firstLabelToSubTextConstraint.constant = 15;
    }
}

- (void)setBorder:(UIView *)viewArea {
    viewArea.layer.cornerRadius = 4.0f;
    viewArea.layer.borderColor = [UIColor blackColor].CGColor;
    viewArea.layer.borderWidth = 1.0f;
}

- (IBAction)pressedClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
