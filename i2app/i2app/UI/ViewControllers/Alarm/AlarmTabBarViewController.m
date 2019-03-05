//
//  AlarmTabBarViewController.m
//  i2app
//
//  Created by Arcus Team on 8/17/15.
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
#import "AlarmTabBarViewController.h"
#import "RDVTabBarItem.h"

#import "SafetyAlarmViewController.h"
#import "SecurityAlarmViewController.h"

#import "AlarmMoreViewControllerOld.h"

@interface AlarmTabBarViewController () <RDVTabBarControllerDelegate>

@end

@implementation AlarmTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.title];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

+ (AlarmTabBarViewController *)createWithType:(AlarmControllerType)type storyboard:(NSString *)storyboard withTitle:(NSString *)title {
    AlarmTabBarViewController *tabBarController = [[AlarmTabBarViewController alloc] init];
    switch (type) {
        case AlarmControllerSafetyAlarm:{
            tabBarController.title = NSLocalizedString(title, nil);
            AlarmBaseViewController *safetyAlarmViewController =[SafetyAlarmViewController createWithStoryboard:storyboard withOwner:tabBarController];
            safetyAlarmViewController.delegate = (id<AlarmSubsystemProtocol>)[[SubsystemsController sharedInstance] safetyController];
            [tabBarController setViewControllers:@[safetyAlarmViewController, [AlarmMoreViewControllerOld create:AlarmTypeSafety withStoryboard:storyboard]]];
        }
            break;
        case AlarmControllerSecurityAlarm:
            tabBarController.title = NSLocalizedString(title, nil);
            [tabBarController setViewControllers:@[[SecurityAlarmViewController createWithStoryboard:storyboard withOwner:tabBarController], [AlarmMoreViewControllerOld create:AlarmTypeSecurity withStoryboard:storyboard]]];
            break;
        default:
            break;
    }
    
    UIImage *finishedImage = nil;
    UIImage *unfinishedImage = nil;
    
    for (RDVTabBarItem *item in tabBarController.tabBar.items) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
    }
    
    return tabBarController;
}

@end
