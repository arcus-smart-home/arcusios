//
//  DashboardFavoritesSettingController.m
//  i2app
//
//  Created by Arcus Team on 7/31/15.
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
#import "DashboardFavoritesSettingController.h"
#import "FavoriteOrderedManager.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ScaleSize.h"
#import "ImagePaths.h"
#import "ImageDownloader.h"
#import "UIImage+ImageEffects.h"
#import "DeviceCapability.h"
#import <i2app-Swift.h>

static NSString const *kKeyWord = @"keyWord";

@interface DashboardFavoritesSettingController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *analyticsToBeSent;

@end

@implementation DashboardFavoritesSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.4f]];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    
    [self navBarWithTitle:[NSLocalizedString(@"Favorites", nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(editFavorites:)];
    [self addBackButtonItemAsLeftButtonItem];
    
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];

    [ArcusAnalytics tag:AnalyticsTags.DashboardSettingsFavorites attributes:@{}];
    self.analyticsToBeSent = [NSMutableArray new];
}

+ (DashboardFavoritesSettingController *)create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)editFavorites:(id)sender {
    if (_tableView.editing) {
        [_tableView setEditing:NO animated: YES];
        [self navBarWithTitle:[NSLocalizedString(@"Favorites", nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(editFavorites:)];

        // sent any analytics that might have accumulated for removing or reodering favorites
        for (NSDictionary <NSString *, NSString *> *analyticsEntry in self.analyticsToBeSent) {
            if (analyticsEntry.allValues[0].length > 0) {
                [ArcusAnalytics tag:analyticsEntry.allKeys[0] attributes:@{ AnalyticsTags.TargetAddressKey : analyticsEntry.allValues[0] }];
            }
            else {
                [ArcusAnalytics tag:analyticsEntry.allKeys[0] attributes:@{}];
            }
        }
        [ArcusAnalytics tag:AnalyticsTags.DashboardSettingsFavoritesEditEnd attributes:@{}];
    }
    else {
        [_tableView setEditing:YES animated: YES];
        [self navBarWithTitle:[NSLocalizedString(@"Favorites", nil) uppercaseString] andRightButtonText:@"Done" withSelector:@selector(editFavorites:)];

        [ArcusAnalytics tag:AnalyticsTags.DashboardSettingsFavoritesEditStart attributes:@{}];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[FavoriteOrderedManager shareInstance] save];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FavoriteOrderedManager shareInstance] getCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DashboardFavoritesSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    FavoriteSettingModel *setting = [[FavoriteOrderedManager shareInstance] getModelByIndex:indexPath.row];
    [cell setFavoriteModel:setting];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *modelAddress = [[FavoriteOrderedManager shareInstance] switchCardOrder:sourceIndexPath.row to:destinationIndexPath.row];

    [self.analyticsToBeSent addObject:@{AnalyticsTags.DashboardSettingsFavoritesEditReorder : modelAddress}];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];

        [[FavoriteOrderedManager shareInstance] removeFavoriteByIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];

        [tableView endUpdates];
    }
}

@end


@implementation DashboardFavoritesSettingCell {
    FavoriteSettingModel *_setting;
}

- (void)setFavoriteModel:(FavoriteSettingModel *)setting {
    _setting = setting;
    
    DeviceModel *model = (DeviceModel *)[setting getModel];
    [_titleLabel styleSet:model.name andButtonType:FontDataType_Medium_12_White upperCase:YES];
    
    if ([model isKindOfClass:[DeviceModel class]]) {
        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:model] withDevTypeId:[model devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
            [_deviceIcon setImage:image];
        });
    }
    else if ([model isKindOfClass:[SceneModel class]]) {
        [_deviceIcon setImage:[[UIImage imageNamed:[@"scene_" stringByAppendingString:[((SceneModel *)model) getTemplateName]]] invertColor]];
    }
}

- (IBAction)pressedSelectButton:(id)sender {
    
}

@end




