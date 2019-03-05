//
//  TutorialListViewController.m
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
#import "TutorialListViewController.h"
#import "ArcusTwoLabelTableViewSectionHeader.h"
#import "ArcusTitleDetailTableViewCell.h"
#import "WebViewController.h"
#import "TutorialViewController.h"
#import <i2app-Swift.h>

@interface TutorialListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *moreResourcesButton;

- (IBAction)moreResourcesButtonPressed:(id)sender;

@end

@implementation TutorialListViewController {
    NSArray     *_tableContent;
}
NSString *const sectionHeaderIdentifier = @"sectionHeader";

+ (TutorialListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"TutorialsStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Support", nil)];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.tableFooterView = [UIView new];

    self.tableView.separatorColor = [FontColors getStandardSeparatorColor];
    _tableContent = @[NSLocalizedString(@"Alarms".uppercaseString, nil),
                      NSLocalizedString(@"Introduction To Arcus".uppercaseString, nil),
                      NSLocalizedString(@"Climate".uppercaseString, nil),
                      NSLocalizedString(@"Rules".uppercaseString, nil),
                      NSLocalizedString(@"Scenes".uppercaseString, nil) ];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArcusTwoLabelTableViewSectionHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:sectionHeaderIdentifier];
    [self.moreResourcesButton styleSet:@"More Resources" andButtonType:FontDataTypeButtonLight upperCase:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TutorialListCell";

    ArcusTitleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (ArcusTitleDetailTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[_tableContent[indexPath.row] uppercaseString] attributes:[FontData getFont:FontDataTypeSettingsText]];
    
    [cell.titleLabel setAttributedText:titleString];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ArcusTwoLabelTableViewSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderIdentifier];
    sectionHeader.mainTextLabel.text = NSLocalizedString(@"Tutorials", nil);
    sectionHeader.accessoryTextLabel.text = nil;
    sectionHeader.hasBlurEffect = YES;
    sectionHeader.backingView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    return sectionHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TutorialViewController *vc = [TutorialViewController create];
    vc.tutorialType = (TuturialType)indexPath.row;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)moreResourcesButtonPressed:(id)sender {
    
    WebViewController *webView = [[WebViewController alloc] init];
    webView.urlString = [[NSURL Support] absoluteString];
    [self.navigationController pushViewController:webView animated:YES];
}
@end
