//
//  TutorialViewController.m
//  i2app
//
//  Created by Arcus Team on 4/25/16.
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
#import "TutorialViewController.h"
#import "ArcusLabel.h"
#import <PureLayout/PureLayout.h>
#import "CustomTutorialPageViewController.h"


@interface TutorialViewController ()

@property (strong, nonatomic) UIPageViewController *pageController;
@property (assign, nonatomic) BOOL shouldHideShowAgain;

@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) NSArray *pageLogos;

@end

@implementation TutorialViewController {
    NSArray <NSString *>    *_titles;
    NSArray <NSString *>    *_subtitles;
    NSArray <NSString *>    *_images;
    
    // Some of the controllers had to be done custom because they have a different
    // structure: more images, more text, formatted differently
    NSDictionary <NSNumber *, NSString *>  *_customViewControllers;
}


+ (TutorialViewController *)create {
    return [[UIStoryboard storyboardWithName:@"TutorialsStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

+ (TutorialViewController *)createWithType:(TuturialType)type andCompletionBlock:(TutorialCompletionBlock)block {
    TutorialViewController *vc = [self create];
    vc.tutorialType = type;
    vc.completionBlock = block;
    return vc;
}

+ (TutorialViewController *)createWithType:(TuturialType)type shouldHideShowAgain:(BOOL)hideShowAgain andCompletionBlock:(TutorialCompletionBlock)block {
    TutorialViewController *vc = [self createWithType:type andCompletionBlock:block];
    vc.shouldHideShowAgain = hideShowAgain;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializePages];
    
    [self createGradientBackgroundWithTopColor:[UIColor colorWithRed:110.f/255.f green:137.f/255.f blue:200.f/255.f alpha:1]
                                   bottomColor:[UIColor colorWithRed:77.f/255.f green:71.f/255.f blue:143.f/255.0f alpha:1]];
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Support", nil)];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    self.pageController.view.frame = self.view.bounds;
    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:0]];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)initializePages {
    switch (self.tutorialType) {
        case TuturialTypeIntro:
            _customViewControllers = nil;
            _titles = @[NSLocalizedString(@"Intro-title1", nil),
                        NSLocalizedString(@"Intro-title2", nil),
                        NSLocalizedString(@"Intro-title3", nil),
                        NSLocalizedString(@"Intro-title4", nil),
                        NSLocalizedString(@"Intro-title5", nil),
                        NSLocalizedString(@"Intro-title6", nil),
                        NSLocalizedString(@"Tutorials", nil)];
            
            _subtitles = @[NSLocalizedString(@"Intro-subtitle1", nil),
                           NSLocalizedString(@"Intro-subtitle2", nil),
                           NSLocalizedString(@"Intro-subtitle3", nil),
                           NSLocalizedString(@"Intro-subtitle4", nil),
                           NSLocalizedString(@"Intro-subtitle5", nil),
                           NSLocalizedString(@"Intro-subtitle6", nil),
                           NSLocalizedString(@"Tutorials-subtitle", nil)];
            
            _images = @[@"intro-screen1", @"intro-screen2", @"intro-screen3", @"intro-screen4", @"intro-screen5", @"intro-screen6", @"tutorial-support"];
            break;
            
        case TuturialTypeClimate:
            _customViewControllers = @{ @(0) : @"TutorialPageClimateIndex0ViewController" };
            _titles = @[@"",
                        NSLocalizedString(@"Climate-title2", nil),
                        NSLocalizedString(@"Climate-title3", nil),
                        NSLocalizedString(@"Climate-title4", nil),
                        NSLocalizedString(@"Tutorials", nil)];
            
            _subtitles = @[@"",
                           NSLocalizedString(@"Climate-subtitle2", nil),
                           NSLocalizedString(@"Climate-subtitle3", nil),
                           NSLocalizedString(@"Climate-subtitle4", nil),
                           NSLocalizedString(@"Tutorials-subtitle", nil)];
            
            _images = @[@"", @"climate-screen2", @"climate-screen3", @"climate-screen4", @"tutorial-support"];
            break;
            
        case TuturialTypeRules:
            _customViewControllers = @{ @(0) : @"TutorialPageRulesIndex0ViewController" };
            _titles = @[NSLocalizedString(@"Rules-title1", nil),
                        NSLocalizedString(@"Rules-title2", nil),
                        NSLocalizedString(@"Rules-title3", nil),
                        NSLocalizedString(@"Rules-title4", nil),
                        NSLocalizedString(@"Rules-title5", nil),
                        NSLocalizedString(@"Tutorials", nil)];
            
            _subtitles = @[NSLocalizedString(@"Rules-subtitle1", nil),
                           NSLocalizedString(@"Rules-subtitle2", nil),
                           NSLocalizedString(@"Rules-subtitle3", nil),
                           NSLocalizedString(@"Rules-subtitle4", nil),
                           NSLocalizedString(@"Rules-subtitle5", nil),
                           NSLocalizedString(@"Tutorials-subtitle", nil)];
            
            _images = @[@"", @"rules-screen2", @"rules-screen3", @"rules-screen4", @"rules-screen5", @"tutorial-support"];
            break;
            
        case TuturialTypeScenes:
            _customViewControllers = @{ @(0) : @"TutorialPageScenesIndex0ViewController", @(1) : @"TutorialPageScenesIndex1ViewController" };
            _titles = @[@"",
                        @"",
                        NSLocalizedString(@"Scenes-title3", nil),
                        NSLocalizedString(@"Scenes-title4", nil),
                        NSLocalizedString(@"Tutorials", nil)];
            
            _subtitles = @[@"",
                           @"",
                           NSLocalizedString(@"Scenes-subtitle3", nil),
                           NSLocalizedString(@"Scenes-subtitle4", nil),
                           NSLocalizedString(@"Tutorials-subtitle", nil)];
            
            _images = @[@"", @"", @"scenes-screen3", @"scenes-screen4", @"tutorial-support"];
            break;
            
        case TuturialTypeSecurity:
            _customViewControllers = @{ @(0) : @"TutorialPageSecurityIndex0ViewController", @(4) : @"TutorialPageSecurityIndex4ViewController" };
            _titles = @[@"",
                        NSLocalizedString(@"Security-title2", nil),
                        NSLocalizedString(@"Security-title3", nil),
                        NSLocalizedString(@"Security-title4", nil),
                        @"",
                        NSLocalizedString(@"Tutorials", nil)];
            
            _subtitles = @[@"",
                           NSLocalizedString(@"Security-subtitle2", nil),
                           NSLocalizedString(@"Security-subtitle3", nil),
                           NSLocalizedString(@"Security-subtitle4", nil),
                           @"",
                           NSLocalizedString(@"Tutorials-subtitle", nil)];
            
            _images = @[@"", @"security-screen2", @"security-screen3", @"security-screen4", @"", @"tutorial-support"];
            break;
            
        case TuturialTypeChoosePlaces:
            _customViewControllers = nil;
            _titles = @[NSLocalizedString(@"Tutorials-chooseplace-title1", nil)];
            _subtitles = @[NSLocalizedString(@"Tutorials-chooseplace-subtitle1", nil)];
            _images = @[@"Tutorials-chooseplace-screen1"];
            break;
            
        case TuturialTypeHistory:
            _customViewControllers = nil;
            _titles = @[NSLocalizedString(@"Tutorials-history-title", nil)];
            _subtitles = @[NSLocalizedString(@"Tutorials-history-subtitle1", nil)];
            _images = @[@"history_tutorial_image"];
            break;
            
        default:
            break;
    }
}

- (TutorialPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    NSString *vcId = _customViewControllers[@(index)];
    if (vcId.length > 0) {
        CustomTutorialPageViewController *customVC = [CustomTutorialPageViewController createWithStoryboardId:vcId];
        if (customVC) {
            customVC.pageIndex = index;
            customVC.tutorialType = self.tutorialType;
            return customVC;
        }
    }
    
    TutorialPageViewController *childViewController = [TutorialPageViewController create];
    childViewController.pageIndex = index;
    childViewController.tutorialType = self.tutorialType;
    childViewController.titleText = _titles[index];
    childViewController.instructionsText = _subtitles[index];
    childViewController.imageName = _images[index];
    childViewController.lastPageViewController = index == _titles.count - 1;
    childViewController.shouldHideShowAgain = self.shouldHideShowAgain;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(TutorialPageViewController *)viewController {
    
    NSUInteger index = viewController.pageIndex;
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;

    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(TutorialPageViewController *)viewController {
    
    NSUInteger index = viewController.pageIndex;
    
    index++;
    
    if (index == _titles.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return _titles.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
