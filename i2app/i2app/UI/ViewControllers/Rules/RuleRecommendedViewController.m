//
//  RuleRecommendedViewController.m
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
#import "RuleRecommendedViewController.h"
#import "ArcusImageTitleDescriptionTableViewCell.h"
#import <PureLayout/PureLayout.h>
#import "UIColor+Convert.h"

#import "RulesController.h"
#import "PlaceCapability.h"
#import "RuleTemplateCapability.h"

#import "Capability.h"
#import "RuleSettingViewController.h"
#import <i2app-Swift.h>


@interface RuleRecommendedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *recommendedRuleTemplates;
@property (nonatomic, strong) NSArray *addlDevicesRequiredTemplates;

@end

@implementation RuleRecommendedViewController

#pragma mark - View LifeCycle

+ (RuleRecommendedViewController *)create {
    RuleRecommendedViewController *controller = [[UIStoryboard storyboardWithName:@"Rules" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([RuleRecommendedViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self navBarWithBackButtonAndTitle:[self.ruleCategory uppercaseString]];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    [self setBackgroundColorToLastNavigateColor];
    
    [self fetchRuleTemplatesForCategory];
}

#pragma mark - Data Fetching

- (void)fetchRuleTemplatesForCategory {
    if (self.ruleCategory) {
        if ([[[[CorneaHolder shared] settings].currentPlace getAttribute:kAttrId] length] > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                
                [RulesController listRulesForCategory:self.ruleCategory withPlaceId:[[[CorneaHolder shared] settings].currentPlace getAttribute:kAttrId]].then(^(NSArray *ruleTemplateData) {
                    NSMutableArray *recommendedTemplates = [[NSMutableArray alloc] init];
                    NSMutableArray *additionalTemplates = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *ruleTemplateDict in ruleTemplateData) {
                        RuleTemplateModel *ruleTemplate = [[RuleTemplateModel alloc] initWithAttributes:ruleTemplateDict];
                        
                        if ([[ruleTemplate getAttribute:@"ruletmpl:satisfiable"] boolValue]) {
                            [recommendedTemplates addObject:ruleTemplate];
                        }
                        else {
                            [additionalTemplates addObject:ruleTemplate];
                        }
                    }
                    
                    self.recommendedRuleTemplates = recommendedTemplates;
                    self.addlDevicesRequiredTemplates = additionalTemplates;
                    [self.tableView reloadData];
                });
            });
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? self.recommendedRuleTemplates.count : self.addlDevicesRequiredTemplates.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 88.0f;
    
    NSArray *ruleTemplates = (indexPath.section == 0) ? self.recommendedRuleTemplates : self.addlDevicesRequiredTemplates;
    RuleTemplateModel *ruleTemplate = ruleTemplates[indexPath.row];
    
    NSDictionary *subTitleFontData = [FontData getItalicFontWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f]
                                                                 size:14.0
                                                              kerning:0.0];
    
    NSString *description = [ruleTemplate getAttribute:@"ruletmpl:template"];
    description = [[description componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"${}"]] componentsJoinedByString:@""];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:description
                                                                   attributes:subTitleFontData];
    
    CGRect rect = [descText boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 45.0f, 10000)
                                         options:NSStringDrawingUsesLineFragmentOrigin |
                                                 NSStringDrawingUsesFontLeading
                                         context:nil];
    
    height = (rect.size.height + 45.0f > height) ? rect.size.height + 45.0f : height;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return ((section == 0 && self.recommendedRuleTemplates.count > 0) ||
            (section == 1 && self.addlDevicesRequiredTemplates.count > 0)) ? 30.0f : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    
    if ((section == 0 && self.recommendedRuleTemplates.count > 0) ||
        (section == 1 && self.addlDevicesRequiredTemplates.count > 0)) {

        header = [[UIView alloc] init];
        [header setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4f]];
        
        UILabel *titleLabel = [[UILabel alloc] initForAutoLayout];
        titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
        [titleLabel setText:(section == 0) ? NSLocalizedString(@"Recommended For You", nil) : NSLocalizedString(@"More Rules - Add'l Devices Required", @"")];
        
        [header addSubview:titleLabel];
        
        [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [titleLabel autoPinEdge:ALEdgeLeft
                         toEdge:ALEdgeLeft
                         ofView:header
                     withOffset:15.0f];
    }
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RuleCell";
    
    ArcusImageTitleDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (!cell) {
        cell = [[ArcusImageTitleDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:CellIdentifier];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    
    NSArray *ruleTemplates = (indexPath.section == 0) ? self.recommendedRuleTemplates : self.addlDevicesRequiredTemplates;

    RuleTemplateModel *ruleTemplate = ruleTemplates[indexPath.row];
    
    NSString *title = [ruleTemplate getAttribute:kAttrRuleTemplateName];
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:title.uppercaseString
                                                                    attributes:[FontData getBlackFontWithSize:12.0f
                                                                                                         bold:NO
                                                                                                      kerning:2.0f]];
    [cell.titleLabel setAttributedText:titleText];
    
    NSDictionary *subTitleFontData = [FontData getItalicFontWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f]
                                                                 size:14.0
                                                              kerning:0.0];

    NSString *description = [ruleTemplate getAttribute:kAttrRuleTemplateDescription];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:description
                                                                   attributes:subTitleFontData];
    [cell.descriptionLabel setAttributedText:descText];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *ruleTemplates = (indexPath.section == 0) ? self.recommendedRuleTemplates : self.addlDevicesRequiredTemplates;
    
    RuleTemplateModel *ruleTemplate = ruleTemplates[indexPath.row];
    NSString *title = [ruleTemplate getAttribute:kAttrRuleTemplateName];
    
    //Tag the rule that was selected and start a timer:
    [ArcusAnalytics tag:AnalyticsTags.RuleAdd attributes:@{ AnalyticsTags.SelectedItem : title }];

    [self performSegueWithIdentifier:@"TemplateSelectedSegue"
                              sender:ruleTemplate];
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TemplateSelectedSegue"]) {
        RuleSettingViewController *viewController = (RuleSettingViewController *)segue.destinationViewController;
        if ([sender isKindOfClass:[RuleTemplateModel class]]) {
            viewController.ruleTemplate = (RuleTemplateModel *)sender;
        }
    }
}

@end

