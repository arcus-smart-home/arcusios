//
//  HomeFamilyTabBarViewController.m
//  i2app
//
//  Created by Arcus Team on 11/16/15.
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


#import "HomeFamilyTabBarViewController.h"
#import "RDVTabBarItem.h"

#import "HomeFamilyViewController.h"
#import "HomeFamilyMoreViewController.h"

@interface HomeFamilyTabBarViewController ()

@end

@implementation HomeFamilyTabBarViewController

+ (HomeFamilyTabBarViewController *)create {
    
    HomeFamilyTabBarViewController *tabBarController = [[HomeFamilyTabBarViewController alloc] init];
    tabBarController.title = NSLocalizedString(@"Home & Family", nil);
    
    [tabBarController setViewControllers:@[[HomeFamilyViewController create], [HomeFamilyMoreViewController create]]];
    
    UIImage *finishedImage = nil;
    UIImage *unfinishedImage = nil;
    
    for (RDVTabBarItem *item in tabBarController.tabBar.items) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
    }
    
    return tabBarController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightMiddleLevel];
    [self navBarWithBackButtonAndTitle: NSLocalizedString(@"Home & Family", nil)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Fix RDVTabBarController backgroup color issue
    [self.selectedViewController.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.view setBackgroundColor:[UIColor clearColor]];
    [self.parentViewController.navigationController.view setBackgroundColor:[UIColor clearColor]];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

