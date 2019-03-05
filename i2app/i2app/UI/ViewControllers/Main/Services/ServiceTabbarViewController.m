//
//  ServiceTabbarViewController.m
//  i2app
//
//  Created by Arcus Team on 9/2/15.
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
#import "ServiceTabbarViewController.h"
#import "RDVTabBarItem.h"
#import "UIColor+Convert.h"

#import "ServiceControlsViewController.h"

#import "DoorLockAccessViewController.h"
#import "DoorLockMoreViewController.h"

#import "ClimateTempViewController.h"
#import "ClimateMoreViewController.h"
#import "SimpleTableViewController.h"
#import "ClimateScheduleController.h"
#import "DoorLockScheduleController.h"

@interface ServiceTabbarViewController ()

@property (nonatomic) DashboardCardType cardType;

@end

@implementation ServiceTabbarViewController {
}

+ (ServiceTabbarViewController *)create:(DashboardCardType)type {
    ServiceTabbarViewController *tabBarController = [[ServiceTabbarViewController alloc] init];
    tabBarController.cardType = type;
    [tabBarController setTitle:DashboardCardTypeToString(type)];
    
    switch (type) {
        case DashboardCardTypeClimate: {
            [tabBarController setViewControllers:@[[ServiceControlsViewController create:type], [SimpleTableViewController createWithDelegate:[ClimateScheduleController new]], [ClimateTempViewController create], [ClimateMoreViewController create:type]]];
        }
            break;
        case DashboardCardTypeDoorsLocks:
            [tabBarController setViewControllers:@[[ServiceControlsViewController create:type], [DoorLockAccessViewController create], [SimpleTableViewController createWithDelegate:[DoorLockScheduleController new]], [DoorLockMoreViewController create]]];
            break;
        default:
            break;
    }
    
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


@end
