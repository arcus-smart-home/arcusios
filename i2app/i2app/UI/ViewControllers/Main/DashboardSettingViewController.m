//
//  DashboardSettingViewController.m
//  i2app
//
//  Created by Arcus Team on 7/29/15.
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
#import "DashboardSettingViewController.h"
#import "DashboardCardsSettingViewController.h"
#import "DashboardFavoritesSettingController.h"
#import "ImagePicker.h"
#import "AKFileManager.h"
#import "UIImage+ScaleSize.h"

#import <i2app-Swift.h>

@interface DashboardSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DashboardSettingViewController

+ (DashboardSettingViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithCloseButtonAndTitle:[NSLocalizedString(@"Settings", nil) uppercaseString]];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.4f]];

    self.titleLabel.text = NSLocalizedString(@"Customize your Dashboard and reorder your cards", nil);

    [ArcusAnalytics tag:AnalyticsTags.DashboardSettings attributes:@{}];
}


#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self premiumAccountCellForIndexPath:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    [self premiumAccountDidSelectIndexPath:indexPath];
}

#pragma mark - Changing Background Photo
- (void)changeBackgroundPhoto {
    [ArcusAnalytics tag:AnalyticsTags.DashboardSettingsBackground attributes:@{}];
    [[ImagePicker sharedInstance] presentImagePickerInViewController:self withImageId:nil withCompletionBlock:^(UIImage *image) {
        if ([image isKindOfClass:[UIImage class]]) {
            [ArcusSettingsHomeImageHelper saveHomeImage:image
                                                placeId:CorneaHolder.shared.settings.currentPlace.modelId];
            [self setCurrentBackgroup:image];

            [ArcusAnalytics tag:AnalyticsTags.DashboardSettingsBackgroundChanged attributes:@{}];
        }
    }];
}

#pragma mark - Premium account methods
- (DashboardSettingCell *)premiumAccountCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    DashboardSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    switch (indexPath.row) {
        case 0:
            [cell setTitle:NSLocalizedString(@"Favorites", nil) withSubtitle:NSLocalizedString(@"Reorder/hide Devices & Scenes", nil)];
            break;
        case 1:
            [cell setTitle:NSLocalizedString(@"Cards", nil) withSubtitle:NSLocalizedString(@"Reorder/hide Cards", nil)];
            break;
        case 2:
            [cell setTitle:NSLocalizedString(@"Background Photo", nil) withSubtitle:NSLocalizedString(@"Edit Photo", nil)];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)premiumAccountDidSelectIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[DashboardFavoritesSettingController create] animated:YES];
            break;

        case 1:
            [self.navigationController pushViewController:[DashboardCardsSettingViewController create] animated:YES];
            break;

        case 2:
            [self changeBackgroundPhoto];
            break;
            
        default:
            break;
    }
}

#pragma mark - Basic account methods
- (DashboardSettingCell *)basicAccountCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    DashboardSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    switch (indexPath.row) {
        case 0:
            [cell setTitle:NSLocalizedString(@"Cards", nil) withSubtitle:NSLocalizedString(@"Reorder/hide Cards", nil)];
            break;
        case 1:
            [cell setTitle:NSLocalizedString(@"Background Photo", nil) withSubtitle:NSLocalizedString(@"Edit Photo", nil)];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)basicAccountDidSelectIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[DashboardCardsSettingViewController create] animated:YES];
            break;

        case 1:
            [self changeBackgroundPhoto];
            break;
            
        default:
            break;
    }
}

@end


@interface DashboardSettingCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation DashboardSettingCell

- (void)setTitle:(NSString *)title withSubtitle:(NSString *)subtitle {
    [self.titleLabel styleSet:title andButtonType:FontDataType_DemiBold_13_White upperCase:YES];
    [self.subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
}


@end
