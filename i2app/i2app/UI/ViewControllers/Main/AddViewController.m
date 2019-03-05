//
//  AddViewController.m
//  i2app
//
//  Created by Arcus Team on 5/21/15.
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
#import "AddViewController.h"
#import "DevicePairingWizard.h"
#import "ChooseDeviceViewController.h"
#import "CreateFavoriteLandingViewController.h"
#import "AddRuleCategoriesViewController.h"

#import "UIViewController+AlertBar.h"
#import "ChooseSceneViewController.h"
#import "AlertActionSheetViewController.h"
#import "CareAddBehaviorsCategoriesViewController.h"
#import "CarePremiumRequiredViewController.h"
#import "TutorialViewController.h"
#import "AddAPlaceAccountOwnerHomeInfoViewController.h"
#import "AddAPlaceGuestHomeInfoViewController.h"
#import <i2app-Swift.h>

#define NUMBER_OF_CELLS_FOR_ACCOUNT_OWNERS 7
#define NUMBER_OF_CELLS_FOR_NON_ACCOUNT_OWNERS 6

typedef NS_ENUM(NSInteger, AddScreenCell) {
    AddScreenCellHub,
    AddScreenCellPlace,
    AddScreenCellPerson,
    AddScreenCellDevice,
    AddScreenCellCareBehavior,
    AddScreenCellRule,
    AddScreenCellScene,
    AddScreenCellArcus
};

@interface AddViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon;

@end

@interface AddViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isAnAccountOwner;
@property (assign, nonatomic) BOOL currentPlaceBelongsToCurrentPerson;

@end

@implementation AddViewController

#pragma mark - Life Cycle
+ (AddViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"add", nil)];
    [self setBackgroundColorToDashboardColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    self.tableView.estimatedRowHeight = 70.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    PlaceModel *currentPlace = CorneaHolder.shared.settings.currentPlace;
    AccountModel *currentAccount = CorneaHolder.shared.settings.currentAccount;
    PersonModel *currentPerson = CorneaHolder.shared.settings.currentPerson;
    NSString *personCurrPlaceString = nil;
    if (currentPerson != nil) {
      personCurrPlaceString = [PersonCapability getCurrPlaceFromModel:currentPerson];
    }
    self.isAnAccountOwner = ![[NSNull null] isEqual:personCurrPlaceString] && personCurrPlaceString.length > 0;
    self.currentPlaceBelongsToCurrentPerson = [currentPerson ownsAccount:currentAccount] && [currentAccount ownsPlace:currentPlace];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self closePopupAlert];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL shouldShowAddHubAndPlace = self.isAnAccountOwner && self.currentPlaceBelongsToCurrentPerson;

    return shouldShowAddHubAndPlace ? NUMBER_OF_CELLS_FOR_ACCOUNT_OWNERS : NUMBER_OF_CELLS_FOR_NON_ACCOUNT_OWNERS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    AddScreenCell cellType = [self cellTypeForIndexPath:indexPath];
    [cell setTitle:[self titleForCellType:cellType]
          subtitle:[self subtitleForCellType:cellType]
              icon:[self imageForCellType:cellType]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch ([self cellTypeForIndexPath:indexPath]) {
        case AddScreenCellHub:
            if ([[CorneaHolder shared] settings].currentHub) {
              [self performSegueWithIdentifier:@"hubAlreadyPairedPopupSegue" sender:self];
            }
            else {
                UIViewController *vc = [HubPairingBuilder buildHubOrKit];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;

        case AddScreenCellPlace:
            [self.navigationController pushViewController:[AddAPlaceAccountOwnerHomeInfoViewController create] animated:YES];
            [ArcusAnalytics tag:AnalyticsTags.AddPlaceClick attributes:@{}];
            break;
            
        case AddScreenCellPerson:
            [self.navigationController pushViewController:[AddPersonTypeSelectionViewController create] animated:YES];

            [ArcusAnalytics tag:AnalyticsTags.AddPersonClick attributes:@{}];
            break;
            
        case AddScreenCellDevice: {
            [ArcusAnalytics tag:AnalyticsTags.AddDeviceClick attributes:@{}];
            CatalogBrandListViewController* vc = [CatalogBrandListViewController create];
            if (vc != nil) {
              [self.navigationController pushViewController: vc animated:YES];
            }
            break;
        }
            
        case AddScreenCellCareBehavior:
            if ([CorneaHolder.shared.settings isPremiumAccount]) {
                [ArcusAnalytics tag:AnalyticsTags.AddBehaviorClick attributes:@{}];
                [self.navigationController pushViewController:[CareAddBehaviorsCategoriesViewController create] animated:YES];
            }
            else {
                [self.navigationController presentViewController:[CarePremiumRequiredViewController create] animated:YES completion:nil];
            }
            break;
            
        case AddScreenCellRule: {
            if ([[CorneaHolder shared] settings].displayRulesTutorial) {
                TutorialViewController *vc = [TutorialViewController createWithType:TuturialTypeRules andCompletionBlock:^{
                    [self displayRulesListViewController];
                }];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else {
                [self displayRulesListViewController];
            }
            break;
        }

        case AddScreenCellScene:
            if ([[CorneaHolder shared] settings].displayScenesTutorial) {
                TutorialViewController *vc = [TutorialViewController createWithType:TuturialTypeScenes andCompletionBlock:^{
                    [self displayScenesListViewController];
                }];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else {
                [self displayScenesListViewController];
            }
            break;
            
        case AddScreenCellArcus:
            if (self.isAnAccountOwner) {
                [self popupMessageWindow:NSLocalizedString(@"Add a Place", nil) subtitle:NSLocalizedString(@"Add screen must switch to add place", nil)];
            } else {
                [self.navigationController pushViewController:[AddAPlaceGuestHomeInfoViewController create] animated:YES];
            }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)displayRulesListViewController {
    [ArcusAnalytics tag:AnalyticsTags.AddRuleClick attributes:@{}];
    [self.navigationController pushViewController:[AddRuleCategoriesViewController create] animated:YES];
}

- (void)displayScenesListViewController {
    [ArcusAnalytics tag:AnalyticsTags.AddSceneClick attributes:@{}];
    [self.navigationController pushViewController:[ChooseSceneViewController create] animated:YES];
}

#pragma mark - Helpers
- (NSString *)titleForCellType:(AddScreenCell)type {
    NSString *title = nil;
    
    switch (type) {
        case AddScreenCellHub:
            title = @"Hub";
            break;
        
        case AddScreenCellPlace:
            title = @"Place";
            break;
            
        case AddScreenCellPerson:
            title = @"Person";
            break;
        
        case AddScreenCellDevice:
            title = @"Device";
            break;
            
        case AddScreenCellCareBehavior:
            title = @"Care Behavior";
            break;
        
        case AddScreenCellRule:
            title = @"Rule";
            break;
        
        case AddScreenCellScene:
            title = @"Scene";
            break;
        
        case AddScreenCellArcus:
            title = @"Add Arcus to Your Home";
            break;
    }
    
    return NSLocalizedString(title, nil);
}

- (NSString *)subtitleForCellType:(AddScreenCell)type {
    NSString *subtitle = nil;
    
    switch (type) {
        case AddScreenCellHub:
            subtitle = @"The Heart of the System";
            break;
            
        case AddScreenCellPlace:
            subtitle = @"Add Additional Places (e.g. Vacation Home)";
            break;
            
        case AddScreenCellPerson:
            subtitle = @"Invite Someone";
            break;
            
        case AddScreenCellDevice:
            subtitle = @"Pair a Device to Arcus";
            break;
            
        case AddScreenCellCareBehavior:
            subtitle = @"Trigger a Care Alarm when a loved one's routine is out of the ordinary.";
            break;
            
        case AddScreenCellRule:
            subtitle = @"Connect & Automate Devices";
            break;
            
        case AddScreenCellScene:
            subtitle = @"Control Several Devices at Once";
            break;
            
        case AddScreenCellArcus:
            subtitle = @"Turn your home into a smart home.";
            break;
    }
    
    return NSLocalizedString(subtitle, nil);
}

- (UIImage *)imageForCellType:(AddScreenCell)type {
    NSString *imageName = nil;
    
    switch (type) {
        case AddScreenCellHub:
            imageName = @"icon_hub";
            break;
            
        case AddScreenCellPlace:
            imageName = @"add_icon_place";
            break;
            
        case AddScreenCellPerson:
            imageName = @"icon_person";
            break;
            
        case AddScreenCellDevice:
            imageName = @"icon_devices";
            break;
            
        case AddScreenCellCareBehavior:
            imageName = @"care";
            break;
            
        case AddScreenCellRule:
            imageName = @"icon_rules";
            break;
            
        case AddScreenCellScene:
            imageName = @"scene";
            break;
            
        case AddScreenCellArcus:
            imageName = @"add_icon_place";
            break;
    }
    
    return [UIImage imageNamed:imageName];
}

- (AddScreenCell)cellTypeForIndexPath:(NSIndexPath *)indexPath {
    //shouldShowAddHubAndPlace being false means we show add arcus instead
    BOOL shouldShowAddHubAndPlace = self.isAnAccountOwner && self.currentPlaceBelongsToCurrentPerson;
    
    switch (indexPath.row) {
        case 0:
            return shouldShowAddHubAndPlace ? AddScreenCellHub : AddScreenCellArcus;
            
        case 1:
            return shouldShowAddHubAndPlace ? AddScreenCellPlace : AddScreenCellPerson;
            
        case 2:
            return shouldShowAddHubAndPlace ? AddScreenCellPerson : AddScreenCellDevice;
            
        case 3:
            return shouldShowAddHubAndPlace ? AddScreenCellDevice : AddScreenCellCareBehavior;
            
        case 4:
            return shouldShowAddHubAndPlace ? AddScreenCellCareBehavior : AddScreenCellRule;
            
        case 5:
            return shouldShowAddHubAndPlace ? AddScreenCellRule : AddScreenCellScene;
            
        case 6:
            return AddScreenCellScene;
            
        default:
            return AddScreenCellScene;
    }
}

@end


@implementation AddViewCell

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon {
    [self.titleLabel styleSet:title andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
    [self.subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_14_BlackAlpha_NoSpace];
    if (icon) {
        [self.iconImage setImage:icon];
    }
    [self layoutIfNeeded];
}

@end

