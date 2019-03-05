//
//  DeviceDetailsTabBarController.m
//  i2app
//
//  Created by Arcus Team on 5/30/15.
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
#import "DeviceDetailsTabBarController.h"
#import "RDVTabBarItem.h"
#import "DeviceControlViewController.h"
#import "DeviceMoreViewController.h"
#import "DeviceManager.h"
#import "UIViewController+AlertBar.h"
#import "AKFileManager.h"
#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"
#import "DeviceCapability.h"
#import "HubCapability.h"
#import <PureLayout/PureLayout.h>
#import "PopupMessageViewController.h"

#import <i2app-Swift.h>

@interface DeviceDetailsTabBarController () <RDVTabBarControllerDelegate>

@property (weak, nonatomic) UIViewController *moreViewController;

@property (nonatomic, readonly) DeviceModel *deviceModel;

@property (weak, nonatomic) id<DeviceDetailsTabBarDelegate> delegate;

@end

@implementation DeviceDetailsTabBarController

@dynamic deviceModel;
@dynamic delegate;

#pragma mark - Life Cycle
+ (DeviceDetailsTabBarController *)createWithModel:(Model *)device {
    
    DeviceDetailsTabBarController *tabBarController = [[DeviceDetailsTabBarController alloc] init];
    tabBarController.title = device.name;

    UIStoryboard *storyboard = [DeviceDetailsViewControllerFactory storyboard];
    UIViewController *moreViewController = [DeviceDetailsViewControllerFactory viewController:storyboard
                                                                                       device:(DeviceModel *)device];

    if ([moreViewController isKindOfClass:[DeviceMoreViewController class]]) {
        tabBarController.delegate = (DeviceMoreViewController *)moreViewController;
    }

    [tabBarController setViewControllers:@[[DeviceControlViewController createWithTabBarController:tabBarController andDeviceModel:(DeviceModel *)device], moreViewController]];

    UIImage *finishedImage = nil;
    UIImage *unfinishedImage = nil;
    
    for (RDVTabBarItem *item in tabBarController.tabBar.items) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
    }

    return tabBarController;
}

- (UIViewController *)moreViewController {
    if (!_moreViewController) {
      UIStoryboard *storyboard = [DeviceDetailsViewControllerFactory storyboard];
      _moreViewController = [DeviceDetailsViewControllerFactory viewController:storyboard
                                                                        device:self.deviceModel];
    }
    return _moreViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.title];
    
    [self setBackgroundColorToDashboardColor];

    [self addDarkOverlay:BackgroupOverlayLightMiddleLevel];

    [self setEdgesForExtendedLayout:UIRectEdgeTop];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceBackgroup:) name:kDeviceBackgroupUpdateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameChanged:) name:[Model attributeChangedNotification:kAttrDeviceName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameChanged:) name:[Model attributeChangedNotification:kAttrHubName] object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Fix RDVTabBarController backgroup color issue
    [self.selectedViewController.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.view setBackgroundColor:[UIColor clearColor]];
    [self.parentViewController.navigationController.view setBackgroundColor:[UIColor clearColor]];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Dynamic Properties
- (DeviceModel *)deviceModel {
    return ((DeviceControlViewController *)self.viewControllers[0]).deviceModel;
}

- (void)updateDeviceBackgroup:(NSNotification *)note {
    NSString *modelID = @"";
    if (note.object && [note.object isKindOfClass:[DeviceModel class]]) {
        modelID = ((DeviceModel *)note.object).modelId;
    }
    else {
        modelID = self.deviceModel.modelId;
    }
    
    if (modelID && modelID.length > 0) {
        UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:modelID
                                                                     atSize:[UIScreen mainScreen].bounds.size
                                                                  withScale:[UIScreen mainScreen].scale];
        
        if (image) {
            image = [image backgroundZoomScaleAndCutSizeInCenter:[UIScreen mainScreen].bounds.size];
            image = [image applyLightEffect];
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
            [self.view setNeedsLayout];
        }
        else {
            [self setBackgroundColorToDashboardColor];
        }
    }
}

- (void)nameChanged:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = self.deviceModel.name;
        [self navBarWithBackButtonAndTitle:self.title];
    });
}

- (void)onClickMore:(id)sender {
    [self.navigationController pushViewController:self.moreViewController animated:YES];
}

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    UIViewController *controller = [self.viewControllers objectAtIndex:index];
    if ([controller isKindOfClass:[DeviceMoreViewController class]]) {
        if (![(DeviceMoreViewController *)controller canSelect:self.deviceModel]) {
            [self popupUnreadyModeOn];
            return NO;
        }

        if (self.delegate) {
            [self.delegate deviceChanged:self.deviceModel];
        }

    }
    return [super tabBar:tabBar shouldSelectItemAtIndex:index];
}

- (void)popupUnreadyModeOn {
    [PopupMessageViewController popupWindow:self
                                      title:NSLocalizedString(@"FIRMWARE UPDATE", nil)
                                    message:NSLocalizedString(@"\"More\" can not be accessed while firmware updating", nil)];
}


// override for clear the backgroup
- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    [super tabBar:tabBar didSelectItemAtIndex:index];
    
    [self.selectedViewController.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.view setBackgroundColor:[UIColor clearColor]];
    [self.parentViewController.navigationController.view setBackgroundColor:[UIColor clearColor]];
}

@end




