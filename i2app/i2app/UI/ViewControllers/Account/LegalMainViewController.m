//
//  LegalMainViewController.m
//  i2app
//
//  Created by Arcus Team on 8/24/15.
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
#import "LegalMainViewController.h"
#import "ArcusTitleDetailTableViewCell.h"
#import "WebViewController.h"

#define LO_TITLE @"Title"
#define LO_DESCRIPTION @"Description"

@interface LegalMainViewController ()

@property (nonatomic, strong) IBOutlet UITableView *legalTableView;
@property (nonatomic, strong) NSArray *legalOptions;

@end

@implementation LegalMainViewController

#pragma mark - View LifeCycle

+ (LegalMainViewController *)create {
    LegalMainViewController *viewController = [[UIStoryboard storyboardWithName:@"AccountSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([LegalMainViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.legalTableView.backgroundColor = [UIColor clearColor];
    self.legalTableView.backgroundView = nil;
    
    [self setBackgroundColorToParentColor];
    
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
    
    self.legalTableView.scrollEnabled = NO;
}

#pragma mark - Setters & Getters

- (NSArray *)legalOptions {
    if (!_legalOptions) {
        _legalOptions = @[@{LO_TITLE : NSLocalizedString(@"Terms of Service", @""),
                            LO_DESCRIPTION : NSLocalizedString(@"Terms & Conditions", @"")},
                          @{LO_TITLE : NSLocalizedString(@"Privacy", @""),
                            LO_DESCRIPTION : NSLocalizedString(@"Privacy Statement", @"")}];
    }
    return _legalOptions;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.legalOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LegalMainCell";
    
    ArcusTitleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                         forIndexPath:indexPath];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (!cell) {
        cell = [[ArcusTitleDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    
    NSDictionary *accountSettingInfo = self.legalOptions[indexPath.row];
    
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:[accountSettingInfo[LO_TITLE] uppercaseString] attributes:[FontData getFont:FontDataTypeSettingsText]];
    [cell.titleLabel setAttributedText:titleText];
    
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:accountSettingInfo[LO_DESCRIPTION] attributes:[FontData getFont:FontDataTypeSlidingMenuSubtitle]];
    [cell.descriptionLabel setAttributedText:descText];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            WebViewController *webView = [[WebViewController alloc] init];
            webView.urlString = termsOfServiceUrl;
            [self.navigationController pushViewController:webView animated:YES];
            break;
        }
            
        case 1: {
            WebViewController *webView = [[WebViewController alloc] init];
            webView.urlString = privacyStatementUrl;
            [self.navigationController pushViewController:webView animated:YES];
            break;
        }
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
