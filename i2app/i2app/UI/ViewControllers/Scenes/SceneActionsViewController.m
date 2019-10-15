//
//  SceneActionsViewController.m
//  i2app
//
//  Created by Arcus Team on 11/2/15.
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
#import "SceneActionsViewController.h"
#import <PureLayout/PureLayout.h>
#import "SceneManager.h"
#import "CommonIconTitleCellTableViewCell.h"
#import "OrderedDictionary.h"
#import "SceneController.h"
#import "SceneCapability.h"
#import "SceneActionDeviceController.h"
#import "SceneDeviceOptions.h"
#import "SimpleTableViewController.h"
#import "PopupSelectionButtonsView.h"
#import "ImagePaths.h"
#import "SDWebImageManager.h"
#import "UIImage+ImageEffects.h"


const int kNumberOfSections = 2;

@interface SceneActionsViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SceneActionsViewController {
    PopupSelectionWindow *_popupWindow;
}

+ (SceneActionsViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Scenes" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self navBarWithBackButtonAndTitle:@"Actions"];
    
    [self setBackgroundColorToDashboardColor];
    
    [self addOverlay:![SceneManager sharedInstance].isNewScene];
    
    [_tableView setBackgroundView:[UIView new]];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [SceneManager sharedInstance].satisfiableActions.count;
    }
    return [SceneManager sharedInstance].unsatisfiableActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonIconTitleCellTableViewCell *cell = [CommonIconTitleCellTableViewCell create:tableView];
    
    SceneAction *action;
    if (indexPath.section == 0) {
        action = [SceneManager sharedInstance].satisfiableActions[indexPath.row];
    }
    else {
        action = [SceneManager sharedInstance].unsatisfiableActions[indexPath.row];
    }
    
    if (action) {
        NSString *imageUrl = [ImagePaths getSceneActionImageUrl:action.hintString];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if ([SceneManager sharedInstance].isNewScene) {
                image = [image invertColor];
            }
            
            [cell setIcon:image withTitle:action.name subtitle:nil andSide:[[SceneManager sharedInstance].currentScene numberOfSelectorsForSceneAction:action] withBlackFont:[SceneManager sharedInstance].isNewScene ];
        }];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
    
    if (section >= kNumberOfSections) {
        return view;
    }
    NSString *key = section == 0 ? NSLocalizedString(@"Recommended For You", nil) : NSLocalizedString(@"Additional Service or Devices Required", nil);
    
    UILabel *label = [[UILabel alloc] initForAutoLayout];
    [label styleSet:key andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:[SceneManager sharedInstance].isNewScene space:NO]];
    
    [view addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view withOffset:15.0f];
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [view addSubview:visualEffectView];
    [view sendSubviewToBack:visualEffectView];
    [visualEffectView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [SceneManager sharedInstance].currentAction = [SceneManager sharedInstance].satisfiableActions[indexPath.row];

        if ([SceneManager sharedInstance].currentAction.type == SceneActionTypeSecurity) {
            SimpleTableViewController *vc = [SimpleTableViewController createWithDelegate:[SceneAlarmDeviceOptions create:[SceneManager sharedInstance].currentAction.selectors[0]]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            UIViewController *vc = [SceneActionDeviceController create];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else {
        PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"OOPS!", nil) subtitle:NSLocalizedString(@"You need to pair an additional device in order to choose this Action. ", nil) button:[PopupSelectionButtonModel createUnfilledStyle:NSLocalizedString(@"SHOP NOW", nil) event:@selector(shopNow)], nil];
        buttonView.owner = self;
        [self popup:buttonView complete:nil];
    }
}

- (void)shopNow {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""] options:@{} completionHandler:nil];
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)popupWarning:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector
                                         style:PopupWindowStyleCautionWindow];
}

@end
