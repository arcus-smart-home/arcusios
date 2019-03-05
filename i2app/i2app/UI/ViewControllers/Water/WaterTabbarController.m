//
//  WaterTabbarController.m
//  i2app
//
//  Created by Arcus Team on 1/13/16.
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
#import "WaterTabbarController.h"
#import "WaterDevicesController.h"
#import "WaterScheduleController.h"
#import "SimpleTableViewController.h"
#import "RDVTabBarItem.h"

@interface WaterTabbarController ()

@end

@implementation WaterTabbarController

+ (WaterTabbarController *)create {
    WaterTabbarController *tabBarController = [[WaterTabbarController alloc] init];
    
    [tabBarController setTitle:@"Water"];
    
    [tabBarController setViewControllers:@[[SimpleTableViewController createWithDelegate:[WaterDevicesController new]],
                                           [SimpleTableViewController createWithDelegate:[WaterScheduleController new]]]];
    
    for (RDVTabBarItem *item in tabBarController.tabBar.items) {
        [item setSelectedTitleAttributes:[FontData getFont:FontDataType_DemiBold_12_White]];
        [item setUnselectedTitleAttributes:[FontData getFont:FontDataType_DemiBold_12_BlackUltraAlpha]];
    }
    
    return tabBarController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.title];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


@end
