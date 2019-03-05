//
//  LightsSwitchesTabbarController.m
//  i2app
//
//  Created by Arcus Team on 12/25/15.
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
#import "LightsSwitchesTabbarController.h"
#import "RDVTabBarItem.h"
#import "UIColor+Convert.h"

#import "LightsSwitchesDevicesController.h"
#import "SimpleTableViewController.h"
#import "LightSwitchScheduleController.h"

@interface LightsSwitchesTabbarController ()

@property (weak, nonatomic) LightsSwitchesDevicesController* devicesController;

@end

@implementation LightsSwitchesTabbarController

+ (LightsSwitchesTabbarController *)create {
    LightsSwitchesTabbarController *tabBarController = [[LightsSwitchesTabbarController alloc] init];
    
    [tabBarController setTitle:DashboardCardTypeToString(DashboardCardTypeLightsSwitches)];
    
    tabBarController.devicesController = [LightsSwitchesDevicesController createWithTabbar:tabBarController];
    [tabBarController setViewControllers:@[tabBarController.devicesController, [SimpleTableViewController createWithDelegate:[LightSwitchScheduleController new]]]];
    
    for (RDVTabBarItem *item in tabBarController.tabBar.items) {
        [item setSelectedTitleAttributes:[FontData getFont:FontDataType_DemiBold_12_White]];
        [item setUnselectedTitleAttributes:[FontData getFont:FontDataType_DemiBold_12_BlackUltraAlpha]];
    }
    return tabBarController;
}

- (void)enableEditButton:(BOOL)editing {
    [self navBarWithTitle:self.title andRightButtonText:editing ? @"Edit" : @"Done" withSelector:@selector(toggleEditState:)];
    [self hideTabbar:!editing];
}

- (void)hideEditButton {
    self.navigationItem.rightBarButtonItem = nil;
    [self navBarWithBackButtonAndTitle:self.title];
}

- (void)showEditButton {
    [self navBarWithTitle:self.title andRightButtonText:@"Edit" withSelector:@selector(toggleEditState:)];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];

    if (selectedIndex == 0) {
        [self showEditButton];
    }
    else {
        [self hideEditButton];
    }
}

- (void)toggleEditState:(id)sender {
    [self.devicesController toggleEditState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.title];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}


@end
