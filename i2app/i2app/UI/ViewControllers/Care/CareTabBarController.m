//
//  CareTabBarController.m
//  i2app
//
//  Created by Arcus Team on 1/28/16.
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
#import "CareTabBarController.h"
#import "CareTabRootViewController.h"
#import "CareActivityViewController.h"
#import "CareStatusViewController.h"
#import "CareMoreViewController.h"
#import "CareAlarmViewController.h"

#import "CareSubsystemCapability.h"

@interface CareTabBarController ()
@property (assign, nonatomic) BOOL alertDisplayed;
@end

@implementation CareTabBarController

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        [self setViewTitle:title];
        [self configureNavigationBar:NSLocalizedString([self viewTitle], nil)];
    }
    return self;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBar setHidden:YES];
    [self setAlertDisplayed:NO];

    [self configureTabBarItems];
    [self configureNavigationBar:NSLocalizedString([self viewTitle], nil)];
    [self configureBackgroundView];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(careAlarmModeEnabled:) name: [Model attributeChangedNotification:kAttrCareSubsystemAlarmMode] object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(careAlarmModeCleared:) name: [Model attributeChangedNotification:kCmdCareSubsystemClear] object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.shouldShowStatusOnAppear) {
        self.shouldShowStatusOnAppear = NO;
        [self setSelectedIndex:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

#pragma mark - Configuration

- (void)configureTabBarItems {
    UIStoryboard *careActivityStoryboard = [UIStoryboard storyboardWithName:@"CareActivity"
                                                                     bundle:nil];
    UIStoryboard *careStatusStoryboard = [UIStoryboard storyboardWithName:@"CareStatus"
                                                                     bundle:nil];
    UIStoryboard *careMoreStoryboard = [UIStoryboard storyboardWithName:@"CareMore"
                                                                     bundle:nil];
    
    if (careActivityStoryboard && careStatusStoryboard && careMoreStoryboard) {
        [self setViewControllers:@[[careActivityStoryboard instantiateInitialViewController],
                                   [careStatusStoryboard instantiateInitialViewController],
                                   [careMoreStoryboard instantiateInitialViewController]]];
    } else {
        DDLogInfo(@"configureTabBarItems missing view controllers: CareActivity - %@\nCareStatus - %@\nCareMore: %@", careActivityStoryboard, careStatusStoryboard, careMoreStoryboard);
    }
    
}


- (void)configureNavigationBar:(NSString *)title {
    if(title) {
        [self navBarWithBackButtonAndTitle:title];
    } else {
        [self navBarWithBackButtonAndTitle:@"CARE"];
    }
}

- (void)configureBackgroundView {
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (void)careAlarmModeEnabled:(NSNotification *)notification {
    [self setAlarming:YES];
    DDLogInfo(@"careAlarmModeEnabled: %@", notification);
}

- (void)careAlarmModeChanged:(NSNotification *)notification {
    [self setAlarming:NO];
    DDLogInfo(@"careAlarmModeChanged: %@", notification);
}

@end
