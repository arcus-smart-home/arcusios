//
//  NotificationViewController.m
//  i2app
//
//  Created by Arcus Team on 7/9/15.
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
#import "NotificationViewController.h"
#import "PromoViewController.h"

#import <i2app-Swift.h>

@interface NotificationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation NotificationViewController

+ (NotificationViewController *)create {
  NotificationViewController *controller = [[UIStoryboard storyboardWithName:@"CreateAccount"
                                                                      bundle:nil]
                                            instantiateViewControllerWithIdentifier:NSStringFromClass([NotificationViewController class])];
  return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Notifications", nil) uppercaseString]];
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
}


- (IBAction)nextButtonPressed:(id)sender {
  [self createGif];
  [[RemoteNotificationHandler shared] registerForRemoteNotifications:[UIApplication sharedApplication]];

  [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"notificationAnswer"];
  [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:[SuccessAccountViewController create] animated:YES];
}

@end
