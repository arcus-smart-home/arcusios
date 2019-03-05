//
//  AddRuleCategoriesViewController.m
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
#import "AddRuleCategoriesViewController.h"
#import "ArcusImageTitleDescriptionTableViewCell.h"
#import "RuleRecommendedViewController.h"
#import "AlertActionSheetViewController.h"

#import "RulesController.h"
#import "PlaceCapability.h"
#import "Capability.h"
#import <i2app-Swift.h>

#import <PureLayout/PureLayout.h>

#define SECTION_HEADER_HEIGHT 30

@interface AddRuleCategoriesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *categoryTableView;
@property (nonatomic, strong) NSDictionary *categoryDictionary;
@property (nonatomic, strong) NSArray *sortedTitlesArray;

@end

@implementation AddRuleCategoriesViewController

#pragma mark - View LifeCylce

+ (AddRuleCategoriesViewController *)create {
    AddRuleCategoriesViewController *controller = [[UIStoryboard storyboardWithName:@"Rules" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AddRuleCategoriesViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
    self.categoryTableView.backgroundColor = [UIColor clearColor];

    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    [self setBackgroundColorToLastNavigateColor];
    
    [self fetchRuleCategories];
}

#pragma mark - Data Fetching

- (void)fetchRuleCategories {
    if ([[[[CorneaHolder shared] settings].currentPlace getAttribute:kAttrId] length] > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [RulesController listRuleCategoriesWithPlaceId:[[[CorneaHolder shared] settings].currentPlace getAttribute:kAttrId]].then(^(NSDictionary *categoryData) {
                
                if (categoryData.count > 0) {
                    self.categoryDictionary = categoryData;
                    
                    self.sortedTitlesArray = [self.categoryDictionary.allKeys sortedArrayUsingComparator:^(NSString *a, NSString *b) {
                        return [a caseInsensitiveCompare:b];
                    }];
                    
                }
                [self.categoryTableView reloadData];
            });
        });
    }
}

#pragma mark - Category Image Handling

- (UIImage *)imageForCategoryType:(NSString *)type {
    NSString *imageName = [[type stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"&" withString:@""].lowercaseString;
    return [UIImage imageNamed:imageName];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RuleCategoryCell";
    
    ArcusImageTitleDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (!cell) {
        cell = [[ArcusImageTitleDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:CellIdentifier];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    
    NSString *titleString = [self.sortedTitlesArray[indexPath.row] uppercaseString];
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:titleString
                                                                    attributes:[FontData getBlackFontWithSize:12.0f
                                                                                                         bold:NO
                                                                                                      kerning:2.0f]];
    [cell.titleLabel setAttributedText:titleText];
    
    NSDictionary *subTitleFontData = [FontData getItalicFontWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f] size:14.0 kerning:0.0];
    
    NSString *description = [NSString stringWithFormat:@"%i Rules", [[self.categoryDictionary objectForKey:self.sortedTitlesArray[indexPath.row]] intValue]];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:description
                                                                   attributes:subTitleFontData];
    [cell.descriptionLabel setAttributedText:descText];
    
    cell.detailImage.image = [self imageForCategoryType:self.sortedTitlesArray[indexPath.row]];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *ruleCategoryString = [self.sortedTitlesArray[indexPath.row] uppercaseString];
    [ArcusAnalytics tag:AnalyticsTags.RuleCategoryClick attributes:@{ AnalyticsTags.SelectedType : AnalyticsTags.RuleCategory,
                                                                   AnalyticsTags.SelectedItem : ruleCategoryString}];
  
    [self performSegueWithIdentifier:@"RuleCategorySegue" sender:self.sortedTitlesArray[indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [FontColors getCreationHeaderTextColor];
    label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
    label.text = NSLocalizedString(@"Choose a Category", nil);
    
    [view addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view withOffset:15.0f];
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [view addSubview:visualEffectView];
    [view sendSubviewToBack:visualEffectView];
    [visualEffectView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return SECTION_HEADER_HEIGHT;
}


#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RuleCategorySegue"]) {
        RuleRecommendedViewController *ruleRecommendedViewController = (RuleRecommendedViewController *)segue.destinationViewController;
        if (sender) {
            ruleRecommendedViewController.ruleCategory = (NSString *)sender;
        }
    }
}

@end
