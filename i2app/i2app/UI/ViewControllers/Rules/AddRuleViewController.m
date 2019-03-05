//
//  AddRuleViewController.m
//  i2app
//
//  Created by Arcus Team on 6/23/15.
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
#import "AddRuleViewController.h"
#import "AddRuleCategoriesViewController.h"
#import "ArcusImageTitleDescriptionTableViewCell.h"

#define RL_TITLE @"title"
#define RL_DESCRIPTION @"subtitle"

@interface AddRuleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *rulesSections;

@end

@implementation AddRuleViewController {
    
    __weak IBOutlet NSLayoutConstraint *tableTopConstraint;
    
}

#pragma mark - View LifeCycle

+ (AddRuleViewController *)createWithTitle:(NSString *)title {
    AddRuleViewController *controller = [[UIStoryboard storyboardWithName:@"Rules" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AddRuleViewController class])];
    [controller setTitle:title];
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"Add a rule", nil);
    self.rulesSections =[[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.title];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self setBackgroundColorToDashboardColor];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    
    if (!self.parentViewController) {
        tableTopConstraint.constant = 49;
    }
    else {
        tableTopConstraint.constant = 64;
    }
}

#pragma mark - Getters & Setters

- (NSArray *)rulesSections {
    if (!_rulesSections) {
        // TEMP: Hardcoded data is intended for temporary use only.
        // TODO: Update to pull categories from Cornea.
        _rulesSections = @[@{@"title":@"explore by category",
                             @"subtitle":@"View all  rules organized by catgory",
                             @"backgroup": @"RuleBackground01"},
                           @{@"title":@"just for you",
                             @"subtitle":@"View all rules that are abailable to you based on devices that you own",
                             @"backgroup": @"RuleBackground02"},
                           @{@"title":@"get notified when a door opens",
                             @"subtitle":@"Stay on top of who's coming and going from your home",
                             @"backgroup": @"RuleBackground03"},
                           @{@"title":@"Featured: keen home rules",
                             @"subtitle":@"Intelligently heat and cool your home efficiently with rules provided by Keen Home",
                             @"backgroup": @"RuleBackground04"},
                           @{@"title":@"staring point",
                             @"subtitle":@"-",
                             @"backgroup": @"RuleBackground05"} ];
    }
    return _rulesSections;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rulesSections.count;
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
    
    NSDictionary *item = [self.rulesSections objectAtIndex:indexPath.item];
    
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:[item[RL_TITLE] uppercaseString]
                                                                    attributes:[FontData getBlackFontWithSize:12.0f
                                                                                                         bold:NO
                                                                                                      kerning:2.0f]];
    [cell.titleLabel setAttributedText:titleText];
    
    NSDictionary *subTitleFontData = [FontData getItalicFontWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f] size:14.0 kerning:2.0];
    
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:[item[RL_DESCRIPTION] uppercaseString]
                                                                   attributes:subTitleFontData];
    [cell.descriptionLabel setAttributedText:descText];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddRuleCategoriesViewController *vc = [AddRuleCategoriesViewController create];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
