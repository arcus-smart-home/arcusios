//
//  CareAddBehaviorsCategoriesViewController.m
//  i2app
//
//  Created by Arcus Team on 2/4/16.
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
#import "CareAddBehaviorsCategoriesViewController.h"
#import "ArcusTitleDetailTableViewCell.h"
#import "SubsystemsController.h"
#import "CareSubsystemController.h"
#import "CareSubsystemCapability.h"
#import "CareBehaviorTemplateModel.h"
#import "CareAddEditBehaviorViewController.h"
#import "CareBehaviorCategorySectionHeaderView.h"

@interface CareAddBehaviorsCategoriesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation CareAddBehaviorsCategoriesViewController {
    NSArray *_behaviorsTemplates;
    NSArray *_recommendedTemplates;
    NSArray *_devicesRequiredTemplates;
}

#pragma mark - Creation
+ (CareAddBehaviorsCategoriesViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CareBehaviors" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareAddBehaviorsCategoriesViewController class])];
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navBarWithBackButtonAndTitle:@"ADD CARE BEHAVIOR"];
    [self setBackgroundColorToDashboardColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    [self loadData];
}

#pragma mark - Data
- (void)loadData {
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[SubsystemsController sharedInstance].careController listBehaviorTemplates].then(^(NSArray *templateData) {
            _behaviorsTemplates = templateData;
            [self filterTemplatesIntoRecommendedAndNot:_behaviorsTemplates];
            [self hideGif];
            [self updateUI];
        });
    });
}

#pragma mark - UI
- (void)updateUI {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_behaviorsTemplates) {
        return 0;
    }
    
    if (_recommendedTemplates.count == 0 || _devicesRequiredTemplates.count == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && _recommendedTemplates.count != 0) {
        return _recommendedTemplates.count;
    }
    return _devicesRequiredTemplates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusTitleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"behaviorCell"];
    
    CareBehaviorTemplateModel *template = [self templateForIndexPath:indexPath];
    
    [cell.titleLabel setText:template.name];
    [cell.descriptionLabel setText:template.templateDescription];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CareBehaviorTemplateModel *template = [self templateForIndexPath:indexPath];
    CareAddEditBehaviorViewController *vc = [CareAddEditBehaviorViewController createWithTemplate:template];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CareBehaviorCategorySectionHeaderView *view = [tableView dequeueReusableCellWithIdentifier:@"sectionHeader"];
    NSString *headerText;
    
    if (section == 0 && _recommendedTemplates.count != 0) {
        headerText = @"Recommended For You";
    } else {
        headerText = @"More Behaviors - Add'l Devices Required";
    }
    
    [view.mainLabel setText:headerText];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0f;
}

#pragma mark - Helper
- (void)filterTemplatesIntoRecommendedAndNot:(NSArray *)templates {
    NSMutableArray *recommendedTemplates = [NSMutableArray array];
    NSMutableArray *additionalDevicesRequiredTemplates = [NSMutableArray array];
    
    for (CareBehaviorTemplateModel *template in templates) {
        if (template.availableDevices.count > 0) {
            [recommendedTemplates addObject:template];
        } else {
            [additionalDevicesRequiredTemplates addObject:template];
        }
    }
    
    _recommendedTemplates = recommendedTemplates;
    _devicesRequiredTemplates = additionalDevicesRequiredTemplates;
}

- (CareBehaviorTemplateModel *)templateForIndexPath:(NSIndexPath *)indexPath {
    CareBehaviorTemplateModel *template;
    
    if (indexPath.section == 0 && _recommendedTemplates.count != 0) {
        template = _recommendedTemplates[indexPath.row];
    } else {
        template = _devicesRequiredTemplates[indexPath.row];
    }
    
    return template;
}

@end
