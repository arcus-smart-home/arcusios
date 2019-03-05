//
//  RulesTabBarController.m
//  i2app
//
//  Created by Arcus Team on 6/24/15.
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
#import "RulesTabBarController.h"
#import "AddRuleViewController.h"
#import "RDVTabBarItem.h"
#import "UIColor+Convert.h"
#import <i2app-Swift.h>

@interface RulesTabBarController ()

@end

@implementation RulesTabBarController


+ (RulesTabBarController *)create {
    RulesTabBarController *tabBarController = [[RulesTabBarController alloc] init];
    RuleListViewController *deviceRulesVC = [RuleListViewController create];

    tabBarController.title = NSLocalizedString(@"rules", nil);
    [tabBarController setViewControllers:@[[AddRuleViewController createWithTitle:NSLocalizedString(@"browse", nil)], deviceRulesVC]];

    UIImage *finishedImage = [UIColor UIImageWithColor:[UIColor UIColorFromRGB:238 green:242 blue:246]];
    UIImage *unfinishedImage = [UIColor UIImageWithColor:[UIColor UIColorFromRGB:238 green:242 blue:246]];
    
    for (RDVTabBarItem *item in tabBarController.tabBar.items) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        [item setSelectedTitleAttributes:[FontData getFont:FontDataType_DemiBold_14_Black]];
        [item setUnselectedTitleAttributes:[FontData getFont:FontDataType_DemiBold_14_BlackAlpha]];
    }
    
    return tabBarController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.title];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Add a Device", nil) rightButtonImageName:@"SearchButton" rightButtonSelector:@selector(search:)];
}

- (void)search:(id)sender {
    [self navBarWithSearchBar];
}


@end
